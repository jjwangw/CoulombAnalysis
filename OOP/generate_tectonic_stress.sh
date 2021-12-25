#!/bin/bash
if [ $# -ne 10 ];then
echo -e "This scirpt is used to transform a principal stress tensor into one in a local topographic coordinate system whose x, y and z axses are due east, due north and upward, respectively. The transformed stress tensor is added to stress tensors aroused by an earthquake faulting when resolving the OOPs."
echo -e "\n\033[1mUsage:\033[0m ./generate_tectonic_stress.sh -s1 \"sigma1(bar) plunge1(deg) azimuth1(deg)\"  -s2 \"sigma2(bar) plunge2(deg) azimuth2(deg)\" \
\n -s3 \"sigma3(bar) plunge3(deg) azimuth3(deg)\" -o outputfilename -n N"
echo -e "\n -s1, -s2, -s3 are the options of the maximum, intermediate and minimum principal stresses.\n -o is the option for targeted file in which \
tectonic background stress is to be saved.\n -n is the option for the number of copies of the six independent comoponents of the principal stress tensor.\n note that tectonic stress field here to be considered is homogeneous."
exit -1
fi
while [ $# -gt 0 ]
do
  case "$1" in
  -s1)
     s1=`echo "$2" | awk '{print $1}'`
     p1=`echo "$2" | awk '{print $2}'`
     t1=`echo "$2" | awk '{print $3}'`
     shift
  ;;
  -s2)
     s2=`echo "$2" | awk '{print $1}'`
     p2=`echo "$2" | awk '{print $2}'`
     t2=`echo "$2" | awk '{print $3}'`
     shift
  ;;
  -s3)
     s3=`echo "$2" | awk '{print $1}'`
     p3=`echo "$2" | awk '{print $2}'`
     t3=`echo "$2" | awk '{print $3}'`
     shift
  ;;
  -o)
     outputfile=$2
     shift
  ;;
  -n)
     nlines=$2
     shift
  esac
  shift  
done
echo -e "$s1 $p1 $t1\n$s2 $p2 $t2\n$s3 $p3 $t3\n$outputfile $nlines"
gfortran ./scripts/principal_stress2_stress_tensor.f90 -o principal_stress2_stress_tensor
./principal_stress2_stress_tensor $s1 $s2 $s3 $p1 $p2 $p3 $t1 $t2 $t3 > temp_p.txt
e11=`grep 'e11' temp_p.txt | awk '{print $3}'`
e12=`grep 'e11' temp_p.txt | awk '{print $6}'`
e13=`grep 'e11' temp_p.txt | awk '{print $9}'`
e22=`grep 'e22' temp_p.txt | awk '{print $3}'`
e23=`grep 'e22' temp_p.txt | awk '{print $6}'`
e33=`grep 'e22' temp_p.txt | awk '{print $9}'`
echo "$e11 $e12 $e13 $e22 $e23 $e33"
./tectonic.sh $e11 $e12 $e13 $e22 $e23 $e33 $outputfile $nlines
rm -f principal_stress2_stress_tensor temp_p.txt
