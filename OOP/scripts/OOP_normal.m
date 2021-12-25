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
dip=90-0.5*atand(1/friction);%dip angle in the principal stresses coordinate system
rake=-90;
if nload==1
disp('prepare the parameter space')
OOP_coefficients(dip,rake,friction);
end
load('grid_OOP_coeff.mat');
for i=1:row
     stress = earthquake_stress(i,:) + tectonic_stress(i,:);
     K=KOOP.*stress;
     %k11 k12 k13 k22 k23 k33
     %1   2   3   4   5   6
     A1=K(1)-K(4); %A1=k11-k22
     A2=2*K(2);    %A2=2*k12
     A3=K(3);      %A3=k13
     A4=-K(5);     %A4=-k23
     %
     B1=4*(A1^2+A2^2);
     B2=4*(A1*A4+A2*A3);
     B3=-4*A1^2-4*A2^2+A3^2+A4^2;
     B4=-2*A2*A3-4*A1*A4;
     B5=A2^2-A4^2;
     %
     if B1==0
          if A3==0&&A4==0
             x=[-1,1];
          else
             temp=sqrt( A4^2/(A3^2+A4^2) );
             x=[-temp,temp];
          end
     else
          x=roots([B1,B2,B3,B4,B5]);
          x=real( x((imag(x)==0),:) );%cos(phi)
     end
     %
     if isempty(x)
         warning('fail to find the 1D thrust-slip OOP!');
     else
         strikes=[];
         coulombs=[];
         nx=length(x);
        for j=1:nx
            tempstrike1=acosd( x(j) );
            tempstrike2=180+acosd( -x(j) );
            strikes=[strikes;tempstrike1;tempstrike2];
            [~,~,tempcoulomb]=CFF(stress,tempstrike1,dip,rake,friction,skempton);
            coulombs=[coulombs;tempcoulomb];
            [~,~,tempcoulomb]=CFF(stress,tempstrike2,dip,rake,friction,skempton);
            coulombs=[coulombs;tempcoulomb];
        end
     end
     strikes=strikes(max(coulombs)==coulombs);
     if length(strikes)==1
         strikes=[strikes strikes];
     end
     strike1=strikes(1);
     dip1=dip;
     rake1=-90;
     opt_strike1=[opt_strike1;strike1];
     opt_dip1=[opt_dip1;dip1];
     opt_rake1=[opt_rake1;rake1];
%     
     strike2=strikes(2);
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
