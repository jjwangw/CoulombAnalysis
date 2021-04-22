program OOPCFFmax
!this code is used to compute the optimally oriented failure plane and the Coulomb stress
!on the OOP based on grid search. The error of grid search is 0.36 deg. The grid search, in my opinion,
!is a good approach used to resolve the OOP because other nonlinear methods would just find a local minima
!and it is possible that no right OOP could be determined. I have tested this point using PSO method.
!
!coded on March 22, 2016

implicit none
real*8 strike,dip,rake,friction,skempton,CFFvalue,optCFFvalue,optCFFvalue_onfault
real*8 stress(6),earthquake_stress(6),tectonic_stress(6)
real*8 minStrike,maxStrike,minDip,maxDip,minRake,maxRake
real*8 optStrike,optDip,optRake
real*8 optshearstress,optnormalstress
real*8 delta_strike,delta_dip,delta_rake
real*8 tempCFF,tempstrike,tempdip,temprake
integer*4 i,n
integer*8 ii,jj,kk,j,k,m,Nloop
integer*8 Npoints,Mpoints,NN
character*100 inputfile_earthquake_stress,inputfile_tectonic_stress,outputfile,strline
character*100 argstr
integer*4 ntest,bshutdown
!parameter(NN=36)
!------------------------------------------
ntest=0
if(ntest.eq.1)then
!toda
strike=113.991
dip=34.099
rake=90
!mine
!strike=329.76
!dip=76.59
!rake=90
friction=0.4
skempton=0.0
stress(1)=1.
stress(2)=2.
stress(3)=3.
stress(4)=4.
stress(5)=5.
stress(6)=6.
call CFF_cal(stress,strike,dip,rake,friction,skempton,optshearstress,optnormalstress,CFFvalue)
write(*,*)'CFFvalue=',CFFvalue
return
endif
n=iargc()
if(n.lt.12)then
write(*,*)'the input parameters are too less!'
write(*,*)'Usage: ./OOPCFFmax earthquake_stress tectonic_stress stress.out 0 360 0 90 -180 180 0.4 0 36'
write(*,*)'''earthquake_stress'' is the file of stress tensors imparted by earthquake.it''s data format is as follows:'
write(*,*)'e11     e12    e13    e22   e23    e33'
write(*,*)'1.0e-6 2.0e-6 3.0e-6 4.0e-6 5.0e-6 6.0e-6'
write(*,*)'both the earthquake stress and tectonic stress belong to the coordinate system'
write(*,*)'whose x is northern, y is eastern and z is upward.'
write(*,*)'''tectonic_stress'' is the file of stress tensors of regional stress field. the data format of'
write(*,*)'tectonic stress is the same as that of the earthquake stress.'
write(*,*)'''coulomb.out'' is the output file of optimal CFF and strike, dip and rake angles.'
write(*,*)'0 360 are the range of the strike angles of receiver fault.'
write(*,*)'0 90 are the range of the dip angles of receiver fault.'
write(*,*)'-180 180 are the range of the rake angles of receiver fault.'
write(*,*)'0.4 is the friction coefficient.It''s in the range of [0,1] and commonly it''s 0.4'
write(*,*)'0 is the skempton''s coefficient.It''s in the range of [0,1]'
write(*,*)'36 is the gridded number of strike, dip and rake angles.'
return
endif
do i=1,n
call getarg(i,argstr)
write(*,*)'i=',i,'argstr=',argstr
select case(i)
    case (1)
    read(argstr,*)inputfile_earthquake_stress
    write(*,*)'inputfile_earthquake_stress=',inputfile_earthquake_stress
    case (2)
    read(argstr,*)inputfile_tectonic_stress
    write(*,*)'inputfile_tectonic_stress=',inputfile_tectonic_stress
    case (3)
    read(argstr,*)outputfile
    write(*,*)'outputfile=',outputfile
    case (4)
    read(argstr,*)minStrike
    write(*,*)'minStrike=',minStrike
    case (5)
    read(argstr,*)maxStrike
    write(*,*)'maxStrike=',maxStrike
    case (6)
    read(argstr,*)minDip
    write(*,*)'minDip=',minDip
    case (7)
    read(argstr,*)maxDip
    write(*,*)'maxDip=',maxDip
    case (8)
    read(argstr,*)minRake
    write(*,*)'minDip=',minRake
    case (9)
    read(argstr,*)maxRake
    write(*,*)'maxRake=',maxRake
    case (10)
    read(argstr,*)friction
    write(*,*)'friction=',friction
    case (11)
    read(argstr,*)skempton
    write(*,*)'skempton=',skempton
    case (12)
    read(argstr,*)NN
    write(*,*)'grid N=',NN
    case default
    write(*,*)'dummy parameter!'
end select
enddo
!--------------------------
!inputfile_earthquake_stress='stress_e.out'
!inputfile_tectonic_stress='tectonic_stress.in'
!outputfile='stress_test.out'
!minStrike=0.
!maxStrike=180.!bug.March 23,2016
!maxStrike=360.0
!minDip=0.
!maxDip=90.
!minRake=-180.
!maxRake=180.
!friction=0.6
!skempton=0.0
!--------------------------
!
delta_strike=(maxStrike-minStrike)/NN
delta_dip=(maxDip-minDip)/NN
delta_rake=(maxRake-minRake)/NN
!
open(1,file=inputfile_earthquake_stress)
open(2,file=inputfile_tectonic_stress)
open(3,file=outputfile)
write(3,*)'  opt_str1   opt_dip1 opt_rake1  shear stress(bar)  normal stress(bar) coulomb stress(bar)'
!
write(*,*)'processing...'
do while(.true.)
ii=ii+1
read(1,*,end=100)(earthquake_stress(jj),jj=1,6)
write(*,*)'earthquake stress'
write(*,*)(earthquake_stress(jj),jj=1,6)
read(2,*)(tectonic_stress(jj),jj=1,6)
write(*,*)'regional tectonic stress'
write(*,*)(tectonic_stress(jj),jj=1,6)
do kk=1,6
stress(kk)=earthquake_stress(kk)+tectonic_stress(kk)
enddo
optCFFvalue=-1.0e+10
!grid search the optimal strike,dip and rake angles of the receiver fault on which the CFF is the maximum.
  do j=0,NN !strike
      strike=delta_strike*j+minStrike
    do k=0,NN !dip
        dip=delta_dip*k+minDip
        do m=0,NN !rake
          rake=delta_rake*m+minRake
          call CFF_cal(stress,strike,dip,rake,friction,skempton,optshearstress,optnormalstress,CFFvalue)
            if(CFFvalue.gt.optCFFvalue)then
                optStrike=strike
                optDip=dip
                optRake=rake
                optCFFvalue=CFFvalue
            endif
            if(abs(delta_rake).le.1.0d-6)then
                exit
            endif 
        enddo !end of rake loop
      if(abs(delta_dip).le.1.0d-6)then
       exit
      endif
    enddo !end of dip loop
    write(*,1000)strike
    1000 format(1x,'strike=',f8.3,1x,'deg')
  enddo
!----------------
write(*,*)'i=',ii,'optCFFvalue=',optCFFvalue,'optStrike=',optStrike,'optDip=',optDip,'optRake=',optRake
call CFF_cal(earthquake_stress,optStrike,optDip,optRake,friction,skempton,optshearstress,optnormalstress,optCFFvalue_onfault)
write(3,1500)optStrike,optDip,optRake,optshearstress,optnormalstress,optCFFvalue_onfault
1500 format(1x,3f13.6,3e28.16)
enddo
100 close(1)
close(2)
close(3)
write(*,*)'it''s done!'


end program OOPCFFmax



subroutine CFF_cal(stress,strike,dip,rake,friction,skempton,shear_stress,normal_stress,CFFvalue)
!
!calculate coulomb stress change by projecting the stress belonging to a coordinate system whose x is northern,
!y is eastern and z is upward onto a predefined fault plane with strike, dip and rake angles.
!
!coded on 14:16 March 22,2016
!

implicit none
real*8 strike,dip,rake,friction,skempton,CFFvalue,stress(6)
real*8 shear_stress,normal_stress
real*8 A,D,L,miu,B,e11,e12,e13,e22,e23,e33
real*8 deg2rad
parameter(deg2rad=0.017453292519943)
A=strike*deg2rad
D=dip*deg2rad
L=rake*deg2rad
miu=friction
skempton=B
e11=stress(1)
e12=stress(2)
e13=stress(3)
e22=stress(4)
e23=stress(5)
e33=stress(6)
!
shear_stress=sin(L)*(-0.5*sin(A)**2.*sin(2.*D)*e11+0.5*sin(2.*A)*sin(2.*D)*e12+sin(A)*cos(2.*D)*e13-&
 0.5*cos(A)**2.*sin(2.*D)*e22-cos(A)*cos(2.*D)*e23+0.5*sin(2.*D)*e33)+ &
 cos(L)*(-0.5*sin(2.*A)*sin(D)*e11+cos(2.*A)*sin(D)*e12+cos(A)*cos(D)*e13+&
 0.5*sin(2.*A)*sin(D)*e22+sin(A)*cos(D)*e23)
normal_stress=sin(A)**2.*sin(D)**2.*e11-sin(2.*A)*sin(D)**2.*e12-sin(A)*sin(2.*D)*e13+&
 cos(A)**2.*sin(D)**2.*e22+cos(A)*sin(2.*D)*e23+cos(D)**2.*e33
CFFvalue=shear_stress+miu*(normal_stress-B/3.0*(e11+e22+e33))
!
end



