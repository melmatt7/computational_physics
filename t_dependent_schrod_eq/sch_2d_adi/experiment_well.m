clf;clear;

tmax = 0.05;
level = 7;
lambda = 0.01;
idtype = 1;
idpar = [0.40, 0.40, 0.075, 0.075, 0.0, 0.0];
vtype = 1;
x1 = 0.6;
x2 = 0.8;

vpar = [0.2, 0.6, 0.2, 0.6, -1*1000];
[x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

h.fig  = figure ;
h.ax   = handle(axes) ;                 
h.surf = handle( surf( NaN(2) ) ) ;     
set( h.surf , 'XData',x , 'YData',y , 'ZData',permute(psi(1,:,:),[2,3,1])) 

myVideo = VideoWriter('well_behaviour'); 
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