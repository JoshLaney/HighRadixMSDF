import random
import sys
import math

RADIX=int(sys.argv[1])
WIDTH=int(sys.argv[2])
A=RADIX-1
D=int(math.log(RADIX,2)+1)
MASK=(2**D)-1
BITS=D*WIDTH+D
WORDS=max(int(math.ceil(math.log(BITS,2))),5)

a_p = 'add/r%d_w%d/a_p_data.txt' % (RADIX,WIDTH)
b_p = 'add/r%d_w%d/b_p_data.txt' % (RADIX,WIDTH)
gold_p = 'add/r%d_w%d/c_p_data_GOLD.txt' % (RADIX,WIDTH)
a_p_file = open(a_p, 'w')
b_p_file = open(b_p, 'w')
gold_p_file = open(gold_p, 'w')

print('Filling a_p_data.txt with random ints')
print('Filling b_p_data.txt with random ints')
print('Storing a+b in c_p_data_GOLD.txt')

for i in range(0,2**(18-WORDS)-1):
    #generate bits
    a = 0
    b = 0
    a_val = 0
    b_val = 0
    for j in range(0,WIDTH):
        a_dig = random.randint(-1*A,A)
        a_val += a_dig*(RADIX**j)
        a |= (a_dig&MASK)<<(j*D)
        b_dig = random.randint(-1*A,A)
        b_val += b_dig*(RADIX**j)
        b |= (b_dig&MASK)<<(j*D)
    c_val = a_val + b_val
    a_p_file.write('%d\n' %a)
    b_p_file.write('%d\n' %b)
    gold_p_file.write('%d\n' %c_val)

a_p_file.close()
b_p_file.close()
gold_p_file.close()

print('Filling a_n_data.txt with random ints')
print('Filling b_n_data.txt with random ints')
print('Storing a+b in c_n_data_GOLD.txt')

a_n = 'add/r%d_w%d/a_n_data.txt' % (RADIX,WIDTH)
b_n = 'add/r%d_w%d/b_n_data.txt' % (RADIX,WIDTH)
gold_n = 'add/r%d_w%d/c_n_data_GOLD.txt' % (RADIX,WIDTH)
a_n_file = open(a_n, 'w')
b_n_file = open(b_n, 'w')
gold_n_file = open(gold_n, 'w')

for i in range(0,2**(18-WORDS)-1):
    #generate bits
    a = 0
    b = 0
    a_val = 0
    b_val = 0
    for j in range(0,WIDTH):
        a_dig = random.randint(-1*A,A)
        a_val += a_dig*(RADIX**j)
        a |= (a_dig&MASK)<<(j*D)
        b_dig = random.randint(-1*A,A)
        b_val += b_dig*(RADIX**j)
        b |= (b_dig&MASK)<<(j*D)
    c_val = a_val + b_val
    a_n_file.write('%d\n' %a)
    b_n_file.write('%d\n' %b)
    gold_n_file.write('%d\n' %c_val)

a_n_file.close()
b_n_file.close()
gold_n_file.close()
