! ********************************************
! name:generalxy2BL
! function:tranform Gaussian coordinates into geographical coordinates
! (x,y):Gaussian coordinates
! sL0:Meridian which has been used for projecting point cooresponding to  (x,y)
! in Gaussian plane.
! nchoiceellipse:reference ellisphere.1.Krassovsky;2.1975 international ellipsphere
! 3.WGS-84.
subroutine generalxy2BL(x,y,sL0,nchoiceellipse,sB,sL)
 implicit none
 real*8 x,y,sL0,sB,sL
 integer*2 nchoiceellipse
 real*8 a,e2,m0,m2,m4,m6,m8
 real*8 a0,a2,a4,a6,a8
 real*8 beta,Bf,sMf,sNf,t,seta,seconde2
 real*8 p2,p4,p6
 real*8 q2,q4,q6
 real*8 pi,ratio,ssl
!
pi=acos(-1.0)
ratio=180.0/pi
!
if(nchoiceellipse.eq.1) then !Krassovsky ellipsphere
a=6378245.0
e2=0.006693421622966
elseif(nchoiceellipse.eq.2) then !1975 international ellipsphere
a=6378140.0
e2=0.006694384999588
elseif(nchoiceellipse.eq.3) then !WGS-84 ellipsphere
a=6378137.0
e2=0.0066943799013
else
print *,'please choose the right ellipsphere'
endif
!
m0=a*(1-e2)
m2=3*e2*m0/2
m4=5*e2*m2/4
m6=7*e2*m4/6
m8=9*e2*m6/8
!
a0=m0+m2/2+3*m4/8+5*m6/16+35*m8/128
a2=m2/2+m4/2+15*m6/32+7*m8/16
a4=m4/8+3*m6/16+7*m8/32
a6=m6/32+m8/16
a8=m8/128
!
beta=x/a0
p2=-a2/(2*a0)
p4=a4/(4*a0)
p6=-a6/(6*a0)
!
q2=-p2-p2*p4+p2**3/2
q4=-p4+p2**2-2*p2*p6+4*p2**2*p4
q6=-p6+3*p2*p4-3*p2**3/2
!
Bf=beta+q2*sin(2*beta)+q4*sin(4*beta)+q6*sin(6*beta)
sNf=a/( (1-e2*sin(Bf)**2)**(0.5) )
sMf=a*(1-e2)*(1-e2*sin(Bf)**2)**(-1.5)
t=tan(Bf)
seconde2=e2/(1-e2)
seta=seconde2**(0.5)*cos(Bf)
sB=Bf-t*y**2/(2*sMf*sNf*cos(Bf))+t*( 5+3*t**2+seta**2-9*(seta**2)*(t**2) )*y**4/(24*sMf*(sNf**3)) &
   -t*(61+90*t**2+45*t**4)*(y**6)/(720*sMf*sNf**5)
sB=sB*ratio
ssl=y/(sNf*cos(Bf)) -(1+2*t**2+seta**2)*(y**3)/( 6*cos(Bf)*(sNf**3) ) + &
  ( 5+28*t**2+24*t**4+6*seta**2+8*(seta**2)*(t**2) )*(y**5)/(120*(sNf**5)*cos(Bf) )
sL=sL0+ssl*ratio
end
!******************************************
