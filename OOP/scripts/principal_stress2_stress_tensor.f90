program principal_stress2_stress_tensor
implicit none
real*8 sigma1,sigma2,sigma3
real*8 plunge1,plunge2,plunge3
real*8 azimuth1,azimuth2,azimuth3
real*8 P1,P2,P3,T1,T2,T3
real*8 s(3,3)
real*8 deg2rad
real*8 A(3),B(3),C
character*100 arg
integer*4 nargc,i,j,N
real*8 e11,e12,e13,e22,e23,e33
!
!coded on 22:39 Aug.7th,2016 jjwang
!
nargc=iargc()
if(nargc.ne.9)then
write(*,*)'               '
write(*,*)'Usage: ./principal_stress2_stress_tensor sigma1 sigma2 sigma3 plunge1 plunge2 plunge3 azimuth1 azimuth2 azimuth3'
write(*,*)'This function is used to compute background tectonic stress tensor in a given coordinate system whose'
write(*,*)'x is northern, y is eastern and z is upward. The inputs are the principal stresses of sigma1, sigma2 and sigma3,'
write(*,*)'plunge angles of plunge1, plunge2, plunge3 with respect to horizontal plane(x-o-y) of the three principal axes,'
write(*,*)'and azimuth angles of azimuth1, azimuth2, azimuth3 for the horizontal projection of the three principal axes'
write(*,*)'counted clockwisely from due north (x axis).'
write(*,*)'               '
return
endif
!
deg2rad=acos(-1.0d0)/180.0d0
!
call getarg(1,arg)
read(arg,*)sigma1
!
call getarg(2,arg)
read(arg,*)sigma2
!
call getarg(3,arg)
read(arg,*)sigma3
!
call getarg(4,arg)
read(arg,*)plunge1
!
call getarg(5,arg)
read(arg,*)plunge2
!
call getarg(6,arg)
read(arg,*)plunge3
!
call getarg(7,arg)
read(arg,*)azimuth1
!
call getarg(8,arg)
read(arg,*)azimuth2
!
call getarg(9,arg)
read(arg,*)azimuth3
!
!write(*,*)sigma1,sigma2,sigma3,plung1,plung2,plung3,azimuth1,azimuth2,azimuth3
!
P1=plunge1*deg2rad
P2=plunge2*deg2rad
P3=plunge3*deg2rad
!
T1=azimuth1*deg2rad
T2=azimuth2*deg2rad
T3=azimuth3*deg2rad
!
s(1,1)=cos(P1)*cos(T1)
s(2,1)=cos(P1)*sin(T1)
s(3,1)=sin(P1)
!
s(1,2)=cos(P2)*cos(T2)
s(2,2)=cos(P2)*sin(T2)
s(3,3)=sin(P2)
!
s(1,3)=cos(P3)*cos(T3)
s(2,3)=cos(P3)*sin(T3)
s(3,3)=sin(P3)
!write(*,*)P1,P2,P3,T1,T2,T3
!
!write(*,*)((s(i,j),i=1,3),j=1,3)
!
N=3
do i=1,2
   A(1)=s(1,i)
   A(2)=s(2,i)
   A(3)=s(3,i)
do j=i+1,3
   B(1)=s(1,j)
   B(2)=s(2,j)
   B(3)=s(3,j)
    C=A(1)*B(1)+A(2)*B(2)+A(3)*B(3)
!  call two_vector_dot_product(A,B,N,C)
 ! write(*,*)'C=',C
 if(abs(C).gt.1.0e-6)then
  write(*,*)'***error: at least two principal axes are not orthogonal to each other!'
  return
 endif
enddo
enddo
!
e11=cos(P1)**2d0*cos(T1)**2d0*sigma1+cos(P2)**2d0*cos(T2)**2d0*sigma2+cos(P3)**2d0*cos(T3)**2d0*sigma3
e12=0.5d0*( cos(P1)**2d0*sin(2d0*T1)*sigma1+cos(P2)**2d0*sin(2d0*T2)*sigma2+cos(P3)**2d0*sin(2d0*T3)*sigma3 )
e13=0.5d0*( sin(2d0*P1)*cos(T1)*sigma1+sin(2d0*P2)*cos(T2)*sigma2+sin(2d0*P3)*cos(T3)*sigma3 )
e22=cos(P1)**2d0*sin(T1)**2d0*sigma1+cos(P2)**2d0*sin(T2)**2d0*sigma2+cos(P3)**2d0*sin(T3)**2d0*sigma3
e23=0.5d0*( sin(2d0*P1)*sin(T1)*sigma1+sin(2d0*P2)*sin(T2)*sigma2+sin(2d0*P3)*sin(T3)*sigma3 )
e33=sin(P1)**2d0*sigma1+sin(P2)**2d0*sigma2+sin(P3)**2d0*sigma3
write(*,1000)e11,e12,e13,e22,e23,e33
1000 format(1x,'e11 = ',1x,e13.6,1x,'e12 = ',1x,e13.6,1x,'e13 = ',1x,e13.6,/,&
            1x,'e22 = ',1x,e13.6,1x,'e23 = ',1x,e13.6,1x,'e33 = ',1x,e13.6)
end program principal_stress2_stress_tensor


subroutine two_vector_dot_product(a,b,N,c)
implicit none
integer*4 i,N
real*8 a(N),b(N),c,temp
temp=0d0
do i=1,N
temp=temp+a(i)*b(i)
enddo
end
