%General Parameters
galaxy_system.r = 1.1314;
r_min = 0.06;  
r_max = 0.2; 
tmax = 3;
level = 8;

%toomre_single.avi parameters
%galaxy(1).core_m = 1;
%galaxy(1).star_num = 5000;

%explosion.avi parameters
%galaxy_system.core_ms = [1 1];
%
%galaxy_system.core_ri = [-0.4,-0.4,0; ... 
%                         0.4,0.4,0];
%
%galaxy_system.core_vi = [sqrt(0.56568)/galaxy_system.r,sqrt(0.56568)/galaxy_system.r,0; ...
%                         -sqrt(0.56568)/galaxy_system.r,-sqrt(0.56568)/galaxy_system.r,0];
%
%galaxy_system.star_nums = [5000;5000;5000];

%major_collision.avi parameters
%galaxy_system.core_ms = [1 1];
%
%galaxy_system.core_ri = [-0.4,-0.3,0; ... 
%                         0.4,0.3,0];
%
%galaxy_system.core_vi = [sqrt(0.56568)/galaxy_system.r,0,0; ...
%                         -sqrt(0.56568)/galaxy_system.r,0,0];
%
%galaxy_system.star_nums = [5000;5000;5000];

%minor_collision.avi parameters
%galaxy_system.core_ms = [1 1];
%
%galaxy_system.core_ri = [-0.4,-0.4,0; ... 
%                         0.4,0.4,0];
%
%galaxy_system.core_vi = [sqrt(0.56568)/galaxy_system.r,0,0; ...
%                         -sqrt(0.56568)/galaxy_system.r,0,0];
%
%galaxy_system.star_nums = [5000;5000;5000];

%single_galaxy.avi parameters
%galaxy_system.core_ms = [1];
%
%galaxy_system.core_ri = [0,0,0];
%
%galaxy_system.core_vi = [0,0,0];
%
%galaxy_system.star_nums = [5000;5000;5000];

%triple_galaxy.avi parameters
%galaxy_system.core_ms = [1 1 0.7];
%
%galaxy_system.core_ri = [-0.9,-0.9,0; ... 
%                         0.9,0.9,0;
%                         0 0 0];
%
%galaxy_system.core_vi = [sqrt(0.7)/galaxy_system.r,0,0; ...
%                         -sqrt(0.7)/galaxy_system.r,0,0;
%                         0,0,0];
%                     
%galaxy_system.star_nums = [5000;5000;5000];

%orbiting_galaxies.avi parameters
galaxy_system.core_ms = [1 1];

galaxy_system.core_ri = [-galaxy_system.r/2,0,0; ... 
                         galaxy_system.r/2,0,0];

galaxy_system.core_vi = [0,sqrt(galaxy_system.r/2)/galaxy_system.r,0; ...
                         0,-sqrt(galaxy_system.r/2)/galaxy_system.r,0;
                         0,0,0];
                    
galaxy_system.star_nums = [5000;5000;5000];

%toomre_single(tmax, level, galaxy(1), r_min, r_max)
toomre_multi(tmax, level, galaxy_system, r_min, r_max)

