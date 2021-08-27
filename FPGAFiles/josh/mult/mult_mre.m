clear; clc;
set(groot,'defaultLineLineWidth',2.0)


Mults_32 = [
    Multiplier(2, 7,2*2047, '-', [0.9 0 0])
    Multiplier(4, 4,2*2047, '-', [0 0.9 0])
    Multiplier(1, 8,2*2047, '-', [0.1 0.1 0.1])
];

Mults_128 = [
    Multiplier(2, 31,2*511, '-', [0.9 0 0])
    Multiplier(4, 15,2*511, '-', [0 0.9 0])
    Multiplier(1, 32,2*511, '-', [0.1 0.1 0.1])
];

Mults_256 = [
    Multiplier(2, 63,2*255, '-', [0.9 0 0])
    Multiplier(4, 32,2*255, '-', [0 0.9 0])
    Multiplier(1, 64,2*255, '-', [0.1 0.1 0.1])
];

Mults_R2 = [
    Multiplier(2, 7,2*2047, '-', [0.9 0 0])
    Multiplier(2, 31,2*511, '-', [0 0.9 0])
    Multiplier(2, 63,2*255, '-', [0 0 0.9])
];
Mults_R4 = [
    Multiplier(4, 4,2*2047, '-', [0.9 0 0])
    Multiplier(4, 15,2*511, '-', [0 0.9 0])
    Multiplier(4, 32,2*255, '-', [0 0 0.9])
];


fig_num = 1;
%fig_num = make_plots(Mults_32, '8-Bit Equivalent', fig_num, {'R-2','R-4','Control'});
%fig_num = make_plots(Mults_128, '32-Bit Equivalent', fig_num, {'r2','r4','control'});
fig_num = make_plots(Mults_256, '64-Bit Equivalent Multipliers', fig_num, {'R-2','R-4','Control'});
%fig_num = make_plots(Mults_R2, 'Radix 2', fig_num, {'7 dig','31 dig','63 dig'});
%fig_num = make_plots(Mults_R4, 'Radix 4', fig_num, {'4 dig','15 dig','32 dig'});

function fig_num = make_plots(Mults, width, fig_num, data_lgd)
    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Mults)
        Mults(i).plot(Mults(i).mr);
    end
    title(sprintf('Average Mean Relative Error, %s',width))
    xlabel('Frequency (MHz)')
    ylabel('Mean Relative Error')
    hold off
    lgd = legend(data_lgd);
    ylim([0 300])
    xlim([100 600])
    lgd.Layout.Tile = 'east';
end