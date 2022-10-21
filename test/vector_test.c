
// /* Create macros so that the matrices are stored in column-major order */

// #define A(i,j) a[ (j)*lda + (i) ]
// #define B(i,j) b[ (j)*ldb + (i) ]
// #define C(i,j) c[ (j)*ldc + (i) ]

// /* Routine for computing C = A * B + C */

// void AddDot4x4( int, double *, int, double *, int, double *, int );

// void MY_MMult( int m, int n, int k, double *a, int lda, 
//                                     double *b, int ldb,
//                                     double *c, int ldc )
// {
//   int i, j;

//   for ( j=0; j<n; j+=4 ){        /* Loop over the columns of C, unrolled by 4 */
//     for ( i=0; i<m; i+=4 ){        /* Loop over the rows of C */
//       /* Update C( i,j ), C( i,j+1 ), C( i,j+2 ), and C( i,j+3 ) in
// 	 one routine (four inner products) */

//       AddDot4x4( k, &A( i,0 ), lda, &B( 0,j ), ldb, &C( i,j ), ldc );
//     }
//   }
// }


// void AddDot4x4( int k, double *a, int lda,  double *b, int ldb, double *c, int ldc )
// {
//   /* So, this routine computes a 4x4 block of matrix A

//            C( 0, 0 ), C( 0, 1 ), C( 0, 2 ), C( 0, 3 ).  
//            C( 1, 0 ), C( 1, 1 ), C( 1, 2 ), C( 1, 3 ).  
//            C( 2, 0 ), C( 2, 1 ), C( 2, 2 ), C( 2, 3 ).  
//            C( 3, 0 ), C( 3, 1 ), C( 3, 2 ), C( 3, 3 ).  

//      Notice that this routine is called with c = C( i, j ) in the
//      previous routine, so these are actually the elements 

//            C( i  , j ), C( i  , j+1 ), C( i  , j+2 ), C( i  , j+3 ) 
//            C( i+1, j ), C( i+1, j+1 ), C( i+1, j+2 ), C( i+1, j+3 ) 
//            C( i+2, j ), C( i+2, j+1 ), C( i+2, j+2 ), C( i+2, j+3 ) 
//            C( i+3, j ), C( i+3, j+1 ), C( i+3, j+2 ), C( i+3, j+3 ) 
	  
//      in the original matrix C 

//      In this version, we use registers for elements in the current row
//      of B as well */

//   int p;
//   register double 
//     /* hold contributions to
//        C( 0, 0 ), C( 0, 1 ), C( 0, 2 ), C( 0, 3 ) 
//        C( 1, 0 ), C( 1, 1 ), C( 1, 2 ), C( 1, 3 ) 
//        C( 2, 0 ), C( 2, 1 ), C( 2, 2 ), C( 2, 3 ) 
//        C( 3, 0 ), C( 3, 1 ), C( 3, 2 ), C( 3, 3 )   */
//        c_00_reg,   c_01_reg,   c_02_reg,   c_03_reg,  
//        c_10_reg,   c_11_reg,   c_12_reg,   c_13_reg,  
//        c_20_reg,   c_21_reg,   c_22_reg,   c_23_reg,  
//        c_30_reg,   c_31_reg,   c_32_reg,   c_33_reg,
//     /* hold 
//        A( 0, p ) 
//        A( 1, p ) 
//        A( 2, p ) 
//        A( 3, p ) */
//        a_0p_reg,
//        a_1p_reg,
//        a_2p_reg,
//        a_3p_reg,
//        b_p0_reg,
//        b_p1_reg,
//        b_p2_reg,
//        b_p3_reg;

//   double 
//     /* Point to the current elements in the four columns of B */
//     *b_p0_pntr, *b_p1_pntr, *b_p2_pntr, *b_p3_pntr; 
    
//   b_p0_pntr = &B( 0, 0 );
//   b_p1_pntr = &B( 0, 1 );
//   b_p2_pntr = &B( 0, 2 );
//   b_p3_pntr = &B( 0, 3 );

//   c_00_reg = 0.0;   c_01_reg = 0.0;   c_02_reg = 0.0;   c_03_reg = 0.0;
//   c_10_reg = 0.0;   c_11_reg = 0.0;   c_12_reg = 0.0;   c_13_reg = 0.0;
//   c_20_reg = 0.0;   c_21_reg = 0.0;   c_22_reg = 0.0;   c_23_reg = 0.0;
//   c_30_reg = 0.0;   c_31_reg = 0.0;   c_32_reg = 0.0;   c_33_reg = 0.0;

//   for ( p=0; p<k; p++ ){
//     a_0p_reg = A( 0, p );
//     a_1p_reg = A( 1, p );
//     a_2p_reg = A( 2, p );
//     a_3p_reg = A( 3, p );

//     b_p0_reg = *b_p0_pntr++;
//     b_p1_reg = *b_p1_pntr++;
//     b_p2_reg = *b_p2_pntr++;
//     b_p3_reg = *b_p3_pntr++;

