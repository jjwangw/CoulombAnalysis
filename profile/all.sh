#!/bin/bash
if [ $# -eq 18 ];then
while getopts 'T:P:M:C:S:D:R:F:B:' opt
do
case $opt in
T)
sourcefault=$OPTARG
;;
M)
meridian=$OPTARG
;;
P)
profile_grid=$OPTARG
;;
C)
brecompute_stress=$OPTARG
;;
S)
strike_receiver=$OPTARG
;;
D)
dip_receiver=$OPTARG
;;
R)
rake_receiver=$OPTARG
;;
F)
friction=$OPTARG
;;
B)
Skempton=$OPTARG
esac
done
else
#echo "there are not enough commandline parameters!"
echo -e "\033[1;30mUSAGE(e.g.):\033[0m ./all.sh -T sourcefaultslipmodel.in -P samplingprofile.in -M meridian -C 1  -S strike_angle -D dip_angle -R rake_angle -F friction -B Skempton"
exit 1
fi
echo -e "sourcefault=$sourcefault meridian=$meridian brecompute_stress=$brecompute_stress\n strike_receiver=$strike_receiver dip_receiver=$dip_receiver rake_receiver=$rake_receiver friction=$friction Skempton=$Skempton"
#-------------------------------------------------------------#
receiverfault=sampling_grids.in
#profile_grid=./inputdata/profile_along_fault_plane1.txt
#when brecompute_stress=0, the stress changes keep the same for choosing different receiver fault. In this case, computing Coulomb stress
#changes can be dramatically speeded because the stress changes are not needed to compute again. On the other hand, when brecompute_stress=1,
#the stress changes are computed. In this case, computing Coulomb stress would be a little slower, depending on the number of grid points at
#which Coulomb stress changes are calculated. Note that the variable 'brecompute_stress' should be set to be 1 for the first time to compute 
#stress changes and then the stress changes can be used for computing Coulomb stress changes on other receiver fault planes when brecompute_stress=0
#-------------------------------------------------------------#
sed '1,28d' $profile_grid | awk '{print $1,$2,$3}' > $receiverfault 
gfortran ../CFSsrc/find_minmax_values/find_minmax_values.f90 -o find_minmax_values
find_range_for_GMT_drawing()
{
coulomb_file=$1
for((j=1;j<=5;j++))
do
   case $j in
   1)
     sed '1d' "$coulomb_file" | awk '{print $1}' > values.txt
   ;;
   2)
     sed '1d' "$coulomb_file" | awk '{print $2}' > values.txt
   ;;
   3)
     sed '1d' "$coulomb_file" | awk '{print $3}' > values.txt
   ;;
   4)
     sed '1d' "$coulomb_file" | awk '{print $4}' > values.txt
   ;;
   5)
     sed '1d' "$coulomb_file" | awk '{print $5}' > values.txt
   esac
   ./find_minmax_values
   if [ $j -eq 1 ];then
      echo "(lon.,lat,depth) geographic range of the grids in the profile" > range_for_GMT_drawing.txt
      awk '{print $2,$4}' minmaxvalues.txt >> range_for_GMT_drawing.txt
   elif [ $j -le 3 ];then
      awk '{print $2,$4}' minmaxvalues.txt >> range_for_GMT_drawing.txt
   else 
       if [ $j -eq 4 ];then
          echo "(along-strike(km),downdip(km)) local range of the grids in the profile" >> range_for_GMT_drawing.txt
          awk '{print $2,$4}' minmaxvalues.txt >> range_for_GMT_drawing.txt
      else
          awk '{print $2,$4}' minmaxvalues.txt >> range_for_GMT_drawing.txt
      fi
   fi
done

}
earthquake_stress=./CFS_result/stress.out
if [ $brecompute_stress -eq 0 ];then
if [ ! -f $earthquake_stress ];then
echo -e "\033[31m The file '${earthquake_stress}' doesn't exist! please modify the variable 'brecompute_stress' to be 'brecompute_stress=1' and run the script.\033[0m"
exit 1
fi
sed '1d' ${earthquake_stress} > stress.out
cd ../CFSsrc/computeCFS/
make clean
make
cp computeCFS ../../profile/
cd ../../profile
./computeCFS ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton}
else
echo "--------------"
pwd
echo "#############"
echo -e "sourcefault=$sourcefault meridian=$meridian brecompute_stress=$brecompute_stress\n strike_receiver=$strike_receiver dip_receiver=$dip_receiver rake_receiver=$rake_receiver friction=$friction Skempton=$Skempton"
./cal_CFS.sh $sourcefault $receiverfault  ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton} ${meridian}
awk '{print $3,$4,$5}' ${earthquake_stress%stress*}/coulomb.out > shearnormalcoulomb.out
fi
#
echo "lon(deg)   lat(deg)  depth(km) ksi(km)  downdip(km)" > temp_sampling_lonlat.txt
sed '1,29d' $profile_grid | awk '{print $2,$1,$3,$4,$5}' >>temp_sampling_lonlat.txt
paste temp_sampling_lonlat.txt shearnormalcoulomb.out > coulomb.out
find_range_for_GMT_drawing coulomb.out
mv coulomb.out ${earthquake_stress%stress*}
rm -rf stress.out temp_sampling_lonlat.txt shearnormalcoulomb.out
rm -rf values.txt minmaxvalues.txt sampling_temp.txt
rm -rf computeCFS  find_minmax_values CoulombStressAnalysis
rm -rf sampling_grids.in
#####################Draw figure###########################
./draw_CFS.sh 
###############
rm -rf range_for_GMT_drawing.txt 

