m1 = 1;
m2 = 0.5;
r = 0.5;
tmax = 5;
    
[t6, r6]   =  two_body(tmax, 6, m1, m2, r);
[t7, r7]   =  two_body(tmax, 7, m1, m2, r);
[t8, r8]   =  two_body(tmax, 8, m1, m2, r);
[t9, r9]   =  two_body(tmax, 9, m1, m2, r);

%sampling position in a single dimension (X) of a single mass (M)
r6 = r6(1, 1, :);
r6 = permute(r6, [1,3,2]);
r7 = r7(1, 1, :);
r7 = permute(r7, [1,3,2]);
r8 = r8(1, 1, :);
r8 = permute(r8, [1,3,2]);
r9 = r9(1, 1, :);
r9 = permute(r9, [1,3,2]);

figure(1);
hold all;
fig1(1) = plot(t6, r6, 'r-.o', 'DisplayName', "level 6");
fig1(2) = plot(t7, r7, 'g-.+', 'DisplayName', "level 7");
fig1(3) = plot(t8, r8, 'b-.*', 'DisplayName', "level 8");
fig1(4) = plot(t9, r9, 'c-.*', 'DisplayName', "level 9");
xlabel('Time [s]'),ylabel('X Displacement [m]')
legend(fig1)
title("Displacement of Single Mass in Two Body System")
hold off;

r7 = r7(1:2:end);
r8 = r8(1:4:end);
r9 = r9(1:8:end);

dr67 = r6 - r7;
dr78 = r7 - r8;
dr89 = r8 - r9;

figure(2);
hold all; 
fig2(1) = plot(t6, dr67, 'r-.o','DisplayName', "level 6-7");
fig2(2) = plot(t6, dr78, 'g-.+','DisplayName', "level 7-8");
fig2(3) = plot(t6, dr89, 'b-.*','DisplayName', "level 8-9");
xlabel('Displacement Difference [m]'),ylabel('Time [s]')
legend(fig2)
title("Level Error")
hold off;

dr78 = 4 * dr78;
dr89 = 16 * dr89;

figure(3);
hold all;
fig3(1) = plot(t6, dr67, 'r-.o','DisplayName', "level 6-7");
fig3(2) = plot(t6, dr78, 'g-.+','DisplayName', "4(level 7-8)");
fig3(3) = plot(t6, dr89, 'b-.*','DisplayName', "16(level 8-9)");
xlabel('Displacement Difference [m]'),ylabel('Time [s]')
legend(fig3)
title("Scaled Level Error")
hold off;