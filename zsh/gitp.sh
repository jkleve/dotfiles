## gitp: Start a patch branch.
#
# Quickly start a new branch with the form '<user>.patch.<sha>'
#
gitp() {
    git checkout -b "$(git config user.name | tr '[:upper:]' '[:lower:]' | tr ' ' '.').patch.$(git rev-parse --short HEAD)"
}
