%Galaxy array
galaxy(1).core_m = 10;
galaxy(1).star_num = 6;

galaxy(2).core_m = 10;
galaxy(2).star_num = 11;

galaxy_system.galaxies = galaxy;
galaxy_system.tot_m = 0;
galaxy_system.r = 5;

for i = 1:length(galaxy)
    galaxy_system.core_ms = galaxy(i).core_m;
    galaxy_system.tot_m = galaxy_system.tot_m + galaxy(i).core_m;
end

galaxy_system.core_ri = []
for i = 1:length(galaxy)
    for j = 1:length(galaxy)
        if i == j
            continue
        end
    
        galaxy_system.core_ri = galaxy_system.core
    end
end

