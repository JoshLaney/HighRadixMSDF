#!/usr/bin/env python

import lib.module as module
import lib.axi as axi
import os
import sys
import math
import lib.fractional_pll as pll

RADIX=int(sys.argv[1])
WIDTH=int(sys.argv[2])
A=RADIX-1
D=math.floor(math.log(RADIX,2)+1)
BITS=D*WIDTH
MASK=int((2**D)-1)

a_p = 'add/r%d_w%d/a_p_data.txt' % (RADIX,WIDTH)
a_p_test = 'add/r%d_w%d/a_p_data_TEST.txt' % (RADIX,WIDTH)
b_p = 'add/r%d_w%d/b_p_data.txt' % (RADIX,WIDTH)
c_p = 'add/r%d_w%d/c_p_data.txt' % (RADIX,WIDTH)
gold_p = 'add/r%d_w%d/c_p_data_GOLD.txt' % (RADIX,WIDTH)
a_n = 'add/r%d_w%d/a_n_data.txt' % (RADIX,WIDTH)
b_n = 'add/r%d_w%d/b_n_data.txt' % (RADIX,WIDTH)
c_n = 'add/r%d_w%d/c_n_data.txt' % (RADIX,WIDTH)
gold_n = 'add/r%d_w%d/c_n_data_GOLD.txt' % (RADIX,WIDTH)
rbf= './program_fpga.sh add/r%d_w%d/r%d_w%d.rbf' % (RADIX,WIDTH,RADIX,WIDTH)

print 'Programming FPGA'
os.popen(rbf)
cat = os.popen('cat /sys/class/fpga/fpga0/status')
if(cat.read() != 'user mode\n'):
    print 'PROGRAMING ERROR'
    exit()

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

# ram_regs = {
#     'data_32': 4*0,
#     'addr': 4*1,
#     'we': 4*2,
#     'id': 4*3,
# }

# axi = axi.axi(0xFF200000, 0x0100)
# tcu = module.module(axi, 0x00c0)
# a_p_ram = module.module(axi, 0x0020)
# a_n_ram = module.module(axi, 0x0000)
# b_p_ram = module.module(axi, 0x0060)
# b_n_ram = module.module(axi, 0x0040)
# c_p_ram = module.module(axi, 0x00a0)
# c_n_ram = module.module(axi, 0x0080)

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
print('IP contacted successfully')

f_try = pll.set(100000000)
while(tcu.read(tcu_regs['lock']) != 1):
    pass

n=0 #number of additions

print('Filling a_p_ram')
a_file = open(a_p, 'r')
a_p_ram.write(ram_regs['addr'], 0)
a_p_ram.write(ram_regs['we'], 1)
#print int(math.ceil(BITS/32))
for a_line in a_file:
    value = int(a_line.strip('\n'))
    for i in range(int(math.ceil(BITS/32)),0,-1):
        #print 'I am here, i =', i
        reg = 'data_%d' % (i*32)
        sub_value = (value>>(32*(i-1)))&0xFFFFFFFF
        #print 'value is: ', value
        #print 'sub_value is: ', sub_value
        a_p_ram.write(ram_regs[reg], sub_value)
    n=n+1
a_p_ram.write(ram_regs['we'], 0)
a_file.close()

print n

c_file = open(c_p, 'w')
a_p_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_num = 0
    for i in range(int(math.ceil(BITS/32)),0,-1):
        reg = 'data_%d' % (i*32)
        sub_c_num = a_p_ram.read(ram_regs[reg])
        c_num = c_num + (sub_c_num<<(32*(i-1)))
    c_file.write('%d\n' %c_num)
c_file.close()

diff = os.popen('diff '+c_p+' '+a_p)
output = diff.read()
if(output != ''):
    print('fail: writing ram_a_pos')
    exit()

print('Filling b_p_ram')
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

c_file = open(c_p, 'w')
b_p_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_num = 0
    for i in range(int(math.ceil(BITS/32)),0,-1):
        reg = 'data_%d' % (i*32)
        sub_c_num = b_p_ram.read(ram_regs[reg])
        c_num = c_num + (sub_c_num<<(32*(i-1)))
    c_file.write('%d\n' %c_num)
