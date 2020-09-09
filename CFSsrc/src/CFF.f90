subroutine CFF(stress,strike,dip,rake,friction,skempton,shear_stress,normal_stress,coulomb_stress)
!stress(6) is in a coordinate system of which x is northern, y is eastern and z is upward.
!
implicit none
!
real*8 stress(6)
real*8 strike,dip,rake,friction,skempton
real*8 shear_stress,normal_stress,pore_pressure,coulomb_stress
real*8 e11,e12,e13,e22,e23,e33
real*8 phi,delta,lambda
!
real*8, external::deg2rad
!
e11=stress(1)
e12=stress(2)
e13=stress(3)
e22=stress(4)
e23=stress(5)
e33=stress(6)
!
phi=deg2rad(strike)
delta=deg2rad(dip)
lambda=deg2rad(rake)
!
shear_stress=sin(lambda)*(-1.0d0/2.0d0*sin(phi)**2d0*sin(2d0*delta)*e11+1.0d0/2.0d0*sin(2d0*phi)*sin(2d0*delta)*e12+ &
              sin(phi)*cos(2d0*delta)*e13-1.0d0/2.0d0*cos(phi)**2d0*sin(2d0*delta)*e22-cos(phi)*cos(2d0*delta)*e23+ &
	      1.0d0/2.0d0*sin(2d0*delta)*e33)+ &
            cos(lambda)*(-1.0d0/2.0d0*sin(2d0*phi)*sin(delta)*e11+cos(2d0*phi)*sin(delta)*e12+ &
	    cos(phi)*cos(delta)*e13+ &
            1.0d0/2.0d0*sin(2d0*phi)*sin(delta)*e22+sin(phi)*cos(delta)*e23)
normal_stress=sin(phi)**2d0*sin(delta)**2d0*e11-sin(2d0*phi)*sin(delta)**2d0*e12- & 
              sin(phi)*sin(2d0*delta)*e13+ &
               cos(phi)**2d0*sin(delta)**2d0*e22+cos(phi)*sin(2d0*delta)*e23+cos(delta)**2d0*e33
pore_pressure=-skempton/3.0d0*(e11+e22+e33)
coulomb_stress=shear_stress+friction*(normal_stress+pore_pressure)
end



