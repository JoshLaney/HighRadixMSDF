#!/usr/bin/python

# PLL controller for Altera Cyclone V
# James Davis, 2016

import module
import math

class pll(module.module):

	regs = {
		'mode': 4*0x0,
		'status': 4*0x1,
		'start': 4*0x2,
		'n': 4*0x3,
		'm': 4*0x4,
		'c': 4*0x5,
		'phase': 4*0x6
	}

	f_vco = 160000000

	def set(self, freq):
		'Set clock output clk to closest possible frequency to freq (MHz). Returns the actual frequency set'
		self.write(self.regs['mode'], 1)													# Polling mode	
		#self.write(self.regs['m'], 0x2020)													# Set high_count(m) = low_count(m) = 32
		f_best = 0
		f_in = 50000000
		for N in range(1, 11):										# N, C, M in [1, 512]
			for C in range(1, 513):
				M = int(math.floor(freq*N*C/f_in))
				if M < 1 or M > 512:
					continue
				f_vco = (f_in*M)/N
				f_out = f_vco/(C)
				if f_vco < 600000000 or f_vco > 1600000000:				# f_vco in [600 M, 1600 M] per https://www.intel.com/content/www/us/en/programmable/documentation/mcn1422497163812.html
					continue
				if abs(f_out - freq) < abs(f_best - freq):
					n_count = N
					c_count = C
					m_count = M
					f_best = f_out
		self.f_vco = (m_count*f_in)/n_count
		print 'M :', m_count
		print 'N :', n_count
		print 'C2:', c_count

		bypass = 0
		if m_count == 1:
			bypass = 1
		if m_count % 2 == 0:																# Divide into high_count(c) and low_count(c). high_count = low_count => even division
			high_count = m_count/2
			low_count = m_count/2
			division = 0
		else:																				# high_count != low_count => high_count = low_count + 1, odd division
			high_count = m_count/2 + 1
			low_count = m_count/2
			division = 1
		self.write(self.regs['m'], (division << 17) + (bypass << 16) + (high_count << 8) + low_count)

		bypass = 0
		if n_count == 1:
			bypass = 1
		if n_count % 2 == 0:																# Divide into high_count(c) and low_count(c). high_count = low_count => even division
			high_count = n_count/2
			low_count = n_count/2
			division = 0
		else:																				# high_count != low_count => high_count = low_count + 1, odd division
			high_count = n_count/2 + 1
			low_count = n_count/2
			division = 1
		self.write(self.regs['n'], (division << 17) + (bypass << 16) + (high_count << 8) + low_count)

		if c_count % 2 == 0:																# Divide into high_count(c) and low_count(c). high_count = low_count => even division
			high_count = c_count/2
			low_count = c_count/2
			division = 0
		else:																				# high_count != low_count => high_count = low_count + 1, odd division
			high_count = c_count/2 + 1
			low_count = c_count/2
			division = 1
		#self.write(self.regs['c'], (0 << 18) + (0 << 17) + (c_count << 8) + c_count)
		#self.write(self.regs['c'], (1 << 18) + (0 << 17) + (c_count << 8) + c_count)
		#self.write(self.regs['c'], (2 << 18) + (division << 17) + (high_count << 8) + low_count)
		self.write(self.regs['c'], (0 << 18) + (division << 17) + (high_count << 8) + low_count)

		#self.write(self.regs['phase'], (1 << 21) + (0 << 16) + 16)

		# self.write(self.regs['phase'], (1 << 21) + (2 << 16) + 1)

		self.write(self.regs['start'], 1)													# Start reconfiguration
		while self.read(self.regs['status']) != 0:											# Wait until done
			pass

		# print 'M:', self.read(self.regs['m'])
		# print 'N:', self.read(self.regs['n'])
		# print 'c0:', self.read(4*10)
		# print 'c1:', self.read(4*11)
		# print 'c2:', self.read(4*12)

		return f_best

	def phase(self, freq):
		self.write(self.regs['mode'], 1)
		pshift = int((8*self.f_vco)/freq)
		print "f_vco:", self.f_vco
		print "pshift:", pshift
		self.write(self.regs['phase'], (1 << 21) + (1 << 16) + pshift)
		self.write(self.regs['start'], 1)													# Start reconfiguration
		while self.read(self.regs['status']) != 0:											# Wait until done
			pass
