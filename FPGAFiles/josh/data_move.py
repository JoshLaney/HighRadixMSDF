#!/usr/bin/env python

import os
import mmap
import struct
import lib.module as module
import lib.axi as axi

m_regs = {
    'data': 4*0,
    'address': 4*1,
    'we': 4*2,
    'id': 4*3,
}

axi = axi.axi(0xFF200000, 0x0040)
mem = module.module(axi, 0x0020)

bee = open("beemovie.txt", "r+b")
bee_map = mmap.mmap(bee.fileno(), os.stat('beemovie.txt').st_size, offset = 0)

if mem.read(m_regs['id'])!=0x87654321:
	print('cannot contact memory')
	exit()

print('writing first 4 words to memory')
mem.write(m_regs['address'], 0)
mem.write(m_regs['we'], 1)
print("we set to ", mem.read(m_regs['we']))
bee_map.seek(0)
print("writing to ",mem.read(m_regs['address']))
mem.write(m_regs['data'], struct.unpack('<L', bee_map.read(4))[0])
print("writing to ",mem.read(m_regs['address']))
bee_map.seek(4)
#mem.write(m_regs['address'], 1)
mem.write(m_regs['data'], struct.unpack('<L', bee_map.read(4))[0])
print("writing to ",mem.read(m_regs['address']))
bee_map.seek(8)
#mem.write(m_regs['address'], 2)
mem.write(m_regs['data'], struct.unpack('<L', bee_map.read(4))[0])
print("writing to ",mem.read(m_regs['address']))
bee_map.seek(12)
#mem.write(m_regs['address'], 3)
mem.write(m_regs['data'], struct.unpack('<L', bee_map.read(4))[0])
mem.write(m_regs['we'], 0)
print("we set to ", mem.read(m_regs['we']))

print('reading 4 words from memory:')
mem.write(m_regs['address'], 0)
#print("reading from ",mem.read(m_regs['address']))
print(mem.read(m_regs['data']))
#mem.write(m_regs['address'], 1)
#print("reading from ",mem.read(m_regs['address']))
print(mem.read(m_regs['data']))
#print("reading from ",mem.read(m_regs['address']))
#mem.write(m_regs['address'], 2)
print(mem.read(m_regs['data']))
#print("reading from ",mem.read(m_regs['address']))
#mem.write(m_regs['address'], 3)
print(mem.read(m_regs['data']))

print('expected output:')
bee_map.seek(0)
print('%s' %(struct.unpack('<L', bee_map.read(4))[0]))
bee_map.seek(4)
print(struct.unpack('<L', bee_map.read(4))[0])
bee_map.seek(8)
print(struct.unpack('<L', bee_map.read(4))[0])
bee_map.seek(12)
print(struct.unpack('<L', bee_map.read(4))[0])

bee_map.close()
bee.close()




