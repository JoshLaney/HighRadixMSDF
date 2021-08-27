clear; clc;
set(groot,'defaultLineLineWidth',2.0)
figure(1);
tiledlayout('flow','TileSpacing','compact');

widths_a = [16 32 64 128];
control_a = [556 483 328 227];
radix_2_a = [575 533 499 381];
radix_4_a = [512 437 529 350];
radix_8_a = [365 367 328 323];

widths_m = [8 32 64];
control_m = [446 265 148];
radix_2_m = [269 215 201];
radix_4_m = [151 128 129];

nexttile(1);
plot(widths_a,control_a, '*-', 'Color',[0.1, 0.1 0.1]);
hold on
plot(widths_a,radix_2_a, 'o-', 'Color',[0.9 0 0]);
plot(widths_a,radix_4_a, 'x-', 'Color',[0 0.9 0]);
plot(widths_a,radix_8_a, 's-', 'Color',[0 0 0.9]);
title('Measured Maximum Frequency vs Equivlent Width of Adders')
ylabel('Frequency (MHz)')
xlabel('Equivlent Width (Bits)')
legend('Control', 'R-2','R-4','R-8')
ylim([100 600])

nexttile(2);
plot(widths_m,control_m, '*-', 'Color',[0.1, 0.1 0.1]);
hold on
plot(widths_m,radix_2_m, 'o-', 'Color',[0.9 0 0]);
plot(widths_m,radix_4_m, 'x-', 'Color',[0 0.9 0]);
title('Measured Maximum Frequency vs Equivlent Width of Multipliers')
ylabel('Frequency (MHz)')
xlabel('Equivlent Width (Bits)')
legend('Control', 'R-2','R-4')
ylim([100 600])

