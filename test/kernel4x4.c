#include <riscv_vector.h>
#include <stdlib.h>
#include <stdio.h>

void kernel4x4(double *a, double *b, double *c) {
    int vlmax, cnt;
    vfloat64m2_t c0, c4, c8, c12, vecA;
    double b0, b4, b8, b12;
    vlmax = vsetvlmax_e64m2();
    // そもそもレジスタ数が足りないと、ここで全ての値を初期化することができない
    // intialization using scalar register which has 0.0
    c0 = vfmv_v_f_f64m2(0.0, vlmax);
    c4 = vfmv_v_f_f64m2(0.0, vlmax);
    c8 = vfmv_v_f_f64m2(0.0, vlmax);
    c12 = vfmv_v_f_f64m2(0.0, vlmax);

    cnt = 0;
    while(cnt < 4) {
        b0 = *(b+cnt); b4 = *(b+cnt+4); b8 = *(b+cnt+8); b12 = *(b+cnt+12);
        printf("b0 = %f, ", b0);
        size_t vl;
        vecA = vle64_v_f64m2((double*) a, 4); // load four 64bit data 
        c0 = vfmacc_vf_f64m2(c0, b0, vecA, 4);
        c4 = vfmacc_vf_f64m2(c4, b4, vecA, 4);
        c8 = vfmacc_vf_f64m2(c8, b8, vecA, 4);
        c12 = vfmacc_vf_f64m2(c12, b12, vecA, 4);
        vse64_v_f64m2(c, c0, 4);
        vse64_v_f64m2(c+4, c4, 4);
        vse64_v_f64m2(c+8, c8, 4);
        vse64_v_f64m2(c+12, c12, 4);
        a += 4;
        cnt++;
    }
}

int main() {
    double *A = (double*)malloc(sizeof(double)*4*4);
    double *B = (double*)malloc(sizeof(double)*4*4);
    double *C = (double*)malloc(sizeof(double)*4*4);
    for (int i = 0; i < 16; i++) {
        *(A+i) = (double)i;
        *(B+i) = (double)i*2;
    }
    kernel4x4(A, B, C);
    for (int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            printf("C[%d][%d] = %f, ", i, j, *(C+i*4+j));
        }
    }
    return 0;
}