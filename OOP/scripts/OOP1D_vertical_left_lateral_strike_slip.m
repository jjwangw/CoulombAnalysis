function [opt_strike,opt_dip,opt_rake,shear_stress,normal_stress,coulomb_stress,total_CFFmax]=OOP1D_vertical_left_lateral_strike_slip(earthquake_stress,tectonic_stress,friction,skempton)
%earthquake_stress:se11 se12 se13 se22 se23 se33
%tectonic_stress:  st11 st12 st13 st22 st23 st33
%Both 'earthquake_stress' and 'tectonic_stress' belong to a local topographic Cartesian coordinate system whose
%x is northern, y is eastern and z is upward.
s=earthquake_stress+tectonic_stress;
row=size(s,1);
opt_strike=[];
opt_dip=[];
opt_rake=[];
total_CFFmax=[];
shear_stress=[];
normal_stress=[];
coulomb_stress=[];
for i=1:row
    A=1/2*( s(i,4) - s(i,1) ) - friction*s(i,2);
    B=1/2*friction*( s(i,4) - s(i,1) ) + s(i,2);
    %-------------------------------------------%
    %just for testing
    A1=A;
    B1=B;
    A2=1/2*( s(i,1) - s(i,4) ) - friction*s(i,2);
    B2=1/2*friction*( s(i,4) - s(i,1) ) - s(i,2);
    A1_bar=1/2*( earthquake_stress(i,4) - earthquake_stress(i,1) ) - friction*earthquake_stress(i,2);
    B1_bar=1/2*friction*( earthquake_stress(i,4) - earthquake_stress(i,1) ) + earthquake_stress(i,2);
    A2_bar=1/2*( earthquake_stress(i,1) - earthquake_stress(i,4) ) - friction*earthquake_stress(i,2);
    B2_bar=1/2*friction*( earthquake_stress(i,4) - earthquake_stress(i,1) ) - earthquake_stress(i,2);
    [(friction^2-1)/(friction^2+1)+2*A1*friction/(1+friction^2)/B1   (A1*A1_bar+B1*B1_bar)/(A2*A2_bar+B2*B2_bar)*B2/B1]
    %-------------------------------------------%
    CFFmax=sqrt(1+friction^2)*sqrt(  1/4*( s(i,4)-s(i,1) )^2 + s(i,2)^2 ) +1/2*friction*( s(i,1)+s(i,4) );
    theta=1/2*atan(A/B);
    if B<0
        K=[1;3];
        strike=theta+1/2*K*pi;
    else
        if A>=0
            K=[0;1];
            strike=theta+K*pi;
        else
            K=[1;2];
            strike=theta+K*pi;
        end
    end
    dip=pi/2;
    rake=0;
    receiver_strike=rad2deg(strike(1));
    receiver_dip=rad2deg(dip(1));
    receiver_rake=rad2deg(rake(1));
    [shear,normal,coulomb]=CFF(earthquake_stress,receiver_strike,receiver_dip,receiver_rake,friction,skempton);
    shear_stress=[shear_stress;shear];
    normal_stress=[normal_stress;normal];
    coulomb_stress=[coulomb_stress;coulomb];
    opt_strike=[opt_strike;strike'];
    opt_dip=[opt_dip;dip dip];
    opt_rake=[opt_rake;rake rake];
    total_CFFmax=[total_CFFmax;CFFmax];
end
opt_strike=rad2deg(opt_strike);
opt_dip=rad2deg(opt_dip);
opt_rake=rad2deg(opt_rake);