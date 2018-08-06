#!/bin/env python
import sys

def getHashtable(filename,c):
    t={}
    for line in open(filename):
        items=line[0:-1].split(c)
        t[items[0]]=items[1]
    return t

def toDBC(text):
    newtext=''
    i = 0        
    stringlen=len(text)
    while i <  stringlen: 
        if text[i].isalnum():
            j=i
            while j<stringlen and text[j].isalnum():
                j+=1
            newtext += text[i:j]
            i=j
        elif ord(text[i])  > 127 and i < stringlen-1:
            if ord(text[i]) == int(0xA3):
                if ord(text[i+1])-128 > 0 and  ord(text[i+1])-128 < 256:
                    newtext += chr(ord(text[i+1])-128)
                else:
                    newtext += text[i:i+2]
            else:
                newtext += text[i:i+2]
            i+=2
        else:
            newtext += text[i]
            i+=1
    return newtext
 
class ISearchXML:
    def __init__(self):
        pass

    def open(self,filename):
        self._fp = open(filename,'r')

    def close(self):
        self._fp.close()

    def get(self):
        doc={}
        self._fields=[]
        line = self._fp.readline()
        if line != '<doc>\x01\n':
            return None
        while True:
            line = self._fp.readline()
            if line == '</doc>\x01\n':
                break 
            pos=line.find('=')        
            field=line[0:pos]
            val=''
            self._fields.append(field)
            if line[-2] == '\x01':
                val=line[pos+1:-2]
            else:
                val=line[pos+1:]
                while '\x01\n' not in line:
                    line = self._fp.readline()
                    val += line
                val=val[0:-2]

            doc[field]=val #;print field, val
        return doc
            
    def p(self,doc):
        print "<doc>\x01"
        if len(self._fields) == len(doc):
            for field in self._fields:
                print "%s=%s\x01" %(field,doc[field])
        else:
            for field in doc:
                print "%s=%s\x01" %(field,doc[field])
 
        print "</doc>\x01"




if __name__ == '__main__':
    xml = ISearchXML()
    xml.open(sys.argv[1])
    while True:
        doc = xml.get()
        if doc == None:break
        xml.p(doc)

    xml.close()
                        
