import logging
import os
import os.path
import random
import shutil

from dots.utils import ask_user, log_and_run


def unlink_and_link(source, link_name):
    log_and_run('Unlinking {}'.format(link_name), os.unlink, args=(link_name,))
    log_and_run('Linking {} -> {}'.format(source, link_name), os.symlink, args=(source, link_name))


def ask_to_unlink_and_link(source, link_name):
    answer = ask_user('Destination {0} is already link. Force link? [yn] '.format(link_name))

    if answer == 'y':
        unlink_and_link(source, link_name)
    else:
        logging.debug('Not re-linking {}'.format(link_name))


def move_and_link(source, link_name, move_location):
    log_and_run('Moving {} to {}'.format(link_name, move_location), shutil.move, args=(link_name, move_location))
    log_and_run('Linking {} -> {}'.format(source, link_name), os.symlink, args=(source, link_name))


def ask_to_backup_file_and_symlink(source_file, link_name):
    random_number = random.randint(0, 65535)
    move_location = '/tmp/{}_{}'.format(os.path.basename(link_name), random_number)

    answer = ask_user('Destination {} is a file or directory. Move to {} and continue? [yn] '.format(link_name,
                                                                                                     move_location))

    if answer == 'y':
        move_and_link(source_file, link_name, move_location)
    else:
        logging.debug('"{}" -> Not overwriting {}'.format(answer, link_name))


def ask_to_backup_dir_and_symlink(source_dir, link_name):
    ask_to_backup_file_and_symlink(source_dir, link_name)  # compatible for now


def symlink(source, link_name, force_link=False):
    if not os.path.lexists(source):
        logging.error('Source {} does not exist'.format(source))
        return 1

    if not os.path.lexists(link_name):
        parent = os.path.dirname(link_name)
        if not os.path.exists(parent):
            os.makedirs(parent)
        os.symlink(source, link_name)

    else:
        if os.path.islink(link_name):
            if force_link:
                unlink_and_link(source, link_name)
            else:
                ask_to_unlink_and_link(source, link_name)

        elif os.path.isfile(link_name):
            ask_to_backup_file_and_symlink(source, link_name)

        elif os.path.isdir(link_name):
            ask_to_backup_dir_and_symlink(source, link_name)


def link_files(links, force_link=False):
    """
    links = (('~/.bashrc', 'bash/bashrc.bash'),)

    :param links: iterable links of pairs (link_name, source)
    :param force_link: if False, ask user to remove links/files/directories
    :return:
    """
    for link in links:
        (link_name, source), = link.items()

        link_name = os.path.expanduser(link_name)

        symlink(os.path.join(os.getcwd(), source), link_name, force_link)
