subroutine GradientDisp2Strain(UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ,strain)
!transform graident of displacement into strain tensor using strain-displacment
!relationship
!
implicit none
!
real*8 UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ
real*8 strain(6)
strain(1)=UXX !e11
strain(2)=0.5*(UXY+UYX) !e12
strain(3)=0.5*(UXZ+UZX) !e13
strain(4)=UYY !e22
strain(5)=0.5*(UYZ+UZY) !e23
strain(6)=UZZ !e33
end
