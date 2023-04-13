#include <bits/stdc++.h>

using namespace std;

const int N = 1024, A = 127;

int main() {
	for(int i = 0; i < N; i++) {
		int x = A + roundl(A * sinl((2 * M_PI * i) / (long double)N)) + 1;
		//cout << "0x" << uppercase << hex  << x << ", ";
		cout << x << ", ";
	}
}
