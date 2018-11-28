#!/bin/bash
psfile=coulomb.ps
range=102/106/30/34
echo -e "\033[31mNOTE: the ranges of geographic coordinates consistent with GMT should be predefined 
when drawing CFS for a fault trace.Here the range is like 102/106/30/34\033[0m."
projection=m2
offx=9
offy=1.2
delta=1m
workdir=./CFS_map
if [ ! -d $workdir ];then
mkdir $workdir
else
rm -rf $workdir/*
fi
cd $workdir
coulomb=../CFS_result/coulomb.out
cptfile=CFS.cpt
makecpt -Cno_green -T-2/2/0.1 > $cptfile
psbasemap -J$projection -R$range -Bpxa2 -Bpya2 -BSWne -K -X$offx -Y$offy >$psfile
awk '{print $1,$2,$5}' $coulomb | psxy -J -R -K -O -B -Sc0.2 -C$cptfile >>${psfile}
psscale  -Dn0.8/0.1+w1.5i/0.15i -J -R -C$cptfile -Ba0.5x+l"@~\104@~CFS" -By+l"bars" -K -O --FONT_ANNOT_PRIMARY=12p --FONT_LABEL=12p>>$psfile
ps2pdf $psfile
open ${psfile%.*}.pdf

