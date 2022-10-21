
vector_test.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <MY_MMult>:
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	00152293          	slti	t0,a0,1
   8:	0015a413          	slti	s0,a1,1
   c:	0082e2b3          	or	t0,t0,s0
  10:	00162413          	slti	s0,a2,1
  14:	0082e433          	or	s0,t0,s0
  18:	e03d                	bnez	s0,7e <MY_MMult+0x7e>
  1a:	6442                	ld	s0,16(sp)
  1c:	4281                	li	t0,0
  1e:	0004031b          	sext.w	t1,s0
  22:	1502                	slli	a0,a0,0x20
  24:	02055393          	srli	t2,a0,0x20
  28:	02059513          	slli	a0,a1,0x20
  2c:	02055e13          	srli	t3,a0,0x20
  30:	02061513          	slli	a0,a2,0x20
  34:	02055e93          	srli	t4,a0,0x20
  38:	080e                	slli	a6,a6,0x3
  3a:	070e                	slli	a4,a4,0x3
  ; for (i = 0; i < m; i++)
  3c:	4f81                	li	t6,0
  3e:	8f3e                	mv	t5,a5
  ; for (j = 0; j < n; j++)
  40:	026f8533          	mul	a0,t6,t1
  44:	9516                	add	a0,a0,t0
  46:	050e                	slli	a0,a0,0x3
  48:	00a88633          	add	a2,a7,a0
  4c:	00063007          	fld	ft0,0(a2)
  50:	8576                	mv	a0,t4
  52:	85b6                	mv	a1,a3
  54:	847a                	mv	s0,t5
  ; for (p = 0; p < k; p++)
  56:	0005b087          	fld	ft1,0(a1)
  5a:	00043107          	fld	ft2,0(s0)
  5e:	0220f043          	fmadd.d	ft0,ft1,ft2,ft0
  62:	00063027          	fsd	ft0,0(a2)
  66:	0421                	addi	s0,s0,8 ; A: 小数でdoubleなので、8byte進める
  68:	157d                	addi	a0,a0,-1 ; a0だけforLoopを繰り返す
  6a:	95ba                	add	a1,a1,a4 ; B: a4はBの列を表し、その分だけインデックスを進める
  6c:	f56d                	bnez	a0,56 <MY_MMult+0x56>
  ;
  6e:	0f85                	addi	t6,t6,1
  70:	9f42                	add	t5,t5,a6
  72:	fdcf97e3          	bne	t6,t3,40 <MY_MMult+0x40>
  ;
  76:	0285                	addi	t0,t0,1
  78:	06a1                	addi	a3,a3,8
  7a:	fc7291e3          	bne	t0,t2,3c <MY_MMult+0x3c>
  ;
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret
