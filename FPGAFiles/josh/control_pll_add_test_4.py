#!/usr/bin/env python

import lib.module as module
import lib.axi as axi
import lib.fractional_pll as pll

import os
import time
import math
import sys

RADIX=2
WIDTH=int(sys.argv[1])
TRYS=int(sys.argv[2])

A=RADIX-1
D=math.floor(math.log(RADIX,2)+1)
BITS=D*WIDTH
BITS_OUT = BITS + D
MASK=int((2**D)-1)

a_p = 'add/control_w%d/a_p_data.txt' % (WIDTH)
a_p_test = 'add/control_w%d/a_p_data_TEST.txt' % (WIDTH)
b_p = 'add/control_w%d/b_p_data.txt' % (WIDTH)
c_p = 'add/control_w%d/c_p_data.txt' % (WIDTH)
gold_p = 'add/control_w%d/c_p_data_GOLD.txt' % (WIDTH)
a_n = 'add/control_w%d/a_n_data.txt' % (WIDTH)
b_n = 'add/control_w%d/b_n_data.txt' % (WIDTH)
c_n = 'add/control_w%d/c_n_data.txt' % (WIDTH)
gold_n = 'add/control_w%d/c_n_data_GOLD.txt' % (WIDTH)
rbf= './program_fpga.sh add/control_w%d/control_%d.rbf' % (WIDTH,WIDTH)

err_path = 'add/control_w%d/control_w%d_err.csv' % (WIDTH,WIDTH)
abs_err_path = 'add/control_w%d/control_w%d_abs_err.csv' % (WIDTH,WIDTH)
mr_err_path = 'add/control_w%d/control_w%d_mr_err.csv' % (WIDTH,WIDTH)
bf_loc_path = 'add/control_w%d/control_w%d_bf_loc.csv' % (WIDTH,WIDTH)

mr_err_file = open(mr_err_path, 'w')
err_file = open(err_path, 'w')
abs_err_file = open(abs_err_path, 'w')
bf_loc_file = open(bf_loc_path, 'w')

err_file.write('freq, avg, max, min\n')
abs_err_file.write('freq, avg, max\n')
mr_err_file.write('freq, avg, max\n')
bf_loc_file.write('freq, min_avg, max, min, illegal, max_avg\n')

mr_err_file.close()
err_file.close()
abs_err_file.close()
bf_loc_file.close()

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

