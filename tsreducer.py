#!/usr/bin/python3
#tsreducer.py

import os
import sys
from datetime import timedelta, datetime
from decimal import Decimal
# tswindow.py
from collections import deque

class WindowException(Exception):
    pass

class WindowArray(object):
    def __init__(self, windowsize):
        self.__windowsize = windowsize
        self.__window = deque()

    def append(self, value):
        if len(self.__window) == self.__windowsize:
            self.__window.popleft()
        self.__window.append(value)

    def clear(self):
        self.__window.clear()

    def clearlast(self):
        self.__window.pop()

    def clearfirst(self):
        self.__window.popleft()

    def getall(self):
        return self.__window

    def get(self, index):
        return self.__window[index]

    def getwindowsize(self):
        return len(self.__window)

    def windowfull(self):
        return len(self.__window) == self.__windowsize

    def sma(self):
        if len(self.__window) == self.__windowsize:
            return sum(self.__window) / len(self.__window)
        else:
            raise WindowException("Window not full. Can't do Simple Moving Average")


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
