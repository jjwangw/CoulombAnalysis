function OOP_grid_search_coefficients(minstrike,maxstrike,mindip,maxdip,minrake,maxrake,friction,skempton,N)
strikee=deg2rad(linspace(minstrike,maxstrike,N));
dipp=deg2rad(linspace(mindip,maxdip,N));
rakee=deg2rad(linspace(minrake,maxrake,N));
%[strike,dip,rake]=meshgrid(strikee(:),dipp(:),rakee(:));
%
strike=strikee(:);
dip=dipp(:);
rake=rakee(:);
%
sinpow2strike=sin(strike).^2;
cospow2strike=1-sinpow2strike;
sinpow2dip=sin(dip).^2;
cospow2dip=1-sinpow2dip;
%
sin2strike=sin(2*strike);
cos2strike=cos(2*strike);
sin2dip=sin(2*dip);
cos2dip=cos(2*dip);
%
sinstrike=sin(strike);
cosstrike=cos(strike);
sindip=sin(dip);
cosdip=cos(dip);
sinrake=sin(rake);
cosrake=cos(rake);
k1=sinrake.*(-1/2).*sinpow2strike.*sin2dip + cosrake.*(-1/2).*sin2strike.*sindip + friction.*sinpow2strike.*sinpow2dip;
k2=sinrake.*(1/2).*sin2strike.*sin2dip +cosrake.*cos2strike.*sindip + friction.*(-sin2strike).*sinpow2dip;
k3=sinrake.*sinstrike.*cos2dip + cosrake.*cosstrike.*cosdip + friction.*(-sinstrike.*sin2dip);
k4=sinrake.*(-1/2).*cospow2strike.*sin2dip + cosrake.*1/2.*sin2strike.*sindip + friction.*cospow2strike.*sinpow2dip;
k5=-sinrake.*cosstrike.*cos2dip + cosrake.*sinstrike.*cosdip + friction.*cosstrike.*sin2dip;
k6=sinrake.*1/2.*sin2dip + friction.*cospow2dip;
KOOP=[k1 k2 k3 k4 k5 k6];
save('grid_search_OOP_coeff.mat','KOOP');