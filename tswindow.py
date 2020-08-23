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
