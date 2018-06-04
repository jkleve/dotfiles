#! /usr/bin/env python
# Unix only... I'm mean, it is for dotfiles
from argparse import ArgumentParser
import errno
import logging
import logging.config
import os
import os.path
import signal
import sys
import yaml

from dots.append import append_to_files
from dots.link import link_files
from dots.log import configure_logging

__author__ = 'Jesse Kleve'
# __license__ = ''
__version__ = '0.1.0'
PROGRAM_NAME = 'dots'


def program_description():
    """Returns a string with a description of the program
    """
    return None


def get_config(config_filename):  # TODO error handling
    if not os.path.lexists(config_filename):
        logging.error('No config file {}'.format(config_filename))

    else:
        with open(config_filename, 'r') as config:
            try:
                return yaml.load(config)
            except yaml.YAMLError as e:
                logging.error('Config file syntax error')
                logging.exception(e)


def dotfiles_variable_missing_help():
    return '''DOTFILES or -d|--dotfiles <dotfiles> not set correctly. 
 Options when running install.py:
  $ DOTFILES=~/.dotfiles ./install.py
  $ ./install.py -d ~/.dotfiles'''


def main(args):
    if not os.getenv('HOME'):
        logging.error("Could not determine user's home directory. Try 'export HOME=/home/<user>'")
        return 1

    config = get_config(args.config)
    if config is None:
        return errno.ENOENT

    if args.dotfiles:
        dotfiles = os.path.expanduser(args.dotfiles)
        if not os.path.lexists(dotfiles):
            logging.error('Dotfiles not found at "{}"'.format(dotfiles))
            return errno.ENOENT

    force_link = True if args.force_link is True else config.get('force_link', False)

    if args.command == 'install':
        link_files(config['links'], force_link)
        append_to_files(config['appends'])

    elif args.command in ('link', 'update'):
        link_files(config['links'], force_link)

    elif args.command == 'append':
        append_to_files(config['appends'])


def cli():
    def handler(signum, frame):
        logging.info('\nCaught control+c keyboard signal. Exiting.')
        sys.exit(os.EX_OK)

    signal.signal(signal.SIGINT, handler)

    parser = ArgumentParser(prog=PROGRAM_NAME, description=program_description())
    parser.add_argument('-v', '--verbose', action='count', help='verbosity level. counting (e.g. -v, -vv)')
    parser.add_argument('--version', action='version', version='%(prog)s {}'.format(__version__))

    parser.add_argument('command', type=str, default='install', nargs='?', choices=('append', 'install', 'link', 'update'))
    parser.add_argument('-c', '--config', type=str, default='install.yaml')
    parser.add_argument('-d', '--dotfiles', action='store', default=os.getenv('DOTFILES'), help='Path to dotfiles. '
                        'Either use this or set DOTFILES environment variable')
    parser.add_argument('-f', '--force-link', action='store_true', default=False, help="Force link symlinks")

    args = parser.parse_args()

    configure_logging(args.verbose)

    return main(args)


if __name__ == '__main__':
    sys.exit(cli())
