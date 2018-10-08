#!/bin/bash
if [ $# -ne 8 ];then
echo "Usage: ./tectonic.sh <e11> <e12> <e13> <e22> <e23> <e33> <tectonic_stress_output_file> <nlines>"
exit -1
fi
i=0
string=`echo "$1 $2 $3 $4 $5 $6"`
echo "$string" > "$7"
for((i=2;i<=$8;i++))
do
echo "$string" >> "$7"
done
#cat -n "$7"
echo "done!"
