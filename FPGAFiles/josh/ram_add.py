#!/usr/bin/env python

import lib.module as module
import lib.axi as axi

add_regs = {
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
adder = module.module(axi, 0x0080)
a_ram = module.module(axi, 0x0020)
b_ram = module.module(axi, 0x0040)
c_ram = module.module(axi, 0x0060)

working = adder.read(add_regs['id'])
if working != 0x12345678:
    print('fail: wrong adder id')
    exit()
working = a_ram.read(ram_regs['id'])
if working != 0x87654321:
    print('fail: wrong a_ram id')
    exit()
working = b_ram.read(ram_regs['id'])
if working != 0x87654321:
    print('fail: wrong b_ram id')
    exit()
working = c_ram.read(ram_regs['id'])
if working != 0x87654321:
    print('fail: wrong c_ram id')
    exit()
print('IP contacted successfully')

print('Setting a_ram[0] to 5')
a_ram.write(ram_regs['addr'], 0)
a_ram.write(ram_regs['we'], 1)
a_ram.write(ram_regs['data'], 5)

print('Setting b_ram[0] to 6')
b_ram.write(ram_regs['addr'], 0)
b_ram.write(ram_regs['we'], 1)
b_ram.write(ram_regs['data'], 6)

print('Setting a_ram[1] to 289')
a_ram.write(ram_regs['data'], 289)
a_ram.write(ram_regs['we'], 0)

print('Setting b_ram[1] to 157')
b_ram.write(ram_regs['data'], 157)
b_ram.write(ram_regs['we'], 0)

print('Starting Adder')
adder.write(add_regs['addr'], 0)
adder.write(add_regs['num'], 2)
adder.write(add_regs['go'], 1)
while (adder.read(add_regs['go']) != 0):
    pass

print('Reading from c_ram[0] (expecting 11)')
c_ram.write(ram_regs['addr'], 0)
print(c_ram.read(ram_regs['data']))

print('Reading from c_ram[1] (expecting 446)')
print(c_ram.read(ram_regs['data']))
