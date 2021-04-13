#include<iostream>
#include <cstdlib>
#include <fstream>

using namespace std;

#define TESTS 168
#define N 8
#define M 5
#define D (M-3)

#define PRINT

ofstream myfile;

void print_vec(int a[], int size, int point);
void partial_product(int a[],int b[], int c, int j);
void shift_up2(int a[], int size);
void online_add(int a[], int b[], int c[], int size, bool carry);
int sel_vec(int a[]);
void copy_and_shift_downN(int a[], int b[]);

int main(){
	
	myfile.open("output.txt");
	for(int test = 1; test<=TESTS; test++){
		int x[N];
		int y[N];
		int p[2*N];
		int p_frac[2*N];
		int p_full[2*N+1];

		int x_j[N+4][N+M+1];
		int y_j[N+4][N+M+1];
		int w[N+M];
		int v[N+M];
		int v_est[M-1];
		int p_j[N+M];
		int x_add_y[N+M];

		long x_gold, y_gold, p_gold;



		x_gold = 0;
		y_gold = 0;
		for(int k = 0; k<N; k++){
			x[k] = rand()/((RAND_MAX + 1u)/3) - 1;
			//x[k] = rand()/((RAND_MAX + 1u)/2);
			x_gold += ((long)x[k])<<k;

			y[k] = rand()/((RAND_MAX + 1u)/3) -1;
			//y[k] = rand()/((RAND_MAX + 1u)/2);
			y_gold += ((long)y[k])<<k;
		}
		p_gold = x_gold*y_gold;

		#ifdef PRINT
		myfile<<"TEST: "<<test<<"\n";
		myfile<<"X: ";
		print_vec(x,N,N);
		myfile<<"Y: ";
		print_vec(y,N,N);
		#endif

		for(int i = 0; i<N+4; i++){
			for(int j = 0; j<N+M+1; j++){
				x_j[i][j]=0;
				y_j[i][j]=0;
			}
		}
		for(int i = 0; i<N+M; i++){
			w[i]=0;
			p_j[i]=0;
		}

		for(int i = 0; i<2*N; i++){
			p[i]=0;
			p_frac[i]=0;
		}
		

		//initialize
		for(int j = -3; j<N; j++){
			int sel = 0;
			if(j<N-3){
				partial_product(x_j[j+3],x,y[N-j-4],j);
				partial_product(y_j[(j+1)+3],y,x[N-j-4],j+1);
			}
			online_add(x_j[j+3],y_j[(j+1)+3],x_add_y, N+M+1, false);
			shift_up2(w, N+M);
			online_add(w, x_add_y, v, N+M, false);

			for(int k = 0; k<M-1; k++){
				v_est[k]=v[(N+1)+k];
			}

			if(j>=0){
				sel = sel_vec(v_est);
				p[2*N-1-j]= sel;
				p_j[N+3]=-1*sel;
			}
			online_add(v, p_j, w, N+M, false);

			#ifdef PRINT
			myfile<<"	j="<<j<<"\n";
			myfile<<"	x[j]y  :";
			print_vec(x_j[j+3], N+M,N+M-D);
			myfile<<"	y[j+1]x:";
			print_vec(y_j[(j+1)+3], N+M,N+M-D);
			myfile<<"	x+y    :";
			print_vec(x_add_y, N+M,N+M-D);
			myfile<<"	v      :";
			print_vec(v, N+M, N+M-D);
			if(j>=0){
				myfile<<"	v_est  :";
				print_vec(v_est, M-1, M-1-D);
				myfile<<"	(p_j ="<<sel<<")\n";
			}
			myfile<<"	w      :";
			print_vec(w, N+M, N+M-D);
			#endif
		}

		copy_and_shift_downN(p_frac, w);
		#ifdef PRINT
		myfile<<"	p_rough:";
		print_vec(p, 2*N, 2*N);
		myfile<<"	p_frac :";
		print_vec(p_frac, 2*N, 2*N);
		#endif
		online_add(p, p_frac, p_full, 2*N, true);

		#ifdef PRINT
		myfile<<"	p      :";
		print_vec(p_full, 2*N+1, 2*N);
		#endif

		long p_out = 0;
		for(int i = 0; i<2*N+1; i++){
			p_out += ((long)p_full[i])<<i;
			//myfile<<"		p_out:"<<p_out<<"\n";
		}

		#ifdef PRINT
		myfile<<"X="<<x_gold<<" Y="<<y_gold<<"\n";
		myfile<<"Calculated P="<<p_out<<"\n";
		myfile<<"Exptect P="<<p_gold<<"\n";
		#endif

		if(p_out!=p_gold){
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

void partial_product(int a[],int b[], int c, int j){
	//myfile<<"		c:"<<c<<"\n";
	for(int i = N-1; i>=N-(j+3); i--){
		a[i]=b[i]*c;
	}
}

void shift_up2(int a[], int size){
	for(int i = size-1; i>=1; i--){
		a[i]=a[i-1];
	}
	a[0]=0;
}

void print_vec(int a[], int size, int point){
	long val = 0;
	for(int i = size-1; i>=0; i--){
		if(i==point-1)myfile<<".";
		myfile<<a[i]<<" ";
		val+=((long)a[i])<<i;
	}
	myfile<<"  "<<val;
	myfile<<"\n";
}

int sel_vec(int a[]){
	int val = 0;
	for(int i=0; i<M-1; i++){
		val += a[i]<<i;
	}
	//myfile<<"		val:"<<val<<"\n";
	if(val>=2) return 1;
	else if (val<-2) return -1;
	else return 0;
}

void online_add(int a[], int b[], int c[], int size, bool carry){
	int w_j1, w_j2, h_j2, z_j2, z_j3, t_j1, s_j1;
	w_j2 = 0;
	z_j3 = 0;
	s_j1 = 0;
	for(int i = size+2; i>=0; i--){
		w_j1 = w_j2;
		z_j2 = z_j3;
		//myfile<<"		s_j1:"<<s_j1<<"\n";
		if(carry && i==size) c[i] = s_j1;
		if(i<(size)){
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

void copy_and_shift_downN(int a[], int b[]){
	for(int i = 0; i<N+2; i++){
		a[i]=b[i+3];
	}
}