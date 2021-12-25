function preproc_sampling_grids()
clc;clear;close all;
%------------------------Modify Parameters at here------------------------%
%minlon=100;%deg
%maxlon=106;%deg
%minlat=28;%deg
%maxlat=36;%deg
%dlon=0.05;%deg
%dlat=0.05;%deg
%depth=10;%km
% receiver_strike=150;%deg
% receiver_dip=78;%deg
% receiver_rake=-13;%deg
% friction=0.4;
% skempton=0.0;
%-------------------------------------------------------------------------%
minlon=input('the minimum longitude (deg): ');
maxlon=input('the maximum longitude (deg): ');
minlat=input('the minimum latitude  (deg): ');
maxlat=input('the maximum latitude  (deg): ');
dlon=input('the longitude interval (deg):  ');
dlat=input('the latitude interval (deg): ');
depth=input('the depth at which CFS is computed (km): ');
%-------------------------------------------------------------------------%
outputfile='../grid/sampling_grids.in';
lon=minlon:dlon:maxlon;
lat=minlat:dlat:maxlat;
if lon(end)<maxlon
lon=[lon maxlon];
end
if lat(end)<maxlat
lat=[lat maxlat];
end
%
[lon,lat]=meshgrid(lon,lat);
lon=lon(:);
lat=lat(:);
totalN=length(lon);
fp=fopen(outputfile,'wt');
fprintf(fp,'%d\n',totalN);
for i=1:totalN
%    fprintf(fp,'%13.6f%13.6f%13.6f%13.6f%13.6f%13.6f%5.2f%5.2f\n',lat(i),lon(i),depth,receiver_strike,receiver_dip,receiver_rake,friction,skempton);
   fprintf(fp,'%13.6f%13.6f%13.6f\n',lat(i),lon(i),depth);
end
fclose(fp);
path=pwd;
n=find(path=='/');
disp([mfilename,'.m: The sampling file was saved in the following directory:']);
disp([path(1:max(n)),outputfile(4:end)]);
disp(sprintf('total sampling points: %d\ndlon=%8.1f km dlat=%8.1f km',totalN,deg2rad(dlon)*6378,deg2rad(dlat)*6378));
%
figure;
plot(lon,lat,'r.');
xlabel('Longitude(deg)');
ylabel('Latitude(deg)');
title('Gridded points');
set(gca,'FontSize',20);
set(gcf,'color','w');

%
