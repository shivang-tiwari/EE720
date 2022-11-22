// हर हर महादेव
#include <bits/stdc++.h>
using namespace std;

int64_t power(int64_t x, int64_t y,int64_t mod){
	int64_t res = 1;
	x = x % mod;
	if (x == 0) return 0;
	while (y > 0){
		if (y & 1)
			res = (res*x) % mod;
		y = y >> 1;
		x = (x*x) % mod;
	}
	return res;
}


vector<int64_t> generate_E(int x,int e,int seq_len,int n){ // Generates the sequence E, c = x^e
	vector<int64_t> sequence = {power(x,e,n)};
	
	for(int i = 0; i < seq_len - 1; i++){
		sequence.push_back(power(sequence.back(),e,n));
	}
	
	return sequence;
}


vector<int64_t> generate_F(int x,int c,int seq_len,int n){ // Generates the sequence F, m = c^x
	vector<int64_t> sequence = {power(c,x,n)};
	
	for(int i = 0; i < seq_len - 1; i++){
		sequence.push_back(power(c,sequence.back(),n));
	}
	
	return sequence;
}

int main(){
	
	return 0;
}