c_file.close()

diff = os.popen('diff '+c_p+' '+b_p)
output = diff.read()
if(output != ''):
    print('fail: writing ram_b_pos')
    exit()

print('Filling a_n_ram')
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

c_file = open(c_p, 'w')
a_n_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_num = 0
    for i in range(int(math.ceil(BITS/32)),0,-1):
        reg = 'data_%d' % (i*32)
        sub_c_num = a_n_ram.read(ram_regs[reg])
        c_num = c_num + (sub_c_num<<(32*(i-1)))
    c_file.write('%d\n' %c_num)
c_file.close()

diff = os.popen('diff '+c_p+' '+a_n)
output = diff.read()
if(output != ''):
    print('fail: writing ram_a_neg')
    exit()
#print(a_n_ram.read(ram_regs['addr']))
    
print('Filling b_n_ram')
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

c_file = open(c_p, 'w')
b_n_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_num = 0
    for i in range(int(math.ceil(BITS/32)),0,-1):
        reg = 'data_%d' % (i*32)
        sub_c_num = b_n_ram.read(ram_regs[reg])
        c_num = c_num + (sub_c_num<<(32*(i-1)))
    c_file.write('%d\n' %c_num)
c_file.close()

diff = os.popen('diff '+c_p+' '+b_n)
output = diff.read()
if(output != ''):
    print('fail: writing ram_b_neg')
    exit()

print('Starting Adder')
tcu.write(tcu_regs['addr'], 0)
tcu.write(tcu_regs['num'], n)
#print(tcu.read(tcu_regs['num']))
tcu.write(tcu_regs['go'], 1)
while (tcu.read(tcu_regs['go']) != 0):
    pass

print('Writing c_p_data.txt')
c_file = open(c_p, 'w')
c_p_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_num = 0
    for i in range(int(math.ceil(BITS/32)),0,-1):
        reg = 'data_%d' % (i*32)
        sub_c_num = c_p_ram.read(ram_regs[reg])
        c_num = c_num + (sub_c_num<<(32*(i-1)))
    c_val = 0
    for j in range(0,WIDTH+1):
        c_dig = (c_num&(MASK<<int(j*D)))>>int(j*D)
        if c_dig > A: c_dig = (-1<<int(D))|c_dig
        #elif c_dig == 2: print('ERROR c_dig 2???')
        #if c_dig > 1 or c_dig < -1: print('Error c_dig out of bounds?????')
        c_val += c_dig*(RADIX**j)
    c_file.write('%d\n' %c_val)
c_file.close()


print('Writing c_n_data.txt')
c_file = open(c_n, 'w')
c_n_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_num = 0
    for i in range(int(math.ceil(BITS/32)),0,-1):
        reg = 'data_%d' % (i*32)
        sub_c_num = c_n_ram.read(ram_regs[reg])
        c_num = c_num + (sub_c_num<<(32*(i-1)))
    c_val = 0
    for j in range(0,WIDTH+1):
        c_dig = (c_num&(MASK<<int(j*D)))>>int(j*D)
        if c_dig > A: c_dig = (-1<<int(D))|c_dig
        #elif c_dig == 2: print('ERROR c_dig 2???')
        #if c_dig > 1 or c_dig < -1: print('Error c_dig out of bounds?????')
        c_val += c_dig*(RADIX**j)
    c_file.write('%d\n' %c_val)
c_file.close()



print('Comparing c_p_data.txt to c_p_data_GOLD.txt')
diff = os.popen('diff '+c_p+' '+gold_p)
output = diff.read()
if(output != ''):
    print('fail: positive edge files do not match')
    #print(output)
else:
    print('Positive edge files match!')

print('Comparing c_n_data.txt to c_n_data_GOLD.txt')
diff = os.popen('diff '+c_n+' '+gold_n)
output = diff.read()
if(output != ''):
    print('fail: neagtive edge files do not match')
    #print(output)
else:
    print('Negative edge files match!')
