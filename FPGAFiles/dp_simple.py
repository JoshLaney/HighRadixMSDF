#!/usr/bin/env python

import lib.module as module
import lib.axi as axi
import os

tcu_regs= {
    'go': 4*0,
    'addr': 4*1,
    'num': 4*2,
    'id': 4*3
}

ram_regs = {
    'data': 4*0,
    'addr': 4*1,
    'we': 4*2,
    'id': 4*3,
}

axi = axi.axi(0xFF200000, 0x0100)
tcu = module.module(axi, 0x00c0)
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
a_p_ram.write(ram_regs['addr'], 0)
a_p_ram.write(ram_regs['we'], 1)
a_p_ram.write(ram_regs['data'], 12)
a_p_ram.write(ram_regs['data'], 2)
a_p_ram.write(ram_regs['data'], 37)
a_p_ram.write(ram_regs['we'], 0)
a_p_ram.write(ram_regs['addr'], 0)
print(a_p_ram.read(ram_regs['data']))
print(a_p_ram.read(ram_regs['data']))
print(a_p_ram.read(ram_regs['data']))

print('Filling a_n_ram')
a_n_ram.write(ram_regs['addr'], 0)
a_n_ram.write(ram_regs['we'], 1)
a_n_ram.write(ram_regs['data'], 66)
a_n_ram.write(ram_regs['data'], 13)
a_n_ram.write(ram_regs['data'], 89)
a_n_ram.write(ram_regs['we'], 0)
a_n_ram.write(ram_regs['addr'], 0)
print(a_n_ram.read(ram_regs['data']))
print(a_n_ram.read(ram_regs['data']))
print(a_n_ram.read(ram_regs['data']))
    
print('Filling b_p_ram')
b_p_ram.write(ram_regs['addr'], 0)
b_p_ram.write(ram_regs['we'], 1)
b_p_ram.write(ram_regs['data'], 8)
b_p_ram.write(ram_regs['data'], 92)
b_p_ram.write(ram_regs['data'], 52)
b_p_ram.write(ram_regs['we'], 0)
b_p_ram.write(ram_regs['addr'], 0)
print(b_p_ram.read(ram_regs['data']))
print(b_p_ram.read(ram_regs['data']))
print(b_p_ram.read(ram_regs['data']))

print('Filling b_n_ram')
b_n_ram.write(ram_regs['addr'], 0)
b_n_ram.write(ram_regs['we'], 1)
b_n_ram.write(ram_regs['data'], 74)
b_n_ram.write(ram_regs['data'], 1)
b_n_ram.write(ram_regs['data'], 18)
b_n_ram.write(ram_regs['we'], 0)
b_n_ram.write(ram_regs['addr'], 0)
print(b_n_ram.read(ram_regs['data']))
print(b_n_ram.read(ram_regs['data']))
print(b_n_ram.read(ram_regs['data']))

print('Starting Adder')
tcu.write(tcu_regs['addr'], 0)
tcu.write(tcu_regs['num'], 3)
print(tcu.read(tcu_regs['num']))
tcu.write(tcu_regs['go'], 1)
while (tcu.read(tcu_regs['go']) != 0):
    pass


print('Reading c_p_ram')
c_p_ram.write(ram_regs['addr'], 0)
print(c_p_ram.read(ram_regs['data']))
print(c_p_ram.read(ram_regs['data']))
print(c_p_ram.read(ram_regs['data']))

print('Reading c_n_ram')
c_n_ram.write(ram_regs['addr'], 0)
print(c_n_ram.read(ram_regs['data']))
print(c_n_ram.read(ram_regs['data']))
print(c_n_ram.read(ram_regs['data']))
