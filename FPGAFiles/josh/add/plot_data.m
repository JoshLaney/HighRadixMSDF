clear; clc;
set(groot,'defaultLineLineWidth',2.0)

figure(1)
r2_w15_abs_err=readmatrix('r2_w15/r2_w15_abs_err.csv');
r2_w31_abs_err=readmatrix('r2_w31/r2_w31_abs_err.csv');
r4_w8_abs_err=readmatrix('r4_w8/r4_w8_abs_err.csv');
r4_w16_abs_err=readmatrix('r4_w16/r4_w16_abs_err.csv');
r8_w5_abs_err=readmatrix('r8_w5/r8_w5_abs_err.csv');
r8_w11_abs_err=readmatrix('r8_w11/r8_w11_abs_err.csv');
control_w15_abs_err=readmatrix('control_w15/control_w15_abs_err.csv');
control_w31_abs_err=readmatrix('control_w31/control_w31_abs_err.csv');

r2_w15_abs_err(:,2)= monotonic_data(r2_w15_abs_err(:,2));
r2_w15_abs_err(:,3)= monotonic_data(r2_w15_abs_err(:,3));
r2_w31_abs_err(:,2)= monotonic_data(r2_w31_abs_err(:,2));
r2_w31_abs_err(:,3)= monotonic_data(r2_w31_abs_err(:,3));
r4_w8_abs_err(:,2)= monotonic_data(r4_w8_abs_err(:,2));
r4_w8_abs_err(:,3)= monotonic_data(r4_w8_abs_err(:,3));
r4_w16_abs_err(:,2)= monotonic_data(r4_w16_abs_err(:,2));
r4_w16_abs_err(:,3)= monotonic_data(r4_w16_abs_err(:,3));
r8_w5_abs_err(:,2)= monotonic_data(r8_w5_abs_err(:,2));
r8_w5_abs_err(:,3)= monotonic_data(r8_w5_abs_err(:,3));
r8_w11_abs_err(:,2)= monotonic_data(r8_w11_abs_err(:,2));
r8_w11_abs_err(:,3)= monotonic_data(r8_w11_abs_err(:,3));
control_w15_abs_err(:,2)= monotonic_data(control_w15_abs_err(:,2));
control_w15_abs_err(:,3)= monotonic_data(control_w15_abs_err(:,3));
control_w31_abs_err(:,2)= monotonic_data(control_w31_abs_err(:,2));
control_w31_abs_err(:,3)= monotonic_data(control_w31_abs_err(:,3));

tiledlayout(2,2)
ax1 = nexttile;
plot(r2_w15_abs_err(:,1), r2_w15_abs_err(:,2), '-s', 'Color',[.9 0 0])
hold on
plot(r4_w8_abs_err(:,1), r4_w8_abs_err(:,2), '-d', 'Color',[0 .9 0])
plot(r8_w5_abs_err(:,1), r8_w5_abs_err(:,2), '-p', 'Color',[0 0 .9])
plot(control_w15_abs_err(:,1), control_w15_abs_err(:,2), '-*', 'Color',[0 0 0])
hold off
title('max absolute ERR 32bits')
xlabel('freqeuncy (MHz)')
ylabel('absolute error')
legend('r2 w15','r4 w8','r8 w5','control w15')
ax2=nexttile;
plot(r2_w15_abs_err(:,1), r2_w15_abs_err(:,3), '-s', 'Color',[.9 0 0])
hold on
plot(r4_w8_abs_err(:,1), r4_w8_abs_err(:,3), '-d', 'Color',[0 .9 0])
plot(r8_w5_abs_err(:,1), r8_w5_abs_err(:,3), '-p', 'Color',[0 0 .9])
plot(control_w15_abs_err(:,1), control_w15_abs_err(:,3), '-*', 'Color',[0 0 0])
hold off
title('Avg abs ERR 32bits')
xlabel('freqeuncy (MHz)')
ylabel('absolute error')
legend('r2 w15','r4 w8','r8 w5','control w15')
ax3=nexttile;
plot(r2_w31_abs_err(:,1), r2_w31_abs_err(:,2), '-s', 'Color',[.5 0 0])
hold on
plot(r4_w16_abs_err(:,1), r4_w16_abs_err(:,2), '-d', 'Color',[0 .5 0])
plot(r8_w11_abs_err(:,1), r8_w11_abs_err(:,2), '-p', 'Color',[0 0 .5])
plot(control_w31_abs_err(:,1), control_w31_abs_err(:,2), '-*', 'Color',[.5 .5 .5])
hold off
title('max absolute ERR 64bits')
xlabel('freqeuncy (MHz)')
ylabel('absolute error')
legend('r2 w31','r4 w16','r8 w11','control w31')
ax4=nexttile;
plot(r2_w31_abs_err(:,1), r2_w31_abs_err(:,3), '-s', 'Color',[.5 0 0])
hold on
plot(r4_w16_abs_err(:,1), r4_w16_abs_err(:,3), '-d', 'Color',[0 .5 0])
plot(r8_w11_abs_err(:,1), r8_w11_abs_err(:,3), '-p', 'Color',[0 0 .5])
plot(control_w31_abs_err(:,1), control_w31_abs_err(:,3), '-*', 'Color',[.5 .5 .5])
hold off
title('Avg abs ERR 64bits')
xlabel('freqeuncy (MHz)')
ylabel('absolute error')
legend('r2 w31','r4 w16','r8 w11','control w31')


