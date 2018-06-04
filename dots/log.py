import logging

LOGGING_FORMAT = '%(levelname)-8s : %(message)s'
LOGGING_DATEFMT = '%H:%M:%S'


def configure_logging(verbose):
    logging.basicConfig(level=logging.DEBUG, format=LOGGING_FORMAT, datefmt=LOGGING_DATEFMT)
