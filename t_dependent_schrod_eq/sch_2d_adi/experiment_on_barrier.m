vtype = 1;
vpar = [0.4, 0.6, 0.4, 0.6, 2000] ;
tmax = 0.05;
level=5;
lambda = 0.01;
idtype = 1;
idpar = [0.5, 0.5, 5, 5, 1, 1];

[x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

h.fig  = figure ;
h.ax   = handle(axes) ;                 
h.surf = handle( surf( NaN(2) ) ) ;     
set( h.surf , 'XData',x , 'YData',y , 'ZData',permute(psimod(1,:,:),[2,3,1])) 

for n = 2:size(t,2)
    set(h.surf, 'ZData', permute(psimod(n,:,:),[2,3,1]));
    drawnow()
    pause(0.07)
end