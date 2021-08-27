#include<iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>

using namespace std;

#define TESTS 1
#define N 4
#define M 6
#define D (M-3)
#define R 4

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
		int x[N] = {-1, 2, 2, 3};
		int y[N] = {-3, -2, -3, -3};
		//int x[N];
		//int y[N];
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
			//x[k] = rand()/((RAND_MAX + 1u)/(R*2-1)) - (R-1);
			//x[k] = rand()/((RAND_MAX + 1u)/2);
			x_gold += ((long)x[k])*pow(R,k);

			//y[k] = rand()/((RAND_MAX + 1u)/(R*2-1)) - (R-1);
			//y[k] = rand()/((RAND_MAX + 1u)/2);
			y_gold += ((long)y[k])*pow(R,k);
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
			
			// myfile<<"	w      :";
			// print_vec(w, N+M, N+M-D);

			// myfile<<"	x+y    :";
			// print_vec(x_add_y, N+M,N+M-D);
			
			online_add(w, x_add_y, v, N+M, false);
			
			// myfile<<"	v      :";
			// print_vec(v, N+M, N+M-D);

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
			p_out += ((long)p_full[i])*pow(R,i);
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

// void partial_product(int a[],int b[], int c, int j){
// 	//myfile<<"		c:"<<c<<"\n";
// 	int val;
// 	//for(int i = N-1; i>=N-(j+3); i--){
// 	for(int i = N-(j+3); i<=N-1; i++){
// 		a[i]+=b[i]*c;;
// 		val = a[i];
// 		//myfile<<"		val:"<<val<<" a["<<i<<"]_old:"<<a[i];
// 		if(a[i]<=-1*R||a[i]>=R){
// 			a[i]-=(val/R)*R;
// 			a[i+1]+=val/R;
// 			//myfile<<" a["<<i<<"]_new:"<<a[i]<<" a["<<i+1<<"]:"<<a[i+1];
// 		}
// 		//myfile<<"\n";
// 	}
// }

void partial_product(int a[],int b[], int c, int j){
	int even[N+1];
	int odd[N+1];
	for(int i =0; i<N+1; i++){
		even[i]=0;
		odd[i]=0;
	}
	int pp_val, pp_ub, pp_lb;
	for(int i = N-(j+3); i<=N-1; i+=2){
		pp_val = b[i]*c;
		if(pp_val<=-1*R||pp_val>=R){
			pp_ub = pp_val/R;
			pp_lb = pp_val - (pp_val/R)*R;
		}
		else{
			pp_ub = 0;
			pp_lb = pp_val;
		}
		//myfile<<pp_val<<" "<<pp_ub<<" "<<pp_lb<<"\n";
		even[i] = pp_lb;
		even[i+1] = pp_ub;
	}

	for(int i = N-(j+3)+1; i<=N-1; i+=2){
		pp_val = b[i]*c;
		if(pp_val<=-1*R||pp_val>=R){
			pp_ub = pp_val/R;
			pp_lb = pp_val - (pp_val/R)*R;
		}
		else{
			pp_ub = 0;
			pp_lb = pp_val;
		}
		odd[i] = pp_lb;
		odd[i+1] = pp_ub;
	}
	//print_vec(even, N, N);
	//print_vec(odd, N, N);
	online_add(even, odd, a, N+1, true);
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
		val+=((long)a[i])*pow(R,i);
	}
	myfile<<"  "<<val;
	myfile<<"\n";
}

int sel_vec(int a[]){
	int val = 0;
	for(int i=0; i<M-1; i++){
		val += a[i]*pow(R,i);
	}
	val+=(R*R)/2;
	//myfile<<"		val:"<<val<<"\n";
	if(val>=R*R*R) return R-1;
	else if (val<=-1*R*R*(R-1)) return -1*R+1;
	else if(val>=0) return val/(R*R);
	else return val/(R*R)-1;
}

void online_add(int a[], int b[], int c[], int size, bool carry){
	// myfile<<"		a    :";
	// print_vec(a, N+M, N+M-D);
	// myfile<<"		b    :";
	// print_vec(b, N+M, N+M-D);
	if(R>2){
		int w_j1, w_j2, t_j1, s_j1, ab;
		w_j2 = 0;
		s_j1 = 0;
		for(int i = size+1; i>=0; i--){
			//myfile<<"		s_j1:"<<s_j1<<"\n";
			//myfile<<"		w_j2:"<<w_j2<<"\n";
			w_j1 = w_j2;
			
			if(carry && i==size) c[i] = s_j1;
			if(i<(size)){
				c[i] = s_j1;
			}
			if(i>=2){
				ab = a[i-2]+b[i-2];
				if(ab >= (R-1)){
					t_j1 = 1;
					w_j2 = ab -R;
				}
				else if (ab <= -(R-1)){
					t_j1 = -1;
					w_j2 = ab + R;
				}
				else {
					t_j1 = 0;
					w_j2 = ab;
				}
			}
			else{
				t_j1 = 0;
				w_j2 = 0;
			}
			s_j1 = t_j1 +w_j1;
		}
	}
	else{
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
}

void copy_and_shift_downN(int a[], int b[]){
	for(int i = 0; i<N+D; i++){
		a[i]=b[i+3];
	}
}