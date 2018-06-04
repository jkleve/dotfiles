import logging
import os.path


def append_text_to(filename, text, duplicate=False):
    append_text = True

    if not duplicate:
        with open(filename, 'r') as file:
            lines = ''.join(file.readlines())
            if text in lines:
                logging.debug('Found text in file "{}". Not appending.'.format(filename))
                append_text = False

    if append_text is True:
        logging.debug('Appending "{}" to "{}"'.format(text, filename))
        with open(filename, 'a+') as file:
            file.write('\n{}\n'.format(text))


def append_to_files(append_actions):
    """
    append_actions = (('~/.bashrc', '[ -f ~/.bash_profile ] && source ~/.bash_profile'),)

    :param append_actions: iterable list of pairs (filename, append_text)
    :return:
    """
    for append_action in append_actions:
        (append_to_filename, append_text), = append_action.items()

        append_to_filename = os.path.expanduser(append_to_filename)
        if not os.path.exists(append_to_filename):
            with open(append_to_filename, 'w'):
                pass

        if isinstance(append_text, list):
            append_text = '\n'.join(append_text)

        append_text_to(append_to_filename, append_text)
