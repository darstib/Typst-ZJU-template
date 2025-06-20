#include <stdio.h>

int main() {
    int n = 100;
    int sum = 0;
    for (int i = 1; i <= n; ++i) {
        sum += i;
    }
    printf("The sum of the first %d natural numbers is: %d\n", n, sum);
}