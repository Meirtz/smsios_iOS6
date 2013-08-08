#!/usr/bin/python
# coding=utf-8
# smstest.py
# by KrishnaChaitanya Yarramsetty
# www.foundstone.com

import sqlite3 as lite
import sys
import smtplib

smspath="/var/mobile/Library/SMS/"

con = lite.connect(smspath+'sms.db')
msg=""


with con:
    con.row_factory = lite.Row
    cur = con.cursor()
    cur.execute('SELECT text,account from message order by date desc')
    rows = cur.fetchall()
    #data = cur.fetchone()
    counter=0
    print "Latest displayed first"
    for row in rows:
        counter+=1
        print "Unread Message: %s" % counter
        textencode = row["text"].encode('utf8')
        print "Text: %s" % textencode
            
        addressdecode = row["account"].encode('utf8')
        print "Address: %s" % addressdecode
        print "-------------------***************-------------------"
        #print "Text: %s" % row["text"]
        msg=row["text"]