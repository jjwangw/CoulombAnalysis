function [opt_strike1, opt_dip1, opt_rake1, opt_strike2, opt_dip2, opt_rake2,opt_shear_stress, opt_normal_stress, opt_coulomb_stress ] ...
          = find_3D_OOP(earthquake_stress,tectonic_stress,friction,skempton)
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
for i=1:row
     stress = earthquake_stress(i,:) + tectonic_stress(i,:);
     stress_tensor=[stress([1 2 3]);...
                    stress([2 4 5]);...
                    stress([3 5 6])];
     [V,D]=eig(stress_tensor);
     [tempD,tempN]=sort(diag(D));
     D=diag(tempD);
     V=V(:,tempN);
     sigma1=D(3,3);%the maximum principal stress
     %s2=D(2,2);%the intermediate principal stress
     sigma3=D(1,1);%the minimum principal stress
     P=V(:,[3 2 1]);%the principal stress axes
     alpha=0.5*atan(1/friction);
     n1=[cos(alpha);0;sin(alpha)];
     s1=[sin(alpha);0;-cos(alpha)];
     %
     n2=[cos(alpha);0;-sin(alpha)];
     s2=[sin(alpha);0;cos(alpha)];
     %
     new_n1=P*n1;
     new_s1=P*s1;
     [strike1,dip1,rake1]=normal_slip_directions2_strike_dip_rake_angles(new_n1,new_s1);
     opt_strike1=[opt_strike1;strike1];
     opt_dip1=[opt_dip1;dip1];
     opt_rake1=[opt_rake1;rake1];
     %
     new_n2=P*n2;
     new_s2=P*s2;
     [strike2,dip2,rake2]=normal_slip_directions2_strike_dip_rake_angles(new_n2,new_s2);
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
end
