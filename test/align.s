	.text
	.attribute	4, 16
	.attribute	5, "rv64i2p0"
	.file	"align.c"
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	lui	a0, 1
	addiw	a0, a0, -80
	sub	sp, sp, a0
	li	a0, 0
	vsetivli	zero, 16, e16, m1, ta, mu
	vid.v	v8
	li	a6, 16
	addi	a2, sp, 2016
	addi	a3, sp, 16
	li	a4, 32
	li	a5, 1984
.LBB0_1:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	vadd.vx	v9, v8, a6
	add	a1, a2, a0
	vse16.v	v8, (a1)
	addi	a1, a1, 32
	vse16.v	v9, (a1)
	vadd.vv	v10, v8, v8
	vadd.vv	v9, v9, v9
	add	a1, a3, a0
	vse16.v	v10, (a1)
	addi	a1, a1, 32
	vse16.v	v9, (a1)
	addi	a0, a0, 64
	vadd.vx	v8, v8, a4
	bne	a0, a5, .LBB0_1
# %bb.2:                                # %for.body
	li	a0, 992
	lui	a1, 1
	addiw	a1, a1, -96
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1984
	sh	a0, 2000(sp)
	li	a0, 993
	lui	a1, 1
	addiw	a1, a1, -94
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1986
	sh	a0, 2002(sp)
	li	a0, 994
	lui	a1, 1
	addiw	a1, a1, -92
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1988
	sh	a0, 2004(sp)
	li	a0, 995
	lui	a1, 1
	addiw	a1, a1, -90
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1990
	sh	a0, 2006(sp)
	li	a0, 996
	lui	a1, 1
	addiw	a1, a1, -88
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1992
	sh	a0, 2008(sp)
	li	a0, 997
	lui	a1, 1
	addiw	a1, a1, -86
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1994
	sh	a0, 2010(sp)
	li	a0, 998
	lui	a1, 1
	addiw	a1, a1, -84
	add	a1, a1, sp
	sh	a0, 0(a1)
	li	a0, 1996
	sh	a0, 2012(sp)
	li	a0, 1998
	sh	a0, 2014(sp)
	addi	a0, sp, 16
	vle16.v	v8, (a0)
	addi	a0, sp, 48
	vle16.v	v9, (a0)
	li	a0, 999
	lui	a1, 1
	addiw	a1, a1, -82
	add	a1, a1, sp
	sh	a0, 0(a1)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v9, v9
	addi	a0, sp, 2016
	vse16.v	v8, (a0)
	addi	a0, sp, 80
	vle16.v	v8, (a0)
	addi	a0, sp, 112
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -2048
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -2016
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 144
	vle16.v	v8, (a0)
	addi	a0, sp, 176
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1984
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1952
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 208
	vle16.v	v8, (a0)
	addi	a0, sp, 240
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1920
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1888
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 272
	vle16.v	v8, (a0)
	addi	a0, sp, 304
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1856
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1824
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 336
	vle16.v	v8, (a0)
	addi	a0, sp, 368
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1792
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1760
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 400
	vle16.v	v8, (a0)
	addi	a0, sp, 432
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1728
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1696
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 464
	vle16.v	v8, (a0)
	addi	a0, sp, 496
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1664
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1632
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 528
	vle16.v	v8, (a0)
	addi	a0, sp, 560
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1600
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1568
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 592
	vle16.v	v8, (a0)
	addi	a0, sp, 624
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1536
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1504
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 656
	vle16.v	v8, (a0)
	addi	a0, sp, 688
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1472
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1440
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 720
	vle16.v	v8, (a0)
	addi	a0, sp, 752
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1408
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1376
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 784
	vle16.v	v8, (a0)
	addi	a0, sp, 816
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1344
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1312
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 848
	vle16.v	v8, (a0)
	addi	a0, sp, 880
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1280
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1248
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 912
	vle16.v	v8, (a0)
	addi	a0, sp, 944
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1216
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1184
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 976
	vle16.v	v8, (a0)
	addi	a0, sp, 1008
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1152
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1120
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1040
	vle16.v	v8, (a0)
	addi	a0, sp, 1072
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1088
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -1056
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1104
	vle16.v	v8, (a0)
	addi	a0, sp, 1136
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -1024
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -992
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1168
	vle16.v	v8, (a0)
	addi	a0, sp, 1200
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -960
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -928
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1232
	vle16.v	v8, (a0)
	addi	a0, sp, 1264
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -896
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -864
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1296
	vle16.v	v8, (a0)
	addi	a0, sp, 1328
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -832
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -800
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1360
	vle16.v	v8, (a0)
	addi	a0, sp, 1392
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -768
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -736
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1424
	vle16.v	v8, (a0)
	addi	a0, sp, 1456
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -704
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -672
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1488
	vle16.v	v8, (a0)
	addi	a0, sp, 1520
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -640
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -608
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1552
	vle16.v	v8, (a0)
	addi	a0, sp, 1584
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -576
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -544
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1616
	vle16.v	v8, (a0)
	addi	a0, sp, 1648
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -512
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -480
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1680
	vle16.v	v8, (a0)
	addi	a0, sp, 1712
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -448
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -416
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1744
	vle16.v	v8, (a0)
	addi	a0, sp, 1776
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -384
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -352
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1808
	vle16.v	v8, (a0)
	addi	a0, sp, 1840
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -320
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -288
	add	a0, a0, sp
	vse16.v	v8, (a0)
	addi	a0, sp, 1872
	vle16.v	v8, (a0)
	addi	a0, sp, 1904
	vle16.v	v10, (a0)
	lui	a0, 1
	addiw	a0, a0, -256
	add	a0, a0, sp
	vse16.v	v9, (a0)
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a0, 1
	addiw	a0, a0, -224
	add	a0, a0, sp
	vse16.v	v8, (a0)
	lui	a0, 1
	addiw	a0, a0, -192
	add	a0, a0, sp
	addi	a1, sp, 1936
	vle16.v	v8, (a1)
	addi	a1, sp, 1968
	vle16.v	v10, (a1)
	vse16.v	v9, (a0)
	addi	a0, sp, 2000
	vadd.vv	v8, v8, v8
	vadd.vv	v9, v10, v10
	lui	a1, 1
	addiw	a1, a1, -160
	add	a1, a1, sp
	vse16.v	v8, (a1)
	lui	a1, 1
	addiw	a1, a1, -128
	add	a1, a1, sp
	vse16.v	v9, (a1)
	vsetivli	zero, 8, e16, mf2, ta, mu
	vle16.v	v8, (a0)
	lui	a0, 1
	addiw	a0, a0, -96
	add	a0, a0, sp
	vadd.vv	v8, v8, v8
	vse16.v	v8, (a0)
	lui	a0, 1
	addiw	a0, a0, -80
	add	a0, a0, sp
	lh	a0, 0(a0)
	lui	a1, 1
	addiw	a1, a1, -80
	add	sp, sp, a1
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.ident	"clang version 14.0.6 (https://github.com/msyksphinz-self/llvm-project.git 9453981754b353ec7d739f968d1f89131bb27290)"
	.section	".note.GNU-stack","",@progbits
