#include<iostream>
#include <cstdlib>
#include <fstream>

using namespace std;

#define TESTS 100000
#define N 8
#define M 2

#define PRINT 1;

int sel(int* w);
void w_copy(int a[],int b[], int type);
void w_add(int a[], int b[]);
void print_vec(int a[], int size);
void condence(int a[], int size, int fbits);
void shift_p(int a[]);

ofstream myfile;

int main(int argc, char *argv[]){ 
	int x[N];
	int y[N];
	int w[N+M];
	int p[N+M];
	int sel_val[N+M];
	int z[2*N];

	myfile.open("output.txt");

	int w_val, p_val, z_j, x_gold, y_gold, z_gold, z_out;
	for(int i = 0; i<TESTS; i++){
		
		x_gold = 0;
		y_gold = 0;
		for(int k = 0; k<(N); k++){
			x[k] = rand()/((RAND_MAX + 1u)/3) - 1;
			//x[k] = rand()/((RAND_MAX + 1u)/2);
			x_gold += x[k]<<k;

			y[k] = rand()/((RAND_MAX + 1u)/3) -1;
			//y[k] = rand()/((RAND_MAX + 1u)/2);
			y_gold += y[k]<<k;
		}

		#ifdef PRINT
		myfile<<"X: ";
		print_vec(x,N);
		myfile<<"Y: ";
		print_vec(y,N);
		#endif

		z_gold = x_gold*y_gold;

		for(int k = 0; k<(N+M); k++){
			p[k] = 0;
		}

		for(int k = 0; k<(2*N); k++){
			z[k] = 0;
		}

		for(int j = 1; j<=N; j++){
			#ifdef PRINT
			myfile<<"j="<<j<<"\n";
			#endif
			
			if(y[N-j]==1) w_copy(w,x,1);
			else if (y[N-j]==-1) w_copy(w,x,2);
			else w_copy(w,x,0);

			#ifdef PRINT
			myfile<<"     Xy: ";
			print_vec(w,(N+M+1));
			#endif

			// shift_p(p);
			// online_add(w,p);
			// condence(w, N+M+1, N);
			w_add(w,p);

			#ifdef PRINT
			myfile<<"     w+p: ";
			print_vec(w,(N+M));
			#endif
			
			w_val = 0;
			for(int k = 0; k<(N+M); k++){
				w_val += w[k]<<k;
			}
			z_j = sel(&w_val);

			for(int k = 0; k<N+M; k++){
				sel_val[k]=0;
			}
			sel_val[N]=-1*z_j;
			
			#ifdef PRINT
			myfile<<"     (w_val="<<w_val<<", z_j="<<z_j<<")\n";
			#endif

			z[(2*N)-j] = z_j;
			
			#ifdef PRINT
			myfile<<"     Z: ";
			print_vec(z, (2*N));
			#endif
			
			for(int k = 0; k<(N+M); k++){
				p[k]=w[k];
			}

			//online_add(p, sel_val);

			p[N]-=z_j;
			int c = 0;
			for(int k = N; k<(N+M); k++){
				p[k] = p[k] + c;
				if(p[k]>=2){
					p[k] -= 2;
					c = 1;
				}
				else if(p[k]<=-2){
					p[k] += 2;
					c = -1;
				}
				else c = 0;
			}

			condence(p, N+M, N);
			
			#ifdef PRINT
			myfile<<"     P: ";
			print_vec(p, (N+M));
			#endif

			p_val = 0;
			for(int k = 0; k<(N+M); k++){
				p_val += p[k]<<k;
			}
			
			#ifdef PRINT
			myfile<<"     (p_val="<<p_val<<")\n";
			#endif

		}

		#ifdef PRINT
		z_out = 0;
		for(int k = 0; k<(2*N); k++){
			z_out += z[k]<<k;
		}
		myfile<<"Unappended Z="<<z_out<<"\n";
		#endif

		//condence p
		condence(p, N+M, N);

		#ifdef PRINT
		myfile<<"P: ";
		print_vec(p, (N+M));
		#endif

		for(int k = 0; k<N; k++){
			z[k] = p[k];
		}

		#ifdef PRINT
		myfile<<"Z: ";
		print_vec(z, (2*N));
		#endif

		z_out = 0;
		for(int k = 0; k<(2*N); k++){
			z_out += z[k]<<k;
		}

		if(z_out!=z_gold){
			myfile<<"MISMATCH!, i="<<i<<"\n";
			myfile<<"X="<<x_gold<<" Y="<<y_gold<<"\n";
			myfile<<"Exptect Z="<<z_gold<<"\n";
			myfile<<"Calculated Z="<<z_out<<"\n";

			cout<<"MISMATCH!, i="<<i<<"\n";

			goto mismatch;
		}

	}

	cout<<"Successfully passed "<<TESTS<<" tests\n";

	mismatch:

	myfile.close();

	return 0;
}

int sel(int* w){
	if(*w>=(1<<(N-1))) return 1;
	else if (*w<-1*(1<<(N-1))) return -1;
	else return 0;
}

void w_copy(int a[],int b[], int type){
	for(int i = 0; i<N; i++){
		if(type==2) a[i] = -1*b[i];
		else if(type==1) a[i] = b[i];
		else a[i]=0;
	}
	for(int i = N; i<(N+M); i++){
		a[i]=0;
	}
}

void w_add(int a[], int b[]){
	int c = 0;
	for(int i = 1; i<(N+M); i++){
		//myfile<<"          w="<<a[i]<<"+ "<<b[i-1]<<" + "<<c<<"\n";
		a[i] = a[i] + b[i-1] + c;
		if(a[i]>=2){
			a[i] -= 2;
			c = 1;
		}
		else if(a[i]<=-2){
			a[i] += 2;
			c = -1;
		}
		else c = 0;
	}
}

void print_vec(int a[], int size){
	for(int i = size-1; i>=0; i--){
		myfile<<a[i]<<" ";
	}
	myfile<<"\n";
}

void condence(int a[], int size, int fbits){
		for(int k = ((size)-1); k>=fbits; k--){

			if(a[k]!=0){
				if(a[k]==-1*a[k-1]){
					//myfile<<"		a[k]==-1*a[k-1], k="<<k<<"\n";
					a[k-1]=a[k];
					a[k] = 0;
					//print_vec(a, size);
				}
				else if (a[k-1]==0 && a[k]==-1*a[k-2]){
					//myfile<<"		a[k]==-1*a[k-2], k="<<k<<"\n";
					a[k-2]=a[k];
					a[k-1]=a[k];
					a[k]=0;
				}
				else{
					//myfile<<"I WASNT EXPECTING TO GET HERE\n";
				}
			}
	}
}

void shift_p(int a[]){
	for(int i = N+M-1; i>=1; i--){
		a[i]=a[i-1];
	}
	a[0] = 0;
}