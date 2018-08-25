#!/usr/bin/env python

import os
import sys

def my_urlencode(str) :
    reprStr = repr(str).replace(r'\x', '%')
    return reprStr[1:-1]

if __name__ == '__main__':
    if (len(sys.argv) == 2) :
        print my_urlencode(sys.argv[1])

