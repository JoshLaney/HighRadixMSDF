clear; clc;
set(groot,'defaultLineLineWidth',2.0)

Adders_32 = [
    Adder(2, 15, '-s', [0.9 0 0])
    Adder(4, 8, '-d', [0 0.9 0])
    Adder(8, 5, '-p', [0 0 0.9])
    Adder(1, 15, '-*', [0.1 0.1 0.1])
];

fig_abs=1;
figure(fig_abs);
tiledlayout('flow','TileSpacing','compact');
hold on
for i = 1:size(Adders_32)
    Adders_32(i).plot(Adders_32(i).abs);
end
nexttile(1);
title('max absolute ERR 32bits')
xlabel('freqeuncy (MHz)')
ylabel('absolute error')
nexttile(2);
title('avg absolute ERR 32bits')
xlabel('freqeuncy (MHz)')
ylabel('absolute error')
hold off
lgd = legend('r2 w15','r4 w8','r8 w5','control w15');
lgd.Layout.Tile = 'east';


fig_bf=2;
figure(fig_bf);
tiledlayout('flow','TileSpacing','compact');
hold on
for i = 1:size(Adders_32)
    Adders_32(i).plot(Adders_32(i).bits);
end
nexttile(1);
title('min flipped bit 32bits')
xlabel('freqeuncy (MHz)')
ylabel('bit location')
nexttile(2);
title('avg min flipped bit 32bits')
xlabel('freqeuncy (MHz)')
ylabel('bit location')
nexttile(3);
title('max flipped bit 32bits')
xlabel('freqeuncy (MHz)')
ylabel('bit location')
nexttile(4);
title('illegal digits 32bits')
xlabel('freqeuncy (MHz)')
ylabel('# of digits')
hold off
lgd = legend('r2 w15','r4 w8','r8 w5','control w15');
lgd.Layout.Tile = 'east';

