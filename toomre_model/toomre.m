function toomre(tmax, level, galaxy_system)
    
    %discretization
    nt = 2^level + 1;
    deltat = tmax/(nt-1);
    t = (0.0:deltat:(nt-1)*deltat);
    
    galaxy_num = galaxy_system.galaxy_num;
    star_num = max(galaxy_system.star_nums)+1;
    sim = gobjects(1, galaxy_num);
    
    r = zeros(galaxy_num, star_num, 3, nt);
    vi = zeros(galaxy_num, star_num, 3);
    
    for core = 1:galaxy_num
        %Initial Position, Velocity for the Galaxy Cores
        r(core,1,:,1) = galaxy_system.core_ri(core,:);
        
        vi(core,1,:) = galaxy_system.core_vi(core,:);        
        %r(core,1,:,2) = r(core,1,:,1) + deltat*vi(core,1,:);      
        %r(:,:,:,1)
        %Minimum/maximum star orbital radius
            r_min = 0.03;  
            r_max = 0.2; 
        %Initial Position, Velocity for the stars
        d = (r_max-r_min)*linspace(0,1,galaxy_system.star_nums(core)+1) + r_min;
        theta = (2*pi)*linspace(0,1,galaxy_system.star_nums(core)+1);
        for star=2:galaxy_system.star_nums(core)+1
            
            
            
            %Representing x and y components of d
            r_orbit = [d(star)*cos(theta(star)) d(star)*sin(theta(star)) 0];

            r(core,star,:,1) = permute(r(core,1,:,1), [1,3,2]) + r_orbit;
            vi(core,star,:) = permute(vi(core,1,:), [1,3,2]) + sqrt(galaxy_system.core_ms(core))*sqrt(norm(r_orbit))*[-sin(theta(star)) cos(theta(star)) 0];        
            r(core,star,:,2) = permute(r(core,star,:,1), [1,3,2]) + deltat*permute(vi(core,star,:),[1,3,2]);
        end
    end
    

    for core = 1:galaxy_num
        %Initial Acceleration for the Galaxy Cores 
        
        a = nbodyaccn(galaxy_system.core_ms, permute(r(:,1,:,1),[1,3,2]));
        r(core,1,:,2) = r(core,1,:,1) + deltat*vi(core,1,:) + 0.5*deltat^2*permute(a(core,:),[1,3,2]);      
        r(:,:,:,2);
        %Initial Acceleration for the stars
        for star=2:galaxy_system.star_nums(core)+1
            permute(r(1,:,:,1),[2,3,4,1]);
            mvec = [galaxy_system.core_ms(core),zeros(1,galaxy_system.star_nums(core))];
            a = nbodyaccn(mvec, permute(r(core,:,:,1),[2,3,4,1]));
            permute(a(star,:),[1,3,2]);
            r(core,star,:,2) = r(core,star,:,1) + deltat*vi(core,star,:) + 0.5*deltat^2*permute(a(star,:),[1,3,2]);      
        end
    end
    %r(:,:,:,2)
    %-----------------------------------------------------------
    % Set plotenable to non-zero/zero to enable/disable plotting.
    %-----------------------------------------------------------
    plotenable = 0;
    %-----------------------------------------------------------
    % Parameter to control speed of animation.  Script execution
    % will pause for pausesecs each time a new frame is drawn.
    % 
    % Setting this parameter to a "largish" value, say 0.1
    % (seconds), will produce a slow-motion effect.
    % 
    % Set it to 0 for maximum animation speed.
    %-----------------------------------------------------------
    pausesecs = 0.01;

    %-----------------------------------------------------------
    % Plot attributes defining the appearance  of the ball.
    %-----------------------------------------------------------

    % Particles have a (marker) size of 2
    bodysize = 2;
    % they are yellow
    bodycolors = ['y', 'g', 'm', 'c'];
    % ... and it's plotted as a circle.
    bodymarker = 'o';

    % Plot background is black
    bgcolor = 'k';

    %-----------------------------------------------------------
    % Set avienable to a non-zero value to make an AVI movie.
    %-----------------------------------------------------------
    avienable = 1;

    % If plotting is disabled, ensure that AVI generation
    % is as well
    if ~plotenable
       avienable = 0;
    end

    % Name of avi file.
    avifilename = 'toomre.avi';

    % Presumed AVI playback rate in frames per second.
    aviframerate = 25;

    %-----------------------------------------------------------
    
    %-----------------------------------------------------------
    % If AVI creation is enabled, then initialize an avi object.
    %-----------------------------------------------------------
    if avienable
       aviobj = VideoWriter(avifilename);
       open(aviobj);
    end
    
    if plotenable
        % Clear figure
        clf;

        % Don't erase figure after each plot command.
        hold on;

        % Setup
        axis square;
        xlim([-1, 1]);
        ylim([-1, 1]);
        set(gca, 'Color', bgcolor);
        set(gcf, 'Visible', 'off');
        set(gcf,'Position',[100 100 250 250])
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        
        for i=1:galaxy_num
            sim(i) = plot(r(i, :, 1, 1), r(i, :, 2, 1), 'Marker', bodymarker, 'MarkerSize', bodysize, ...
                'MarkerEdgeColor', bodycolors(i), 'MarkerFaceColor', bodycolors(i), 'LineStyle', 'none');
        end
    end
    
    for n=2:nt-1
        if plotenable
            
            for i=1:galaxy_num
                % Draw the particles
                sim(i).XData = r(i, :, 1, n);
                sim(i).YData = r(i, :, 2, n);
            end
                
            % Force update of figure window.
            % drawnow;

            % Record video frame if AVI recording is enabled and record 
            % multiple copies of the first frame.  Here we record 5 seconds
            % worth which will allow the viewer a bit of time to process 
            % the initial scene before the animation starts.
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

            % Pause execution to control interactive visualization speed.
            pause(pausesecs);
        end
        
        for core=1:galaxy_num
            %a(:,:,n) = nbodyaccn([galaxy_system.core_ms(core),zeros(1,galaxy_system.star_nums(core))], permute(r(core,:,:,n),[2,3,1,4]));
            for star=1:galaxy_system.star_nums(core)+1
                %r(core,star,:,n+1) = 2*permute(r(core,star,:,n),[1,2,4,3]) - permute(r(core,star,:,n-1),[1,2,4,3]) + deltat^2*permute(a(star,:,n),[1,4,3,2]);
            end
        end
    end

    if plotenable
        sim(core).XData = r(core, star, 1, nt);
        sim(core).YData = r(core, star, 2, nt);
    end
end

