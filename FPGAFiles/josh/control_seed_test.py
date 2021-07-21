#!/usr/bin/env python

import lib.module as module
import lib.axi as axi
import lib.fractional_pll as pll

import os
import time
import math
import sys

RADIX=int(sys.argv[1])
WIDTH=int(sys.argv[2])

A=RADIX-1
D=math.floor(math.log(RADIX,2)+1)
BITS=D*WIDTH
BITS_OUT = BITS + D
MASK=int((2**D)-1)
SEED = 0

a_p = 'add/control_w%d/a_p_data.txt' % (WIDTH)
a_p_test = 'add/control_w%d/a_p_data_TEST.txt' % (WIDTH)
b_p = 'add/control_w%d/b_p_data.txt' % (WIDTH)
c_p = 'add/control_w%d/c_p_data.txt' % (WIDTH)
gold_p = 'add/control_w%d/c_p_data_GOLD.txt' % (WIDTH)
a_n = 'add/control_w%d/a_n_data.txt' % (WIDTH)
b_n = 'add/control_w%d/b_n_data.txt' % (WIDTH)
c_n = 'add/control_w%d/c_n_data.txt' % (WIDTH)
gold_n = 'add/control_w%d/c_n_data_GOLD.txt' % (WIDTH)

freq_file_path = 'add/control_w%d/control_%d_seeds.txt' % (WIDTH,WIDTH)
freq_file = open(freq_file_path, 'w')
freq_file.write('seed, avg, max, min\n')
freq_file.close()

max_max = 0
avg_avg = 0
min_min = 600000000

tcu_regs= {
    'go': 4*0,
    'addr': 4*1,
    'num': 4*2,
    'lock': 4*3,
    'id': 4*4
}

ram_regs = {
    'data_32': 4*0,
    'addr': 4*1,
    'we': 4*2,
    'id': 4*3
}

for i in range(4,19):
    reg = 'data_%d' % ((i-2)*32)
    ram_regs[reg] = 4*i

axi = axi.axi(0xFF200000, 0x0500)
pll = pll.pll(axi, 0x0400)
tcu = module.module(axi, 0x0300)
a_p_ram = module.module(axi, 0x0000)
a_n_ram = module.module(axi, 0x0080)
b_p_ram = module.module(axi, 0x0100)
b_n_ram = module.module(axi, 0x0180)
c_p_ram = module.module(axi, 0x0200)
c_n_ram = module.module(axi, 0x0280)

