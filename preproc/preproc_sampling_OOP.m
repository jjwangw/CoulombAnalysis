function preproc_sampling_OOP()
clc;clear;close all;
disp('-----the boundary and grid size of sampling points-----');
minlon=input('minimum longitude (deg): ');
maxlon=input('maximum longitude (deg): ');
minlat=input('minimum latitude (deg):  ');
maxlat=input('maximum latitude (deg): ');
dlon=input('step of longitude (deg): ');
dlat=input('step of latitude (deg): ');
depth=input('depth (km): ');
disp('-----the principal tectonic stress-----');
disp('the maximum principal stress s1 (magnitdue(bar), plunge(deg),trend(deg)):');
s1=input('s1: ');
disp('the intermediate principal stress s2 (magnitdue(bar), plunge(deg),trend(deg)):');
s2=input('s2: ');
disp('the minimum principal stress s3 (magnitdue(bar), plunge(deg),trend(deg)):');
s3=input('s3: ');
regional_stress=[s1;s2;s3];
%------------------------Modify Parameters at here------------------------%
nchoice=0;
switch nchoice
    case 1
minlon=100;%deg
maxlon=106;%deg
minlat=28;%deg
maxlat=36;%deg
dlon=0.01;%deg
dlat=0.01;%deg
depth=5;%km
% receiver_strike=150;%deg
% receiver_dip=78;%deg
% receiver_rake=-13;%deg
% friction=0.4;
% skempton=0.0;
%regional_stress=[-100 0 75;-10 90 0;-50 0 165];
% regional_stress=[-100 0 60;...
%                  -10 90 0;...
%                    0  0 150];
regional_stress=[-100 0 30;...
                 -10 90 0;...
                   0  0 120];
%  regional_stress=[-100 0 90;...
%                  -10 90 0;...
%                    0  0 180];
    case 2
minlon=102;%deg
maxlon=106;%deg
minlat=30;%deg
maxlat=34;%deg
dlon=0.01;%deg
dlat=0.01;%deg
depth=10;%km
% receiver_strike=150;%deg
% receiver_dip=78;%deg
% receiver_rake=-13;%deg
% friction=0.4;
% skempton=0.0;
%regional_stress=[-100 0 75;-10 90 0;-50 0 165];
% regional_stress=[-100 0 60;...
%                  -10 90 0;...
%                    0  0 150];
regional_stress=[-100 0 60;...
                 -10 90 0;...
                   0  0 150];
%  regional_stress=[-100 0 90;...
%                  -10 90 0;...
%                    0  0 180];
end
%-------------------------------------------------------------------------%
outputfile='../OOP/sampling_grids.in';
N=2;
N=601;
ddlon=9999;
epsilon=1.0e-4;
% while abs(ddlon-dlon)>epsilon
%     lon=linspace(minlon,maxlon,N);
%     ddlon=lon(2)-lon(1);
%     N=N+1;
% end
% %
% N=2;
% N=801;
% ddlat=9999;
% while abs(ddlat-dlat)>epsilon
%     lat=linspace(minlat,maxlat,N);
%     ddlat=lat(2)-lat(1);
%     N=N+1;
% end
lon=minlon:dlon:maxlon;
lat=minlat:dlat:maxlat;
ddlon=dlon;
ddlat=dlat;
%-----------------------------
[lon,lat]=meshgrid(lon,lat);
lon=lon(:);
lat=lat(:);
totalN=length(lon);
fp=fopen(outputfile,'wt');
fprintf(fp,'%d\n',totalN);
for i=1:totalN
    fprintf(fp,'%13.6f%13.6f%13.6f\n',lat(i),lon(i),depth);
end
fclose(fp);
path=pwd;
n=find(path=='/');
disp([mfilename,'.m: The sampling file was save in the following directory:']);
disp([path(1:max(n)),outputfile(4:end)]);
disp(sprintf('total sampling points: %d\ndlon=%8.1f km dlat=%8.1f km',totalN,deg2rad(ddlon)*6378,deg2rad(ddlat)*6378));
%
figure;
plot(lon,lat,'r.');
xlabel('Longitude(deg)');
ylabel('Latitude(deg)');
title('Gridded points');
set(gca,'FontSize',20);
set(gcf,'color','w');
%-------------------------------------------------------------------------%
outputfile='../OOP/tectonic_stress.in';
s=tectonic_stress(regional_stress);
if isempty(s)
    disp('something is wrong for generating tectonic background stresses.');
    return;
end
T=repmat([s(1,:) s(2,2:3) s(3,3)] ,totalN,1);%x is northern, y is eastern and z is upward.
dlmwrite(outputfile,T,'delimiter','\t','precision','%13.6e');
disp([mfilename,'.m: The regional tectonic stress file was save in the following directory:']);
disp([path(1:max(n)),outputfile(4:end)]);
%
