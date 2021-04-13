#include<iostream>
#include <cstdlib>
#include <fstream>

using namespace std;

#define TESTS 100000
#define N 8
#define M 2

#define PRINT 1;

int sel(int* w);
int sel_vec(int a[]);
void Xy_copy(int a[],int b[], int type);
void print_vec(int a[], int size);
void condence(int a[], int size, int fbits);
void online_add(int a[], int b[], int c[], int size);
void shift_p(int a[]);

ofstream myfile;

int main(int argc, char *argv[]){ 
	int x[N];
	int y[N];
	int Xy[N+M];
	int w[N+M+1];
	int p[N+M+1];
	int p_z[2*N];
	int sel_val[N+M];
	int z[2*N];
	int z_p[2*N+1];
	int w_sel[M+1];

	myfile.open("output.txt");

	int w_val, p_val, z_j, x_gold, y_gold, z_gold, z_out;
	for(int i = 0; i<TESTS; i++){
		
		x_gold = 0;
		y_gold = 0;
		for(int k = 0; k<(N); k++){
			//x[k] = rand()/((RAND_MAX + 1u)/3) - 1;
			x[k] = rand()/((RAND_MAX + 1u)/2);
			x_gold += x[k]<<k;

			//y[k] = rand()/((RAND_MAX + 1u)/3) -1;
			y[k] = rand()/((RAND_MAX + 1u)/2);
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

		#ifdef PRINT
		myfile<<"X: ";
		print_vec(x,N);
		myfile<<"Y: ";
		print_vec(y,N);
		#endif
			
			if(y[N-j]==1) Xy_copy(Xy,x,1);
			else if (y[N-j]==-1) Xy_copy(Xy,x,2);
			else Xy_copy(Xy,x,0);

			#ifdef PRINT
			myfile<<"     Xy: ";
			print_vec(Xy,(N+M));
			#endif

			shift_p(p);
			online_add(Xy,p, w, N+M);
			condence(w, N+M+1, N);

			#ifdef PRINT
			myfile<<"     w+p: ";
			print_vec(w,(N+M+1));
			#endif
			
			w_val = 0;
			for(int k = 0; k<(N+M); k++){
				w_val += w[k]<<k;
			}
			for(int k = 0; k<M+1; k++){
				w_sel[k]=w[k+N-1];
			}
			z_j = sel_vec(w_sel);

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

			online_add(p, sel_val, p, N+M);
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

		for(int k = 0; k<2*N; k++){
			if(k<N+M){
				p_z[k]=p[k];
			}
			else p_z[k] = 0;
		}

		#ifdef PRINT
		myfile<<"P_z:   ";
		print_vec(p_z, (2*N));
		#endif

		#ifdef PRINT
		myfile<<"Z:     ";
		print_vec(z, (2*N));
		#endif

		online_add(z,p_z,z_p,2*N);
		// for(int k = 0; k<N; k++){
		// 	z[k] = p[k];
		// }

		#ifdef PRINT
		myfile<<"New Z: ";
		print_vec(z_p, (2*N+1));
		#endif

		z_out = 0;
		for(int k = 0; k<(2*N+1); k++){
			z_out += z_p[k]<<k;
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

int sel_vec(int a[]){
	int val = 0;
	for(int i=0; i<M+1; i++){
		val += a[i]<<i;
	}
	if(val>=1) return 1;
	else if (val<-1) return -1;
	else return 0;
}

void Xy_copy(int a[],int b[], int type){
	for(int i = 0; i<N; i++){
		if(type==2) a[i] = -1*b[i];
		else if(type==1) a[i] = b[i];
		else a[i]=0;
	}
	for(int i = N; i<(N+M)+1; i++){
		a[i]=0;
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

void online_add(int a[], int b[], int c[], int size){
	int w_j1, w_j2, h_j2, z_j2, z_j3, t_j1, s_j1;
	w_j2 = 0;
	z_j3 = 0;
	s_j1 = 0;
	for(int i = size+2; i>=0; i--){
		w_j1 = w_j2;
		z_j2 = z_j3;
		//myfile<<"		s_j1:"<<s_j1<<"\n";
		if(i<(size+1)){
			c[i] = s_j1;
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

void shift_p(int a[]){
	for(int i = N+M-1; i>=1; i--){
		a[i]=a[i-1];
	}
	a[0] = 0;
}