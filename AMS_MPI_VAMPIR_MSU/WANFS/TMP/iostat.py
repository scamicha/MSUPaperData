#!/usr/bin/python
import sys
import string
import os
import re
import operator
import commands
import subprocess
import time
from optparse import OptionParser

otfname = 'blah.otf'
otfdump_def = 'otfdump --noevent --nostat --nosnap --nomarker '+otfname
otfdump_def_proc = subprocess.Popen(otfdump_def,shell=True,stdout=subprocess.PIPE)
def_listing = otfdump_def_proc.stdout

for line in def_listing:
    tick_start = string.find(line,'TicksPerSecond')
    print line[tick_start:tick_start+5]
