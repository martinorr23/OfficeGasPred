#! /usr/bin/python3
# tsmapper.py

import sys
import os
from datetime import datetime

header_skipped = False

for row in sys.stdin:
    Timestamp, HDD, Gas = row.rstrip(os.linesep).split(',')
    if header_skipped: # skip header
        date_time = datetime.strptime(Timestamp, '%Y-%m-%d %H:%M:%S')
        date_time_string = datetime.strftime(date_time, '%Y%m%d%H%M')
        print('{}\t{}'.format(date_time_string, Gas))
    header_skipped = True
