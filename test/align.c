int main() {
    int n = 1000;
    short a[n];
    short b[n];
    for (int i = 0; i < n; i++) {
        a[i] = i;
        b[i] = i*2;
    }
    for (int i = 0; i < n; i++) {
        a[i] = b[i] * 2;
    }
    return a[n];
}