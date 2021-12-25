program computeCFS
integer*4 i
character*100 arg,path_stress
real*8 strike,dip,rake,friction,skempton
real*8 stress(6),shear_stress,normal_stress,coulomb_stress
call getarg(1,arg)
read(arg,*)strike
call getarg(2,arg)
read(arg,*)dip
call getarg(3,arg)
read(arg,*)rake
call getarg(4,arg)
read(arg,*)friction
call getarg(5,arg)
read(arg,*)skempton
write(*,*)'-----the parameters of receiver faults-----'
write(*,*)strike,dip,rake,friction,skempton
open(10,file='stress.out')
open(11,file='shearnormalcoulomb.out')
write(*,*)'processing...'
write(11,*)'    shear_stress(bar)  normal_stress(bar) coulomb_stress(bar)'
do while(.true.)
read(10,*,end=100)(stress(i),i=1,6)
write(*,*)(stress(i),i=1,6)
call CFF(stress,strike,dip,rake,friction,skempton,shear_stress,normal_stress,coulomb_stress)
write(11,1000)shear_stress,normal_stress,coulomb_stress
1000 format(3e18.6)
enddo
100 close(10)
write(*,*)'done!'
end program computeCFS
