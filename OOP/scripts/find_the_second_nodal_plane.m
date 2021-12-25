function   [strike, dip, rake]=find_the_second_nodal_plane(strike,dip,rake)
[normal,slip]=strike_dip_rake_angles2normal_slip_directions(strike,dip,rake);
[strike,dip,rake]=normal_slip_directions2_strike_dip_rake_angles(slip,normal);