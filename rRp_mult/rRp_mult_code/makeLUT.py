#!/usr/bin/env python3
import math

RADIX=4
WIDTH=5
A=RADIX-1
D=math.floor(math.log(RADIX,2)+1)
MASK=int((2**D)-1)


print("task automatic estimate;")
print("    input [D*(WIDTH+6)-1: 0] v;")
print("    output [D-1:0] p;")
print("    output [D*(WIDTH+6)-1: 0] p_val;")
print("    begin")
print("        case (v[D*(WIDTH+6)-1 -: 5*D])")

fmt = "            {{0}}'b{{1:0{0}b}}: p = {{2}}'b{{3:0{1}b}};".format(int(WIDTH*D), int(D))
for a in range(0, (2 ** int(WIDTH*D))):
    val = 0
    for j in range(0,WIDTH):
        dig = (a&(MASK<<int(j*D)))>>int(j*D)
        if dig > A: dig = (-1<<int(D))|dig
        if (dig==-1*RADIX):
            val=dig
            break;
        val += dig*(RADIX**j)
    val = val + int((RADIX*RADIX)/2)
    if(dig==-1*RADIX): p = 'XX'
    elif(val>=(RADIX**3)): p = RADIX-1
    elif(val<=(-1*RADIX*RADIX*(RADIX-1))): p = -1*(RADIX-1)
    elif(val>=0): p = int(float(val)/(RADIX*RADIX))
    else: 
        p= int(float(val)/(RADIX*RADIX)) -1
    if(p=='XX'):
        case = fmt.format(int(WIDTH*D),a,int(D),0)[:-(int(D)+1)]
        for x in range(0,int(D)):
            case += 'X'
        case += ';'
        print(case)
    else:
        if(p<0):
            p = p & ~(-1<<int(D))
        print(fmt.format(int(WIDTH*D),a,int(D),p))


print("            default: ;")
print("         endcase")
print("         p_val[D*(WIDTH+6)-1 -: 2*D] = 128'b0;")
print("         p_val[D*(WIDTH+3) +: D] = (~p+1);")
print("         p_val[0 +: D*(WIDTH+3)] = 128'b0;")
print("    end")
print("endtask")
# print("endmodule")