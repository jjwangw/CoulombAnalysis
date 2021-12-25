#!/bin/bash
######Compile programs###################################
cd ../CFSsrc/src
make
make clean
cp CoulombStressAnalysis  ../../faultrace
#
cd ../../faultrace
#
source_fault=$1
sampling_file=$2
filefolder=./CFS_result
if [ ! -d $filefolder ];then
mkdir ./$filefolder
else
rm -rf $filefolder/*
fi
cp $sampling_file samplingpoints.in
echo -e "\033[31m----processing ...---\033[0m"
naltermode_receiver=1
#note the following receiver fault is merely used for compatable reading format of the 'CoulombAnalysis' program. The real receiver fault will be read from the sampling file that is saved in the filefolder 'grid'.
strike_receiver=$3
dip_receiver=$4
rake_receiver=$5
friction=$6
Skempton=$7
meridian=$8
cp  $source_fault  slipmodel.in
echo "$1 $2 $3 $4 $5 $6 $7 $8"
echo "naltermode_receiver=$naltermode_receiver strike_receiver=$strike_receiver dip_receiver=$dip_receiver rake_receiver=$rake_receiver friction=$friction Skempton=$Skempton meridian=$meridian"
./CoulombStressAnalysis ${naltermode_receiver} ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton} ${meridian}
mv stress.out "${filefolder}"
mv coulomb.out  "${filefolder}/coulomb.out"
rm -rf slipmodel.in samplingpoints.in sampling_temp.txt CoulombStressAnalysis
