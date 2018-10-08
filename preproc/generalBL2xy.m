% !********************************************!
% !general Gaussian projection
% !name:generalGaussproj
% !function:project point (B,L) into plane such as Gaussian plane (x,y)
% !sB:latitude
% !sL:longitude
% !sL0:Meridian
% !nchoiceellip:choose paramters of ellipshpere.1.Krassovsky;2.1975 international ellipsphere
% !3.WGS-84.
% !nchoiceplane:1.Gaussian plane;2.UTM
function [x y]=generalGaussproj(sB,sL,sL0,nchoiceellip,nchoiceplane)
% real*8 sB,sL,sL0,x,y
% integer*2 nchoiceellip,nchoiceplane
% real*8 a,e2,m0,m2,m4,m6,m8
% real*8     a0,a2,a4,a6,a8
% real*8  arclength
% real*8 sN,t,seta
% real*8 scale
% real*8 seconde2,B,newsL,newsL0,pi,ratio,diffl
% !
% pi=acos(-1.0);
% ratio=pi/180;
% B=sB*ratio;
% newsL=sL*ratio;
% newsL0=sL0*ratio;
B=deg2rad(sB);
newsL=deg2rad(sL);
newsL0=deg2rad(sL0);
%
if  nchoiceellip==1%then %Krassovsky ellipsphere
a=6378245.0;
e2=0.006693421622966;
elseif  nchoiceellip==2%then %1975 international ellipsphere
a=6378140.0;
e2=0.006694384999588;
elseif  nchoiceellip==3%then %WGS-84 ellipsphere
a=6378137.0;
e2=0.0066943799013;
% flat = 298.257222101;%test DenkinProjection.m May 26, 2012 wilsonlia
% f=1/flat;
% e2=1-(1/(1+f))^2;
else
disp('please choose the right ellipsphere');
return
end
%
if nchoiceplane==1%then %Gaussian projection
scale=1.0;
elseif nchoiceplane==2%then %UTM
scale=0.9996;
else
disp('please choose the right kind of projection');
return
end
%
m0=a*(1-e2);
m2=3*e2*m0/2;
m4=5*e2*m2/4;
m6=7*e2*m4/6;
m8=9*e2*m6/8;
%
a0=m0+m2/2+3*m4/8+5*m6/16+35*m8/128;
a2=m2/2+m4/2+15*m6/32+7*m8/16;
a4=m4/8+3*m6/16+7*m8/32;
a6=m6/32+m8/16;
a8=m8/128;
%
arclength=a0*B-a2*sin(2*B)/2+a4*sin(4*B)/4-a6*sin(6*B)/6+a8*sin(8*B)/8;
sN=a*(1-e2*sin(B)^2)^(-0.5);
st=tan(B);
seconde2=e2/(1-e2);
seta=seconde2^(0.5)*cos(B);
diffl=newsL-newsL0;
x=arclength+sN/2*st*( cos(B)^2 )*( diffl^2 ) +sN/24.0*st*( 5-st^2+9*seta^2+4*seta^4)*cos(B)^4*diffl^4+ ...
  sN/720.0*st*(61-58*st^2+st^4)*cos(B)^6*diffl^6;
y=sN*cos(B)*diffl+sN/6*(1-st^2+seta^2)*cos(B)^3*diffl^3+sN/120*(5-18*st^2+st^4+14*seta^2-58*seta^2*st^2)*cos(B)^5*diffl^5 ;
x=scale*x;
y=scale*y;

