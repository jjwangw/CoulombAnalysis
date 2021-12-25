#!/bin/bash
if [ $# -eq 6 ];then
while getopts 'T:M:R:' opt
do
case $opt in
T)
sourcefault=$OPTARG
;;
M)
meridian=$OPTARG
;;
R)
receiverfault=$OPTARG
esac
done
else
#echo "there are not enough commandline parameters!"
echo -e "\033[1;30mUSAGE(e.g.):\033[0m ./all.sh -T sourcefault -M meridian -R receiverfault"
exit 1
fi
echo -e "sourcefault=$sourcefault meridian=$meridian receiverfault=$receiverfault"
#-------------------------------------------------------------#
strike_receiver=150 #dummy value
dip_receiver=78 #dummy value
rake_receiver=-13 #dummy value
friction=0.4 #dummy value
Skempton=0.0 #dummy value
echo "----$sourcefault $receiverfault  ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton} ${meridian}----"
./cal_CFS.sh $sourcefault $receiverfault  ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton} ${meridian}
./draw_CFS.sh

