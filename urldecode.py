#!/usr/bin/env python

import os
import sys
import urllib

if __name__ == '__main__':
    if (len(sys.argv) == 2) :
        query = urllib.unquote(sys.argv[1])
        print query
        # print query.decode("utf-8").encode("gb2312")
