#include <stdlib.h>

#define A( i,j ) a[ (j)*lda + (i) ]

void random_matrix( int m, int n, double *a, int lda )
{
  double drand48();
  int i,j;

  for ( j=0; j<n; j++ )
    for ( i=0; i<m; i++ )
      # if DEBUG_ON
      A(i, j) = 1.0 * i+j*m;
      # else
      A( i,j ) = 2.0 * drand48( ) - 1.0;
      # endif
}
