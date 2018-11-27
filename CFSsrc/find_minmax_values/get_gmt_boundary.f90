program get_gmt_boundary
implicit none
character*100 filename
real*8 lon,lat
real*8 minlon,maxlon,minlat,maxlat
integer*4 nargs
minlon=1.0e+9
maxlon=-1.0e+9
minlat=1.0e+9
maxlat=-1.0e+9
nargs=iargc();
if(nargs.ne.1) then
write(*,*)'Usage: ./get_gmt_boundary inputfile'
write(*,*)'the inputfile has the following format:'
write(*,*)'latitude(deg) longitude(deg)'
return
endif
call getarg(1,filename)
open(10,file=filename)
do while(.true.)
read(10,*,end=20)lat,lon
if(minlon.gt.lon) minlon=lon
if(maxlon.lt.lon) maxlon=lon
if(minlat.gt.lat) minlat=lat
if(maxlat.lt.lat) maxlat=lat
enddo
20 continue
open(11,file="gmtbounds.txt")
write(*,*)"   minlon   maxlon   minlat   maxlat"
write(*,1000)minlon,maxlon,minlat,maxlat
write(11,1001)minlon,maxlon,minlat,maxlat
1000 format(4f9.2)
1001 format(4f13.6)
close(10)
close(11)
end program get_gmt_boundary
