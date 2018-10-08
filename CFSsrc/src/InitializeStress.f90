subroutine InitializeStress(stress)
!
implicit none
!
real*8 stress(6)
integer*4 i
do i=1,6
stress(i)=0.0
enddo
end
