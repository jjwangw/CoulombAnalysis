#!/bin/bash
usage(){
echo ""
echo "Usage: ./drawgridCFS.sh -I <Coulombfile> -N <Ncase>"
echo ""
echo -e "\033[31m-I\033[0m Coulombfile is a Coulomb stress file produced by the AutoCoulomb software and saved in a folder named CFS_result.
   The format of this file is as follows: the first line is a header. Then each of the following lines has five columns, 
   which are lon.(deg) lat.(deg) shearstress(bar) normalstress(bar) Coulombstress(bar) when Ncase = 1 or 2, and
   lon.(deg) lat.(deg) optstr1(deg) optdip1(deg) optrake1(deg) optstr2(deg) optdip2(deg) optrake2(deg) shearstress(bar) normalstress(bar) Coulombstress(bar) when Ncase = 3."
echo -e "\033[31m-N\033[0m Ncase = 1 for drawing a Coulomb stress map with fixed receiver faults at horizontal grids.
   Ncase = 2 for drawing a Coulomb stress map with varying receiver faults along a fault trace.
   Ncase = 3 for drawing a Coulomb stress map on optimally oriented failure planes."
echo ""
echo "The following are three command lines used to exhibit relevant Coulomb stress maps:"
echo "e.g. ./drawgridCFS.sh -I ../grid/CFS_result/coulomb.out -N 1"
echo "e.g. ./drawgridCFS.sh -I ../faultrace/CFS_result/coulomb.out -N 2"
echo "e.g. ./drawgridCFS.sh -I ../OOP/CFS_result/coulomb.out -N 3"
echo ""
echo "Coded on 8 Jan.,2022 by jjwang"
echo ""
exit 1
}
if [ $# -ne 4 ];then
usage
fi
#
while getopts 'I:N:' opt
do
  case "$opt" in 
    I)
       coulombfile=$OPTARG
       ;;
    N)
       ncase=$OPTARG
  esac
done
#
if [ ! -f $coulombfile ];then
echo -e "\033[31m ***The input file doesn't exist***\033[0m"
exit 1
fi
if [ ! -s $coulombfile ];then
echo -e "\033[31m ***The input file is empty***\033[0m"
exit 1
fi
case "$ncase" in
 1|2)
   cp $coulombfile coulomb.out
   ;;
 3)
  echo "lon.(deg) lat(deg) shear(bar) normal(bar) CFS(bar)" > coulomb.out
  sed '1d' $coulombfile | awk '{print $1,$2,$9,$10,$11}'  >> coulomb.out
esac
echo -e "coulomb.out\n$ncase" | matlab -nodisplay -nodesktop -nosplash -r "drawgridCFS;quit"
rm coulomb.out
echo "done!"
open coulomb.pdf
