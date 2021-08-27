clear; clc;
set(groot,'defaultLineLineWidth',2.0)

Adders_32 = [
    Adder(2, 15,2*2047, '-', [0.9 0 0])
    Adder(4, 8,2*2047, '-', [0 0.9 0])
    Adder(8, 5,2*2047, '-', [0 0 0.9])
    Adder(1, 16,2*2047, '-', [0.1 0.1 0.1])
];

Adders_64 = [
    Adder(2, 31,2*1023, '-', [0.9 0 0])
    Adder(4, 16,2*1023, '-', [0 0.9 0])
    Adder(8, 11,2*1023, '-', [0 0 0.9])
    Adder(1, 32,2*1023, '-', [0.1 0.1 0.1])
];

Adders_128 = [
    Adder(2, 63,2*511, '-', [0.9 0 0])
    Adder(4, 32,2*511, '-', [0 0.9 0])
    Adder(8, 21,2*511, '-', [0 0 0.9])
    Adder(1, 64,2*511, '-', [0.1 0.1 0.1])
];


Adders_256 = [
    Adder(2, 127,2*255, '-', [0.9 0 0])
    Adder(4, 64,2*255, '-', [0 0.9 0])
    Adder(8, 43,2*255, '-', [0 0 0.9])
    Adder(1, 128,2*255, '-', [0.1 0.1 0.1])
];

fig_num = 1;
% fig_num = make_plots(Adders_32, '16-Bit Equivalent', fig_num, {'R-2','R-4','R-8','Control'});
% fig_num = make_plots(Adders_64, '32-Bit Equivalent', fig_num, {'R-2','R-4','R-8','Control'});
% fig_num = make_plots(Adders_128, '64-Bit Equivalent', fig_num, {'R-2','R-4','R-8','Control'});
fig_num = make_plots(Adders_256, '128-Bit Equivalent', fig_num, {'R-2','R-4','R-8','Control'});


function fig_num = make_plots(Adders, width, fig_num, data_lgd)
    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).bits);
    end
    nexttile(1);
    title(sprintf('Count of Illegal Digits, %s',width))
    xlabel('Frequency (MHz)')
    ylabel('Number of Illegal Digits (normalized)')
%     ylim([0 15])
%     xlim([250 600])
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';
end

