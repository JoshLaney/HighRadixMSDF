#!/usr/bin/python

# AXI interface class
# James Davis, 2016

import mmap
import struct

class axi:
	
	def __init__(self, addr = 0xFF200000, size = 0x40000):
		self.mem = open('/dev/mem', 'r+b')
		self.map = mmap.mmap(self.mem.fileno(), size, offset = addr)
		
	def __del__(self):
		self.map.close()
		self.mem.close()
		
	def read(self, addr):
		'Read 4 bytes from addr'
		self.map.seek(addr)
		return struct.unpack('<L', self.map.read(4))[0]
		
	def write(self, addr, data):
		'Write data as 4 bytes from addr'
		self.map.seek(addr)
		self.map.write(struct.pack('<L', data))
		
