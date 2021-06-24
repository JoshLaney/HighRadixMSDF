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

n=0 #number of additions

print('Filling a_ram')
a_file = open('a_data.txt', 'r')
a_ram.write(ram_regs['addr'], 0)
a_ram.write(ram_regs['we'], 1)
for a_line in a_file:
    a_ram.write(ram_regs['data'], int(a_line.strip('\n')))
    n=n+1
a_ram.write(ram_regs['we'], 0)
a_file.close()
    
print('Filling b_ram')
b_file = open('b_data.txt', 'r')
b_ram.write(ram_regs['addr'], 0)
b_ram.write(ram_regs['we'], 1)
for b_line in b_file:
    b_ram.write(ram_regs['data'], int(b_line.strip('\n')))
b_ram.write(ram_regs['we'], 0)
b_file.close()

print('Starting Adder')
adder.write(add_regs['addr'], 0)
adder.write(add_regs['num'], n)
adder.write(add_regs['go'], 1)
while (adder.read(add_regs['go']) != 0):
    pass

print('Writing c_data.txt')
c_file = open('c_data.txt', 'w')
c_ram.write(ram_regs['addr'], 0)
for i in range(n):
    c_file.write('%d\n' %c_ram.read(ram_regs['data']))
c_file.close()
