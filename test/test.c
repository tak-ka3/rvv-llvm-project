#include<riscv_vector.h>
#include<stdio.h>

#define N 15

float vsum(float *v, int n){
  vfloat32m1_t vs, vv, vtmp;
  float s=0.0;
  int i;
  int vlmax;
  

  vlmax=vsetvlmax_e32m1();

  printf("vlmax:%d\n", vlmax);
  
  vs=vfmv_v_f_f32m1(0.0, vlmax);  // レジスタに即値をvlmax個だけ詰める
  
  vtmp=vfmv_v_f_f32m1(0.0, vlmax);

  // 並列にできるだけ計算
  for(i=0; i<n-vlmax; i+=vlmax){
    vv = vle32_v_f32m1(&v[i], vlmax); // v[i]のアドレスからvlmax個だけLOADする
    vtmp = vfadd_vv_f32m1(vtmp, vv, vlmax); // vtmp = vtmp + vv
  }

  vs=vfredusum_vs_f32m1_f32m1(vs,vtmp, vs, vlmax); // 順序なし加算。自動ベクトル化に対応していないからより高速化が可能。
  
  s = vfmv_f_s_f32m1_f32(vs);

  printf("middle: s = %f\n", s); // <0,1,2,3,4,5,6,7>の和
  
  // 先ほどのfor文でiは増えている。ここでは余りの部分の計算
  for(; i<n; i++){
    s+=v[i];
  }
  return s;
}


float vsum1(float *v, int n){
  vfloat32m1_t vs, vv;
  float s;
  int i;
  int vl, vlmax;
  
  vlmax=vsetvlmax_e32m1();
  vs=vfmv_v_f_f32m1(0.0, vlmax);

  for(i=0; n>0; i+=vl, n-=vl){
    vl=vsetvl_e32m1(n); // できるだけ並列に処理するが余りの分は最後にvlに代入される
    printf("vl:%d\n", vl);    
    vv = vle32_v_f32m1(&v[i], vl);

    // vs = dst, vv = vector, vs = scalar
    // vsは全ての要素が配列要素の合計値となっている
    vs=vfredusum_vs_f32m1_f32m1(vs,vv, vs, vl);  // Loopごとにリダクションの和を取っている // vs[0] = vs[0] + sum(vv)
  }
  
  s = vfmv_f_s_f32m1_f32(vs); // s = f[rd] = vs[0] // ベクトルレジスタから要素0をスカラレジスタにコピー
  
  return s;
}

// レジスタを複数使用
float vsum2(float *v, int n){
  vfloat32m2_t vv;
  vfloat32m1_t vs;
  float s;
  int i;
  int vl, vlmax;
  
  vlmax=vsetvlmax_e32m1();
  
  vs=vfmv_v_f_f32m1(0.0, vlmax);

  for(i=0; n>0; i+=vl, n-=vl){
    vl=vsetvl_e32m2(n); // レジスタを2つ使用
    printf("vl:%d\n", vl);    
    vv = vle32_v_f32m2(&v[i], vl);

    vs=vfredusum_vs_f32m2_f32m1(vs,vv, vs, vl);  
  }

  
  s = vfmv_f_s_f32m1_f32(vs);
  
  return s;
}

float mul(float* v, int n) {
    int vl, vlmax;
    int i;
    vfloat32m2_t vv;
    vfloat32m1_t vs;
    vlmax = vsetvlmax_e32m1();
    vs = vfmv_v_f_f32m1(0.0, vlmax);

    for (i = 0; n > 0; i+=vl, n-=vl) {
        vl = vsetvl_e32m2(n); // vlmaxはレジスタに格納されているからそれと比較している
        printf("vl = %d\n", vl);
        vv = vle32_v_f32m2(&v[i], vl);

        vs = vfredu
    }
}


int main()
{
  int i;
  float v[N], sum=0.0;
  
  printf("Hello RISC-V!\n");

  for(i=0; i<N; i++){
    v[i]=i;
  }
  
  sum = vsum2(v, N);

  printf("%f\n", sum);
  

  return 0;
}