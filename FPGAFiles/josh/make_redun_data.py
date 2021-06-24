import random

a_p_file = open('a_p_data.txt', 'w')
b_p_file = open('b_p_data.txt', 'w')
gold_p_file = open('c_p_data_GOLD.txt', 'w')

print('Filling a_p_data.txt with random ints')
print('Filling b_p_data.txt with random ints')
print('Storing a+b in c_p_data_GOLD.txt')

for i in range(0,2**11-1):
    #generate bits
    a = 0
    b = 0
    a_val = 0
    b_val = 0
    for j in range(0,15):
        a_dig = random.randint(-1,1)
        a_val += a_dig*(2**j)
        a |= (a_dig&3)<<(j*2)
        b_dig = random.randint(-1,1)
        b_val += b_dig*(2**j)
        b |= (b_dig&3)<<(j*2)
    c_val = a_val + b_val
    a_p_file.write('%d\n' %a)
    b_p_file.write('%d\n' %b)
    gold_p_file.write('%d\n' %c_val)

a_p_file.close()
b_p_file.close()
gold_p_file.close()


a_n_file = open('a_n_data.txt', 'w')
b_n_file = open('b_n_data.txt', 'w')
gold_n_file = open('c_n_data_GOLD.txt', 'w')

print('Filling a_n_data.txt with random ints')
print('Filling b_n_data.txt with random ints')
print('Storing a+b in c_n_data_GOLD.txt')

for i in range (0, 2**11-1):
    #generate bits
    a = 0
    b = 0
    a_val = 0
    b_val = 0
    for j in range(0,15):
        a_dig = random.randint(-1,1)
        a_val += a_dig*(2**j)
        a |= (a_dig&3)<<(j*2)
        b_dig = random.randint(-1,1)
        b_val += b_dig*(2**j)
        b |= (b_dig&3)<<(j*2)
    c_val = a_val + b_val
    a_n_file.write('%d\n' %a)
    b_n_file.write('%d\n' %b)
    gold_n_file.write('%d\n' %c_val)

a_n_file.close()
b_n_file.close()
gold_n_file.close()
