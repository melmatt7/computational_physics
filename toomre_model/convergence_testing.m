m1 = 1;
m2 = 0.5;
r = 0.5;
tmax = 5;
    
[t6, r6]   =  two_body(tmax, 6, m1, m2, r);
[t7, r7]   =  two_body(tmax, 7, m1, m2, r);
[t8, r8]   =  two_body(tmax, 8, m1, m2, r);
[t9, r9]   =  two_body(tmax, 9, m1, m2, r);

%sampling a single point
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
plot(t6, r6, 'r-.o')
plot(t7, r7, 'g-.+')
plot(t8, r8, 'b-.*')
plot(t9, r9, 'c-.*')
hold off;

r7 = r7(1:2:end);
r8 = r8(1:4:end);
r9 = r9(1:8:end);

dr67 = r6 - r7;
dr78 = r7 - r8;
dr89 = r8 - r9;

figure(2);
hold all; 
plot(t6, dr67, 'r-.o')
plot(t6, dr78, 'g-.+')
plot(t6, dr89, 'b-.*')
hold off;

dr78 = 4 * dr78;
dr89 = 16 * dr89;

figure(3);
hold all;
plot(t6, dr67, 'r-.o')
plot(t6, dr78, 'g-.+')
plot(t6, dr89, 'b-.*')
hold off;