f_sum = 0
start_time = time.time()
for x in range(1, TRYS+1):
    print 'Control, W',WIDTH,'Trial', x
    os.popen('python make_reg_data.py %d' % (WIDTH))
    f_min=100000000
    f_max=600000000

    prog_working = False
    prog_try = 0
    n = 0
    print 'Programming FPGA'

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
            if(c_num >> (WIDTH)): c_num -= 2**int(WIDTH+1)
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
            if(c_num >> (WIDTH)): c_num -= 2**int(WIDTH+1)
            c_file.write('%d\n' %c_num)
        c_file.close()

        diff_pos = os.popen('diff '+c_p+' '+gold_p)
        diff_neg = os.popen('diff '+c_n+' '+gold_n)
        output_pos = diff_pos.read()
        output_neg = diff_neg.read()
        if (output_pos != '' or output_neg != '') :
            print '     fail'
            time.sleep(0.01)
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
            if(c_num >> (WIDTH)): c_num -= 2**int(WIDTH+1)
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
            if(c_num >> (WIDTH)): c_num -= 2**int(WIDTH+1)
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
    print 'found f_max of', f_min
    f_sum += f_min

    pll.set(100000000)
    while(tcu.read(tcu_regs['lock']) != 1):
        pass

    tcu.write(tcu_regs['addr'], 0)
    tcu.write(tcu_regs['num'], n)
    tcu.write(tcu_regs['go'], 1)
    while (tcu.read(tcu_regs['go']) != 0):
        pass

    ovc_freq_start = int(f_min/1000000) - 10
    ovc_freq= ovc_freq_start
    freq_span = 600 - ovc_freq_start
    prog_bar = int(freq_span/5)
    print 'Beging overlock tests at', ovc_freq, 'MHz'

    mr_err_file = open(mr_err_path, 'a')
    err_file = open(err_path, 'a')
    abs_err_file = open(abs_err_path, 'a')
    bf_loc_file = open(bf_loc_path, 'a')

    checkpoint_400 = False
    checkpoint_450 = False
    checkpoint_500 = False
    checkpoint_550 = False

    while(ovc_freq<=600):
        actual_freq = int(math.ceil(pll.set(ovc_freq*1000000)/1000000))
        if(actual_freq!=ovc_freq):
            if(actual_freq>ovc_freq):
                ovc_freq = actual_freq
            else:
                ovc_freq = ovc_freq + 1
                continue

        if(ovc_freq>=(600-4*prog_bar) and (not checkpoint_400)):
            print 'reached', ovc_freq, 'MHz, [XX--------]'
            checkpoint_400 = True

        if(ovc_freq>=(600-3*prog_bar) and (not checkpoint_450)):
            print 'reached', ovc_freq, 'MHz, [XXXX------]'
            checkpoint_450 = True

        if(ovc_freq>=(600-2*prog_bar) and (not checkpoint_500)):
            print 'reached', ovc_freq, 'MHz, [XXXXXX----]'
            checkpoint_500 = True

        if(ovc_freq>=(600-1*prog_bar) and (not checkpoint_550)):
            print 'reached', ovc_freq, 'MHz, [XXXXXXXX--]'
            checkpoint_550 = True

        while(tcu.read(tcu_regs['lock']) != 1):
            pass

        tcu.write(tcu_regs['addr'], 0)
        tcu.write(tcu_regs['num'], n)
        tcu.write(tcu_regs['go'], 1)
        while (tcu.read(tcu_regs['go']) != 0):
            pass

        max_err = 0
        min_err = 0
        avg_err = 0.0
        avg_err_count = 0

        max_abs_err = 0
        avg_abs_err = 0.0
        avg_abs_count = 0

        max_mr_err = 0.0
        avg_mr_err = 0.0
        avg_mr_count = 0

        max_bf = 0
        min_bf = BITS+D+1
        avg_min_bf = 0.0
        avg_min_bf_count = 0
        avg_max_bf = 0.0
        avg_max_bf_count = 0
        bf_illegal = 0


        c_p_ram.write(ram_regs['addr'], 0)
        p_val_file = open(gold_p, 'r')
        for line in p_val_file:
            gold_val = long(line.strip('\n'))
            gold_vec = gold_val
            c_num = 0
            for i in range(int(math.ceil(BITS_OUT/32)),0,-1):
                reg = 'data_%d' % (i*32)
                sub_c_num = c_p_ram.read(ram_regs[reg])
                c_num = c_num + (sub_c_num<<(32*(i-1)))
            if(c_num >> (WIDTH)): c_num -= 2**int(WIDTH+1)

            xor_vec = c_num^gold_vec
            right_1 = BITS+D+1
            if(xor_vec!=0): right_1 = math.log(xor_vec&-xor_vec, 2)+1
            if(right_1<min_bf): min_bf = right_1
            if(right_1==BITS+D+1):right_1 = 0
            avg_min_bf += right_1
            avg_min_bf_count += 1

            left_1 = 0
            if(xor_vec!=0):
                left_1 = 1
                xor_left = int(xor_vec/2)
                while (xor_left > 0):
                    xor_left = int(xor_left/2)
                    left_1 += 1
            if(left_1>max_bf): max_bf = left_1
            avg_max_bf += left_1
            avg_max_bf_count +=1 

            c_val = c_num

            err = c_val-gold_val
            abs_err = abs(err)
            if(gold_val != 0): mr_err = float(abs_err)/float(abs(gold_val))
            else: mr_err = float("NaN")

            if(err > max_err):
                max_err = err
            if(err < min_err):
                min_err = err
            avg_err += err
            avg_err_count+=1

            if(abs_err > max_abs_err):
                max_abs_err = abs_err
            avg_abs_err += abs_err
            avg_abs_count += 1

            if(mr_err > max_mr_err):
                max_mr_err = mr_err
            if(mr_err >= 0):
                avg_mr_err += mr_err
                avg_mr_count += 1
        p_val_file.close()

        c_n_ram.write(ram_regs['addr'], 0)
        n_val_file = open(gold_n, 'r')
        for line in n_val_file:
            gold_val = long(line.strip('\n'))
            gold_vec = gold_val
            c_num = 0
            for i in range(int(math.ceil(BITS_OUT/32)),0,-1):
                reg = 'data_%d' % (i*32)
                sub_c_num = c_n_ram.read(ram_regs[reg])
                c_num = c_num + (sub_c_num<<(32*(i-1)))
            if(c_num >> (WIDTH)): c_num -= 2**int(WIDTH+1)

            xor_vec = c_num^gold_vec
            right_1 = BITS+D+1
            if(xor_vec!=0): right_1 = math.log(xor_vec&-xor_vec, 2)+1
            if(right_1<min_bf): min_bf = right_1
            if(right_1==BITS+D+1):right_1 = 0
            avg_min_bf += right_1
            avg_min_bf_count += 1

            left_1 = 0
            if(xor_vec!=0):
                left_1 = 1
                xor_left = int(xor_vec/2)
                while (xor_left > 0):
                    xor_left = int(xor_left/2)
                    left_1 += 1
            if(left_1>max_bf): max_bf = left_1
            avg_max_bf += left_1
            avg_max_bf_count +=1 

            c_val = c_num

            err = c_val-gold_val
            abs_err = abs(err)
            if(gold_val != 0): mr_err = float(abs_err)/float(abs(gold_val))
            else: mr_err = float("NaN")

            if(err > max_err):
                max_err = err
            if(err < min_err):
                min_err = err
            avg_err += err
            avg_err_count+=1

            if(abs_err > max_abs_err):
                max_abs_err = abs_err
            avg_abs_err += abs_err
            avg_abs_count += 1

            if(mr_err > max_mr_err):
                max_mr_err = mr_err
            if(mr_err >= 0):
                avg_mr_err += mr_err
                avg_mr_count += 1
        n_val_file.close()

        if(avg_err_count != 0):
            avg_err = float(avg_err)/float(avg_err_count)
        else:
            avg_err = 0

        if(avg_abs_count != 0):
            avg_abs_err = float(avg_abs_err)/float(avg_abs_count)
        else:
            avg_abs_err = 0

        if(avg_mr_count != 0):
            avg_mr_err = float(avg_mr_err)/float(avg_mr_count)
        else:
            avg_mr_err = 0

        if(avg_min_bf_count != 0):
            avg_min_bf = float(avg_min_bf)/float(avg_min_bf_count)
        else:
            avg_min_bf = 0
        if(min_bf==BITS+D+1): min_bf = 0

        if(avg_max_bf_count != 0):
            avg_max_bf = float(avg_max_bf)/float(avg_max_bf_count)
        else:
            avg_max_bf = 0

        err_file.write('%d, %E, %d, %d\n' %(ovc_freq,avg_err,max_err,min_err))
        abs_err_file.write('%d, %E, %d\n' %(ovc_freq,avg_abs_err,max_abs_err))
        mr_err_file.write('%d, %E, %E\n' %(ovc_freq,avg_mr_err,max_mr_err))
        bf_loc_file.write('%d, %E, %d, %d, %d, %E\n' %(ovc_freq,avg_min_bf,max_bf,min_bf,bf_illegal,avg_max_bf))
        
        freq_diff = ovc_freq-ovc_freq_start
        if(freq_diff<=100): ovc_freq += 1
        elif(freq_diff<=200): ovc_freq += 5
        elif(freq_diff<=300): ovc_freq += 10
        else: ovc_freq += 25

    mr_err_file.close()
    err_file.close()
    abs_err_file.close()
    bf_loc_file.close()

end_time = time.time()
timing = int(end_time-start_time)
print 'Average Fmax of', f_sum/TRYS
print 'Completed',TRYS,'tests in',timing,'seconds... Goodbye!'