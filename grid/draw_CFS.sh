#!/bin/bash
psfile=coulomb.ps
gfortran ../CFSsrc/find_minmax_values/get_gmt_boundary.f90 -o get_gmt_boundary
sed '1d' $1 > tempgrids.txt
./get_gmt_boundary tempgrids.txt >/dev/null
range=`awk '{printf("%13.6f/%13.6f/%13.6f/%13.6f\n"),$1,$2,$3,$4}' gmtbounds.txt | \
sed 's/ //g'`
rm -rf tempgrids.txt gmtbounds.txt get_gmt_boundary
#range=102/106/30/34
projection=m4
offx=7
offy=1.5
delta=1m
workdir=./CFS_map
bshut=0
if [ ! -d $workdir ];then
mkdir $workdir
else
rm -rf $workdir/*
fi
cd ./$workdir
coulomb=../CFS_result/coulomb.out
cptfile=CFS.cpt
makecpt -Cno_green -T-2/2/0.1 > $cptfile
psbasemap -J$projection -R$range -Bpxa2 -Bpya2 -BSWne -K -X$offx -Y$offy >$psfile
if [ $bshut -eq 0 ];then
awk '{print $1,$2,$5}' $coulomb | psxy -J -R -K -O -B -Ss0.1 -C$cptfile >>${psfile}
else
awk '{print $1,$2,$5}' $coulomb | blockmean -I$delta -R$range | \
surface -Gcoulomb.grd -I$delta -R$range
grdimage -R -B  coulomb.grd -C$cptfile -J$projection -K -O>> $psfile
fi
psscale  -Dn0.8/0.1+w1.5i/0.15i -J -R -C$cptfile -Ba0.5x+l"@~\104@~CFS" -By+l"bars" -K -O --FONT_ANNOT_PRIMARY=12p --FONT_LABEL=12p>>$psfile
ps2pdf $psfile
open ${psfile%.*}.pdf

