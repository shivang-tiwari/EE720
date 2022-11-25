import math
import random
import time
from sage.matrix.berlekamp_massey import berlekamp_massey


def generate_E(c,e,n,seq_len):
	sequence = [Mod(c,n)]
	for i in range(seq_len - 1):
		sequence.append(sequence[-1]^e);
	return sequence

def generate_D(m,c,n,seq_len):
	sequence = [Mod(m,n)]
	c = Mod(c,n)
	for i in range(seq_len - 1):
		sequence.append(c^sequence[-1]);
	return sequence

def local_inverse(F,poly):
	a = poly.list()
	m = len(a) - 1
	
	if m > len(F):
		return None
	
	x = F[m-1]
	if(a[0] == 0):
		return None
	for i in range(1,m):
		x += a[i] * F[i-1]
	return x

def get_bit_sequence(sequence,bit):
	res = []
	for x in sequence:
		b = 0
		
		if (int(x) & (1 << bit)) != 0:
			b = 1
		res.append(b)
	return res
	

def get_minimum_polynomial(sequence,bit_length):
	res = None
	for j in range(bit_length):
		bit_seq = []
		for i in range(len(sequence)):
			bit = 0
			if (int(sequence[i]) & (1 << j)):
				bit = 1
			bit_seq.append(Mod(bit, 2))
		min_poly = berlekamp_massey(bit_seq)
		if res == None:
			res = min_poly
		else:
			res = lcm(res,min_poly)
	return res



def run_encryption(p,q,e,sample_size = None):
	print("Starting simulation for (p,q,e) = ",[p,q,e])
	
	n = p * q
	l = 1 + math.floor(math.log(n,2))
	M = l * l
	if sample_size == None:
		sample_size = n - 2
	x_list = random.sample(range(0,n-1), sample_size)
	correct = 0
	total = 0
	last = 0
	start_time = time.time()
	for i in range(len(x_list)):
	
		cur = 100 * (float(i) / float(sample_size))
		if cur > float(last) + 10:
			last = cur
			print("Done ",round(cur),"%")
		
		x = x_list[i]
		x = Mod(x,n)
		c = x^e
		F = generate_E(c,e,n,2*M)
		fail = False
		poly = get_minimum_polynomial(F,l)
		ans = 0
		for bit in range(l):
			bit_sequence = get_bit_sequence(F,bit)
			inv = local_inverse(bit_sequence,poly)
			if inv == None:
				fail = True
				break
			if int(inv) == 1:
				ans += 1 << bit
		if fail:
			ans = 0
		ans = Mod(ans,n)
		if c == ans^e:
			correct += 1
		total += 1
	end_time = time.time()
	print("Simulation for (p,q,e) = ",[p,q,e]," is complete")
	print("Got ",correct,"/",total," correct")
	print("-----------------------------------------------")


def run_decryption(p,q,c,sample_size = None):
	
	print("Starting simulation for (p,q,c) = ",[p,q,c])
	
	n = p * q
	l = 1 + math.floor(math.log(n,2))
	M = l * l
	if sample_size == None:
		sample_size = n - 2
	x_list = random.sample(range(0,n-1), sample_size)
	correct = 0
	total = 0
	last = 0
	c = Mod(c,n)
	start_time = time.time()
	for i in range(len(x_list)):
	
		cur = 100 * (float(i) / float(sample_size))
		if cur > float(last) + 10:
			last = cur
			print("Done ",round(cur),"%")
		
		x = x_list[i]
		m = c^x
		F = generate_D(m,c,n,2*M)
		fail = False
		poly = get_minimum_polynomial(F,l)
		ans = 0
		for bit in range(l):
			bit_sequence = get_bit_sequence(F,bit)
			inv = local_inverse(bit_sequence,poly)
			if inv == None:
				fail = True
				break
			if int(inv) == 1:
				ans += 1 << bit
		if fail:
			ans = 0
		ans = Mod(ans,n)
		if m == c^ans:
			correct += 1
		total += 1
	end_time = time.time()
	print("Simulation for (p,q,c) = ",[p,q,c]," is complete")
	print("Got ",correct,"/",total," correct")
	print("-----------------------------------------------")


######################### Encryption ##########################################

# set of values for p,q,e

values = [
	[613,449,5,10000],
	[907, 503, 23,12000],
	[9421,10369,13,20000],
	[13171, 12421, 23,25000],
	[41737, 39769, 6,30000],
	[63409, 59011, 5,50000]
]

for i in range(len(values)):
	run_encryption(values[i][0],values[i][1],values[i][2],values[i][3])

######################### Decryption ##########################################

# set of values for p,q,c

values = [
	[601, 521, 3,10000],
	[569, 683, 3,10000],
	[2857,3739,7,12000],
	[15803,10369,13,20000],
	[33581,28961,3,30000],
	[63409,59011,5,50000],
]


for i in range(len(values)):
	run_decryption(values[i][0],values[i][1],values[i][2],values[i][3])

	
##############################################################################
