#! /usr/bin/python3
# tscombiner.py

from datetime import datetime, timedelta
from decimal import *
from tswindow import WindowArray
import sys
import os

window_size = int(os.environ['window_size'])
window = WindowArray(window_size)

for record in sys.stdin:
    try: 
        date_time_string, Gas = record.rstrip(os.linesep).split('\t')
        Gas = Decimal(Gas)
        window.append(Gas)
        if window.windowfull():
            # pass the forecast for the complete window to the reducer
            print('{}|F\t{}'.format(date_time_string, (str(window.sma()) + ',' + str(Gas))))
        else:
            # pass incomplete window at the start of the series to the reducer
            for index in range(0, window.getwindowsize()):
                print('{}|B\t{}'.format(date_time_string, str(window.get(index)) + ',' + str(Gas)))
    except Exception as e:
        print(e)

date_time = datetime.strptime(date_time_string, '%Y%m%d%H%M')

# pass incomplete window at the end of the series to the reducer
for observation in reversed(range(1, window.getwindowsize())):
    observations = window.getall()
    date_time = date_time+timedelta(hours = 0.25)
    date_time_out = datetime.strftime(date_time, '%Y%m%d%H%M')
    for index in reversed(range(1, len(observations))):
        print('{}|E\t{}'.format(date_time_out, (str(observations[index]) + ',' + str(Gas))))
    window.clearlast()
