function [shear_stress,normal_stress,coulomb]=CFF(stress,receiver_strike,receiver_dip,receiver_rake,friction,skempton)
%stress:e11 e12 e13 e22 e23 e33.these stress components belongs to a local
%Cartesian coordinate system whose x is north, y is east and z is upward.
%friction:[0,1]. commonly it's 0.4
%skempton:[0,1]. commonly it's 0.6
%receiver_strike,receiver_dip and receiver_rake are angles of receiver
%fault.
%coded on June 19, 2015 jjwang

s=[stress([1 2 3]);...
   stress([2 4 5]);...
   stress([3 5 6])];
%
strike=deg2rad(receiver_strike);
dip=deg2rad(receiver_dip);
rake=deg2rad(receiver_rake);
%
normal=[-sin(strike)*sin(dip);...
         cos(strike)*sin(dip);...
         cos(dip)];
slip=[cos(strike)*cos(rake)+sin(strike)*cos(dip)*sin(rake);...
      sin(strike)*cos(rake)-cos(strike)*cos(dip)*sin(rake);...
      sin(dip)*sin(rake)];
p=s*normal;
normal_stress=normal'*p;
shear_stress=slip'*p;
poropressure=-skempton/3*(s(1,1)+s(2,2)+s(3,3));
coulomb=shear_stress+friction*(normal_stress+poropressure);