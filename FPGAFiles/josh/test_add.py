#!/usr/bin/env python

import lib.module as module
import lib.axi as axi

regs = {
    'a': 4*0,
    'b': 4*1,
    'c': 4*2,
    'id': 4*3
}

address = 0x0000
axi = axi.axi(0xFF200000, 0x0020)
adder = module.module(axi, address)

working = adder.read(regs['id'])
if working != 0x12345678:
    print('fail')
    exit()
print('IP contacted successfully')
print('Atempting 5+6....')
adder.write(regs['a'],5)
adder.write(regs['b'],6)
c=adder.read(regs['c'])
print(c)
