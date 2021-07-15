clear; clc;
set(groot,'defaultLineLineWidth',2.0)


Adders_32 = [
    Adder(2, 15,2*2047, '-s', [0.9 0 0])
    Adder(4, 8,2*2047, '-d', [0 0.9 0])
    Adder(8, 5,2*2047, '-p', [0 0 0.9])
    Adder(1, 15,2*2047, '-*', [0.1 0.1 0.1])
];

Adders_64 = [
    Adder(2, 31,2*1023, '-s', [0.9 0 0])
    Adder(4, 16,2*1023, '-d', [0 0.9 0])
    Adder(8, 11,2*1023, '-p', [0 0 0.9])
    Adder(1, 31,2*1023, '-*', [0.1 0.1 0.1])
];

Adders_128 = [
    Adder(2, 63,2*511, '-s', [0.9 0 0])
    Adder(4, 32,2*511, '-d', [0 0.9 0])
    Adder(8, 21,2*511, '-p', [0 0 0.9])
    Adder(1, 63,2*511, '-*', [0.1 0.1 0.1])
];

fig_num = 1;
fig_num = make_plots(Adders_32, 32, fig_num);
fig_num = make_plots(Adders_64, 64, fig_num);
fig_num = make_plots(Adders_128, 128, fig_num);
function fig_num = make_plots(Adders, width, fig_num)
    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).err);
    end
    nexttile(1);
    title(sprintf('avg ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('error')
    nexttile(2);
    title(sprintf('max ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('error')
    nexttile(3);
    title(sprintf('min ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('error')
    hold off
    lgd = legend('r2','r4','r8','control');
    lgd.Layout.Tile = 'east';

    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).abs);
    end
    nexttile(1);
    title(sprintf('avg absolute ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('absolute error')
    nexttile(2);
    title(sprintf('max absolute ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('absolute error')
    hold off
    lgd = legend('r2','r4','r8','control');
    lgd.Layout.Tile = 'east';

    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).mr);
    end
    nexttile(1);
    title(sprintf('avg mr ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('mr error')
    nexttile(2);
    title(sprintf('max mr ERR %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('mr error')
    hold off
    lgd = legend('r2','r4','r8','control');
    lgd.Layout.Tile = 'east';


    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).bits);
    end
    nexttile(1);
    title(sprintf('avg min flipped %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    nexttile(2);
    title(sprintf('max flipped %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    nexttile(3);
    title(sprintf('min flipped %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    nexttile(4);
    title(sprintf('illegal digits %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('# of digits')
    nexttile(5);
    title(sprintf('avg max flipped %dbits',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    hold off
    lgd = legend('r2','r4','r8','control');
    lgd.Layout.Tile = 'east';
end

