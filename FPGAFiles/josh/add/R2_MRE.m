clear; clc;
set(groot,'defaultLineLineWidth',2.0)

Adders_R2 = [
    Adder(2, 15,2*2047, '-', [0.9 0 0])
    Adder(2, 31,2*1023, '-', [0 0.9 0])
    Adder(2, 63,2*511, '-', [0 0 0.9])
    Adder(2, 127,2*255, '-', [0.9 0.9 0])
];
Adders_R4 = [
    Adder(4, 8,2*2047, '-', [0.9 0 0])
    Adder(4, 16,2*1023, '-', [0 0.9 0])
    Adder(4, 32,2*511, '-', [0 0 0.9])
    Adder(4, 64,2*255, '-', [0.9 0.9 0])
];
Adders_R8 = [
    Adder(8, 5,2*2047, '-', [0.9 0 0])
    Adder(8, 11,2*1023, '-', [0 0.9 0])
    Adder(8, 21,2*511, '-', [0 0 0.9])
    Adder(8, 43,2*255, '-', [0.9 0.9 0])
];

fig_num = 1;
fig_num = make_plots(Adders_R2, 'Radix-2', fig_num, {'16-Bit Eq.','32-Bit Eq.','64-Bit Eq.','128-Bit Eq.'});
fig_num = make_plots(Adders_R4, 'Radix-4', fig_num, {'16-Bit Eq.','32-Bit Eq.','64-Bit Eq.','128-Bit Eq.'});
fig_num = make_plots(Adders_R8, 'Radix-8', fig_num, {'16-Bit Eq.','32-Bit Eq.','64-Bit Eq.','128-Bit Eq.'});
function fig_num = make_plots(Adders, width, fig_num, data_lgd)

    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).mr);
    end
    nexttile(1);
    title(sprintf('Average Mean Relative Error, %s',width))
    xlabel('Frequency (MHz)')
    ylabel('Mean Relative Error')
    ylim([0 100])
    xlim([300 600])
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';


end

