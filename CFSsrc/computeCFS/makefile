PROG=computeCFS
SRC= computeCFS.f90  \
     CFF.f90 \
     deg2rad.f90
FC= gfortran
FFLAGS= -g -O3
# FFLAGS= -g
OBJS=$(SRC:.f90=.o) 
$(PROG):$(OBJS)
	$(FC) -o $@ $(OBJS) $(FFLAGS)
%.o:%.f90
	$(FC) -c $(FFLAGS) $<
clean:
	rm -rf *.o
