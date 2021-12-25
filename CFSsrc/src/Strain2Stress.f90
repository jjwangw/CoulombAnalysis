subroutine Strain2Stress(strain,lambda,mu,stress)
!strain(1)=e11 strain(2)=e12 strain(3)=e13
!strain(4)=e22 strain(5)=e23 strain(6)=e33
!
implicit none
!
real*8 lambda,mu
real*8 strain(6),stress(6)
real*8 dilation
!
dilation=strain(1)+strain(4)+strain(6)
stress(1)=lambda*dilation+2*mu*strain(1)
stress(2)=2*mu*strain(2)
stress(3)=2*mu*strain(3)
stress(4)=lambda*dilation+2*mu*strain(4)
stress(5)=2*mu*strain(5)
stress(6)=lambda*dilation+2*mu*strain(6)
end