figure(2)
r2_w15_mr_err=readmatrix('r2_w15/r2_w15_mr_err.csv');
r2_w31_mr_err=readmatrix('r2_w31/r2_w31_mr_err.csv');
r4_w8_mr_err=readmatrix('r4_w8/r4_w8_mr_err.csv');
r4_w16_mr_err=readmatrix('r4_w16/r4_w16_mr_err.csv');
r8_w5_mr_err=readmatrix('r8_w5/r8_w5_mr_err.csv');
r8_w11_mr_err=readmatrix('r8_w11/r8_w11_mr_err.csv');
control_w15_mr_err=readmatrix('control_w15/control_w15_mr_err.csv');
control_w31_mr_err=readmatrix('control_w31/control_w31_mr_err.csv');

r2_w15_mr_err(:,2)= monotonic_data(r2_w15_mr_err(:,2));
r2_w15_mr_err(:,3)= monotonic_data(r2_w15_mr_err(:,3));
r2_w31_mr_err(:,2)= monotonic_data(r2_w31_mr_err(:,2));
r2_w31_mr_err(:,3)= monotonic_data(r2_w31_mr_err(:,3));
r4_w8_mr_err(:,2)= monotonic_data(r4_w8_mr_err(:,2));
r4_w8_mr_err(:,3)= monotonic_data(r4_w8_mr_err(:,3));
r4_w16_mr_err(:,2)= monotonic_data(r4_w16_mr_err(:,2));
r4_w16_mr_err(:,3)= monotonic_data(r4_w16_mr_err(:,3));
r8_w5_mr_err(:,2)= monotonic_data(r8_w5_mr_err(:,2));
r8_w5_mr_err(:,3)= monotonic_data(r8_w5_mr_err(:,3));
r8_w11_mr_err(:,2)= monotonic_data(r8_w11_mr_err(:,2));
r8_w11_mr_err(:,3)= monotonic_data(r8_w11_mr_err(:,3));
control_w15_mr_err(:,2)= monotonic_data(control_w15_mr_err(:,2));
control_w15_mr_err(:,3)= monotonic_data(control_w15_mr_err(:,3));
control_w31_mr_err(:,2)= monotonic_data(control_w31_mr_err(:,2));
control_w31_mr_err(:,3)= monotonic_data(control_w31_mr_err(:,3));

