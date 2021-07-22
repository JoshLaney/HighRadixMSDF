import random
import sys
import math

WIDTH=int(sys.argv[1])
RADIX=2
A=RADIX-1
D=1
MASK=1
BITS=2*D*WIDTH+D
WORDS=max(int(math.ceil(math.log(BITS,2))),5)

a_p = 'mult/control_w%d/a_p_data.txt' % (WIDTH)
b_p = 'mult/control_w%d/b_p_data.txt' % (WIDTH)
gold_p = 'mult/control_w%d/c_p_data_GOLD.txt' % (WIDTH)
a_p_file = open(a_p, 'w')
b_p_file = open(b_p, 'w')
gold_p_file = open(gold_p, 'w')

#print('Filling a_p_data.txt with random ints')
#print('Filling b_p_data.txt with random ints')
#print('Storing a+b in c_p_data_GOLD.txt')

for i in range(0,2**(15-WORDS)-1):
    #generate bits
    a = 0
    b = 0
    a_val = random.randint(0,2**WIDTH-1)
    b_val = random.randint(0,2**WIDTH-1)
    c_val = a_val * b_val
    a_p_file.write('%d\n' %a_val)
    b_p_file.write('%d\n' %b_val)
    gold_p_file.write('%d\n' %c_val)

a_p_file.close()
b_p_file.close()
gold_p_file.close()

#print('Filling a_n_data.txt with random ints')
#print('Filling b_n_data.txt with random ints')
#print('Storing a+b in c_n_data_GOLD.txt')

a_n = 'mult/control_w%d/a_n_data.txt' % (WIDTH)
b_n = 'mult/control_w%d/b_n_data.txt' % (WIDTH)
gold_n = 'mult/control_w%d/c_n_data_GOLD.txt' % (WIDTH)
a_n_file = open(a_n, 'w')
b_n_file = open(b_n, 'w')
gold_n_file = open(gold_n, 'w')

for i in range(0,2**(15-WORDS)-1):
    #generate bits
    a = 0
    b = 0
    a_val = random.randint(0,2**WIDTH-1)
    b_val = random.randint(0,2**WIDTH-1)
    c_val = a_val * b_val
    a_n_file.write('%d\n' %a_val)
    b_n_file.write('%d\n' %b_val)
    gold_n_file.write('%d\n' %c_val)

a_n_file.close()
b_n_file.close()
gold_n_file.close()
