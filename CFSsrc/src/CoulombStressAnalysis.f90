program CoulombStressAnalysis
!This source code is used to compute the static Coulomb stress change induced by earthquake
!faulting in a half space. The key elements of this source code include: (1) computing stress tensor
!using the Okada's dislocation model (Okada et al., 1992,BSSA); (2) performing tensor transformation to
!transform stress tensor in fault coordinate system into local Cartesian coordinate system and (3) substituting
!the transformed stress tensor into the Coulomb stress model to compute the static Coulomb stress change.
!
!coded on Sep. 25, 2014, AK
!jjwang@sgg.whu.edu.cn

!
implicit none
!displacment
real*8 UX,UY,UZ
!gradient of displacement 
real*8 UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ
!stran and stress
real*8 strain(6),stress(6),sum_stress(6),stressin(3,3),trans_matrix(3,3),stressout(3,3)
!Lame constants.
real*8 lambda,mu,alpha
!observation point
real*8 x,y,z
!source fault
real*8 depth,ksi0,eta0,length,width,strike,dip,strike_slip,dip_slip,tensile_slip
!receiver fault
real*8 strike_receiver,dip_receiver,rake_receiver,friction,Skempton
!
real*8, allocatable::xs(:)
real*8, allocatable::ys(:)
real*8, allocatable::xr(:)
real*8, allocatable::yr(:)
!
integer*4 IRET
integer*8 bjudge,i,j,k
integer*8 naltermode_receiver
!pathname
character*100 slip_model_file,sampling_points_file,stress_file,coulomb_file,commonpath,strline
!number of source faults and number of sampling points
integer*8  Nfaults,Nsamplings
!source fault and samping points
real*8, allocatable::faults(:,:)
real*8, allocatable::samplingpoints(:,:)
!real*8 faults(100,10),samplingpoints(500,8)
!central meridian of Gaussian plane
real*8 meridian
!
real*8 deltax,deltay
!
!coulomb stress
real*8 shear_stress,normal_stress,coulomb_stress
!
real*8 temp
!
!
real*8, external::deg2rad
!
real*8 AL1,AL2,AW1,AW2
!
character*100 arg

!------------------------------------------
lambda=3.3e+5 !bars
mu=3.3e+5 !bars
alpha=(lambda+mu)/(lambda+2*mu)
!----------------------------------------
print *,'----read source fault model----'
slip_model_file='slipmodel.in'
!read(*,'(a)')slip_model_file
!write(*,*)slip_model_file
print*,'source fault model file: ',slip_model_file
open(unit=10,file=slip_model_file)
read(10,*)Nfaults
write(*,1000)Nfaults
1000 format(1x,"Nfaults=",i4)
allocate(faults(Nfaults,14))
allocate(xs(Nfaults))
allocate(ys(Nfaults))
print *,'the source faults are as follows:'
!print *,' lat.(deg)  lon.(deg) depth(km) length(km) width(km) AL1(km) AL2(km) AW1(km) AW2(km) strike(deg) dip(deg) s1(m)   s2(m)  s3(m)'
!temp=0;
do i=1,Nfaults   
   read(10,*)(faults(i,j),j=1,14)
   write(*,1001)(faults(i,j),j=1,14)
1001 format(14f10.3)
!   temp=temp+faults(i,2)
enddo
close(10)
print *, '----read sampling points(receiver faults)----'
sampling_points_file='samplingpoints.in'
print*,'sampping points file: ',sampling_points_file
!read(*,'(a)')sampling_points_file
!write(*,*)sampling_points_file
open(11,file=sampling_points_file)
read(11,*)Nsamplings
write(*,1002)Nsamplings
1002 format(1x,"Nsamplings=",i4)
allocate(samplingpoints(Nsamplings,8))
allocate(xr(Nsamplings))
allocate(yr(Nsamplings))
print *,'the sampling points are as follows:'
print *,'lat.(deg)  lon.(deg)  depth(km) strike(deg) dip(deg) rake(deg) friction Skempton'
temp=0.0
call getarg(1,arg)
read(arg,*)naltermode_receiver
write(*,*)naltermode_receiver
do i=1,Nsamplings
  if (naltermode_receiver.ne.1)then
  read(11,*)(samplingpoints(i,j),j=1,3)
  write(*,1003)(samplingpoints(i,j),j=1,3)!lat., lon, depth
 else
 read(11,*)(samplingpoints(i,j),j=1,8) !lat., lon., depth, strike, dip, rake, friction, Skempton
 write(*,1003)(samplingpoints(i,j),j=1,8)
 endif
