#include <stdio.h>
#include <stdlib.h>

int number(int N){
    int N_out=0;
    int N_temp=N;
    for (N_temp;N_temp>0;N_temp--){
    N_out+=N_temp;
    }
    return N_out;
}
int main(int argc, char *argv[]) {
    int N = 5;   // default τιμή

    if (argc > 1) {
        N = atoi(argv[1]);
    }

    int result = number(N);
    printf("%d\n", result);
    return 0;
}
