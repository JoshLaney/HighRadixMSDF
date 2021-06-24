import random

a_p_file = open('a_p_data.txt', 'w')
b_p_file = open('b_p_data.txt', 'w')
gold_p_file = open('c_p_data_GOLD.txt', 'w')

print('Filling a_p_data.txt with random ints')
print('Filling b_p_data.txt with random ints')
print('Storing a+b in c_p_data_GOLD.txt')

for i in range(0,2**11-1):
    a = random.randint(0, 2**30 -1)
    b = random.randint(0, 2**30 -1)
    c = a + b
    a_p_file.write('%d\n' %a)
    b_p_file.write('%d\n' %b)
    gold_p_file.write('%d\n' %c)

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
    a = random.randint(0, 2**30 -1)
    b = random.randint(0, 2**30 -1)
    c = a + b
    a_n_file.write('%d\n' %a)
    b_n_file.write('%d\n' %b)
    gold_n_file.write('%d\n' %c)

a_n_file.close()
b_n_file.close()
gold_n_file.close()
