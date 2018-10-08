function [strike_angle,dip_angle,rake_angle]=normal_slip_directions2_strike_dip_rake_angles(normal_direc,slip_direc)
col=size(normal_direc,2);
strike_angle=[];
dip_angle=[];
rake_angle=[];
for j=1:col
    normal=normal_direc(:,j);
    slip=slip_direc(:,j);
%to make sure that the Aki&Richards's convention for the dip angle of a
%receiver fault is satisfied.
if normal(3)<0
    normal=-normal;
    slip=-slip;
end
%
n1=normal(1);n2=normal(2);n3=normal(3);
s1=slip(1);s2=slip(2);s3=slip(3);
dip=acos(n3);
epsilon=1.0e-6;
if dip>epsilon
    strike=atan2(-n1,n2);
    rake=atan2( s3/sin(dip), s1*cos(strike)+s2*sin(strike) );
else
    dip=0.0;
    rake=0.0;%compulsively set the rake angel to be zero because in this case only the difference of strike and rake angles can be constrained.
    strike=rake+atan2(s2,s1);
end
strike=(strike<0)*(2*pi+strike)+(strike>=0)*strike;
strike=rad2deg(strike);
dip=rad2deg(dip);
rake=rad2deg(rake);
%
strike_angle=[strike_angle;strike];
dip_angle=[dip_angle;dip];
rake_angle=[rake_angle;rake];
end
