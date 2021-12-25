subroutine StressTensor2StressArray(stresstensor,stressarray)
!
implicit none
!
real*8 stresstensor(3,3),stressarray(6)
integer*4 i,j,n
n=1
do 100  i=1,3
  do 200 j=i,3
     stressarray(n)=stresstensor(i,j)
     n=n+1
  200 continue
100 continue 
end
