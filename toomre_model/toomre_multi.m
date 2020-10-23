function toomre_multi(tmax, level, galaxy_system)
    
    %discretization
    nt = 2^level + 1;
    deltat = tmax/(nt-1);
    t = (0.0:deltat:(nt-1)*deltat);
    
    galaxy_num = galaxy_system.galaxy_num;
    star_num_vec = galaxy_system.star_nums;
    star_num = max(galaxy_system.star_nums);
    core_mass_vec = galaxy_system.core_ms;
    multi_galaxy_sim = gobjects(1, galaxy_num);
    
    r = zeros(galaxy_num, star_num+1, 3, nt);
    vi = zeros(galaxy_num, star_num+1, 3);
    
    for core = 1:galaxy_num
        %Initial Position, Velocity for the Galaxy Cores
        r(core,1,:,1) = galaxy_system.core_ri(core,:);        
        vi(core,1,:) = galaxy_system.core_vi(core,:);        
        r(core,1,:,2) = r(core,1,:,1) + deltat*vi(core,1,:);     
        
        %Minimum/maximum star orbital radius
        %r_min = 0.04;  
        %r_max = 0.2; 
        
        %Minimum/maximum star orbital radius
        r_min = 0.03;  
        r_max = 0.2; 
        %Initial Position, Velocity for the stars
        %d = (r_max-r_min)*linspace(0,1,star_num+1) + r_min;
        %theta = (2*pi)*linspace(0,1,star_num+1);
        
        for star=2:galaxy_system.star_nums(core)+1
            % Initial Position, Velocity per star
            d = (r_max-r_min)*rand(1,1) + r_min;
            theta = (2*pi)*rand(1,1);

            % Representing x and y components of d
            %r_orbit = [d(star)*cos(theta(star)) d(star)*sin(theta(star)) 0];
            r_orbit = [d*cos(theta) d*sin(theta) 0];

            r(core,star,:,1) = reshape(r(core,1,:,1), [1,3]) + r_orbit;
            vi(core,star,:) = reshape(vi(core,1,:), [1,3]) + sqrt(core_mass_vec(core))/sqrt(norm(r_orbit))*[-sin(theta) cos(theta) 0];        
            r(core,star,:,2) = reshape(r(core,star,:,1), [1,3]) + deltat*reshape(vi(core,star,:),[1,3]);
        end
    end
    
    a = nbodyaccn2(core_mass_vec,galaxy_num, star_num, r(:, :, :, 1));
    %Initial Acceleration for all Galaxy Cores 
    a_coresi = nbodyaccn(core_mass_vec, permute(r(:,1,:,1),[1,3,2]));
    for core = 1:galaxy_num
        permute(a_coresi(core,:),[1,3,2]);
        r(core,1,:,2) = r(core,1,:,1) + deltat*vi(core,1,:) + 0.5*deltat^2*a(core, 1, :);      
        
        % Initial Acceleration for all stars around current core
        mvec = [core_mass_vec(core),zeros(1,star_num_vec(core))];
        a_starsi = nbodyaccn(mvec, permute(r(core,:,:,1),[2,3,1,4]));
        for star=2:star_num+1
            permute(a_starsi(star,:),[1,3,2]);
            r(core,star,:,2) = r(core,star,:,1) + deltat*vi(core,star,:) + 0.5*deltat^2*a(core, star, :);      
        end
    end
    
    
    
    % Plot initializing parameters
    plotenable = 1;
    pausesecs = 0.01;
    avienable = 1;
    avifilename = 'toomre_multi.avi';
    aviframerate = 25;
    
    % Visual parameters
    particlesize = 2;
    galaxycolors = ['m', 'g', 'y', 'c'];
    particlemarker = 'o';
    backgroundcolor = 'k';    

    if avienable
       aviobj = VideoWriter(avifilename);
       open(aviobj);
    end
    
    if plotenable
        clf;
        hold on;

        axis square;
        xlim([-1, 1]);
        ylim([-1, 1]);
        set(gca, 'Color', backgroundcolor);
        set(gcf, 'Visible', 'off');
        set(gcf,'Position',[300 300 600 600])
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        
        for core = 1:galaxy_num
            multi_galaxy_sim(core) = plot(r(core, :, 1, 1), r(core, :, 2, 1), ...
                                     'Marker', particlemarker, 'MarkerSize', particlesize, ...
                                     'MarkerEdgeColor', galaxycolors(core), 'MarkerFaceColor', ...
                                     galaxycolors(core), 'LineStyle', 'none');
        end
    end
    
    for n=2:nt-1
        if plotenable
            
            for core=1:galaxy_num
                % Draw the particles
                multi_galaxy_sim(core).XData = r(core, :, 1, n);
                multi_galaxy_sim(core).YData = r(core, :, 2, n);
            end

            if avienable
                if t == 0
                    framecount = 5 * aviframerate ;
                else
                    framecount = 1;
                end
                for iframe = 1 : framecount
                    writeVideo(aviobj, getframe(gcf));
                end
            end

            pause(pausesecs);
        end
        
        a = nbodyaccn2(core_mass_vec,galaxy_num, star_num, r(:, :, :, n));

        a_core = nbodyaccn(core_mass_vec, permute(r(:,1,:,n),[1,3,2]));
        for core=1:galaxy_num
            %r(core,1,:,n+1) = 2*reshape(r(core,1,:,n),[1,3]) - reshape(r(core,1,:,n-1),[1,3]) + deltat^2*reshape(a_core(core,:),[1,3]);
            
            % Update particle position
            %m_vec = [core_mass_vec(core),zeros(1,star_num_vec(core))];
            %a_stars = nbodyaccn(m_vec, permute(r(1,:,:,n),[2,3,1,4]));
            for star=1:galaxy_system.star_nums(core)+1
                r(core,star,:,n+1) = 2*reshape(r(core,star,:,n),[1,3]) - reshape(r(core,star,:,n-1),[1,3]) + deltat^2*reshape(a(core,star,:),[1,3]);
            end
        end
    end

    if plotenable
        multi_galaxy_sim(core).XData = r(core, star, 1, nt);
        multi_galaxy_sim(core).YData = r(core, star, 2, nt);
    end
end

