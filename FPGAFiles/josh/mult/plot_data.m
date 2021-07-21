clear; clc;
set(groot,'defaultLineLineWidth',2.0)


Mults_32 = [
    Multiplier(2, 7,2*2047, '-', [0.9 0 0])
    Multiplier(4, 4,2*2047, '-', [0 0.9 0])
    Multiplier(1, 7,2*2047, '-', [0.1 0.1 0.1])
];

Mults_128 = [
    Multiplier(2, 31,2*511, '-', [0.9 0 0])
    Multiplier(4, 15,2*511, '-', [0 0.9 0])
    Multiplier(1, 31,2*511, '-', [0.1 0.1 0.1])
];

Mults_256 = [
    Multiplier(2, 63,2*255, '-', [0.9 0 0])
    Multiplier(4, 32,2*255, '-', [0 0.9 0])
    Multiplier(1, 63,2*255, '-', [0.1 0.1 0.1])
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
%fig_num = make_plots(Mults_32, '32 Bits', fig_num, {'r2','r4','control'});
%fig_num = make_plots(Mults_128, '128 Bits', fig_num, {'r2','r4','control'});
%fig_num = make_plots(Mults_256, '256 Bits', fig_num, {'r2','r4','control'});
%fig_num = make_plots(Mults_R2, 'Radix 2', fig_num, {'7 dig','31 dig','63 dig'});
fig_num = make_plots(Mults_R4, 'Radix 4', fig_num, {'4 dig','15 dig','32 dig'});
function fig_num = make_plots(Mults, width, fig_num, data_lgd)
    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Mults)
        Mults(i).plot(Mults(i).err);
    end
    nexttile(1);
    title(sprintf('avg ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('error')
    nexttile(2);
    title(sprintf('max ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('error')
    nexttile(3);
    title(sprintf('min ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('error')
    hold off
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';

    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Mults)
        Mults(i).plot(Mults(i).abs);
    end
    nexttile(1);
    title(sprintf('avg absolute ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('absolute error')
    nexttile(2);
    title(sprintf('max absolute ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('absolute error')
    hold off
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';

    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Mults)
        Mults(i).plot(Mults(i).mr);
    end
    nexttile(1);
    title(sprintf('avg mr ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('mr error')
    nexttile(2);
    title(sprintf('max mr ERR %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('mr error')
    hold off
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';


    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Mults)
        Mults(i).plot(Mults(i).bits);
    end
    nexttile(1);
    title(sprintf('avg min flipped %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    nexttile(2);
    title(sprintf('max flipped %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    nexttile(3);
    title(sprintf('min flipped %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    nexttile(4);
    title(sprintf('illegal digits %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('# of digits')
    nexttile(5);
    title(sprintf('avg max flipped %s',width))
    xlabel('freqeuncy (MHz)')
    ylabel('bit location')
    hold off
    lgd = legend(data_lgd);
    lgd.Layout.Tile = 'east';
end

