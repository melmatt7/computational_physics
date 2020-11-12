function [t,r] = two_body(tmax, level, m1, m2, r)
    % tmax: maximum timestep to account for
    % level: discretization level
    % m1: first mass in the system
    % m2: second mass in the system
    % r: N x 3 array containing the computed particle accelerations

    m = m1+m2;
    
    %discretization
    nt = 2^level + 1;
    deltat = tmax/(nt-1);
    t = (0.0:deltat:(nt-1)*deltat);

    r1 = zeros(1, 3, nt);
    r2 = zeros(1, 3, nt);
    v1 = zeros(1, 3, nt);
    v2 = zeros(1, 3, nt);
    a1 = zeros(1, 3, nt);
    a2 = zeros(1, 3, nt);

    %need to determine distances (r1_i,r2_i) from centre of mass (rc) to calculate
    %initial velocities (v1_i,v2_i). For convenience we set rc at origin
    %(rc=0) so we get the following values:
    r2_i = (m1/m)*r;
    r1_i = (m2/m)*r;    
    v2_i = sqrt(m1*r2_i)/r;
    v1_i = sqrt(m2*r1_i)/r;
    a2_i = m1/r^2;
    a1_i = m2/r^2;
    
    r1(1, :, 1) = [r1_i 0 0];
    r2(1, :, 1) = [-r2_i 0 0];    
    v1(1, :, 1) = [0 v1_i 0];
    v2(1, :, 1) = [0 -v2_i 0];
    a1(1, :, 1) = [-a1_i 0 0];
    a2(1, :, 1) = [a2_i 0 0]; 
    
    %We also need the first timestep increment of r1 and r2
    r1(1, :, 2) = r1(1, :, 1) + v1(1, :, 1)*deltat + 0.5*deltat^2*a1(1, :, 1);
    r2(1, :, 2) = r2(1, :, 1) + v2(1, :, 1)*deltat + 0.5*deltat^2*a2(1, :, 1);
    
    %We can now combine the matricies for easier handling
    r = [r1;r2];
    a = [a1;a2];
    
    for n = (2:nt-1)
        mvec = [m1,m2];
        
        a(:,:,n) = nbodyaccn(mvec, r(:,:,n));
        
        r(1, :, n+1) = 2*r(1, :, n) - r(1, :, n-1) + deltat^2 * a(1,:,n);
        r(2, :, n+1) = 2*r(2, :, n) - r(2, :, n-1) + deltat^2 * a(2,:,n);
    end

end

