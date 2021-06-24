#!/usr/bin/env python

import lib.module as module
import lib.axi as axi
import lib.fractional_pll as pll

import os
import time
import math

tcu_regs= {
    'go': 4*0,
    'addr': 4*1,
    'num': 4*2,
    'lock': 4*3,
    'id': 4*4
}

ram_regs = {
    'data': 4*0,
    'addr': 4*1,
    'we': 4*2,
    'id': 4*3,
}

axi = axi.axi(0xFF200000, 0x0200)
tcu = module.module(axi, 0x00c0)
pll = pll.pll(axi, 0x0100)
a_p_ram = module.module(axi, 0x0020)
a_n_ram = module.module(axi, 0x0000)
b_p_ram = module.module(axi, 0x0060)
b_n_ram = module.module(axi, 0x0040)
c_p_ram = module.module(axi, 0x00a0)
c_n_ram = module.module(axi, 0x0080)

working = tcu.read(tcu_regs['id'])
if working != 1:
    print('fail: wrong tcu id')
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
print('IP contacted successfully')

n=0 #number of additions

print('Filling a_p_ram')
a_file = open('a_p_data.txt', 'r')
a_p_ram.write(ram_regs['addr'], 0)
a_p_ram.write(ram_regs['we'], 1)
for a_line in a_file:
    a_p_ram.write(ram_regs['data'], int(a_line.strip('\n')))
    n=n+1
a_p_ram.write(ram_regs['we'], 0)
a_file.close()
#print(a_p_ram.read(ram_regs['addr']))
    
print('Filling b_p_ram')
b_file = open('b_p_data.txt', 'r')
b_p_ram.write(ram_regs['addr'], 0)
b_p_ram.write(ram_regs['we'], 1)
for b_line in b_file:
    b_p_ram.write(ram_regs['data'], int(b_line.strip('\n')))
b_p_ram.write(ram_regs['we'], 0)
b_file.close()

print('Filling a_n_ram')
a_file = open('a_n_data.txt', 'r')
a_n_ram.write(ram_regs['addr'], 0)
a_n_ram.write(ram_regs['we'], 1)
for a_line in a_file:
    a_n_ram.write(ram_regs['data'], int(a_line.strip('\n')))
a_n_ram.write(ram_regs['we'], 0)
a_file.close()
#print(a_n_ram.read(ram_regs['addr']))
    
print('Filling b_n_ram')
b_file = open('b_n_data.txt', 'r')
b_n_ram.write(ram_regs['addr'], 0)
b_n_ram.write(ram_regs['we'], 1)
for b_line in b_file:
    b_n_ram.write(ram_regs['data'], int(b_line.strip('\n')))
b_n_ram.write(ram_regs['we'], 0)
b_file.close()

f_min=100000000
f_max=600000000

f_previous = 0
f_try = pll.set(round(f_min+f_max)/2)
while(tcu.read(tcu_regs['lock']) != 1):
    pass

while (f_try!=f_previous):
    print 'Trying', f_try, 'Hz'
    
    time.sleep(1)

    tcu.write(tcu_regs['addr'], 0)
    tcu.write(tcu_regs['num'], n)
    #print(tcu.read(tcu_regs['num']))
    tcu.write(tcu_regs['go'], 1)
    while (tcu.read(tcu_regs['go']) != 0):
        pass

    c_file = open('c_p_data.txt', 'w')
    c_p_ram.write(ram_regs['addr'], 0)
    for i in range(n):
        c_num = c_p_ram.read(ram_regs['data'])
        c_val = 0
        for j in range(0,16):
            c_dig = (c_num&(3<<(j*2)))>>(j*2)
            if c_dig == 3: c_dig = -1
            #elif c_dig == 2: print('ERROR c_dig 2???')
            #if c_dig > 1 or c_dig < -1: print('Error c_dig out of bounds?????')
            c_val += c_dig*(2**j)
        c_file.write('%d\n' %c_val)
    c_file.close()


    c_file = open('c_n_data.txt', 'w')
    c_n_ram.write(ram_regs['addr'], 0)
    for i in range(n):
        c_num = c_n_ram.read(ram_regs['data'])
        c_val = 0
        for j in range(0,16):
            c_dig = (c_num&(3<<(j*2)))>>(j*2)
            if c_dig == 3: c_dig = -1
            #elif c_dig == 2: #print('ERROR c_dig 2???')
            #if c_dig > 1 or c_dig < -1: #print('Error c_dig out of bounds?????')
            c_val += c_dig*(2**j)
        c_file.write('%d\n' %c_val)
    c_file.close()



    #print('Comparing c_p_data.txt to c_p_data_GOLD.txt')
    diff_pos = os.popen('diff c_p_data.txt c_p_data_GOLD.txt')
    diff_neg = os.popen('diff c_n_data.txt c_n_data_GOLD.txt')
    output_pos = diff_pos.read()
    output_neg = diff_neg.read()
    if (output_pos != '' or output_neg != '') :
        print '     fail'
        f_max = f_try
    else:
        print '     pass'
        f_min = f_try
    f_previous = f_try
    f_try = pll.set(round(f_min+f_max)/2)
    while(tcu.read(tcu_regs['lock']) != 1):
        pass

print 'f_max:', f_max
print 'f_min:', f_min
print 'f_try:', f_try
