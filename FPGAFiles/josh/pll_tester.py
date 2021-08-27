#!/usr/bin/env python

import time
import lib.module as module
import lib.axi as axi
import lib.fractional_pll as pll
import os
import sys
import math

counter = 100000000.0

test_regs= {
    'go': 4*0,
    'cnt': 4*1,
    'clear': 4*2,
    'ref': 4*3,
    'c0': 4*4,
    'lock': 4*5,
    'id': 4*6,
}


axi = axi.axi(0xFF200000, 0x0200)
pll = pll.pll(axi, 0x0100)
test = module.module(axi, 0x0000)


working = test.read(test_regs['id'])
if working != 1:
    print('fail: wrong test id')
    exit()



f_act = 0
if float(sys.argv[2]):
    print('Setting PLL')
    f_act = pll.set(float(sys.argv[1]))
    print "actual freq:", f_act
    while (test.read(test_regs['lock']) != 1):
        pass


print('Starting Test')
test.write(test_regs['clear'], 1)
test.write(test_regs['cnt'], int(counter))
test.write(test_regs['go'], 1)
while (test.read(test_regs['go']) != 0):
    pass

pll.set(float(50000000))

ref = test.read(test_regs['ref'])
c0 = test.read(test_regs['c0'])

print ref
print c0

c0_freq = c0*50000000.0/counter

print 'Ref freq:', ref*50000000.0/counter
print 'C0  freq:', c0_freq
if(abs(c0_freq - f_act) < 0.5): print 'PASS'
else: print 'FAIL', abs(c0_freq-f_act)