1003 format(3f10.3)
temp=temp+samplingpoints(i,2)
enddo
close(11)
!
print *,'----Gauss projection of reference points of source faults and sampling points----'
!meridian=temp/(Nfaults+Nsamplings)
meridian=temp/Nsamplings
!
call getarg(7,arg)
read(arg,*)meridian
!
write(*,1004)meridian
1004 format(1x,"The central meridian of Gauss projection is:",f8.3)
print *, '----Gauss projection of reference points of source faults----'
print *,'   lat.(deg)     lon.(deg)         xs(m)           ys(m)'
!xs is the northern component of gaussian coordinate
!ys is the sourthern component of gaussian coordinate
do i=1,Nfaults
call generalBL2xy(faults(i,1),faults(i,2),meridian,3,1,xs(i),ys(i))
write(*,1005)faults(i,1),faults(i,2),xs(i),ys(i)
1005 format(1x,2f13.6,2e16.6)
enddo
print *, '----Gauss projection of sampling points----'
print *,'   lat.(deg)     lon.(deg)         xr(m)           yr(m)'
do i=1,Nsamplings
call generalBL2xy(samplingpoints(i,1),samplingpoints(i,2),meridian,3,1,xr(i),yr(i))
write(*,1006)samplingpoints(i,1),samplingpoints(i,2),xr(i),yr(i)
1006 format(1x,2f13.6,2e16.6)
enddo
!
print *,'----computing stress tensor at each sampling point----'
!read(*,'(a)')stress_file
!write(*,*)stress_file
!read(*,'(a)')coulomb_file
!write(*,*)coulomb_file
stress_file='stress.out'
coulomb_file='coulomb.out'
open(unit=12,file=stress_file)
open(unit=13,file=coulomb_file)
write(12,*)'          e11               e12               e13              e22               e23               e33'
write(13,*)'     lon.         lat.     shear_stress(bar)   normal_stress(bar)   coulomb_stress(bar)'
call getarg(2,arg)
read(arg,*)strike_receiver
write(*,*)strike_receiver
!
call getarg(3,arg)
read(arg,*)dip_receiver
write(*,*)dip_receiver
!
call getarg(4,arg)
read(arg,*)rake_receiver
write(*,*)rake_receiver
!
call getarg(5,arg)
read(arg,*)friction
write(*,*)friction
call getarg(6,arg)
read(arg,*)Skempton
write(*,*)Skempton
!
print *,'processing...'
do i=1,Nsamplings
 call InitializeStress(sum_stress)
 do j=1,Nfaults
 deltax=( xr(i)-xs(j) )*1.0d-3 !deltax=x-x0. (x,y) is the coordinate of each sampling point in a Guassian plane
 deltay=( yr(i)-ys(j) )*1.0d-3 !deltay=y-y0. (x0,y0) is the coordinate of reference point of each source fault
                                       ! in the same Guassian plane.
!-------------------
!transform coordinate of each sampling point into fault system corresponding to  each source fault 
!whose x is along strike, y is perpendicular to x, z is upward and x-y-z are right-hand coordinate system;
!its origin is (x0,y0) in a Guassian plane and the distance between this origin and its projection on the fault plane of the source fault
!is the depth of the reference point of the source fault.
strike=deg2rad(faults(j,10))
x=cos(strike)*deltax+sin(strike)*deltay
y=sin(strike)*deltax-cos(strike)*deltay
z=-samplingpoints(i,3) 
depth=faults(j,3)
dip=faults(j,11)
length=faults(j,4)
width=faults(j,5)
!(ksi0,eta0) is the coordinate of the referecne point on the source fault plane  in the fault plane coordiante
!system whose x is along strike, y is along updip and z is the normal of the fault plane
!note that if the reference point of each source fault is not the lower left corner of the rectangular fault plane,
!then ks0 and eta0 should be changed. For instance, if the reference point is the centroid of the rectangluar fault plane
!then ks0=length/2,eta0=width/2; if the upper left corner of the rectangluar fault plane, then ks0=0,eta0=width.
!more details on this can be found on the site:http://www.bosai.go.jp/study/application/dc3d/DC3Dhtml_E.html. The subroutine 
!DC3D.f is downloaded from this site.
!
AL1=faults(j,6)
AL2=faults(j,7)
AW1=faults(j,8)
AW2=faults(j,9)
!
strike_slip=faults(j,12)
dip_slip=faults(j,13)
tensile_slip=faults(j,14)
call DC3D(alpha,x,y,z,depth,dip, &
                   AL1,AL2,AW1,AW2,&
                   strike_slip,dip_slip,tensile_slip,&
                  UX,UY,UZ,UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ,IRET)
call GradientDisp2Strain(UXX,UYX,UZX,UXY,UYY,UZY,UXZ,UYZ,UZZ,strain) 
call Strain2Stress(strain,lambda,mu,stress)
call StressArray2StressTensor(stress,stressin)
call Rphi(faults(j,10),trans_matrix) !because new format of inpdat data is used. here faults(j,10) instead of faults(j,6) is strike angle.10:00 Nov.14,2014
call TensorTrans(stressin,trans_matrix,stressout)
call StressTensor2StressArray(stressout,stress)
  do k=1,6
    sum_stress(k)=sum_stress(k)+stress(k)
  enddo
enddo !end of loop for source faults j
write(12,1007)(sum_stress(k)*1.0d-3,k=1,6) !note that as the unit of slip is meter and the unit of length is kilometer, the unit of strain should be 1.0e-3.
!1007 format(6e18.6)                         !so stress should be multiplied by a factor of 1.0e-3.
1007 format(6e28.16)
if (naltermode_receiver==1)then
strike_receiver=samplingpoints(i,4)
dip_receiver=samplingpoints(i,5)
rake_receiver=samplingpoints(i,6)
friction=samplingpoints(i,7)
Skempton=samplingpoints(i,8)
write(*,1009)strike_receiver,dip_receiver,rake_receiver,friction,Skempton
1009 format(1x,'receiver strike=',f9.3,2x,'receiver dip=',f9.3,2x,'receiver rake=',f9.3,2x,'friction=',f7.2,2x,'Skempton=',f7.2)
endif
do k=1,6
stress(k)=sum_stress(k)*1.0d-3
enddo
call CFF(stress,strike_receiver,dip_receiver,rake_receiver,friction,Skempton,shear_stress,normal_stress,coulomb_stress)
write(13,1008)samplingpoints(i,2),samplingpoints(i,1),shear_stress,normal_stress,coulomb_stress
!1008 format(2f13.6,3e18.6)
1008 format(2f13.6,3e26.15)
enddo !end of loop for sampling points i

!close outputfile
close(12)
close(13)
!free memory
deallocate(faults)
deallocate(samplingpoints)
deallocate(xs)
deallocate(ys)
deallocate(xr)
deallocate(yr)
print *, '----it''s done!----'
!
end program CoulombStressAnalysis