% %********************************************%
% %name:xy2Gauss
% %function:tansform Cartesian coordinate projection by Gaussian projection 
% %to geographical coordinate.
% %(x,y):Cartesian coordinate
% %ameridian:meridian used during Gaussian projection.
% %(sB,sL):geographical coordinate
% function xy2Gauss(x,y,ameridian,sB,sL)
% % real*8 x,y,ameridian,sB,sL
% pi=acos(-1.0);
% beta=x/6367558.4969;
% Bf=beta+( 50221746+ ( 293622+( 2350+22*cos(beta)**2)*cos(beta)**2 )*cos(beta)**2 )*sin(2*beta)*0.5*1.0e-10;
% sNf=6399698.902-( 21562.267-(108.93-0.612*cos(beta)**2)*cos(beta)**2)*cos(beta)**2;
% Z=y/(sNf*cos(beta));
% b2=(0.5+0.003369*cos(beta)**2)*sin(2*beta)*0.5;
% b3=0.333333-(0.166667-0.001123*cos(beta)**2)*cos(beta)**2;
% b4=0.25+(0.16161+0.00562*cos(beta)**2)*cos(beta)**2;
% b5=0.2-(0.1667-0.0088*cos(beta)**2)*cos(beta)**2;
% sB=Bf-(1-(b4-0.12*Z**2)*Z**2)*Z**2*b2;
% sl=(1-(b3-b5*Z**2)*Z**2)*Z;
% sL=ameridian+sl*180/pi;
% sB=sB*180/pi;
% 
% % %********************************************%
% % %name:generalxy2BL
% % %function:tranform Gaussian coordinates into geographical coordinates
% % %(x,y):Gaussian coordinates
% % %sL0:Meridian which has been used for projecting point coorespondent to that (x,y)
% % %in Gaussian plane.
% % %nchoiceellip:reference ellisphere.1.Krassovsky;2.1975 international ellipsphere
% % %3.WGS-84.
% function generalxy2BL(x,y,sL0,nchoiceellip,sB,sL)
% % real*8 x,y,sL0,sB,sL
% % integer*2 nchoiceellip
% % real*8 a,e2,m0,m2,m4,m6,m8
% % real*8 a0,a2,a4,a6,a8
% % real*8 beta,Bf,sMf,sNf,t,seta,seconde2
% % real*8 p2,p4,p6
% % real*8 q2,q4,q6
% % real*8 pi,ratio,ssl
% %
% pi=acos(-1.0);
% ratio=180.0/pi;
% %
% if  nchoiceellip==1%then %Krassovsky ellipsphere
% a=6378245.0;
% e2=0.006693421622966;
% elseif  nchoiceellip==2%then %1975 international ellipsphere
% a=6378140.0;
% e2=0.006694384999588;
% elseif  nchoiceellip==3%then %WGS-84 ellipsphere
% a=6378137.0;
% e2=0.0066943799013;
% else
% disp('please choose the right ellipsphere');
% return
% end
% %
% m0=a*(1-e2);
% m2=3*e2*m0/2;
% m4=5*e2*m2/4;
% m6=7*e2*m4/6;
% m8=9*e2*m6/8;
% %
% a0=m0+m2/2+3*m4/8+5*m6/16+35*m8/128;
% a2=m2/2+m4/2+15*m6/32+7*m8/16;
% a4=m4/8+3*m6/16+7*m8/32;
% a6=m6/32+m8/16;
% a8=m8/128;
% %
% beta=x/a0;
% p2=-a2/(2*a0);
% p4=a4/(4*a0);
% p6=-a6/(6*a0);
% %
% q2=-p2-p2*p4+p2**3/2;
% q4=-p4+p2**2-2*p2*p6+4*p2**2*p4;
% q6=-p6+3*p2*p4-3*p2**3/2;
% %
% Bf=beta+q2*sin(2*beta)+q4*sin(4*beta)+q6*sin(6*beta);
% sNf=a/( (1-e2*sin(Bf)**2)**(0.5) );
% sMf=a*(1-e2)*(1-e2*sin(Bf)**2)**(-1.5);
% t=tan(Bf);
% seconde2=e2/(1-e2);
% seta=seconde2**(0.5)*cos(Bf);
% sB=Bf-t*y**2/(2*sMf*sNf*cos(Bf))+t*( 5+3*t**2+seta**2-9*(seta**2)*(t**2) )*y**4/(24*sMf*(sNf**3)) ...
%    -t*(61+90*t**2+45*t**4)*(y**6)/(720*sMf*sNf**5);
% sB=sB*ratio;
% ssl=y/(sNf*cos(Bf)) -(1+2*t**2+seta**2)*(y**3)/( 6*cos(Bf)*(sNf**3) ) +...
%   ( 5+28*t**2+24*t**4+6*seta**2+8*(seta**2)*(t**2) )*(y**5)/(120*(sNf**5)*cos(Bf) );
% sL=sL0+ssl*ratio;
% 
% %********************************************%