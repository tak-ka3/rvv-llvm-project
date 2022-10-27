/* Create macros so that the matrices are stored in column-major order */

#define A(i,j) a[ (j)*lda + (i) ]
#define B(i,j) b[ (j)*ldb + (i) ]
#define C(i,j) c[ (j)*ldc + (i) ]

/* Block sizes */
#define mc 256
#define kc 128
#define nb 1000

#define min( i, j ) ( (i)<(j) ? (i): (j) )

/* Routine for computing C = A * B + C */

void AddDot4x4( int, double *, int, double *, int, double *, int );
void PackMatrixA( int, double *, int, double * );
void PackMatrixB( int, double *, int, double * );
void InnerKernel( int, int, int, double *, int, double *, int, double *, int, int );

void MY_MMult( int m, int n, int k, double *a, int lda, 
                                    double *b, int ldb,
                                    double *c, int ldc )
{
  int i, p, pb, ib;

  /* This time, we compute a mc x n block of C by a call to the InnerKernel */

  for ( p=0; p<k; p+=kc ){
    pb = min( k-p, kc );
    for ( i=0; i<m; i+=mc ){
      ib = min( m-i, mc );
      InnerKernel( ib, n, pb, &A( i,p ), lda, &B(p, 0 ), ldb, &C( i,0 ), ldc, i==0 );
    }
  }
}

void InnerKernel( int m, int n, int k, double *a, int lda, 
                                       double *b, int ldb,
                                       double *c, int ldc, int first_time )
{
  int i, j;
  double 
    packedA[ m * k ]; // 扱う要素の数だけ確保
  static double 
    packedB[ kc*nb ];    /* Note: using a static buffer is not thread safe... */

  for ( j=0; j<n; j+=4 ){        /* Loop over the columns of C, unrolled by 4 */
    if ( first_time )
      PackMatrixB( k, &B( 0, j ), ldb, &packedB[ j*k ] );
    for ( i=0; i<m; i+=4 ){        /* Loop over the rows of C */
      /* Update C( i,j ), C( i,j+1 ), C( i,j+2 ), and C( i,j+3 ) in
	 one routine (four inner products) */
      if ( j == 0 ) 
	PackMatrixA( k, &A( i, 0 ), lda, &packedA[ i*k ] );
      AddDot4x4( k, &packedA[ i*k ], 4, &packedB[ j*k ], k, &C( i,j ), ldc );
    }
  }
}

void PackMatrixA( int k, double *a, int lda, double *a_to )
{
  int j;

  for( j=0; j<k; j++){  /* loop over columns of A */
    double 
      *a_ij_pntr = &A( 0, j );

    *a_to     = *a_ij_pntr;
    *(a_to+1) = *(a_ij_pntr+1);
    *(a_to+2) = *(a_ij_pntr+2);
    *(a_to+3) = *(a_ij_pntr+3);

    a_to += 4;
  }
}

void PackMatrixB( int k, double *b, int ldb, double *b_to )
{
  int i;
  double 
    *b_i0_pntr = &B( 0, 0 ), *b_i1_pntr = &B( 0, 1 ),
    *b_i2_pntr = &B( 0, 2 ), *b_i3_pntr = &B( 0, 3 );

  for( i=0; i<k; i++){  /* loop over rows of B */
    *b_to++ = *b_i0_pntr++;
    *b_to++ = *b_i1_pntr++;
    *b_to++ = *b_i2_pntr++;
    *b_to++ = *b_i3_pntr++;
  }
}

#include <riscv_vector.h>
#include <stdio.h>
#include <stdlib.h>

void AddDot4x4( int k, double *a, int lda,  double *b, int ldb, double *c, int ldc )
{
  int vlmax, cnt;
  vfloat64m1_t c0, c4, c8, c12, vecA;
  register double *b0, *b4, *b8, *b12;
  vlmax = vsetvlmax_e64m1();
  # if DEBUG_ON
  printf("vlmax = %d\n", vlmax);
  printf("lda: %d, ldb: %d, ldc: %d\n", lda, ldb, ldc);
  printf("k = %d\n", k);
  printf("A in kernel\n");
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      printf("%f, ", A(i, j));
    }
    printf("\n");
  }
  printf("B in kernel\n");
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      printf("%f, ", B(i, j));
    }
    printf("\n");
  }
  # endif
  // そもそもレジスタ数が足りないと、ここで全ての値を初期化することができない
  // intialization using scalar register which has 0.0
  c0 = vle64_v_f64m1(&C(0, 0), 4);
  c4 = vle64_v_f64m1(&C(0, 1), 4);
  c8 = vle64_v_f64m1(&C(0, 2), 4);
  c12 = vle64_v_f64m1(&C(0, 3), 4);

  b0 = &B(0, 0);

  int ap = 0, bp = 0;

  for (int p = 0; p < k; p++) {
    vecA = vle64_v_f64m1((double*) (a+ap), 4);
    c0 = vfmacc_vf_f64m1(c0, *(b0+bp), vecA, 4);
    c4 = vfmacc_vf_f64m1(c4, *(b0+1+bp), vecA, 4);
    c8 = vfmacc_vf_f64m1(c8, *(b0+2+bp), vecA, 4);
    c12 = vfmacc_vf_f64m1(c12, *(b0+3+bp), vecA, 4);
    # if DEBUG_ON
    printf("b0: %f, b1: %f, b8: %f. b12: %f\n", *b0, *b4, *b8, *b12);
    # endif
    ap += 4;
    bp += 4;
    # if DEBUG_ON
    printf("------------\n");
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        printf("%f, ",*(c+i*ldc+j));
      }
      printf("\n");
    }
    printf("------------\n");
    # endif
  }
  vse64_v_f64m1(&C(0, 0), c0, 4);
  vse64_v_f64m1(&C(0, 1), c4, 4);
  vse64_v_f64m1(&C(0, 2), c8, 4);
  vse64_v_f64m1(&C(0, 3), c12, 4);

  # if DEBUG_ON
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      printf("%f, ", *(c+i*ldc+j));
    }
    printf("\n");
  }
  # endif
}
