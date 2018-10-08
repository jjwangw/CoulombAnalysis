subroutine Rphi(phi_angle,P)
!phi is the strike angle of source fault
!P is a transform matrix of basis vectors from fault coordinate system
!to a local Cartesian coordinate system. The axes of the fault coordinate
!system are like this: x is along strike, y is perpendicular x and z is upward;
!the axes of x,y,z are right-hand. The local Cartesian coordinate sytem is defined as:
!x is northern, y is eastern and z is upward. 
!
implicit none
real*8 phi_angle,P(3,3),phi
!
real*8,external::deg2rad
!
phi=deg2rad(phi_angle)
P(1,1)=cos(phi)
P(1,2)=sin(phi)
P(1,3)=0.0
!
P(2,1)=sin(phi)
P(2,2)=-cos(phi)
P(2,3)=0.0
!
P(3,1)=0.0
P(3,2)=0.0
P(3,3)=1.0
end
