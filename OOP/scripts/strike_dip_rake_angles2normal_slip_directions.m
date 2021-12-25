function [normal,slip]=strike_dip_rake_angles2normal_slip_directions(strike,dip,rake)
%note that the normal to a fault plane and the slip direction belong to a
%local topographic Cartesian coordinate system whose x, y and z axes are
%northern, eastern and upward, respectively.
strike=deg2rad(strike(:));
dip=deg2rad(dip(:));
rake=deg2rad(rake(:));
normal=[-sin(strike).*sin(dip) cos(strike).*sin(dip)  cos(dip)]';
slip=[ cos(strike).*cos(rake)+sin(strike).*cos(dip).*sin(rake) ...
       sin(strike).*cos(rake)-cos(strike).*cos(dip).*sin(rake) ...
       sin(dip).*sin(rake) ]';
