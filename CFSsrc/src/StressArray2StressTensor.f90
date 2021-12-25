subroutine StressArray2StressTensor(stressarray,stresstensor)
!
implicit none
!
real*8 stressarray(6),stresstensor(3,3)
integer*4 i,j,n
n=1
do 100 i=1,3
  do 200 j=1,3
      if(j.ge.i)then
         stresstensor(i,j)=stressarray(n)
         n=n+1
      else
         stresstensor(i,j)=stresstensor(j,i)
      endif
  200 continue
100 continue
end
