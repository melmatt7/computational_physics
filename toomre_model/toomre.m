function toomre()
    
    core_m_vec = [10];
    galaxy_num = length(core_m_vec);
    
    
   
    %discretization
    nt = 2^level + 1;
    deltat = tmax/(nt-1);
    t = (0.0:deltat:(nt-1)*deltat);
end

