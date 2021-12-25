function preproc_sampling_profile()
clc;clear;close all;
%-------------------------------------------------------------------------%
path_receiver_fault=input('profile plane with the same format as a single source fault: ','s');
MM=700;
NN=200;
%MM=400;
%NN=50;
bprofile=1;
k1=0;k2=1;
k3=0;k4=1;
%-------------------------------------------------------------------------%
fp=fopen(path_receiver_fault,'r');
ss=textscan(fp,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','headerlines',1);
fclose(fp);
lat=ss{:,1};
lon=ss{:,2};
depth=ss{:,3};
length=ss{:,4};
width=ss{:,5};
AL1=ss{:,6};
AL2=ss{:,7};
AW1=ss{:,8};
AW2=ss{:,9};
strike=ss{:,10};
dip=ss{:,11};
row=size(lat,1);
unit=1.0e-3;
for i=1:row
    sL0=lon(i);
    L=length(i);
    W=width(i);
    strikee=strike(i);
    dipp=dip(i);
    ksi0=abs(AL1);
    eta0=abs(AW1);
    z0=-depth(i);%km
    sB=lat(i);
    sL=lon(i);
    [x0,y0]=generalBL2xy(sB,sL,sL0,3,1);
    x0=x0*unit;%from meter to kilometer
    y0=y0*unit;
    %
    %-----------------------------------%
    if W*sind(dip)>(-z0+abs(AW1)*sind(dip))
        disp('wrong width!the upper edge of the fault plane is above the earth''s surface!');
        W=-z0/sind(dip)+abs(AW1);
    end
    ksi_range=[k1*L, k2*L];
    eta_range=[k3*W,k4*W];
    %-----------------------------------%
    result_fault_corners=[];
    for j=1:6
        switch j
            case 1 %lower-left corner of fault plane
                ksi=0;
                eta=0;
                n=0;
            case 2 %lower-right corner of fault plane
                ksi=L;
                eta=0;
                n=0;
            case 3 %upper-right corner of fault plane
                ksi=L;
                eta=W;
                n=0;
            case 4 %upper-left corner of fault plane
                ksi=0;
                eta=W;
                n=0;
            case 5 %uppler-left corner of the projected plane along the updip direction
                ksi=0;
                eta=-z0/sind(dip)+abs(AW1);
                n=0;
            case 6 %uppler-right corner of the projected plane along the updip direction
                ksi=L;
                eta=-z0/sind(dip)+abs(AW1);
                n=0;
        end
        [x,y,z]=faultplanecoord2localCartesiancoord(strikee,dipp,ksi0,eta0,x0,y0,z0,ksi,eta,n);
        x=x/unit;%km to m
        y=y/unit;
        [Bc,Lc]=generalxy2BL(x,y,sL0,3);
        result_fault_corners=[result_fault_corners;Lc Bc z];
    end
    figure;
    temp=result_fault_corners;
    fill3(temp(1:4,1),temp(1:4,2),temp(1:4,3),'r');hold on;
    plot3(sL,sB,z0,'go','MarkerSize',5);
%-------------------------------------------------------------------------%
    if bprofile==1
    %discritizing the fault plane
    NT=MM*NN;
    LL=linspace(min(ksi_range),max(ksi_range),MM);
    WW=linspace(min(eta_range),max(eta_range),NN);
    [LL,WW]=meshgrid(LL,WW);
    LL=LL(:);
    WW=WW(:);
    pathout=['../profile/profile_along_fault_plane',num2str(i),'.txt'];
    fp=fopen(pathout,'wt');
    fprintf(fp,'%s\n','Fault corners of the fault plane and the projected line on the earth''s surface of the fault plane along updip direction.');
    fprintf(fp,'%s\n','the 1st line: lower left corner; the 2nd line: lower right corner; the 3rd line:upper right corner; the 4th corner: upper left corner');
    fprintf(fp,'%s\n','the 5th line: the starting point of the projected line; the 6th line: the ending point of the projected line.');
    fprintf(fp,'%s\n','   lon(deg)       lat(deg)    depth(km)');
    for ii=1:6
        fprintf(fp,'%13.6f%13.6f%13.6f\n',temp(ii,1),temp(ii,2),temp(ii,3));
    end
    fprintf(fp,'%s\n','coordinate on the fault plane:(ksi, W-eta(downdip km))');
    fprintf(fp,'%13.6f%13.6f\n%13.6f%13.6f\n%13.6f%13.6f\n%13.6f%13.6f\n',0,max(eta_range)-0,L,max(eta_range)-0,L,max(eta_range)-W,0,max(eta_range)-W);
    fprintf(fp,'%s\n','''Downdip'' means the reference   point of the fault plane coordinate system is the upper left corner on the earth''s surface')
    fprintf(fp,'range of the sampled plane(note that x axis is along strike direction, y axis is along downdip direction, and the origin is the\n upper left corner of the plane intersected with the earth''s surface):\n');
    fprintf(fp,'along strike: %13.6f%13.6f\n',  min(ksi_range),max(ksi_range));
    fprintf(fp,'along downdip: %13.6f%13.6f\n', 0,max(eta_range)-min(eta_range));
    fprintf(fp,'fault box is:\n');
    fprintf(fp,'%13.6f%13.6f\n%13.6f%13.6f\n%13.6f%13.6f\n%13.6f%13.6f\n%13.6f%13.6f\n',0, max(eta_range)-0,L, max(eta_range)-0, L, max(eta_range)-W, ...
        0, max(eta_range)-W,0, max(eta_range)-0);
    fprintf(fp,'%s\n%s\n%d\n','The following are the sampling points on the fault plane','     lat(deg)    lon(deg)      depth(km)    ksi(km)      W-eta(km)(downdip)',NT);
    
    for k=1:NT
        ksi=LL(k);
        eta=WW(k);
        n=0;
        [x,y,z]=faultplanecoord2localCartesiancoord(strikee,dipp,ksi0,eta0,x0,y0,z0,ksi,eta,n);
        x=x/unit;%km to m
        y=y/unit;
        [Bc,Lc]=generalxy2BL(x,y,sL0,3);
        fprintf(fp,'%13.6f%13.6f%13.6f%13.6f%13.6f\n',Bc,Lc,-z,ksi,max(eta_range)-eta);
        sprintf('k=%d N=%d done(%4.1f%%)\n',k,NT,k*100/NT)
        plot3(Lc,Bc,z,'b.');
    end
     fclose(fp);
    end
end
return;
%-------------------------------------------------------------------------%
    %
    pathout='../profile/inputdata/profile_aftershocks.txt';
    aftershocks=importdata(path_aftershocks);
    %plot3(aftershocks(:,7),aftershocks(:,8),-aftershocks(:,9),'go');
    %
    fp1=fopen(pathout,'wt');
    fprintf(fp1,'%s\n','''Downdip'' means the referecen point of the fault plane coordinate system is the upper left corner.');
    fprintf(fp1,'%s\n','''n(km)'' means the distance to the fault plane positive towards its normal.');
    fprintf(fp1,'%s\n%s\n','The following are the projected points of aftershocks on the fault plane','     lat(deg)    lon(deg)      depth(km)    ksi(km)      W-eta(km)(downdip)     n(km)');
    row=size(aftershocks,1);
    for k=1:row
        sL=aftershocks(k,7);
        sB=aftershocks(k,8);
        z=-aftershocks(k,9);
        [x,y]=generalBL2xy(sB,sL,sL0,3,1);
        x=x*unit;%note that from meter to kilometer
        y=y*unit;
        [ksi,eta,n]=localCartesiancoord2faultplanecoord(strikee,dipp,ksi0,eta0,x0,y0,z0,x,y,z);
        %fprintf(fp1,'%13.6f%13.6f%13.6f%13.6f%13.6f%23.6f\n',sB,sL,-z,ksi,W-eta,n);
        fprintf(fp1,'%13.6f%13.6f%13.6f%13.6f%13.6f%23.6f\n',sB,sL,-z,ksi,max(eta_range)-eta,n);
    end
    fclose(fp1);
    %

function [x,y,z]=faultplanecoord2localCartesiancoord(strike,dip,ksi0,eta0,x0,y0,z0,ksi,eta,n)
%ksi,eta,n with reference point being the lower left corner of fault plane
    theta=deg2rad(strike);
    D=deg2rad(dip);
    Rtheta=[cos(theta)  sin(theta)  0;... %x north, y east, z upward
            sin(theta) -cos(theta)  0;...
            0            0          1];
    Rdip=[1   0     0 ;...
          0   cos(D) -sin(D);...
          0   sin(D)  cos(D)];
    C=Rtheta*Rdip*[ksi-ksi0;eta-eta0;n]+[x0;y0;z0];
    x=C(1);
    y=C(2);
    z=C(3);
function [ksi,eta,n]=localCartesiancoord2faultplanecoord(strike,dip,ksi0,eta0,x0,y0,z0,x,y,z)
%ksi,eta,n with reference point being the lower left corner of fault plane
    theta=deg2rad(strike);
    D=deg2rad(dip);
    Rtheta=[cos(theta)  sin(theta)  0;... %x north, y east, z upward
            sin(theta) -cos(theta)  0;...
            0            0          1];
    Rdip=[1   0     0 ;...
          0   cos(D) -sin(D);...
          0   sin(D)  cos(D)];
    A=Rdip'*Rtheta'*[x-x0;y-y0;z-z0]+[ksi0;eta0;0];
    ksi=A(1);
    eta=A(2);
    n=A(3);
