function toomre_single(tmax, level, galaxy, r_min, r_max)
    % Discretization
    nt = 2^level + 1;
    deltat = tmax/(nt-1);
    t = (0.0:deltat:(nt-1)*deltat);

    star_num = galaxy.star_num;
    core_mass = galaxy.core_m;
    galaxy_sim = gobjects(1, 1);
    
    r = zeros(1, star_num+1, 3, nt);
    vi = zeros(1, star_num+1, 3);
    
    for star=2:star_num+1      
        % Initial Position, Velocity per star
        d = (r_max-r_min)*rand(1,1) + r_min;
        theta = (2*pi)*rand(1,1);
        
        % Representing x and y components of d
        r_orbit = [d*cos(theta) d*sin(theta) 0];

        r(1,star,:,1) = reshape(r(1,1,:,1), [1,3]) + r_orbit;
        vi(1,star,:) = reshape(vi(1,1,:), [1,3]) + sqrt(core_mass)/sqrt(norm(r_orbit))*[-sin(theta) cos(theta) 0];        
        r(1,star,:,2) = reshape(r(1,star,:,1), [1,3]) + deltat*reshape(vi(1,star,:),[1,3]);
    end
    
    % Initial Acceleration for all stars
    mvec = [core_mass,zeros(1,star_num)];
    a = nbodyaccn(mvec, permute(r(1,:,:,1),[2,3,1,4]));
    for star=2:star_num+1
        r(1,star,:,2) = r(1,star,:,1) + deltat*vi(1,star,:) + 0.5*deltat^2*permute(a(star,:),[1,3,2]);      
    end
    
    % Plot initializing parameters
    plotenable = 1;
    pausesecs = 0.01;
    avienable = 1;
    avifilename = 'toomre_single.avi';
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
        set(gcf,'Position',[150 150 300 300])
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        
        
        galaxy_sim(1) = plot(r(1, :, 1, 1), r(1, :, 2, 1), ...
                      'Marker', particlemarker, 'MarkerSize', particlesize, ...
                      'MarkerEdgeColor', galaxycolors(1), 'MarkerFaceColor', ...
                      galaxycolors(1), 'LineStyle', 'none');
    end
    
    for n=2:nt-1
        if plotenable
                        
            % Update particle position on plot
            galaxy_sim(1).XData = r(1, :, 1, n);
            galaxy_sim(1).YData = r(1, :, 2, n);

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
        
        % Update particle position
        m_vec = [core_mass,zeros(1,star_num)];
        a = nbodyaccn(m_vec, permute(r(1,:,:,n),[2,3,1,4]));
        for star=1:star_num+1
            r(1,star,:,n+1) = 2*reshape(r(1,star,:,n),[1,3]) - reshape(r(1,star,:,n-1),[1,3]) + (deltat^2)*reshape(a(star,:),[1,3]);
        end
    end
    
    % Plot final particle positions
    if plotenable
        galaxy_sim(1).XData = r(1, star, 1, nt);
        galaxy_sim(1).YData = r(1, star, 2, nt);
    end
end

