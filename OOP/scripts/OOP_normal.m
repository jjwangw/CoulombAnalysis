function [opt_strike1, opt_dip1, opt_rake1, opt_strike2, opt_dip2, opt_rake2,opt_shear_stress, opt_normal_stress, opt_coulomb_stress ] ...
          = OOP_normal(earthquake_stress,tectonic_stress,friction,skempton,nload,Nslice)
%earthquake_stress:e11 e12 e13 e22 e23 e33
%tectonic_stress:t11 t12 t13 t22 t23 t33
%note that the earthquake_stress and tectonic_stress belong to a local
%topographic Cartesian coordinate system whose x, y and z axes are
%northern, eastern and upward.
%opt_strike1, opt_dip1, opt_rake1 are the strike, dip and rake angles of
%the first optimally oriented failure plane (OOP), respectively.
%opt_strike2, opt_dip2, opt_rake2 are the strike, dip and rake angles of
%the second OOP,respectively.
%opt_shear_stress, opt_normal_stress and opt_coulomb_stress are shear stress change,
%normal stress change and Coulomb stress change on the both OOPs (the Coulomb
%stress changes on the both OOPs are equal to each other), respectively.


row=size(earthquake_stress,1);
opt_strike1=[];
opt_dip1=[];
opt_rake1=[];
opt_strike2=[];
opt_dip2=[];
opt_rake2=[];
opt_shear_stress=[];
opt_normal_stress=[];
opt_coulomb_stress=[];
%
minstrike=0;
maxstrike=360;
dip=90-0.5*atand(1/friction);%dip angle in the principal stresses coordinate system
mindip=dip;
maxdip=dip;
minrake=-90;
maxrake=-90;
%
%N=7200;
%N=360000;
%N=360;
N=Nslice;
N=N+1;
strike_range=linspace(minstrike,maxstrike,N);
if nload==1
disp('prepare parameter space')
OOP_grid_search_coefficients(minstrike,maxstrike,mindip,maxdip,minrake,maxrake,friction,skempton,N);
end
load('grid_search_OOP_coeff.mat');
for i=1:row
     stress = earthquake_stress(i,:) + tectonic_stress(i,:);
     tempCFS=KOOP*stress';
     strike1=strike_range(tempCFS==max(tempCFS));
     strike1=strike1(1);
     dip1=dip;rake1=-90;
     opt_strike1=[opt_strike1;strike1];
     opt_dip1=[opt_dip1;dip1];
     opt_rake1=[opt_rake1;rake1];
%     
     strike2=strike1;
     dip2=dip;
     rake2=-90;
     opt_strike2=[opt_strike2;strike2];
     opt_dip2=[opt_dip2;dip2];
     opt_rake2=[opt_rake2;rake2];
     %
     stress= earthquake_stress(i,:);
     temp=[];
     [shear_stress,normal_stress,coulomb]=CFF(stress,strike1,dip1,rake1,friction,skempton);
     temp=[temp;shear_stress,normal_stress,coulomb];
     [shear_stress,normal_stress,coulomb]=CFF(stress,strike2,dip2,rake2,friction,skempton);
      temp=[temp;shear_stress,normal_stress,coulomb];
      temp
     opt_shear_stress=[opt_shear_stress;shear_stress];
     opt_normal_stress=[opt_normal_stress;normal_stress];
     opt_coulomb_stress=[opt_coulomb_stress;coulomb];  
     disp(sprintf('optstrike=%13.6f,optdip=%13.6f,optrake=%13.6f,shear=%13.6f,normal=%13.6f,coulomb=%13.6f',...
         opt_strike1(1),opt_dip1(1),opt_rake1(1),shear_stress(1),normal_stress(1),coulomb(1)));
end
