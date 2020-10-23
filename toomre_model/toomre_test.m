%Galaxy array
galaxy(1).core_m = 1;
galaxy(1).star_num = 300;

galaxy(2).core_m = 1;
galaxy(2).star_num = 300;

galaxy_system.galaxy_num = length(galaxy);
galaxy_system.tot_m = 0;
galaxy_system.r = 0.4;

for i = 1:galaxy_system.galaxy_num
    galaxy_system.core_ms(i) = galaxy(i).core_m;
    galaxy_system.tot_m = galaxy_system.tot_m + galaxy(i).core_m;
    galaxy_system.star_nums(i) = galaxy(i).star_num; 
end

galaxy_system.core_ri = [-(galaxy_system.core_ms(2)/galaxy_system.tot_m)*galaxy_system.r,0,0; ... 
                         (galaxy_system.core_ms(1)/galaxy_system.tot_m)*galaxy_system.r,0,0];

galaxy_system.core_vi = [0,sqrt(galaxy_system.core_ms(2)*abs(galaxy_system.core_ri(1)))/galaxy_system.r,0; ...
                         0,-sqrt(galaxy_system.core_ms(1)*abs(galaxy_system.core_ri(2)))/galaxy_system.r,0];

tmax = 3;
level = 8;
%toomre_single(tmax, level, galaxy(1))
toomre_multi(tmax, level, galaxy_system)

