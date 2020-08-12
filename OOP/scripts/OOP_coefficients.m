function OOP_coefficients(delta,lambda,friction)
dip=deg2rad(delta);
rake=deg2rad(lambda);
miu=friction;
%
k11=(-1.0/2.0*sin(rake)*sin(2*dip)+miu*sin(dip)^2);
k12=(1.0/2.0*sin(rake)*sin(2*dip)-miu*sin(dip)^2);
k13=(sin(rake)*cos(2*dip)-miu*sin(2*dip));
k22=(-1.0/2.0*sin(rake)*sin(2*dip)+miu*sin(dip)^2);
k23=(-sin(rake)*cos(2*dip)+miu*sin(2*dip));
k33=(1.0/2.0*sin(rake)*sin(2*dip)+miu*cos(dip)^2);
%
KOOP=[k11 k12 k13 k22 k23 k33];
save('grid_OOP_coeff.mat','KOOP');
