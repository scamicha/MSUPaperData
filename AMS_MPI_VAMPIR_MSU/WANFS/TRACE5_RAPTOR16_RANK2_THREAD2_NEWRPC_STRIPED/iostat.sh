#!/bin/bash

OTFNAME=$1

# list all definitions
otfdump --noevent --nostat --nosnap --nomarker $OTFNAME >def.txt

TPS=`grep TicksPerSecond def.txt | cut -d ',' -f2 | cut -d ' ' -f 3`

# cut out filenames and their ID's
grep DefFile def.txt | grep -v DefFileGroup | cut -d ':' -f2 | cut -d ',' -f1,3 >fl.txt

# nr of files
NRF=`cat fl.txt | wc -l`


# see OTF_Definitions.h for number of OTF_FILEOPERATION_RECORD
# add --procs 1 to only dump process 1
otfdump --procs 1 --records 53 54 $OTFNAME >fio.txt

for nr in `seq 1 $NRF`
do
    cat fio.txt | grep "file ID $nr," >${nr}.txt
done


# operation 0 == open
# operation 1 == close
# operation 2 == read
# operation 3 == write

for nr in `seq 1 $NRF`
do
    #write filename into file
    cat fl.txt | cut -d ',' -f 1 | head -n $nr | tail -n 1 >${nr}_read.csv
    cat fl.txt | cut -d ',' -f 1 | head -n $nr | tail -n 1 >${nr}_write.csv
    #write ticks per second into file
    echo $TPS >>${nr}_read.csv
    echo $TPS >>${nr}_write.csv
    # timestamp in ticks, bytes, duration in ticks , rate = bytes/duration
    cat ${nr}.txt | grep "operation 2" | awk '{rate = strtonum($15) / strtonum($17) ; print $2 "," $15 $17 rate}' >>${nr}_read.csv
    cat ${nr}.txt | grep "operation 3" | awk '{rate = strtonum($15) / strtonum($17) ; print $2 "," $15 $17 rate}' >>${nr}_write.csv
done

