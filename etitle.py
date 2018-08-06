#!/bin/env python
#!-*- encoding:UTF-8 -*-
import ISearchXML
import sys

known_spus = set()
 
main_site = open('spuid.xml', 'rb', 10*1024*1024)
for line in main_site:
    known_spus.add(int(line) )
 
main_site.close()

isx=ISearchXML.ISearchXML()
isx.open(sys.argv[1])
cnt=0
while True:
    doc=isx.get()
    if doc == None:break
    cnt+=1
    if cnt%10000==0:print >>sys.stderr,"go->"+str(cnt)
    if int(doc['spuid']) in known_spus : 
        print "<doc>\001"
        print "spuid=%s\001" %(doc['spuid'])
        print "epid=%s\001" %(doc['pid'])
        print "title=%s\001" %(doc['title'])
        print "</doc>\001"
