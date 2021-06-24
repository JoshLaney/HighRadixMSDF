import math
import module

class pll(module.module):

	regs = {
		'mode': 4*0x0,
		'status': 4*0x1,
		'start': 4*0x2,
		'n': 4*0x3,
		'm': 4*0x4,
		'c': 4*0x5,
		'phase': 4*0x6,
		'k': 4*0x7
	}

	def set(self, freq):
		f_best = 0
		f_in = 50000000
		f_target = freq
		for N in range(1, 11):
			for C in range(1, 512):
				N = float(N)
				C = float(C)
				M = math.floor(f_target*N*C/f_in)
				if M < 1 or M > 512:
					continue
				k = round(2**32*(f_target*N*C/f_in - M))
				# if k/(2.0**32) < 0.05:
				# 	M_h = M-1
				# 	k_h = 4080218931
				# 	M_l = M
				# 	k_l = 214748364
				# 	k_bound = True
				# elif k/(2.0**32) > 0.95:
				# 	M_h = M+1
				# 	k_h = 214748364
				# 	M_l = M
				# 	k_l = 4080218931
				# 	k_bound = True
				# else:
				# 	k_bound = False

				# if k_bound:
				# 	f_vco_l = f_in*(M_l + k_l/2.0**32)/N
				# 	if f_vco_l < 600000000 or f_vco_l > 1600000000:
				# 		f_vco_l = 0

				# 	f_vco_h = f_in*(M_h + k_h/2.0**32)/N
				# 	if f_vco_h < 600000000 or f_vco_h > 1600000000:
				# 		f_vco_h = 0

				# 	if f_vco_l == 0 and f_vco_h == 0:
				# 		continue

				# 	f_out_l = f_vco_l/(C)
				# 	f_out_h = f_vco_h/(C)
				# 	if abs(f_out_h - f_target) < abs(f_out_l - f_target):
				# 		M = M_h
				# 		k = k_h
				# 		f_out = f_out_h
				# 	else:
				# 		M = M_l
				# 		k = k_l
				# 		f_out = f_out_l

				# else:
				f_vco = f_in*(M + k/2**32)/N
				f_out = f_vco/(C)
				if f_vco < 600000000 or f_vco > 1600000000:
					continue
				if abs(f_out - f_target) < abs(f_best - f_target):
					n_count = int(N)
					c_count = int(C)
					m_count = int(M)
					k_count = int(k)
					f_best = f_out
		#print 'found values'
		print 'n', n_count
		print 'c', c_count
		print 'm', m_count
		print 'k', k_count

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
		#print 'writing k_reg'
		self.write(self.regs['k'], k_count)

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

		self.write(self.regs['c'], (0 << 18) + (division << 17) + (high_count << 8) + low_count)
		#print 'starting reconfig'
		self.write(self.regs['start'], 1)													# Start reconfiguration
		while self.read(self.regs['status']) != 0:											# Wait until done
			pass

		return f_best