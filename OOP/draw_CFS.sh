#!/bin/bash
psfile=coulomb.ps
gfortran ../CFSsrc/find_minmax_values/get_gmt_boundary.f90 -o get_gmt_boundary
sed '1d' $2 > tempgrids.txt
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
#-----------------------------------------------------------------------------------#
if [ $# != 2 ];then
echo -e  "\033[31m USAGE: $0 nchoice\033[0m"
echo -e "\033[31m nchoice=1,2,3. nchoice=1 for displaying CFS resolved on the vertical strike-slip OOPs;\033[31m"
echo -e "\033[31m nchoice=2 for displaying CFS resolved on the 3D OOPs;\n nchoice=3 for displaying CFS resolved on constrained OOPs.\033[0m"
echo -e "\033[31m For the first two choices CFS are resolved using analytical formulae and the execution speed is very fast.\033[0m"
echo -e "\033[31m In contrast, for the third choice CFS are resolved using grid search and the execution speed depends on the step of grid search \n and the size of the parameter space of receiver faults..\033[0m"
echo -e "\033[31m The step is declared by the variable 'NN' in the Line 23 of the program './scripts/OOPCFFmax.f90'. One can modify it to a smaller value\n for accerlating execution speed. But in this circumstance the strike angles, dip angles and rake angles of OOPs are roughly determined.\033[0m"
exit 1
fi
#-----------------------------------------------------------------------------------#
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
if [ $bshut -eq 0 ];then
case $1 in
1|2|3|4) #1: 1D-strike-OOP 2:1D-thrust-OOP 3:1D-normal-OOP 4:3D-OOP
sed '1d' $coulomb | awk '{print $1,$2,$11}' | psxy -J -R -K -O -B -Ss0.1 -C$cptfile -hi1>>${psfile}
;;
5) #grid search
sed '1d' $coulomb | awk '{print $1,$2,$8}' | psxy -J -R -K -O -B -Ss0.1 -C$cptfile -hi1>>${psfile}
esac
else #smoothing CFS at first 
case $1 in
1|2|3|4)
awk '{print $1,$2,$11}' $coulomb | blockmean -I$delta -R$range | \
surface -Gcoulomb.grd -I$delta -R$range
grdimage -R -B  coulomb.grd -C$cptfile -J$projection -K -O>> $psfile
;;
5)
awk '{print $1,$2,$8}' $coulomb | blockmean -I$delta -R$range | \
surface -Gcoulomb.grd -I$delta -R$range
grdimage -R -B  coulomb.grd -C$cptfile -J$projection -K -O>> $psfile
esac
fi
psscale  -Dn0.8/0.1+w1.5i/0.15i -J -R -C$cptfile -Ba0.5x+l"@~\104@~CFS" -By+l"bars" -K -O --FONT_ANNOT_PRIMARY=12p --FONT_LABEL=12p>>$psfile
ps2pdf $psfile
open ${psfile%.*}.pdf

