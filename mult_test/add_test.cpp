#include<iostream>
#include <cstdlib>
#include <fstream>

using namespace std;

#define TESTS 1000000
#define N 8
#define M 5

//#define PRINT

ofstream myfile;

void print_vec(int a[], int size, int point);
void online_add(int a[], int b[], int c[], int size, bool carry);

int main(){
	
	myfile.open("output.txt");
	for(int test = 1; test<=TESTS; test++){
		int x[N];
		int y[N];
		int s[N+1];
		int x_gold, y_gold, s_gold;





		do{
		x_gold = 0;
		y_gold = 0;
		for(int k = 0; k<N; k++){
			x[k] = rand()/((RAND_MAX + 1u)/3) - 1;
			//x[k] = rand()/((RAND_MAX + 1u)/2);
			x_gold += x[k]<<k;

			y[k] = rand()/((RAND_MAX + 1u)/3) -1;
			//y[k] = rand()/((RAND_MAX + 1u)/2);
			y_gold += y[k]<<k;
		}
		s_gold = x_gold+y_gold;
		}while(s_gold>=1<<N||s_gold<=-1*(1<<N));

		#ifdef PRINT
		myfile<<"TEST: "<<test<<"\n";
		myfile<<"X: ";
		print_vec(x,N,N);
		myfile<<"Y: ";
		print_vec(y,N,N);
		#endif

		for(int i = 0; i<N+1; i++){
			s[i] = 0;
		}


		online_add(x,y,s, N, true);

		#ifdef PRINT
		myfile<<"S: ";
		print_vec(s,N+1,N);
		#endif

		int s_out = 0;
		for(int i = 0; i<N+1; i++){
			s_out += s[i]<<i;
		}


		#ifdef PRINT
		myfile<<"X="<<x_gold<<" Y="<<y_gold<<"\n";
		myfile<<"Calculated P="<<s_out<<"\n";
		myfile<<"Exptect P="<<s_gold<<"\n";
		#endif

		if(s_out!=s_gold){
			#ifdef PRINT
			myfile<<"MISMATCH!\n";
			#endif

			cout<<"MISMATCH!, test: "<<test<<"\n";
			goto mismatch;
		}

		#ifdef PRINT
		myfile<<"\n";
		#endif

	}

	cout<<"Successfully passed "<<TESTS<<" tests\n";

	mismatch:
	myfile.close();
}


void print_vec(int a[], int size, int point){
	for(int i = size-1; i>=0; i--){
		if(i==point-1)myfile<<".";
		myfile<<a[i]<<" ";
	}
	myfile<<"\n";
}

//if no overflow
void online_add(int a[], int b[], int c[], int size, bool carry){
	int w_j1, w_j2, h_j2, z_j2, z_j3, t_j1, s_j1, condense;
	w_j2 = 0;
	z_j3 = 0;
	s_j1 = 0;
	for(int i = size+2; i>=0; i--){
		w_j1 = w_j2;
		z_j2 = z_j3;
		//myfile<<"		s_j1:"<<s_j1<<"\n";
		if(carry && i==size) condense=s_j1;
		if(i<(size)){
			c[i] = (s_j1!=0)? ((condense!=0)? condense : s_j1) : condense;
			condense = (s_j1!=0)? 0 : condense;
		}
		if(i>=3){
			h_j2 = ((a[i-3]+b[i-3])>0)? 1 : 0;
			//myfile<<"		h_j2:"<<h_j2<<"\n";
			z_j3 = ((a[i-3]+b[i-3])>0)? (a[i-3]+b[i-3]-2) : (a[i-3] + b[i-3]);
		}
		else{
			h_j2 = 0;
			z_j3 = 0;
		}

		t_j1 = ((z_j2+h_j2)<0)? -1: 0;
		w_j2 = ((z_j2+h_j2)<0)? (z_j2+h_j2+2): (z_j2+h_j2);

		s_j1 = t_j1 +w_j1;
	}
}
