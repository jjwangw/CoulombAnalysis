function drawgridCFS()
path=input('input the path of a CFS file: ','s');
nmode=input('input the selected number(1,2,or 3):');
[lon,lat,shear,normal,coulomb]=textread(path,'%f%f%f%f%f','delimiter','\t','headerlines',1);
cutoff=2;
minlon=min(lon);
maxlon=max(lon);
minlat=min(lat);
maxlat=max(lat);
lonnew=linspace(minlon,maxlon,300);
latnew=linspace(minlat,maxlat,300);
[lonnew,latnew]=meshgrid(lonnew,latnew);
h=figure;
set(h,'colormap',color_map());
switch nmode
  case {1,3}
coul=griddata(lon,lat,coulomb,lonnew,latnew);
h=pcolor(lonnew,latnew,coul);
shading interp;
  case 2
scatter(lon,lat,5,coulomb);
scale=4;
dlat=maxlat-minlat;
dlon=maxlon-minlon;
axis([minlon-dlon*scale,maxlon+dlon*scale,minlat-dlat*scale,maxlat+dlat*scale]);
end
caxis([-cutoff,cutoff]);
xlabel('Longitude(deg)');
ylabel('Latitude(deg)');
set(gca,'fontsize',18);
title(colorbar,'bars');
[~,filename,~] = fileparts(path);
print([filename,'.pdf'],'-dpdf');
%
function [map]=color_map()
map=[...
   0.125490196078431   0.376470588235294   1.000000000000000;...
   0.125490196078431   0.376470588235294   1.000000000000000;...
   0.125490196078431   0.623529411764706   1.000000000000000;...
   0.125490196078431   0.623529411764706   1.000000000000000;...
   0.125490196078431   0.749019607843137   1.000000000000000;...
   0.125490196078431   0.749019607843137   1.000000000000000;...
                   0   0.811764705882353   1.000000000000000;...
                   0   0.811764705882353   1.000000000000000;...
   0.164705882352941   1.000000000000000   1.000000000000000;...
   0.164705882352941   1.000000000000000   1.000000000000000;...
   0.333333333333333   1.000000000000000   1.000000000000000;...
   0.333333333333333   1.000000000000000   1.000000000000000;...
   0.498039215686275   1.000000000000000   1.000000000000000;...
   0.498039215686275   1.000000000000000   1.000000000000000;...
   0.666666666666667   1.000000000000000   1.000000000000000;...
   0.666666666666667   1.000000000000000   1.000000000000000;...
   1.000000000000000   1.000000000000000   0.329411764705882;...
   1.000000000000000   1.000000000000000   0.329411764705882;...
   1.000000000000000   0.941176470588235                   0;...
   1.000000000000000   0.941176470588235                   0;...
   1.000000000000000   0.749019607843137                   0;...
   1.000000000000000   0.749019607843137                   0;...
   1.000000000000000   0.658823529411765                   0;...
   1.000000000000000   0.658823529411765                   0;...
   1.000000000000000   0.541176470588235                   0;...
   1.000000000000000   0.541176470588235                   0;...
   1.000000000000000   0.439215686274510                   0;...
   1.000000000000000   0.439215686274510                   0;...
   1.000000000000000   0.301960784313725                   0;...
   1.000000000000000   0.301960784313725                   0;...
   1.000000000000000                   0                   0;...
   1.000000000000000                   0                   0];