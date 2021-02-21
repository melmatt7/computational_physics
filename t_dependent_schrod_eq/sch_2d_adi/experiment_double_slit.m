clf;clear;

tmax = 0.05;
level = 7;
lambda = 0.01;
idtype = 1;
idpar = [0.1, 0.5, 0.75, -0.75, 0.0, 0.0];
vtype = 2;
vpar = [0.47, 0.48, 0.52, 0.53, 1*100000];

[x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

h.fig  = figure ;
h.ax   = handle(axes) ;                 
h.surf = handle( surf( NaN(2) ) ) ;     
set( h.surf , 'XData',x , 'YData',y , 'ZData',permute(psimod(1,:,:),[2,3,1])) 

myVideo = VideoWriter('double_slit_behaviour'); 
myVideo.FrameRate = 10;  
open(myVideo)

for n = 2:size(t,2)
    set(h.surf, 'ZData', permute(psimod(n,:,:),[2,3,1]));
    drawnow()

    pause(0.05)
    frame = getframe(gcf); 
    writeVideo(myVideo, frame);
end
    
close(myVideo)
    