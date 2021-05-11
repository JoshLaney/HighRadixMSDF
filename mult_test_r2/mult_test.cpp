#include<iostream>
#include <cstdlib>

using namespace std;

#define N 100000

int sel(int* w);

int main(){ 
	int x[8];
	int y[8];
	//signed char z[16];

	int w,p, z_j, x_gold, y_gold, z_gold, z, z_un,p_frac;
	for(int i = 0; i<N; i++){
		
		x_gold = 0;
		y_gold = 0;
		for(int k = 0; k<8; k++){
			x[k] = rand()/((RAND_MAX + 1u)/3) - 1;
			x_gold += x[k]<<k;

			y[k] = rand()/((RAND_MAX + 1u)/3) -1;
			y_gold += y[k]<<k;
		}
		z_gold = x_gold*y_gold;

		p=0;
		z=0;
		for(int j = 1; j<=8; j++){
			if(y[8-j]==1) w=x_gold;
			else if (y[8-j]==-1) w=-1*x_gold;
			else w = 0;
			//cout<<"Xy="<<w;
			w += p<<1;
			z_j = sel(&w);
			z += z_j<<(16-j);
			p = w - (z_j<<8);
			//cout<<", w="<<w<<", p="<<p<<", z_j="<<z_j<<", z="<<z<<"\n";
		}
		z_un = z;
		p_frac = p;
		if(p_frac<0) p_frac*= -1;
		p_frac = 0xFF&p_frac;
		if(p<0) p_frac*= -1;
		z+=p_frac
		z+= p;

		if(z!=z_gold){
			cout<<"MISMATCH!, i="<<i<<"\n";
			cout<<"X="<<x_gold<<" Y="<<y_gold<<"\n";
			cout<<"Exptect Z="<<z_gold<<"\n";
			cout<<"Unappended Z="<<z_un<<"\n";
			cout<<"P="<<p<<"\n";
			cout<<"Calculated Z="<<z<<"\n";

			goto mismatch;
		}

	//cout<<z<<"\n";

	}

	cout<<"Successfully passed "<<N<<" tests\n";

	mismatch:

	return 0;
}

int sel(int* w){
	if(*w>=128) return 1;
	else if (*w<-128) return -1;
	else return 0;
}