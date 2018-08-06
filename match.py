#!/bin/env python
#!-*- encoding:UTF-8 -*-
import ISearchXML
import sys

known_spus = dict()
 
main_site = open('stitle.xml', 'rb', 10*1024*1024)
for line in main_site:
    term = line.strip().split(":")
    known_spus[int(term[0])]=term[1]
    #print "%d" %(int(term[0]))
 
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
        print doc['spuid'],"\t",known_spus[int(doc['spuid'])],"\t",doc['epid'],"\t",doc['title']
