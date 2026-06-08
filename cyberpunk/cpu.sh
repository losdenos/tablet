#!/bin/bash
grep 'cpu ' /proc/stat | awk '{u=$2+$4; t=$2+$3+$4+$5; if(NR==1){u1=u;t1=t} else printf "%d", (u-u1)*100/(t-t1)}' /proc/stat /proc/stat
