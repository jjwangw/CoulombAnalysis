#!/bin/bash
#-------------------------------------------------------------#
if [ $# -eq 18 ];then
   while getopts 'T:P:M:C:S:D:R:F:B:' opt
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
 echo -e "\033[1;30mUSAGE(e.g.):\033[0m ./all.sh -T sourcefaultslipmodel.in -P samplingpoints.in -M meridian -C 1  -S strike_angle -D dip_angle -R rake_angle -F friction -B Skempton"
 exit 1
fi
echo -e "sourcefault=$sourcefault meridian=$meridian brecompute_stress=$brecompute_stress\n strike_receiver=$strike_receiver dip_receiver=$dip_receiver rake_receiver=$rake_receiver friction=$friction Skempton=$Skempton"
#receiverfault=sampling_grids.in
#when brecompute_stress=0, the stress changes keep the same for choosing different receiver fault. In this case, computing Coulomb stress
#changes can be dramatically speeded up because the stress changes are not needed to compute again. On the other hand, when brecompute_stress=1,
#the stress changes are computed. In this case, computing Coulomb stress would be a little slower, depending on the number of grid points at
#which Coulomb stress changes are calculated. Note that the variable 'brecompute_stress' should be set to be 1 for the first time to compute
#stress changes and then the stress changes can be used for computing Coulomb stress changes on other receiver fault planes when brecompute_stress=0
#brecompute_stress=1
#-------------------------------------------------------------#
earthquake_stress=./CFS_result/stress.out
if [ $brecompute_stress -eq 0 ];then
  if [ ! -f $earthquake_stress ];then
   echo -e "\033[31m $earthquake_stress doesn't exist! set brecompute_stress=1 and run the script to generate '${earthquake_stress}' at first.\n\033[0m"
   exit 1
  fi
sed '1d' ${earthquake_stress} > stress.out
cd ../CFSsrc/computeCFS
make
make clean
cp computeCFS ../../grid
cd ../../grid
./computeCFS ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton}
echo "lon(deg)   lat(deg)" > temp_sampling_lonlat.txt
sed '1d' $receiverfault | awk '{print $2,$1}' >>temp_sampling_lonlat.txt
paste temp_sampling_lonlat.txt shearnormalcoulomb.out > lonlatshearnormalcoulomb.out
mv lonlatshearnormalcoulomb.out ${earthquake_stress%stress*}/coulomb.out
rm -rf stress.out  shearnormalcoulomb.out
else
./cal_CFS.sh $sourcefault $receiverfault  ${strike_receiver} ${dip_receiver} ${rake_receiver} ${friction} ${Skempton} ${meridian}
fi
rm -rf computeCFS CoulombStressAnalysis sampling_temp.txt
./draw_CFS.sh $receiverfault

