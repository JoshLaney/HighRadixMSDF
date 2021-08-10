clear; clc;
set(groot,'defaultLineLineWidth',2.0)


Adders_32 = [
    Adder(2, 15,2*2047, '-', [0.9 0 0])
    Adder(4, 8,2*2047, '-', [0 0.9 0])
    Adder(8, 5,2*2047, '-', [0 0 0.9])
    Adder(16,4,2*2047, '-', [0.9 0.9 0])
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
%fig_num = make_plots(Adders_32, '32 Bits', fig_num, {'r2','r4','r8','r16','control'});
%fig_num = make_plots(Adders_64, '64 Bits', fig_num, {'r2','r4','r8','control'});
%fig_num = make_plots(Adders_128, '128 Bits', fig_num, {'r2','r4','r8','control'});
fig_num = make_plots(Adders_256, '256 Bits', fig_num, {'r2','r4','r8','control'});
%fig_num = make_plots(Adders_R2, 'Radix 2', fig_num, {'15 dig','31 dig','63 dig','127 dig'});
%fig_num = make_plots(Adders_R4, 'Radix 4', fig_num, {'8 dig','16 dig','32 dig','64 dig'});
%fig_num = make_plots(Adders_R8, 'Radix 8', fig_num, {'5 dig','11 dig','21 dig', '43 dig'});
function fig_num = make_plots(Adders, width, fig_num, data_lgd)
    figure(fig_num);
    fig_num = fig_num+1;
    tiledlayout('flow','TileSpacing','compact');
    hold on
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).err);
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
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).abs);
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
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).mr);
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
    for i = 1:size(Adders)
        Adders(i).plot(Adders(i).bits);
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

