#! /usr/bin/python3
# tsmapper.py

import sys
import os
from datetime import datetime

header_skipped = False

for row in sys.stdin:
    Timestamp, HDD, Gas, date, weekday, weekend, hour, outOfHours, month = row.rstrip(os.linesep).split(',')
    if header_skipped: # skip header
        date_time = datetime.strptime(Timestamp, '%d/%m/%Y %H:%M')
        date_time_string = datetime.strftime(date_time, '%Y%m%d%H%M')
        print('{}\t{}\t{}'.format(date_time_string, Gas))
    header_skipped = True
