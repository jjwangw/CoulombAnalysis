!********************************************!
!general Gaussian projection
!name:generalGaussproj
!function:project point (B,L) into plane such as Gaussian plane (x,y)
!sB:latitude
!sL:longitude
!sL0:Meridian
!nchoiceellip:choose paramters of ellipshpere.1.Krassovsky;2.1975 international ellipsphere
!3.WGS-84.
!nchoiceplane:1.Gaussian plane;2.UTM
subroutine generalBL2xy(sB,sL,sL0,nchoiceellipse,nchoiceplane,x,y)
implicit none
real*8 sB,sL,sL0,x,y
integer*2 nchoiceellipse,nchoiceplane
real*8 a,e2,m0,m2,m4,m6,m8
real*8     a0,a2,a4,a6,a8
real*8  arclength
real*8 sN,st,seta
real*8 scale
real*8 seconde2,B,newsL,newsL0,pi,ratio,diffl
!
pi=acos(-1.0);
ratio=pi/180;
B=sB*ratio;
newsL=sL*ratio;
newsL0=sL0*ratio;
!
if(nchoiceellipse==1) then !Krassovsky ellipsphere
a=6378245.0
e2=0.006693421622966
elseif(nchoiceellipse==2) then !1975 international ellipsphere
a=6378140.0;
e2=0.006694384999588;
elseif(nchoiceellipse==3) then !WGS-84 ellipsphere
a=6378137.0
e2=0.0066943799013
else
print *,'please choose the right ellipsphere'
endif
!
if(nchoiceplane==1) then !Gaussian projection
scale=1.0
elseif(nchoiceplane==2) then !UTM
scale=0.9996
else
print *,'please choose the right kind of projection'
return
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
arclength=a0*B-a2*sin(2*B)/2+a4*sin(4*B)/4-a6*sin(6*B)/6+a8*sin(8*B)/8
sN=a*(1-e2*sin(B)**2)**(-0.5)
st=tan(B)
seconde2=e2/(1-e2)
seta=seconde2**(0.5)*cos(B)
diffl=newsL-newsL0
x=arclength+sN/2*st*( cos(B)**2 )*( diffl**2 ) +sN/24.0*st*( 5-st**2+9*seta**2+4*seta**4)*cos(B)**4*diffl**4+ &
  sN/720.0*st*(61-58*st**2+st**4)*cos(B)**6*diffl**6
y=sN*cos(B)*diffl+sN/6*(1-st**2+seta**2)*cos(B)**3*diffl**3+sN/ &
  120*(5-18*st**2+st**4+14*seta**2-58*seta**2*st**2)*cos(B)**5*diffl**5
x=scale*x
y=scale*y
end
