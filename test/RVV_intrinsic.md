### `vbool64_t mask = vmfne_vv_f64m1_b64(vec_a, vec_zero, vl);`
vmfneは浮動小数点比較命令。2つのソースレジスタを比較してその結果をマスクレジスタに書き込む。[参照](https://msyksphinz-self.github.io/riscv-v-spec-japanese/html/chapter14_floatingpoint.html#id9)
- vmfeq : compare equal
- vmfne : compare not equal

### ` vec_s = vfmacc_vv_f64m1_m(mask, vec_s, vec_a, vec_b, vl);`
単一ビット幅浮動小数点Fused Multiply-Add命令
- vfmacc : vd[i] = +(vs1[i] * vs2[i]) + vd[i] // 加算のオペランドを上書き
- vfnmacc : vd[i] = -(vs1[i] * vs2[i]) - vd[i] // 減算のオペランドを上書き