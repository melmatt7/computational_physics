clf

tmax = 0.10;
level = 9;
lambda = 0.01;
idtype = 1;
idpar = [0.40, 0.075, 0.0];
vtype = 1;
x1 = 0.6;
x2 = 0.8;
lnV0 = linspace(-2,5,10);
V0 = exp(lnV0);

for k = 1:length(V0)
    vpar = [0.6, 0.8, V0(k)];
    [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar);
    x
    nx = size(x,2);
    P = mean(prob)/mean(prob(:,nx));
    X1 = find(round(x,2)==x1, 1, 'first');
    X2 = find(round(x,2)==x2, 1, 'last');
    lnFe(k) = log((P(X2)-P(X1))/(x2-x1));
end

plot(lnV0, lnFe)