tiledlayout(2,2)
ax1 = nexttile;
plot(r2_w15_mr_err(:,1), r2_w15_mr_err(:,2), '-s', 'Color',[.9 0 0])
hold on
plot(r4_w8_mr_err(:,1), r4_w8_mr_err(:,2), '-d', 'Color',[0 .9 0])
plot(r8_w5_mr_err(:,1), r8_w5_mr_err(:,2), '-p', 'Color',[0 0 .9])
plot(control_w15_mr_err(:,1), control_w15_mr_err(:,2), '-*', 'Color',[0 0 0])
hold off
title('max mr ERR 32bits')
xlabel('freqeuncy (MHz)')
ylabel('mean relative error')
legend('r2 w15','r4 w8','r8 w5','control w15')
ax2=nexttile;
plot(r2_w15_mr_err(:,1), r2_w15_mr_err(:,3), '-s', 'Color',[.9 0 0])
hold on
plot(r4_w8_mr_err(:,1), r4_w8_mr_err(:,3), '-d', 'Color',[0 .9 0])
plot(r8_w5_mr_err(:,1), r8_w5_mr_err(:,3), '-p', 'Color',[0 0 .9])
plot(control_w15_mr_err(:,1), control_w15_mr_err(:,3), '-*', 'Color',[0 0 0])
hold off
title('Avg mr ERR 32bits')
xlabel('freqeuncy (MHz)')
ylabel('mean relative error')
legend('r2 w15','r4 w8','r8 w5','control w15')
ax3=nexttile;
plot(r2_w31_mr_err(:,1), r2_w31_mr_err(:,2), '-s', 'Color',[.5 0 0])
hold on
plot(r4_w16_mr_err(:,1), r4_w16_mr_err(:,2), '-d', 'Color',[0 .5 0])
plot(r8_w11_mr_err(:,1), r8_w11_mr_err(:,2), '-p', 'Color',[0 0 .5])
plot(control_w31_mr_err(:,1), control_w31_mr_err(:,2), '-*', 'Color',[.5 .5 .5])
hold off
title('max mr ERR 64bits')
xlabel('freqeuncy (MHz)')
ylabel('mean relative error')
legend('r2 w31','r4 w16','r8 w11','control w31')
ax4=nexttile;
plot(r2_w31_mr_err(:,1), r2_w31_mr_err(:,3), '-s', 'Color',[.5 0 0])
hold on
plot(r4_w16_mr_err(:,1), r4_w16_mr_err(:,3), '-d', 'Color',[0 .5 0])
plot(r8_w11_mr_err(:,1), r8_w11_mr_err(:,3), '-p', 'Color',[0 0 .5])
plot(control_w31_mr_err(:,1), control_w31_mr_err(:,3), '-*', 'Color',[.5 .5 .5])
hold off
title('Avg mr ERR 64bits')
xlabel('freqeuncy (MHz)')
ylabel('mean relative error')
legend('r2 w31','r4 w16','r8 w11','control w31')


figure(3)
r2_w15_bf_loc=readmatrix('r2_w15/r2_w15_bf_loc.csv');
r2_w31_bf_loc=readmatrix('r2_w31/r2_w31_bf_loc.csv');
r4_w8_bf_loc=readmatrix('r4_w8/r4_w8_bf_loc.csv');
r4_w16_bf_loc=readmatrix('r4_w16/r4_w16_bf_loc.csv');
r8_w5_bf_loc=readmatrix('r8_w5/r8_w5_bf_loc.csv');
r8_w11_bf_loc=readmatrix('r8_w11/r8_w11_bf_loc.csv');
control_w15_bf_loc=readmatrix('control_w15/control_w15_bf_loc.csv');
control_w31_bf_loc=readmatrix('control_w31/control_w31_bf_loc.csv');



