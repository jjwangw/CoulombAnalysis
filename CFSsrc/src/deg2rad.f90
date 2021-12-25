real*8 function  deg2rad(deg_angle)
implicit none
real*8 deg_angle
deg2rad=deg_angle/180.0d0*acos(-1.0d0)
end
