#!/usr/bin/python3
#tsreducer.py

import os
import sys
from datetime import timedelta, datetime
from decimal import Decimal
from tswindow import WindowArray


window_size = int(os.environ['window_size'])
last_observation = ''

window = WindowArray(window_size)

print('Date,Forecast for t+1,Actual')
for record in sys.stdin:
    try: 
        key, value = record.rstrip(os.linesep).split('\t')
        date_time_string, rowtype = key.split('|')
        date_time = datetime.strptime(date_time_string, '%Y%m%d%H%M')
        date_time_out = datetime.strftime(date_time, '%d/%m/%Y %H:%M')
        if rowtype == 'F':
            print('{},{}'.format(date_time_out, value))
        else:
            Gas = value.rsplit(',', 1)[0]
            Gas = Decimal(Gas)
            Actual = value.rsplit(',', 1)[1]
            if last_observation == date_time_string:
                window.append(Gas)
                if window.windowfull():
                    print('{},{}'.format(date_time_out, (str(window.sma()) + ',' + str(Actual))))
            else:
                window.clear()
                window.append(Gas)
            last_observation = date_time_string
    except Exception as e:
        print(e)
