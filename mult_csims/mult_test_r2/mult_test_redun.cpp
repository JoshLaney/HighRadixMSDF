#include<iostream>
#include <cstdlib>
#include <fstream>

using namespace std;

#define N 100

#define PRINT 1;

int sel(int* w);
void w_copy(int a[],int b[], int type);
void w_add(int a[], int b[]);
void print_vec(int a[], int size);
void condence(int a[]);

ofstream myfile;

int main(){ 
	int x[8];
	int y[8];
	int w[11];
	int p[11];
	int z[16];

	myfile.open("output.txt");

	int w_val, p_val, z_j, x_gold, y_gold, z_gold, z_out;
	for(int i = 0; i<N; i++){
		
		x_gold = 0;
		y_gold = 0;
		for(int k = 0; k<7; k++){
			x[k] = rand()/((RAND_MAX + 1u)/3) - 1;
			x_gold += x[k]<<k;

			y[k] = rand()/((RAND_MAX + 1u)/3) -1;
			y_gold += y[k]<<k;
		}

		#ifdef PRINT
		myfile<<"X: ";
		print_vec(x,8);
		myfile<<"Y: ";
		print_vec(y,8);
		#endif

		z_gold = x_gold*y_gold;

		for(int k = 0; k<11; k++){
			p[k] = 0;
		}

		for(int k = 0; k<16; k++){
			z[k] = 0;
		}

		for(int j = 1; j<=8; j++){
			#ifdef PRINT
			myfile<<"j="<<j<<"\n";
			#endif
			
			if(y[8-j]==1) w_copy(w,x,1);
			else if (y[8-j]==-1) w_copy(w,x,2);
			else w_copy(w,x,0);

			#ifdef PRINT
			myfile<<"     Xy: ";
			print_vec(w,11);
			#endif

			w_add(w,p);

			#ifdef PRINT
			myfile<<"     w+p: ";
			print_vec(w,11);
			#endif
			
			w_val = 0;
			for(int k = 0; k<11; k++){
				w_val += w[k]<<k;
			}
			z_j = sel(&w_val);
			
			#ifdef PRINT
			myfile<<"     (w_val="<<w_val<<", z_j="<<z_j<<")\n";
			#endif

			z[16-j] = z_j;
			
			#ifdef PRINT
			myfile<<"     Z: ";
			print_vec(z, 16);
			#endif
			
			for(int k = 0; k<11; k++){
				p[k]=w[k];
			}

			p[8]-=z_j;
			int c = 0;
			for(int k = 8; k<11; k++){
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
			
			#ifdef PRINT
			myfile<<"     P: ";
			print_vec(p, 11);
			#endif

			p_val = 0;
			for(int k = 0; k<11; k++){
				p_val += p[k]<<k;
			}
			
			#ifdef PRINT
			myfile<<"     (p_val="<<p_val<<")\n";
			#endif

		}

		#ifdef PRINT
		z_out = 0;
		for(int k = 0; k<16; k++){
			z_out += z[k]<<k;
		}
		myfile<<"Unappended Z="<<z_out<<"\n";
		#endif

		//condence p
		for(int k = 10; k>7; k--){
			if(p[k]!=0){
				if(p[k]==-1*p[k-1]){
					p[k-1]=p[k];
					p[k] = 0;
				}
				else if (p[k]==-1*p[k-2]){
					p[k-2]=p[k];
					p[k-1]=p[k];
					p[k]=0;
				}
				else{
					myfile<<"I WASNT EXPECTING TO GET HERE\n";
				}
			}
		}

		#ifdef PRINT
		myfile<<"P: ";
		print_vec(p, 11);
		#endif

		for(int k = 0; k<8; k++){
			z[k] = p[k];
		}

		#ifdef PRINT
		myfile<<"Z: ";
		print_vec(z, 16);
		#endif

		z_out = 0;
		for(int k = 0; k<16; k++){
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

	cout<<"Successfully passed "<<N<<" tests\n";

	mismatch:

	myfile.close();

	return 0;
}

int sel(int* w){
	if(*w>=128) return 1;
	else if (*w<-128) return -1;
	else return 0;
}

void w_copy(int a[],int b[], int type){
	for(int i = 0; i<8; i++){
		if(type==2) a[i] = -1*b[i];
		else if(type==1) a[i] = b[i];
		else a[i]=0;
	}
	a[8] = 0;
	a[9] = 0;
	a[10] = 0;
}

void w_add(int a[], int b[]){
	int c = 0;
	for(int i = 1; i<10; i++){
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

	//prevent overflow from the shifting..
	if(b[10]!=0){
		a[10] = a[10] + b[10] + c;
		if(a[10]>=2) a[10] -= 2;
		else if(a[10]<=-2) a[10] += 2;
	}
	else{
		a[10] = a[10] + b[9] + c;
		if(a[10]>=2) a[10] -= 2;
		else if(a[10]<=-2) a[10] += 2;
	}
}

void print_vec(int a[], int size){
	for(int i = size-1; i>=0; i--){
		myfile<<a[i]<<" ";
	}
	myfile<<"\n";
}

void condence(int a[]){

}