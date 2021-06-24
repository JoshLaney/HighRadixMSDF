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

f_try = float(sys.argv[1])
f_act_prev = 0
f_act = 0
try_again_count = 0
try_again_multipier = 0;
while 1:
    print 'trying', f_try
    f_act = pll.set(f_try)
    if(f_act_prev==f_act):
        f_try = f_try + 10**try_again_multipier
        try_again_count = try_again_count + 1
        if (try_again_count>=10):
            try_again_contt = 0
            try_again_multipier = try_again_multipier+1
        continue
    try_again_multipier = 0
    try_again_count = 0
    f_act_prev=f_act
    f_try=round(f_act)
    print 'actually trying', f_try
    #print "actual freq:", f_act
    while (test.read(test_regs['lock']) != 1):
        pass


    #print('Starting Test')
    test.write(test_regs['clear'], 1)
    test.write(test_regs['cnt'], int(counter))
    test.write(test_regs['go'], 1)
    while (test.read(test_regs['go']) != 0):
        pass

    pll.set(float(50000000))
    while (test.read(test_regs['lock']) != 1):
        pass
    ref = test.read(test_regs['ref'])
    c0 = test.read(test_regs['c0'])

    #print ref
    #print c0

    c0_freq = c0*50000000.0/counter

    #print 'Ref freq:', ref*50000000.0/counter
    #print 'C0  freq:', c0_freq
    if(abs(c0_freq - f_act) < 0.6): 
        #print 'PASS'
        f_try = f_try + 1
    else: 
        #print 'FAIL', abs(c0_freq-f_act)
        break
print 'failed at:', f_try
print 'C0  freq:', c0_freq