#!/bin/bash
#-------------------------------------------------------------#
if [ $# -ge 16 ];then
while getopts 'T:P:M:C:F:B:S:N:' opt
do
case $opt in
T)
sourcefault=$OPTARG
;;
P)
receiverfault=$OPTARG
;;
M)
meridian=$OPTARG
;;
C)
brecompute_stress=$OPTARG
;;
F)
friction=$OPTARG
;;
B)
Skempton=$OPTARG
;;
S)
tectonic_stress=$OPTARG
;;
N)
nchoiceOOP=$OPTARG
esac
done
else
#echo "there are not enough commandline parameters!"
echo -e "\033[1;30mUSAGE(e.g.):\033[0m ./all.sh -T sourcefaultslipmodel.in -P samplingpoints.in -M meridian -C 1  -F friction -B Skempton -S tectonic_stress -N nchoiceOOP \n"
exit 1
fi
if [ $nchoiceOOP -eq 5 ];then
shift 16
 if [ $# -eq 7 ];then
minstrike=$1
maxstrike=$2
mindip=$3
maxdip=$4
minrake=$5
maxrake=$6
NN=$7
 else
 echo -e "\033[1;30mUSAGE(e.g.):\033[0m ./all.sh -T sourcefaultslipmodel.in -P samplingpoints.in -M meridian -C 1  -F friction -B Skempton -S tectonic_stress -N nchoiceOOP  0 360 0 90 0 360 36"
 exit -1
 fi
fi
echo -e "sourcefault=$sourcefault receiverfault=$receiverfault meridian=$meridian brecompute_stress=$brecompute_stress friction=$friction Skempton=$Skempton \n tectonic_stress_path=$tectonic_stress_path nchoiceOOP=$nchoiceOOP"
echo "minstrike=$minstrike maxstrike=$maxstrike mindip=$mindip maxdip=$maxdip minrake=$minrake maxrake=$maxrake NN=$NN"
##sourcefault=Hashimoto_slipmodel10.in
##receiverfault=sampling_grids.in
##friction=0.4
##Skempton=0.0
#meridan is used for Gaussian projection. For the whole study region, it can be prescribed to be the middle of the longitude.
##meridian=104 #deg
#when brecompute_stress=0, the stress changes keep the same for choosing different receiver fault. In this case, computing Coulomb stress
#changes can be dramatically speeded because the stress changes are not needed to compute again. On the other hand, when brecompute_stress=1,
#the stress changes are computed. In this case, computing Coulomb stress would be a little slower, depending on the number of grid points at
#which Coulomb stress changes are calculated. Note that the variable 'brecompute_stress' should be set to be 1 for the first time to compute 
#stress changes and then the stress changes can be used for computing Coulomb stress changes on other receiver fault planes when brecompute_stress=0
##brecompute_stress=1
#############################################################
#note that here the strike angle, dip angle and rake angle of the receiver fault
#are merely used to compute stress tensor through running the 'CoulombAnalysis' program with these dummy parameters.
#Therefore, any valid values of them are approriate. 
#In the case of resolving the OOP, the strike angle, dip angle and rake angles of the OOP are in fact determined by the OOP models
#rather than being predefined.
strike_receiver=150
dip_receiver=78
rake_receiver=-13
#earthquake_stress=./CFS_result/stress.out
commonpath=./CFS_result
if [ ! -d $commonpath ];then
mkdir $commonpath
fi
earthquake_stress=${commonpath}/stress_backup.out
if [ $brecompute_stress -eq 1 ];then
rm -rf ${earthquake_stress%stress*}coulomb.out
./cal_CFS.sh $sourcefault $receiverfault  ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton} ${meridian}
cp ./CFS_result/stress.out ${earthquake_stress}
fi
#
echo "$earthquake_stress"
#-------------------resolve the OOP------------------------#
if [ ! -f $earthquake_stress ];then
echo -e "\033[31mthe file '${earthquake_stress}' does not exist! set the variable 'brecompute_stress=1' at the beginning of  this script\033[0m"
echo -e "\033[31m and then run this script. Only when the file exists the variable 'brecompute_stress' can be set to 'brecompute_stress=0'\033[0m"
echo -e "\033[31m Also, please check whether the file of the slip model of source fault and the sampling file are correctly prepared because without\033[0m"
echo -e "\033[31m the both files the file '${earthquake_stress}' cannot be generated.\033[0m"
exit 1
fi
sed '1d' $earthquake_stress > stress.out
earthquake_stress_path=stress.out
#for test Sep.27,2018
#earthquake_stress_path=stress1.out
#---------------------------------------------
tectonic_stress_path=tectonic_stress.in
if [ $tectonic_stress_path == $tectonic_stress ];then
echo -e "\033[31mwarning(ignorable): please set the filename of the regional stress field  other than 'tectonic_stress.in'.\033[0m"
fi
#---------------------------------------------
cp $tectonic_stress $tectonic_stress_path
coulomb_path=coulomb.out
rm -rf $coulomb_path
#------------------
case $nchoiceOOP in
1|2|3|4)
cd ./scripts
matlab -nodesktop -nodisplay -nosplash -r  "resolve_OOP('../${earthquake_stress_path}','../${tectonic_stress_path}','../${coulomb_path}',${nchoiceOOP},${friction},${Skempton});quit"
cd ..
echo "lon(deg)   lat(deg)" > temp.txt
#sed '1d' sampling_grids.in | awk '{print $2,$1}' >> temp.txt
sed '1d' ${receiverfault} | awk '{print $2,$1}' >> temp.txt
#cp coulomb.out coulomb_backup.out
paste temp.txt coulomb.out > temp1.txt 
mv temp1.txt ${earthquake_stress%stress*}coulomb.out
rm -rf temp.txt temp1.txt coulomb.out stress.out
;;
5)
gfortran ./scripts/OOPCFFmax.f90  -o OOPCFFmax
echo "compiling OOPCFFmax is done!"
./OOPCFFmax $earthquake_stress_path $tectonic_stress_path $coulomb_path $minstrike $maxstrike $mindip $maxdip $minrake $maxrake $friction $Skempton $NN
 echo "lon(deg)   lat(deg)" > temp.txt
#sed '1d' sampling_grids.in | awk '{print $2,$1}' >> temp.txt
sed '1d' ${receiverfault} | awk '{print $2,$1}' >> temp.txt
paste temp.txt coulomb.out > temp1.txt
mv temp1.txt ${earthquake_stress%stress*}coulomb.out
rm -rf temp.txt temp1.txt coulomb.out stress.out
esac
rm -rf computeCFS CoulombStressAnalysis OOPCFFmax
if [ "${earthquake_stress%stress*}" != "./CFS_result/" ];then
cp ${earthquake_stress%stress*}coulomb.out  ./CFS_result/
fi
./draw_CFS.sh $nchoiceOOP $receiverfault