//     /* First row */
//     c_00_reg += a_0p_reg * b_p0_reg;
//     c_01_reg += a_0p_reg * b_p1_reg;
//     c_02_reg += a_0p_reg * b_p2_reg;
//     c_03_reg += a_0p_reg * b_p3_reg;

//     /* Second row */
//     c_10_reg += a_1p_reg * b_p0_reg;
//     c_11_reg += a_1p_reg * b_p1_reg;
//     c_12_reg += a_1p_reg * b_p2_reg;
//     c_13_reg += a_1p_reg * b_p3_reg;

//     /* Third row */
//     c_20_reg += a_2p_reg * b_p0_reg;
//     c_21_reg += a_2p_reg * b_p1_reg;
//     c_22_reg += a_2p_reg * b_p2_reg;
//     c_23_reg += a_2p_reg * b_p3_reg;

//     /* Four row */
//     c_30_reg += a_3p_reg * b_p0_reg;
//     c_31_reg += a_3p_reg * b_p1_reg;
//     c_32_reg += a_3p_reg * b_p2_reg;
//     c_33_reg += a_3p_reg * b_p3_reg;
//   }

//   C( 0, 0 ) += c_00_reg;   C( 0, 1 ) += c_01_reg;   C( 0, 2 ) += c_02_reg;   C( 0, 3 ) += c_03_reg;
//   C( 1, 0 ) += c_10_reg;   C( 1, 1 ) += c_11_reg;   C( 1, 2 ) += c_12_reg;   C( 1, 3 ) += c_13_reg;
//   C( 2, 0 ) += c_20_reg;   C( 2, 1 ) += c_21_reg;   C( 2, 2 ) += c_22_reg;   C( 2, 3 ) += c_23_reg;
//   C( 3, 0 ) += c_30_reg;   C( 3, 1 ) += c_31_reg;   C( 3, 2 ) += c_32_reg;   C( 3, 3 ) += c_33_reg;
// }
// ----------------------------
  
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

#include <mmintrin.h>
#include <xmmintrin.h>  // SSE
#include <pmmintrin.h>  // SSE2
#include <emmintrin.h>  // SSE3
#include <riscv_vector.h>

typedef union
{
  __m128d v;
  double d[2];
} v2df_t;

