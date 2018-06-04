import logging
import sys


def log_and_run(text, func, args=None, level=logging.INFO):
    logging.log(level, text)
    func(*args) if args else func()


def ask_user(text):
    return raw_input(text) if sys.version_info[0] <= 2 else input(text)