r2_w15_bf_loc(:,2)= monotonic_data(r2_w15_bf_loc(:,2));
r2_w15_bf_loc(:,3)= monotonic_data(r2_w15_bf_loc(:,3));
r2_w31_bf_loc(:,2)= monotonic_data(r2_w31_bf_loc(:,2));
r2_w31_bf_loc(:,3)= monotonic_data(r2_w31_bf_loc(:,3));
r4_w8_bf_loc(:,2)= monotonic_data(r4_w8_bf_loc(:,2));
r4_w8_bf_loc(:,3)= monotonic_data(r4_w8_bf_loc(:,3));
r4_w16_bf_loc(:,2)= monotonic_data(r4_w16_bf_loc(:,2));
r4_w16_bf_loc(:,3)= monotonic_data(r4_w16_bf_loc(:,3));
r8_w5_bf_loc(:,2)= monotonic_data(r8_w5_bf_loc(:,2));
r8_w5_bf_loc(:,3)= monotonic_data(r8_w5_bf_loc(:,3));
r8_w11_bf_loc(:,2)= monotonic_data(r8_w11_bf_loc(:,2));
r8_w11_bf_loc(:,3)= monotonic_data(r8_w11_bf_loc(:,3));
control_w15_bf_loc(:,2)= monotonic_data(control_w15_bf_loc(:,2));
control_w15_bf_loc(:,3)= monotonic_data(control_w15_bf_loc(:,3));
control_w31_bf_loc(:,2)= monotonic_data(control_w31_bf_loc(:,2));
control_w31_bf_loc(:,3)= monotonic_data(control_w31_bf_loc(:,3));

tiledlayout(2,2)
ax1 = nexttile;
plot(r2_w15_bf_loc(:,1), r2_w15_bf_loc(:,2), '-s', 'Color',[.9 0 0])
hold on
plot(r4_w8_bf_loc(:,1), r4_w8_bf_loc(:,2), '-d', 'Color',[0 .9 0])
plot(r8_w5_bf_loc(:,1), r8_w5_bf_loc(:,2), '-p', 'Color',[0 0 .9])
plot(control_w15_bf_loc(:,1), control_w15_bf_loc(:,2), '-*', 'Color',[0 0 0])
hold off
title('min bit 32bits')
xlabel('freqeuncy (MHz)')
ylabel('lsb flipped')
legend('r2 w15','r4 w8','r8 w5','control w15')
ax2=nexttile;
plot(r2_w15_bf_loc(:,1), r2_w15_bf_loc(:,3), '-s', 'Color',[.9 0 0])
hold on
plot(r4_w8_bf_loc(:,1), r4_w8_bf_loc(:,3), '-d', 'Color',[0 .9 0])
plot(r8_w5_bf_loc(:,1), r8_w5_bf_loc(:,3), '-p', 'Color',[0 0 .9])
plot(control_w15_bf_loc(:,1), control_w15_bf_loc(:,3), '-*', 'Color',[0 0 0])
hold off
title('Avg ming bit 32bits')
xlabel('freqeuncy (MHz)')
ylabel('lsb flipped')
legend('r2 w15','r4 w8','r8 w5','control w15')
ax3=nexttile;
plot(r2_w31_bf_loc(:,1), r2_w31_bf_loc(:,2), '-s', 'Color',[.5 0 0])
hold on
plot(r4_w16_bf_loc(:,1), r4_w16_bf_loc(:,2), '-d', 'Color',[0 .5 0])
plot(r8_w11_bf_loc(:,1), r8_w11_bf_loc(:,2), '-p', 'Color',[0 0 .5])
plot(control_w31_bf_loc(:,1), control_w31_bf_loc(:,2), '-*', 'Color',[.5 .5 .5])
hold off
title('min bit 64bits')
xlabel('freqeuncy (MHz)')
ylabel('lsb flipped')
legend('r2 w31','r4 w16','r8 w11','control w31')
ax4=nexttile;
plot(r2_w31_bf_loc(:,1), r2_w31_bf_loc(:,3), '-s', 'Color',[.5 0 0])
hold on
plot(r4_w16_bf_loc(:,1), r4_w16_bf_loc(:,3), '-d', 'Color',[0 .5 0])
plot(r8_w11_bf_loc(:,1), r8_w11_bf_loc(:,3), '-p', 'Color',[0 0 .5])
plot(control_w31_bf_loc(:,1), control_w31_bf_loc(:,3), '-*', 'Color',[.5 .5 .5])
hold off
title('Avg min bit 64bits')
xlabel('freqeuncy (MHz)')
ylabel('lsb flipped')
legend('r2 w31','r4 w16','r8 w11','control w31')


function data=monotonic_data(x)
    data = zeros(size(x));
    max=x(1);
    for i = 1:size(x)
        if(max<x(i)) 
            max=x(i);
        end
        data(i)=max;
    end
end