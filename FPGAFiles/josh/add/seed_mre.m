clear; clc;
set(groot,'defaultLineLineWidth',2.0)

Adders_32 = [
    Adder(4, 8,2*2047, '-', [0 0.9 0])
    Adder(8, 5,2*2047, '-', [0 0 0.9])
    Adder(1, 16,2*2047, '-', [0.1 0.1 0.1])
];

Adders_64 = [
    Adder(4, 16,2*1023, '-', [0 0.9 0])
    Adder(8, 11,2*1023, '-', [0 0 0.9])
    Adder(1, 32,2*1023, '-', [0.1 0.1 0.1])
];

Adders_128 = [
    SeedAdder(1, 64,2*511, '-', [0.1 0.1 0.1], 1)
    SeedAdder(1, 64,2*511, '-', [0.1 0.1 0.1], 2)
    SeedAdder(1, 64,2*511, '-', [0.1 0.1 0.1], 3)
    SeedAdder(1, 64,2*511, '-', [0.1 0.1 0.1], 4)
    SeedAdder(1, 64,2*511, '-', [0.1 0.1 0.1], 5)
];


Adders_256 = [
    Adder(4, 64,2*255, '-', [0 0.9 0])
    Adder(8, 43,2*255, '-', [0 0 0.9])
    Adder(1, 128,2*255, '-', [0.1 0.1 0.1])
];

fig_num = 1;
%fig_num = make_plots(Adders_32, '16-Bit Equivalent', fig_num, {'R-4','R-8','Control'});
%fig_num = make_plots(Adders_64, '32-Bit Equivalent', fig_num, {'R-4','R-8','Control'});
fig_num = make_plots(Adders_128, '64-Bit Equivalent', fig_num, {'Seed=1','Seed=2','Seed=3','Seed=4','Seed=5'});
%fig_num = make_plots(Adders_256, '128-Bit Equivalent', fig_num, {'R-4','R-8','Control'});

function fig_num = make_plots(Adders, width, fig_num,data_lgd)

    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).mr);
    end
    nexttile(1);
    title(sprintf('Average Mean Relative Error, 64-Bit Control'))
    xlabel('Frequency (MHz)')
    ylabel('Mean Relative Error')
%     ylim([0 15])
%     xlim([250 600])
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';

end