for x in range (1,11):
    SEED = x
    print 'SEED', SEED
    rbf= './program_fpga.sh add/control_w%d/control_%d_s%d.rbf' % (WIDTH,WIDTH,SEED)

    f_sum = 0
    ovr_min = 600000000
    ovr_max = 0
    start_time = time.time()
    for x in range(1, 11):
        #print 'R',RADIX,'W',WIDTH,'Trial', x
        f_min=100000000
        f_max=600000000

        prog_working = False
        prog_try = 0
        n = 0
        #print 'Programming FPGA'

        while((not prog_working) and (prog_try<=10)):
            prog_try = prog_try +1;

            os.popen(rbf)

            working = tcu.read(tcu_regs['id'])
            if working != 8:
                print('fail: wrong tcu id')
                print working
                exit()
            working = a_p_ram.read(ram_regs['id'])
            if working != 2:
                print('fail: wrong a_p_ram id')
                exit()
            working = a_n_ram.read(ram_regs['id'])
            if working != 3:
                print('fail: wrong a_n_ram id')
                exit()
            working = b_p_ram.read(ram_regs['id'])
            if working != 4:
                print('fail: wrong b_p_ram id')
                exit()
            working = b_n_ram.read(ram_regs['id'])
            if working != 5:
                print('fail: wrong b_n_ram id')
                exit()
            working = c_p_ram.read(ram_regs['id'])
            if working != 6:
                print('fail: wrong c_p_ram id')
                exit()
            working = c_n_ram.read(ram_regs['id'])
            if working != 7:
                print('fail: wrong c_n_ram id')
                exit()

            n=0 #number of additions

            a_file = open(a_p, 'r')
            a_p_ram.write(ram_regs['addr'], 0)
            a_p_ram.write(ram_regs['we'], 1)
            for a_line in a_file:
                value = int(a_line.strip('\n'))
                for i in range(int(math.ceil(BITS/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_value = (value>>(32*(i-1)))&0xFFFFFFFF
                    a_p_ram.write(ram_regs[reg], sub_value)
                n=n+1
            a_p_ram.write(ram_regs['we'], 0)
            a_file.close()

            b_file = open(b_p, 'r')
            b_p_ram.write(ram_regs['addr'], 0)
            b_p_ram.write(ram_regs['we'], 1)
            for b_line in b_file:
                value = int(b_line.strip('\n'))
                for i in range(int(math.ceil(BITS/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_value = (value>>(32*(i-1)))&0xFFFFFFFF
                    b_p_ram.write(ram_regs[reg], sub_value)
            b_p_ram.write(ram_regs['we'], 0)
            b_file.close()

            a_file = open(a_n, 'r')
            a_n_ram.write(ram_regs['addr'], 0)
            a_n_ram.write(ram_regs['we'], 1)
            for a_line in a_file:
                value = int(a_line.strip('\n'))
                for i in range(int(math.ceil(BITS/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_value = (value>>(32*(i-1)))&0xFFFFFFFF
                    a_n_ram.write(ram_regs[reg], sub_value)
            a_n_ram.write(ram_regs['we'], 0)
            a_file.close()

            b_file = open(b_n, 'r')
            b_n_ram.write(ram_regs['addr'], 0)
            b_n_ram.write(ram_regs['we'], 1)
            for b_line in b_file:
                value = int(b_line.strip('\n'))
                for i in range(int(math.ceil(BITS/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_value = (value>>(32*(i-1)))&0xFFFFFFFF
                    b_n_ram.write(ram_regs[reg], sub_value)
            b_n_ram.write(ram_regs['we'], 0)
            b_file.close()

            pll.set(100000000)
            while(tcu.read(tcu_regs['lock']) != 1):
                pass

            tcu.write(tcu_regs['addr'], 0)
            tcu.write(tcu_regs['num'], n)
            tcu.write(tcu_regs['go'], 1)
            while (tcu.read(tcu_regs['go']) != 0):
                pass

            c_file = open(c_p, 'w')
            c_p_ram.write(ram_regs['addr'], 0)
            for i in range(n):
                c_num = 0
                for i in range(int(math.ceil(BITS/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_c_num = c_p_ram.read(ram_regs[reg])
                    c_num = c_num + (sub_c_num<<(32*(i-1)))
                c_file.write('%d\n' %c_num)
            c_file.close()


            c_file = open(c_n, 'w')
            c_n_ram.write(ram_regs['addr'], 0)
            for i in range(n):
                c_num = 0
                for i in range(int(math.ceil(BITS/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_c_num = c_n_ram.read(ram_regs[reg])
                    c_num = c_num + (sub_c_num<<(32*(i-1)))
                c_file.write('%d\n' %c_num)
            c_file.close()

            diff_pos = os.popen('diff '+c_p+' '+gold_p)
            diff_neg = os.popen('diff '+c_n+' '+gold_n)
            output_pos = diff_pos.read()
            output_neg = diff_neg.read()
            if (output_pos != '' or output_neg != '') :
                print '     fail'
                time.sleep(0.05)
            else:
                prog_working = True

        if(prog_try>10):
            print 'Failed to work after 10 trys'
            exit()

        print 'programming successful after', prog_try, 'try(s)'

        f_previous = 0
        f_try = pll.set(round(f_min+f_max)/2)
        while(tcu.read(tcu_regs['lock']) != 1):
            pass

        while (f_try!=f_previous):
            #print 'Trying', f_try, 'Hz'

            tcu.write(tcu_regs['addr'], 0)
            tcu.write(tcu_regs['num'], n)
            tcu.write(tcu_regs['go'], 1)
            while (tcu.read(tcu_regs['go']) != 0):
                pass

            c_file = open(c_p, 'w')
            c_p_ram.write(ram_regs['addr'], 0)
            for i in range(n):
                c_num = 0
                for i in range(int(math.ceil(BITS_OUT/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_c_num = c_p_ram.read(ram_regs[reg])
                    c_num = c_num + (sub_c_num<<(32*(i-1)))
                c_file.write('%d\n' %c_num)
            c_file.close()


            c_file = open(c_n, 'w')
            c_n_ram.write(ram_regs['addr'], 0)
            for i in range(n):
                c_num = 0
                for i in range(int(math.ceil(BITS_OUT/32)),0,-1):
                    reg = 'data_%d' % (i*32)
                    sub_c_num = c_n_ram.read(ram_regs[reg])
                    c_num = c_num + (sub_c_num<<(32*(i-1)))
                c_file.write('%d\n' %c_num)
            c_file.close()

            diff_pos = os.popen('diff '+c_p+' '+gold_p)
            diff_neg = os.popen('diff '+c_n+' '+gold_n)
            output_pos = diff_pos.read()
            output_neg = diff_neg.read()
            if (output_pos != '' or output_neg != '') :
                f_max = f_try
            else:
                f_min = f_try
            f_previous = f_try
            f_try = pll.set(round(f_min+f_max)/2)
            while(tcu.read(tcu_regs['lock']) != 1):
                pass
        #print 'found f_max of', f_min
        f_sum+=f_min
        if(f_min<ovr_min): ovr_min = f_min
        if(f_min>ovr_max): ovr_max = f_min
    f_sum = f_sum/10
    if(ovr_min<min_min): min_min = ovr_min
    if(ovr_max>max_max): max_max = ovr_max
    avg_avg += f_sum
    freq_file = open(freq_file_path, 'a')
    freq_file.write('%d,%f,%f,%f\n' % (SEED,f_sum,ovr_max,ovr_min))
    freq_file.close()
print 'min_min', min_min
print 'max_max', max_max
print 'avg_avg', avg_avg/10




