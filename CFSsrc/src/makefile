PROG=CoulombStressAnalysis
SRC= CoulombStressAnalysis.f90 \
     GradientDisp2Strain.f90 \
     Strain2Stress.f90 \
     TensorTrans.f90 \
     StressArray2StressTensor.f90 \
     StressTensor2StressArray.f90 \
     CFF.f90 \
     deg2rad.f90 \
     Rphi.f90\
     InitializeStress.f90 \
     generalxy2BL.f90 \
     generalBL2xy.f90	

SSRC=DC3D.f
FC= gfortran
#FFLAGS= -g -O3
 FFLAGS= -g
OBJS=$(SRC:.f90=.o) $(SSRC:.f=.o)
$(PROG):$(OBJS)
	$(FC) -o $@ $(OBJS) $(FFLAGS)
%.o:%.f90
	$(FC) -c $(FFLAGS) $<
%.o:%.f
	$(FC) -c $(FFLAGS) $<
clean:
	rm -rf *.o