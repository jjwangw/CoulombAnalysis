function resolve_OOP(earthquake_stress_path,tectonic_stress_path,coulomb_path,nchoice,friction,skempton)
fp1=fopen(earthquake_stress_path,'r');
fp2=fopen(tectonic_stress_path,'r');
fp3=fopen(coulomb_path,'wt');
fprintf(fp3,'  opt_str1   opt_dip1 opt_rake1  opt_str2  opt_dip2 opt_rake2     shear stress(bar)  normal stress(bar) coulomb stress(bar)\n');
disp('processing ...');
Nslice=360;%the number of equal fractions for the range of strike angle [0,360], used in 'OOP_thrust.m' and 'OOP_normal'.
ncount=1;
    while ~feof(fp1)
    se=fscanf(fp1,'%f',6);
    st=fscanf(fp2,'%f',6);
    if isempty(se)||isempty(st)
        break;
    end
    switch nchoice
        case 1 %OOP_strike
            [opt_strike1,opt_dip1,opt_rake1,opt_shear_stress, opt_normal_stress, opt_coulomb_stress,total_CFFmax]=OOP1D_vertical_left_lateral_strike_slip(se',st',friction,skempton);
            num2str(opt_coulomb_stress)
            [opt_strike2,opt_dip2,opt_rake2,opt_shear_stress, opt_normal_stress, opt_coulomb_stress,total_CFFmax]=OOP1D_vertical_right_lateral_strike_slip(se',st',friction,skempton);
            num2str(opt_coulomb_stress)
	    disp('OOP_strike');
        case 2 %OOP_thrust
    [opt_strike1, opt_dip1, opt_rake1, opt_strike2, opt_dip2, opt_rake2,opt_shear_stress, opt_normal_stress, opt_coulomb_stress ] ...
          = OOP_thrust(se',st' ,friction,skempton,ncount,Nslice);
              disp('OOP_thrust');
              [opt_strike1 opt_dip1 opt_rake1 opt_strike2 opt_dip2 opt_rake2]
        case 3 %OOP_normal
    [opt_strike1, opt_dip1, opt_rake1, opt_strike2, opt_dip2, opt_rake2,opt_shear_stress, opt_normal_stress, opt_coulomb_stress ] ...
          = OOP_normal(se',st' ,friction,skempton,ncount,Nslice);
              disp('OOP_normal');
              [opt_strike1 opt_dip1 opt_rake1 opt_strike2 opt_dip2 opt_rake2]
%      %------------------
          case 4 %3D OOP
%          se=[ 0.232598517618278   0.006902909733292   0.622396950079850 0.694061438524276   0.229326531659840   0.688507293361295]';
%          st=zeros(6,1);
[opt_strike1, opt_dip1, opt_rake1, opt_strike2, opt_dip2, opt_rake2,opt_shear_stress, opt_normal_stress, opt_coulomb_stress ] ...
= find_3D_OOP(se',st' ,friction,skempton);
             disp('the 3D OOP');
    end
%    fprintf(fp3,'%10.4f%10.4f%10.4f%10.4f%10.4f%10.4f%19.6e%19.6e%19.6e\n',opt_strike1(1), opt_dip1(1), opt_rake1(1), opt_strike2(1), opt_dip2(1), opt_rake2(1),...
disp(['------save in file: ',coulomb_path]);
[opt_strike1 opt_dip1 opt_rake1 opt_strike2 opt_dip2 opt_rake2]

fprintf(fp3,'%10.4f%10.4f%10.4f%10.4f%10.4f%10.4f%28.16e%28.16e%28.16e\n',opt_strike1(1), opt_dip1(1), opt_rake1(1), opt_strike2(1), opt_dip2(1), opt_rake2(1),...
        opt_shear_stress(1), opt_normal_stress(1), opt_coulomb_stress(1));
    disp(sprintf('ncount=%d',ncount));  ncount=ncount+1;
end
fclose(fp1);
fclose(fp2);
fclose(fp3);
if exist('grid_search_OOP_coeff.mat','file')~=0
delete('grid_search_OOP_coeff.mat');
end
disp('all done!');
