program find_minmax_values
real*8 minvalue,maxvalue,val
minvalue=1.0e+10
maxvalue=-1.0e+10
open(10,file='values.txt')
open(11,file='minmaxvalues.txt')
do while(.true.)
read(10,*,end=100)val
if(val.gt.maxvalue) maxvalue=val
if(val.lt.minvalue) minvalue=val
enddo
100 close(10)
write(11,1000)minvalue,maxvalue
1000 format(1x,'minvalue= ',f13.6,1x,'maxvalue=',f13.6)
end program find_minmax_values
