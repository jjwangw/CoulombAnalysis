function [s]=tectonic_stress(stress_plung_trend_angle)
%P1 is the plunge angle of the principal stress s1. T1 is its azimuth.
%P2 is the plunge angle of the principal stress s2. T2 is its azimuth.
%P3 is the plunge angle of the principal stress s3. T3 is its azimuth.
%note x is north, y is east and z is upward.
%coded on 23:57 Sep. 28, 2014.
%
s1=stress_plung_trend_angle(1,1);
s2=stress_plung_trend_angle(2,1);
s3=stress_plung_trend_angle(3,1);
%
P1=stress_plung_trend_angle(1,2);
T1=stress_plung_trend_angle(1,3);
%
P2=stress_plung_trend_angle(2,2);
T2=stress_plung_trend_angle(2,3);
%
P3=stress_plung_trend_angle(3,2);
T3=stress_plung_trend_angle(3,3);
%
P1=deg2rad(P1);
T1=deg2rad(T1);
%
P2=deg2rad(P2);
T2=deg2rad(T2);
%
P3=deg2rad(P3);
T3=deg2rad(T3);
%
%check orthogonality
D=[cos(P1)*cos(T1) cos(P2)*cos(T2) cos(P3)*cos(T3);...
   cos(P1)*sin(T1) cos(P2)*sin(T2) cos(P3)*sin(T3);...
   sin(P1)         sin(P2)         sin(P3)]; 
if length(find(abs(reshape(D*D'-eye(3),9,1))<1.0e-6))~=9
    disp('error!!!the principal axes of principal stresses are not orthogonal!!!');
    s=[];
    return
end
%
s11=s1*cos(P1)^2*cos(T1)^2+s2*cos(P2)^2*cos(T2)^2+s3*cos(P3)^2*cos(T3)^2;
s12=1/2*(s1*cos(P1)^2*sin(2*T1)+s2*cos(P2)^2*sin(2*T2)+s3*cos(P3)^2*sin(2*T3));
s13=1/2*(s1*sin(2*P1)*cos(T1)+s2*sin(2*P2)*cos(T2)+s3*sin(2*P3)*cos(T3));
s22=s1*cos(P1)^2*sin(T1)^2+s2*cos(P2)^2*sin(T2)^2+s3*cos(P3)^2*sin(T3)^2;
s23=1/2*(s1*sin(2*P1)*sin(T1)+s2*sin(2*P2)*sin(T2)+s3*sin(2*P3)*sin(T3));
s33=s1*sin(P1)^2+s2*sin(P2)^2+s3*sin(P3)^2;
%
s=[s11 s12 s13;s12 s22 s23;s13 s23 s33];%my coordinate. x is northern, y is eastern and z is upward.
