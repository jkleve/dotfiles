#!/usr/bin/env bash
# Claude Code Notification hook -> Microsoft Teams (Workflows webhook).
#
# Fires when Claude is blocked on you (permission prompt, question, idle at the
# prompt). Waits a grace period first and only sends if the session transcript
# hasn't moved since, so prompts you answer right away never reach Teams.
#
# Config:
#   ~/.claude/teams_webhook_url   one line: the Workflows "When a Teams webhook
#                                 request is received" URL (chmod 600)
#   CLAUDE_TEAMS_NOTIFY_DELAY     grace period in seconds (default 45)
#   CLAUDE_TEAMS_NOTIFY_DISABLE=1 mute without removing the hook
#
# Test: echo '{"message":"test","notification_type":"permission_prompt"}' \
#         | CLAUDE_TEAMS_NOTIFY_DELAY=0 ~/.claude/hooks/teams_notify.sh --foreground

set -u

URL_FILE="${CLAUDE_TEAMS_WEBHOOK_URL_FILE:-$HOME/.claude/teams_webhook_url}"
DELAY="${CLAUDE_TEAMS_NOTIFY_DELAY:-45}"
LOG="$HOME/.claude/hooks/teams_notify.log"

[ "${CLAUDE_TEAMS_NOTIFY_DISABLE:-0}" = "1" ] && exit 0
[ -s "$URL_FILE" ] || exit 0

input="$(cat)"
field() { printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null; }

message="$(field .message)"
ntype="$(field .notification_type)"
transcript="$(field .transcript_path)"
cwd="$(field .cwd)"
session="$(field .session_id)"

# GNU stat (Linux) first, BSD stat (macOS) as fallback.
mtime() { [ -n "$1" ] && { stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null; }; }

# idle_prompt already means "nobody has typed for a while" - no extra wait.
[ "$ntype" = "idle_prompt" ] && DELAY=0

# Single-line, length-capped text for card fields.
clip() { tr -s '[:space:]' ' ' | sed 's/^ //; s/ $//' | cut -c1-"${1:-200}"; }

# Latest line of a given transcript entry type (ai-title, last-prompt). The
# transcript is append-only JSONL, so grep|tail avoids slurping a large file.
last_entry() { [ -r "$transcript" ] && grep "^{\"type\":\"$1\"" "$transcript" | tail -n1 | jq -r "$2 // empty" 2>/dev/null; }

# Recent assistant content blocks of one kind; only the tail is read since the
# blocking tool call / final message is always at the end of the transcript.
last_block() {
    [ -r "$transcript" ] || return 0
    tail -n 200 "$transcript" | jq -rs "
      [.[] | select(.type==\"assistant\") | .message.content[]? | select(.type==\"$1\")] | last // empty | $2" 2>/dev/null
}

send() {
    local before after branch host title body payload url code
    local session_title last_prompt waiting
    # Facts below are what lets you tell sessions apart and see what's pending.
    # permission_prompt/elicitation_dialog -> the tool call awaiting a decision;
    # idle_prompt -> the last thing Claude said before going idle.
    before="$(mtime "$transcript")"
    [ "$DELAY" -gt 0 ] && sleep "$DELAY"
    after="$(mtime "$transcript")"
    # Transcript moved during the grace period -> you already unblocked it.
    if [ -n "$before" ] && [ "$before" != "$after" ]; then
        exit 0
    fi

    host="$(hostname -s)"
    branch="$( [ -n "$cwd" ] && git -C "$cwd" branch --show-current 2>/dev/null )"
    case "$ntype" in
        permission_prompt)  title="Claude needs permission" ;;
        idle_prompt)        title="Claude is waiting for your input" ;;
        elicitation_dialog) title="Claude is asking you a question" ;;
        *)                  title="Claude needs you" ;;
    esac
    body="${message:-Claude Code is waiting on you.}"

    session_title="$(last_entry ai-title .aiTitle | clip 80)"
    last_prompt="$(last_entry last-prompt .lastPrompt | clip 160)"
    case "$ntype" in
        idle_prompt)
            waiting="$(last_block text .text | clip 300)" ;;
        *)
            waiting="$(last_block tool_use \
                '.name + ": " + ((.input.command // .input.file_path // .input.questions[0].question // .input.description // .input.pattern // .input.url // "") | tostring)' \
                | clip 300)" ;;
    esac
    # Fall back to the dir name so the title is never empty.
    [ -n "$session_title" ] || session_title="$(basename "${cwd:-?}")"
    title="$title - $session_title"

    payload="$(jq -n \
        --arg title "$title" --arg body "$body" --arg host "$host" \
        --arg dir "${cwd:-?}" --arg branch "${branch:--}" \
        --arg session "${session:0:8}" --arg when "$(date '+%H:%M:%S')" \
        --arg waiting "${waiting:--}" --arg prompt "${last_prompt:--}" \
        --arg wlabel "$([ "$ntype" = idle_prompt ] && echo 'Last said' || echo 'Pending')" '
      {type: "message",
       attachments: [{
         contentType: "application/vnd.microsoft.card.adaptive",
         content: {
           "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
           type: "AdaptiveCard", version: "1.4",
           body: [
             {type: "TextBlock", text: $title, weight: "Bolder", size: "Medium", wrap: true},
             {type: "TextBlock", text: $body, wrap: true},
             {type: "FactSet", facts: [
               {title: $wlabel,   value: $waiting},
               {title: "Prompt",  value: $prompt},
               {title: "Host",    value: $host},
               {title: "Dir",     value: $dir},
               {title: "Branch",  value: $branch},
               {title: "Session", value: $session},
               {title: "Time",    value: $when}]}]}}]}')"

    url="$(head -n1 "$URL_FILE" | tr -d '[:space:]')"
    code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 15 \
        -H 'Content-Type: application/json' -d "$payload" "$url" 2>>"$LOG")"
    case "$code" in
        2*) ;;
        *) echo "$(date '+%F %T') [$host] HTTP $code for $ntype: $body" >>"$LOG" ;;
    esac
}

if [ "${1:-}" = "--foreground" ]; then
    send
else
    # Detach so the hook returns immediately and Claude isn't held up.
    ( send ) </dev/null >/dev/null 2>&1 &
    disown 2>/dev/null
fi
exit 0