void AddDot4x4( int k, double *a, int lda,  double *b, int ldb, double *c, int ldc )
{
  /* So, this routine computes a 4x4 block of matrix A

           C( 0, 0 ), C( 0, 1 ), C( 0, 2 ), C( 0, 3 ).  
           C( 1, 0 ), C( 1, 1 ), C( 1, 2 ), C( 1, 3 ).  
           C( 2, 0 ), C( 2, 1 ), C( 2, 2 ), C( 2, 3 ).  
           C( 3, 0 ), C( 3, 1 ), C( 3, 2 ), C( 3, 3 ).  

     Notice that this routine is called with c = C( i, j ) in the
     previous routine, so these are actually the elements 

           C( i  , j ), C( i  , j+1 ), C( i  , j+2 ), C( i  , j+3 ) 
           C( i+1, j ), C( i+1, j+1 ), C( i+1, j+2 ), C( i+1, j+3 ) 
           C( i+2, j ), C( i+2, j+1 ), C( i+2, j+2 ), C( i+2, j+3 ) 
           C( i+3, j ), C( i+3, j+1 ), C( i+3, j+2 ), C( i+3, j+3 ) 
	  
     in the original matrix C 

     And now we use vector registers and instructions */

  int p, vlmax;
  vint64m1_t bindex;
  vfloat64m1_t 
    c_00_c_10_vreg,    c_01_c_11_vreg,    c_02_c_12_vreg,    c_03_c_13_vreg,
    c_20_c_30_vreg,    c_21_c_31_vreg,    c_22_c_32_vreg,    c_23_c_33_vreg,
    a_0p_a_1p_vreg,
    a_2p_a_3p_vreg,
    b_p0_vreg, b_p1_vreg, b_p2_vreg, b_p3_vreg; 
  // v2df_t
  //   c_00_c_10_vreg,    c_01_c_11_vreg,    c_02_c_12_vreg,    c_03_c_13_vreg,
  //   c_20_c_30_vreg,    c_21_c_31_vreg,    c_22_c_32_vreg,    c_23_c_33_vreg,
  //   a_0p_a_1p_vreg,
  //   a_2p_a_3p_vreg,
  //   b_p0_vreg, b_p1_vreg, b_p2_vreg, b_p3_vreg; 

  vlmax = vsetvlmax_e64m1();
  c_00_c_10_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_01_c_11_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_02_c_12_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_03_c_13_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_20_c_30_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_21_c_31_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_22_c_32_vreg = vfmv_v_f64m1(0.0, vlmax);
  c_23_c_33_vreg = vfmv_v_f64m1(0.0, vlmax);

  bindex = vmv_v_i64m1(0, vlmax);

  // c_00_c_10_vreg.v = _mm_setzero_pd();   
  // c_01_c_11_vreg.v = _mm_setzero_pd();
  // c_02_c_12_vreg.v = _mm_setzero_pd(); 
  // c_03_c_13_vreg.v = _mm_setzero_pd(); 
  // c_20_c_30_vreg.v = _mm_setzero_pd();   
  // c_21_c_31_vreg.v = _mm_setzero_pd();  
  // c_22_c_32_vreg.v = _mm_setzero_pd();   
  // c_23_c_33_vreg.v = _mm_setzero_pd(); 

  for (p = 0; p < k-vlmax; p+=vlmax) {
    a_0p_a_1p_vreg = vle64_v_f64m1((double *) a, vlmax);
    a_2p_a_3p_vreg = vle64_v_f64m1((double *) (a+2), vlmax);
    a += 4;

    b_p0_vreg = vloxei64_v_f64((double *) b, bindex, vlmax);
    b_p1_vreg = vloxei64_v_f64((double *) (b+1), bindex, vlmax);
    b_p2_vreg = vloxei64_v_f64((double *) (b+2), bindex, vlmax);
    b_p3_vreg = vloxei64_v_f64((double *) (b+3), bindex, vlmax);
    b += 4;

    // vector同士の演算
    c_00_c_10_vreg += a_0p_a_1p_vreg * b_p0_vreg;
    c_01_c_11_vreg += a_0p_a_1p_vreg * b_p1_vreg;
    c_02_c_12_vreg += a_0p_a_1p_vreg * b_p2_vreg;
    c_03_c_13_vreg += a_0p_a_1p_vreg * b_p3_vreg;
    c_20_c_30_vreg += a_2p_a_3p_vreg * b_p0_vreg;
    c_21_c_31_vreg += a_2p_a_3p_vreg * b_p1_vreg;
    c_22_c_32_vreg += a_2p_a_3p_vreg * b_p2_vreg;
    c_23_c_33_vreg += a_2p_a_3p_vreg * b_p3_vreg;
  }

  // for ( p=0; p<k; p++ ){
  //   a_0p_a_1p_vreg.v = _mm_load_pd( (double *) a );
  //   a_2p_a_3p_vreg.v = _mm_load_pd( (double *) ( a+2 ) );
  //   a += 4;

  //   b_p0_vreg.v = _mm_loaddup_pd( (double *) b );       /* load and duplicate */
  //   b_p1_vreg.v = _mm_loaddup_pd( (double *) (b+1) );   /* load and duplicate */
  //   b_p2_vreg.v = _mm_loaddup_pd( (double *) (b+2) );   /* load and duplicate */
  //   b_p3_vreg.v = _mm_loaddup_pd( (double *) (b+3) );   /* load and duplicate */

  //   b += 4;

  //   /* First row and second rows */
  //   c_00_c_10_vreg.v += a_0p_a_1p_vreg.v * b_p0_vreg.v;
  //   c_01_c_11_vreg.v += a_0p_a_1p_vreg.v * b_p1_vreg.v;
  //   c_02_c_12_vreg.v += a_0p_a_1p_vreg.v * b_p2_vreg.v;
  //   c_03_c_13_vreg.v += a_0p_a_1p_vreg.v * b_p3_vreg.v;

  //   /* Third and fourth rows */
  //   c_20_c_30_vreg.v += a_2p_a_3p_vreg.v * b_p0_vreg.v;
  //   c_21_c_31_vreg.v += a_2p_a_3p_vreg.v * b_p1_vreg.v;
  //   c_22_c_32_vreg.v += a_2p_a_3p_vreg.v * b_p2_vreg.v;
  //   c_23_c_33_vreg.v += a_2p_a_3p_vreg.v * b_p3_vreg.v;
  // }

  // C(0, 0)は64bitスカラレジスタ、c_00_c_10_vregは128bitのベクトルレジスタに入っている
  // ベクトルレジスタとスカラレジスタの演算は実行できるのか？

  vint64m1_t vec_zero = vmv_v_xi64m1(0, vlmax);

  C( 0, 0 ) += c_00_c_10_vreg.d[0];  C( 0, 1 ) += c_01_c_11_vreg.d[0];  
  C( 0, 2 ) += c_02_c_12_vreg.d[0];  C( 0, 3 ) += c_03_c_13_vreg.d[0]; 

  C( 1, 0 ) += c_00_c_10_vreg.d[1];  C( 1, 1 ) += c_01_c_11_vreg.d[1];  
  C( 1, 2 ) += c_02_c_12_vreg.d[1];  C( 1, 3 ) += c_03_c_13_vreg.d[1]; 

  C( 2, 0 ) += c_20_c_30_vreg.d[0];  C( 2, 1 ) += c_21_c_31_vreg.d[0];  
  C( 2, 2 ) += c_22_c_32_vreg.d[0];  C( 2, 3 ) += c_23_c_33_vreg.d[0]; 

  C( 3, 0 ) += c_20_c_30_vreg.d[1];  C( 3, 1 ) += c_21_c_31_vreg.d[1];  
  C( 3, 2 ) += c_22_c_32_vreg.d[1];  C( 3, 3 ) += c_23_c_33_vreg.d[1]; 

  for (; p < k; p++) {
    c_00_c_10_vreg += a[0] * b[0];
  }
}
