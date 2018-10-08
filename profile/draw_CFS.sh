#!/bin/bash
psfile=coulomb.ps
#range=100/106/28/36
range_file=range_for_GMT_drawing.txt
range_along_strike=`sed '1,5d' $range_file | head -n 1 `
range_downdip=`sed '1,6d' $range_file | head -n 1 `
range=`echo "$range_along_strike $range_downdip" | awk '{printf "%-f/%-f/%-f/%-f",$1,$2,$3,$4}'`
echo "range=$range"
projection=X18/-7
offx=6
offy=7
delta=1m
workdir=./CFS_map
bshut=0
if [ ! -d $workdir ];then
mkdir $workdir
else
rm -rf $workdir/*
fi
cd $workdir
coulomb=../CFS_result/coulomb.out
cptfile=CFS.cpt
makecpt -Cno_green -T-2/2/0.1 > $cptfile
psbasemap -J$projection -R$range -Bpxa10f5+l"Along strike (km)" -Bpya2+l"Downdip (km)" -BSWne -K -X$offx -Y$offy >$psfile
if [ $bshut -eq 0 ];then
awk '{print $4,$5,$8}' $coulomb | psxy -J -R -K -O -B -Ss0.1 -C$cptfile -hi1>>${psfile}
else
awk '{print $1,$2,$5}' $coulomb | blockmean -I$delta -R$range | \
surface -Gcoulomb.grd -I$delta -R$range
grdimage -R -B  coulomb.grd -C$cptfile -J$projection -K -O>> $psfile
fi
psscale  -Dn0.8/0.1+w1.5i/0.15i -J -R -C$cptfile -Ba0.5x+l"@~\104@~CFS" -By+l"bars" -K -O --FONT_ANNOT_PRIMARY=12p --FONT_LABEL=12p>>$psfile
ps2pdf $psfile
open ${psfile%.*}.pdf

