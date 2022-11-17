; ModuleID = 'align.c'
source_filename = "align.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64-unknown-unknown"

; Function Attrs: nofree norecurse nosync nounwind readnone
define dso_local signext i32 @main() local_unnamed_addr #0 {
entry:
  %vla39 = alloca [1000 x i16], align 2
  %vla140 = alloca [1000 x i16], align 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %vec.ind48 = phi <16 x i16> [ <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15>, %entry ], [ %vec.ind.next51, %vector.body ]
  %step.add49 = add <16 x i16> %vec.ind48, <i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16, i16 16>
  %0 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 %index
  %1 = bitcast i16* %0 to <16 x i16>*
  store <16 x i16> %vec.ind48, <16 x i16>* %1, align 2, !tbaa !4
  %2 = getelementptr inbounds i16, i16* %0, i64 16
  %3 = bitcast i16* %2 to <16 x i16>*
  store <16 x i16> %step.add49, <16 x i16>* %3, align 2, !tbaa !4
  %4 = shl nuw nsw <16 x i16> %vec.ind48, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %5 = shl nuw nsw <16 x i16> %step.add49, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %6 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 %index
  %7 = bitcast i16* %6 to <16 x i16>*
  store <16 x i16> %4, <16 x i16>* %7, align 2, !tbaa !4
  %8 = getelementptr inbounds i16, i16* %6, i64 16
  %9 = bitcast i16* %8 to <16 x i16>*
  store <16 x i16> %5, <16 x i16>* %9, align 2, !tbaa !4
  %index.next = add nuw i64 %index, 32
  %vec.ind.next51 = add <16 x i16> %vec.ind48, <i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32, i16 32>
  %10 = icmp eq i64 %index.next, 992
  br i1 %10, label %for.body, label %vector.body, !llvm.loop !8

for.body:                                         ; preds = %vector.body
  %arrayidx = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 992
  store i16 992, i16* %arrayidx, align 2, !tbaa !4
  %arrayidx4 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 992
  store i16 1984, i16* %arrayidx4, align 2, !tbaa !4
  %arrayidx.1 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 993
  store i16 993, i16* %arrayidx.1, align 2, !tbaa !4
  %arrayidx4.1 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 993
  store i16 1986, i16* %arrayidx4.1, align 2, !tbaa !4
  %arrayidx.2 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 994
  store i16 994, i16* %arrayidx.2, align 2, !tbaa !4
  %arrayidx4.2 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 994
  store i16 1988, i16* %arrayidx4.2, align 2, !tbaa !4
  %arrayidx.3 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 995
  store i16 995, i16* %arrayidx.3, align 2, !tbaa !4
  %arrayidx4.3 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 995
  store i16 1990, i16* %arrayidx4.3, align 2, !tbaa !4
  %arrayidx.4 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 996
  store i16 996, i16* %arrayidx.4, align 2, !tbaa !4
  %arrayidx4.4 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 996
  store i16 1992, i16* %arrayidx4.4, align 2, !tbaa !4
  %arrayidx.5 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 997
  store i16 997, i16* %arrayidx.5, align 2, !tbaa !4
  %arrayidx4.5 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 997
  store i16 1994, i16* %arrayidx4.5, align 2, !tbaa !4
  %arrayidx.6 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 998
  store i16 998, i16* %arrayidx.6, align 2, !tbaa !4
  %arrayidx4.6 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 998
  store i16 1996, i16* %arrayidx4.6, align 2, !tbaa !4
  %arrayidx.7 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 999
  store i16 999, i16* %arrayidx.7, align 2, !tbaa !4
  %arrayidx4.7 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 999
  store i16 1998, i16* %arrayidx4.7, align 2, !tbaa !4
  %11 = bitcast [1000 x i16]* %vla140 to <16 x i16>*
  %wide.load = load <16 x i16>, <16 x i16>* %11, align 2, !tbaa !4
  %12 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 16
  %13 = bitcast i16* %12 to <16 x i16>*
  %wide.load59 = load <16 x i16>, <16 x i16>* %13, align 2, !tbaa !4
  %14 = shl <16 x i16> %wide.load, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %15 = shl <16 x i16> %wide.load59, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %16 = bitcast [1000 x i16]* %vla39 to <16 x i16>*
  store <16 x i16> %14, <16 x i16>* %16, align 2, !tbaa !4
  %17 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 16
  %18 = bitcast i16* %17 to <16 x i16>*
  store <16 x i16> %15, <16 x i16>* %18, align 2, !tbaa !4
  %19 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 32
  %20 = bitcast i16* %19 to <16 x i16>*
  %wide.load.1 = load <16 x i16>, <16 x i16>* %20, align 2, !tbaa !4
  %21 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 48
  %22 = bitcast i16* %21 to <16 x i16>*
  %wide.load59.1 = load <16 x i16>, <16 x i16>* %22, align 2, !tbaa !4
  %23 = shl <16 x i16> %wide.load.1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %24 = shl <16 x i16> %wide.load59.1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %25 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 32
  %26 = bitcast i16* %25 to <16 x i16>*
  store <16 x i16> %23, <16 x i16>* %26, align 2, !tbaa !4
  %27 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 48
  %28 = bitcast i16* %27 to <16 x i16>*
  store <16 x i16> %24, <16 x i16>* %28, align 2, !tbaa !4
  %29 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 64
  %30 = bitcast i16* %29 to <16 x i16>*
  %wide.load.2 = load <16 x i16>, <16 x i16>* %30, align 2, !tbaa !4
  %31 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 80
  %32 = bitcast i16* %31 to <16 x i16>*
  %wide.load59.2 = load <16 x i16>, <16 x i16>* %32, align 2, !tbaa !4
  %33 = shl <16 x i16> %wide.load.2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %34 = shl <16 x i16> %wide.load59.2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %35 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 64
  %36 = bitcast i16* %35 to <16 x i16>*
  store <16 x i16> %33, <16 x i16>* %36, align 2, !tbaa !4
  %37 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 80
  %38 = bitcast i16* %37 to <16 x i16>*
  store <16 x i16> %34, <16 x i16>* %38, align 2, !tbaa !4
  %39 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 96
  %40 = bitcast i16* %39 to <16 x i16>*
  %wide.load.3 = load <16 x i16>, <16 x i16>* %40, align 2, !tbaa !4
  %41 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 112
  %42 = bitcast i16* %41 to <16 x i16>*
  %wide.load59.3 = load <16 x i16>, <16 x i16>* %42, align 2, !tbaa !4
  %43 = shl <16 x i16> %wide.load.3, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %44 = shl <16 x i16> %wide.load59.3, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %45 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 96
  %46 = bitcast i16* %45 to <16 x i16>*
  store <16 x i16> %43, <16 x i16>* %46, align 2, !tbaa !4
  %47 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 112
  %48 = bitcast i16* %47 to <16 x i16>*
  store <16 x i16> %44, <16 x i16>* %48, align 2, !tbaa !4
  %49 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 128
  %50 = bitcast i16* %49 to <16 x i16>*
  %wide.load.4 = load <16 x i16>, <16 x i16>* %50, align 2, !tbaa !4
  %51 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 144
  %52 = bitcast i16* %51 to <16 x i16>*
  %wide.load59.4 = load <16 x i16>, <16 x i16>* %52, align 2, !tbaa !4
  %53 = shl <16 x i16> %wide.load.4, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %54 = shl <16 x i16> %wide.load59.4, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %55 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 128
  %56 = bitcast i16* %55 to <16 x i16>*
  store <16 x i16> %53, <16 x i16>* %56, align 2, !tbaa !4
  %57 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 144
  %58 = bitcast i16* %57 to <16 x i16>*
  store <16 x i16> %54, <16 x i16>* %58, align 2, !tbaa !4
  %59 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 160
  %60 = bitcast i16* %59 to <16 x i16>*
  %wide.load.5 = load <16 x i16>, <16 x i16>* %60, align 2, !tbaa !4
  %61 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 176
  %62 = bitcast i16* %61 to <16 x i16>*
  %wide.load59.5 = load <16 x i16>, <16 x i16>* %62, align 2, !tbaa !4
  %63 = shl <16 x i16> %wide.load.5, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %64 = shl <16 x i16> %wide.load59.5, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %65 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 160
  %66 = bitcast i16* %65 to <16 x i16>*
  store <16 x i16> %63, <16 x i16>* %66, align 2, !tbaa !4
  %67 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 176
  %68 = bitcast i16* %67 to <16 x i16>*
  store <16 x i16> %64, <16 x i16>* %68, align 2, !tbaa !4
  %69 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 192
  %70 = bitcast i16* %69 to <16 x i16>*
  %wide.load.6 = load <16 x i16>, <16 x i16>* %70, align 2, !tbaa !4
  %71 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 208
  %72 = bitcast i16* %71 to <16 x i16>*
  %wide.load59.6 = load <16 x i16>, <16 x i16>* %72, align 2, !tbaa !4
  %73 = shl <16 x i16> %wide.load.6, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %74 = shl <16 x i16> %wide.load59.6, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %75 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 192
  %76 = bitcast i16* %75 to <16 x i16>*
  store <16 x i16> %73, <16 x i16>* %76, align 2, !tbaa !4
  %77 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 208
  %78 = bitcast i16* %77 to <16 x i16>*
  store <16 x i16> %74, <16 x i16>* %78, align 2, !tbaa !4
  %79 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 224
  %80 = bitcast i16* %79 to <16 x i16>*
  %wide.load.7 = load <16 x i16>, <16 x i16>* %80, align 2, !tbaa !4
  %81 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 240
  %82 = bitcast i16* %81 to <16 x i16>*
  %wide.load59.7 = load <16 x i16>, <16 x i16>* %82, align 2, !tbaa !4
  %83 = shl <16 x i16> %wide.load.7, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %84 = shl <16 x i16> %wide.load59.7, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %85 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 224
  %86 = bitcast i16* %85 to <16 x i16>*
  store <16 x i16> %83, <16 x i16>* %86, align 2, !tbaa !4
  %87 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 240
  %88 = bitcast i16* %87 to <16 x i16>*
  store <16 x i16> %84, <16 x i16>* %88, align 2, !tbaa !4
  %89 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 256
  %90 = bitcast i16* %89 to <16 x i16>*
  %wide.load.8 = load <16 x i16>, <16 x i16>* %90, align 2, !tbaa !4
  %91 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 272
  %92 = bitcast i16* %91 to <16 x i16>*
  %wide.load59.8 = load <16 x i16>, <16 x i16>* %92, align 2, !tbaa !4
  %93 = shl <16 x i16> %wide.load.8, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %94 = shl <16 x i16> %wide.load59.8, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %95 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 256
  %96 = bitcast i16* %95 to <16 x i16>*
  store <16 x i16> %93, <16 x i16>* %96, align 2, !tbaa !4
  %97 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 272
  %98 = bitcast i16* %97 to <16 x i16>*
  store <16 x i16> %94, <16 x i16>* %98, align 2, !tbaa !4
  %99 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 288
  %100 = bitcast i16* %99 to <16 x i16>*
  %wide.load.9 = load <16 x i16>, <16 x i16>* %100, align 2, !tbaa !4
  %101 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 304
  %102 = bitcast i16* %101 to <16 x i16>*
  %wide.load59.9 = load <16 x i16>, <16 x i16>* %102, align 2, !tbaa !4
  %103 = shl <16 x i16> %wide.load.9, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %104 = shl <16 x i16> %wide.load59.9, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %105 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 288
  %106 = bitcast i16* %105 to <16 x i16>*
  store <16 x i16> %103, <16 x i16>* %106, align 2, !tbaa !4
  %107 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 304
  %108 = bitcast i16* %107 to <16 x i16>*
  store <16 x i16> %104, <16 x i16>* %108, align 2, !tbaa !4
  %109 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 320
  %110 = bitcast i16* %109 to <16 x i16>*
  %wide.load.10 = load <16 x i16>, <16 x i16>* %110, align 2, !tbaa !4
  %111 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 336
  %112 = bitcast i16* %111 to <16 x i16>*
  %wide.load59.10 = load <16 x i16>, <16 x i16>* %112, align 2, !tbaa !4
  %113 = shl <16 x i16> %wide.load.10, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %114 = shl <16 x i16> %wide.load59.10, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %115 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 320
  %116 = bitcast i16* %115 to <16 x i16>*
  store <16 x i16> %113, <16 x i16>* %116, align 2, !tbaa !4
  %117 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 336
  %118 = bitcast i16* %117 to <16 x i16>*
  store <16 x i16> %114, <16 x i16>* %118, align 2, !tbaa !4
  %119 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 352
  %120 = bitcast i16* %119 to <16 x i16>*
  %wide.load.11 = load <16 x i16>, <16 x i16>* %120, align 2, !tbaa !4
  %121 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 368
  %122 = bitcast i16* %121 to <16 x i16>*
  %wide.load59.11 = load <16 x i16>, <16 x i16>* %122, align 2, !tbaa !4
  %123 = shl <16 x i16> %wide.load.11, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %124 = shl <16 x i16> %wide.load59.11, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %125 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 352
  %126 = bitcast i16* %125 to <16 x i16>*
  store <16 x i16> %123, <16 x i16>* %126, align 2, !tbaa !4
  %127 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 368
  %128 = bitcast i16* %127 to <16 x i16>*
  store <16 x i16> %124, <16 x i16>* %128, align 2, !tbaa !4
  %129 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 384
  %130 = bitcast i16* %129 to <16 x i16>*
  %wide.load.12 = load <16 x i16>, <16 x i16>* %130, align 2, !tbaa !4
  %131 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 400
  %132 = bitcast i16* %131 to <16 x i16>*
  %wide.load59.12 = load <16 x i16>, <16 x i16>* %132, align 2, !tbaa !4
  %133 = shl <16 x i16> %wide.load.12, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %134 = shl <16 x i16> %wide.load59.12, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %135 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 384
  %136 = bitcast i16* %135 to <16 x i16>*
  store <16 x i16> %133, <16 x i16>* %136, align 2, !tbaa !4
  %137 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 400
  %138 = bitcast i16* %137 to <16 x i16>*
  store <16 x i16> %134, <16 x i16>* %138, align 2, !tbaa !4
  %139 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 416
  %140 = bitcast i16* %139 to <16 x i16>*
  %wide.load.13 = load <16 x i16>, <16 x i16>* %140, align 2, !tbaa !4
  %141 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 432
  %142 = bitcast i16* %141 to <16 x i16>*
  %wide.load59.13 = load <16 x i16>, <16 x i16>* %142, align 2, !tbaa !4
  %143 = shl <16 x i16> %wide.load.13, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %144 = shl <16 x i16> %wide.load59.13, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %145 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 416
  %146 = bitcast i16* %145 to <16 x i16>*
  store <16 x i16> %143, <16 x i16>* %146, align 2, !tbaa !4
  %147 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 432
  %148 = bitcast i16* %147 to <16 x i16>*
  store <16 x i16> %144, <16 x i16>* %148, align 2, !tbaa !4
  %149 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 448
  %150 = bitcast i16* %149 to <16 x i16>*
  %wide.load.14 = load <16 x i16>, <16 x i16>* %150, align 2, !tbaa !4
  %151 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 464
  %152 = bitcast i16* %151 to <16 x i16>*
  %wide.load59.14 = load <16 x i16>, <16 x i16>* %152, align 2, !tbaa !4
  %153 = shl <16 x i16> %wide.load.14, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %154 = shl <16 x i16> %wide.load59.14, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %155 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 448
  %156 = bitcast i16* %155 to <16 x i16>*
  store <16 x i16> %153, <16 x i16>* %156, align 2, !tbaa !4
  %157 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 464
  %158 = bitcast i16* %157 to <16 x i16>*
  store <16 x i16> %154, <16 x i16>* %158, align 2, !tbaa !4
  %159 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 480
  %160 = bitcast i16* %159 to <16 x i16>*
  %wide.load.15 = load <16 x i16>, <16 x i16>* %160, align 2, !tbaa !4
  %161 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 496
  %162 = bitcast i16* %161 to <16 x i16>*
  %wide.load59.15 = load <16 x i16>, <16 x i16>* %162, align 2, !tbaa !4
  %163 = shl <16 x i16> %wide.load.15, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %164 = shl <16 x i16> %wide.load59.15, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %165 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 480
  %166 = bitcast i16* %165 to <16 x i16>*
  store <16 x i16> %163, <16 x i16>* %166, align 2, !tbaa !4
  %167 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 496
  %168 = bitcast i16* %167 to <16 x i16>*
  store <16 x i16> %164, <16 x i16>* %168, align 2, !tbaa !4
  %169 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 512
  %170 = bitcast i16* %169 to <16 x i16>*
  %wide.load.16 = load <16 x i16>, <16 x i16>* %170, align 2, !tbaa !4
  %171 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 528
  %172 = bitcast i16* %171 to <16 x i16>*
  %wide.load59.16 = load <16 x i16>, <16 x i16>* %172, align 2, !tbaa !4
  %173 = shl <16 x i16> %wide.load.16, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %174 = shl <16 x i16> %wide.load59.16, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %175 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 512
  %176 = bitcast i16* %175 to <16 x i16>*
  store <16 x i16> %173, <16 x i16>* %176, align 2, !tbaa !4
  %177 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 528
  %178 = bitcast i16* %177 to <16 x i16>*
  store <16 x i16> %174, <16 x i16>* %178, align 2, !tbaa !4
  %179 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 544
  %180 = bitcast i16* %179 to <16 x i16>*
  %wide.load.17 = load <16 x i16>, <16 x i16>* %180, align 2, !tbaa !4
  %181 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 560
  %182 = bitcast i16* %181 to <16 x i16>*
  %wide.load59.17 = load <16 x i16>, <16 x i16>* %182, align 2, !tbaa !4
  %183 = shl <16 x i16> %wide.load.17, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %184 = shl <16 x i16> %wide.load59.17, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %185 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 544
  %186 = bitcast i16* %185 to <16 x i16>*
  store <16 x i16> %183, <16 x i16>* %186, align 2, !tbaa !4
  %187 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 560
  %188 = bitcast i16* %187 to <16 x i16>*
  store <16 x i16> %184, <16 x i16>* %188, align 2, !tbaa !4
  %189 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 576
  %190 = bitcast i16* %189 to <16 x i16>*
  %wide.load.18 = load <16 x i16>, <16 x i16>* %190, align 2, !tbaa !4
  %191 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 592
  %192 = bitcast i16* %191 to <16 x i16>*
  %wide.load59.18 = load <16 x i16>, <16 x i16>* %192, align 2, !tbaa !4
  %193 = shl <16 x i16> %wide.load.18, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %194 = shl <16 x i16> %wide.load59.18, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %195 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 576
  %196 = bitcast i16* %195 to <16 x i16>*
  store <16 x i16> %193, <16 x i16>* %196, align 2, !tbaa !4
  %197 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 592
  %198 = bitcast i16* %197 to <16 x i16>*
  store <16 x i16> %194, <16 x i16>* %198, align 2, !tbaa !4
  %199 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 608
  %200 = bitcast i16* %199 to <16 x i16>*
  %wide.load.19 = load <16 x i16>, <16 x i16>* %200, align 2, !tbaa !4
  %201 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 624
  %202 = bitcast i16* %201 to <16 x i16>*
  %wide.load59.19 = load <16 x i16>, <16 x i16>* %202, align 2, !tbaa !4
  %203 = shl <16 x i16> %wide.load.19, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %204 = shl <16 x i16> %wide.load59.19, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %205 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 608
  %206 = bitcast i16* %205 to <16 x i16>*
  store <16 x i16> %203, <16 x i16>* %206, align 2, !tbaa !4
  %207 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 624
  %208 = bitcast i16* %207 to <16 x i16>*
  store <16 x i16> %204, <16 x i16>* %208, align 2, !tbaa !4
  %209 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 640
  %210 = bitcast i16* %209 to <16 x i16>*
  %wide.load.20 = load <16 x i16>, <16 x i16>* %210, align 2, !tbaa !4
  %211 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 656
  %212 = bitcast i16* %211 to <16 x i16>*
  %wide.load59.20 = load <16 x i16>, <16 x i16>* %212, align 2, !tbaa !4
  %213 = shl <16 x i16> %wide.load.20, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %214 = shl <16 x i16> %wide.load59.20, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %215 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 640
  %216 = bitcast i16* %215 to <16 x i16>*
  store <16 x i16> %213, <16 x i16>* %216, align 2, !tbaa !4
  %217 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 656
  %218 = bitcast i16* %217 to <16 x i16>*
  store <16 x i16> %214, <16 x i16>* %218, align 2, !tbaa !4
  %219 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 672
  %220 = bitcast i16* %219 to <16 x i16>*
  %wide.load.21 = load <16 x i16>, <16 x i16>* %220, align 2, !tbaa !4
  %221 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 688
  %222 = bitcast i16* %221 to <16 x i16>*
  %wide.load59.21 = load <16 x i16>, <16 x i16>* %222, align 2, !tbaa !4
  %223 = shl <16 x i16> %wide.load.21, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %224 = shl <16 x i16> %wide.load59.21, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %225 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 672
  %226 = bitcast i16* %225 to <16 x i16>*
  store <16 x i16> %223, <16 x i16>* %226, align 2, !tbaa !4
  %227 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 688
  %228 = bitcast i16* %227 to <16 x i16>*
  store <16 x i16> %224, <16 x i16>* %228, align 2, !tbaa !4
  %229 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 704
  %230 = bitcast i16* %229 to <16 x i16>*
  %wide.load.22 = load <16 x i16>, <16 x i16>* %230, align 2, !tbaa !4
  %231 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 720
  %232 = bitcast i16* %231 to <16 x i16>*
  %wide.load59.22 = load <16 x i16>, <16 x i16>* %232, align 2, !tbaa !4
  %233 = shl <16 x i16> %wide.load.22, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %234 = shl <16 x i16> %wide.load59.22, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %235 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 704
  %236 = bitcast i16* %235 to <16 x i16>*
  store <16 x i16> %233, <16 x i16>* %236, align 2, !tbaa !4
  %237 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 720
  %238 = bitcast i16* %237 to <16 x i16>*
  store <16 x i16> %234, <16 x i16>* %238, align 2, !tbaa !4
  %239 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 736
  %240 = bitcast i16* %239 to <16 x i16>*
  %wide.load.23 = load <16 x i16>, <16 x i16>* %240, align 2, !tbaa !4
  %241 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 752
  %242 = bitcast i16* %241 to <16 x i16>*
  %wide.load59.23 = load <16 x i16>, <16 x i16>* %242, align 2, !tbaa !4
  %243 = shl <16 x i16> %wide.load.23, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %244 = shl <16 x i16> %wide.load59.23, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %245 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 736
  %246 = bitcast i16* %245 to <16 x i16>*
  store <16 x i16> %243, <16 x i16>* %246, align 2, !tbaa !4
  %247 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 752
  %248 = bitcast i16* %247 to <16 x i16>*
  store <16 x i16> %244, <16 x i16>* %248, align 2, !tbaa !4
  %249 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 768
  %250 = bitcast i16* %249 to <16 x i16>*
  %wide.load.24 = load <16 x i16>, <16 x i16>* %250, align 2, !tbaa !4
  %251 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 784
  %252 = bitcast i16* %251 to <16 x i16>*
  %wide.load59.24 = load <16 x i16>, <16 x i16>* %252, align 2, !tbaa !4
  %253 = shl <16 x i16> %wide.load.24, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %254 = shl <16 x i16> %wide.load59.24, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %255 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 768
  %256 = bitcast i16* %255 to <16 x i16>*
  store <16 x i16> %253, <16 x i16>* %256, align 2, !tbaa !4
  %257 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 784
  %258 = bitcast i16* %257 to <16 x i16>*
  store <16 x i16> %254, <16 x i16>* %258, align 2, !tbaa !4
  %259 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 800
  %260 = bitcast i16* %259 to <16 x i16>*
  %wide.load.25 = load <16 x i16>, <16 x i16>* %260, align 2, !tbaa !4
  %261 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 816
  %262 = bitcast i16* %261 to <16 x i16>*
  %wide.load59.25 = load <16 x i16>, <16 x i16>* %262, align 2, !tbaa !4
  %263 = shl <16 x i16> %wide.load.25, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %264 = shl <16 x i16> %wide.load59.25, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %265 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 800
  %266 = bitcast i16* %265 to <16 x i16>*
  store <16 x i16> %263, <16 x i16>* %266, align 2, !tbaa !4
  %267 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 816
  %268 = bitcast i16* %267 to <16 x i16>*
  store <16 x i16> %264, <16 x i16>* %268, align 2, !tbaa !4
  %269 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 832
  %270 = bitcast i16* %269 to <16 x i16>*
  %wide.load.26 = load <16 x i16>, <16 x i16>* %270, align 2, !tbaa !4
  %271 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 848
  %272 = bitcast i16* %271 to <16 x i16>*
  %wide.load59.26 = load <16 x i16>, <16 x i16>* %272, align 2, !tbaa !4
  %273 = shl <16 x i16> %wide.load.26, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %274 = shl <16 x i16> %wide.load59.26, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %275 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 832
  %276 = bitcast i16* %275 to <16 x i16>*
  store <16 x i16> %273, <16 x i16>* %276, align 2, !tbaa !4
  %277 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 848
  %278 = bitcast i16* %277 to <16 x i16>*
  store <16 x i16> %274, <16 x i16>* %278, align 2, !tbaa !4
  %279 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 864
  %280 = bitcast i16* %279 to <16 x i16>*
  %wide.load.27 = load <16 x i16>, <16 x i16>* %280, align 2, !tbaa !4
  %281 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 880
  %282 = bitcast i16* %281 to <16 x i16>*
  %wide.load59.27 = load <16 x i16>, <16 x i16>* %282, align 2, !tbaa !4
  %283 = shl <16 x i16> %wide.load.27, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %284 = shl <16 x i16> %wide.load59.27, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %285 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 864
  %286 = bitcast i16* %285 to <16 x i16>*
  store <16 x i16> %283, <16 x i16>* %286, align 2, !tbaa !4
  %287 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 880
  %288 = bitcast i16* %287 to <16 x i16>*
  store <16 x i16> %284, <16 x i16>* %288, align 2, !tbaa !4
  %289 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 896
  %290 = bitcast i16* %289 to <16 x i16>*
  %wide.load.28 = load <16 x i16>, <16 x i16>* %290, align 2, !tbaa !4
  %291 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 912
  %292 = bitcast i16* %291 to <16 x i16>*
  %wide.load59.28 = load <16 x i16>, <16 x i16>* %292, align 2, !tbaa !4
  %293 = shl <16 x i16> %wide.load.28, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %294 = shl <16 x i16> %wide.load59.28, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %295 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 896
  %296 = bitcast i16* %295 to <16 x i16>*
  store <16 x i16> %293, <16 x i16>* %296, align 2, !tbaa !4
  %297 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 912
  %298 = bitcast i16* %297 to <16 x i16>*
  store <16 x i16> %294, <16 x i16>* %298, align 2, !tbaa !4
  %299 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 928
  %300 = bitcast i16* %299 to <16 x i16>*
  %wide.load.29 = load <16 x i16>, <16 x i16>* %300, align 2, !tbaa !4
  %301 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 944
  %302 = bitcast i16* %301 to <16 x i16>*
  %wide.load59.29 = load <16 x i16>, <16 x i16>* %302, align 2, !tbaa !4
  %303 = shl <16 x i16> %wide.load.29, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %304 = shl <16 x i16> %wide.load59.29, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %305 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 928
  %306 = bitcast i16* %305 to <16 x i16>*
  store <16 x i16> %303, <16 x i16>* %306, align 2, !tbaa !4
  %307 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 944
  %308 = bitcast i16* %307 to <16 x i16>*
  store <16 x i16> %304, <16 x i16>* %308, align 2, !tbaa !4
  %309 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 960
  %310 = bitcast i16* %309 to <16 x i16>*
  %wide.load.30 = load <16 x i16>, <16 x i16>* %310, align 2, !tbaa !4
  %311 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 976
  %312 = bitcast i16* %311 to <16 x i16>*
  %wide.load59.30 = load <16 x i16>, <16 x i16>* %312, align 2, !tbaa !4
  %313 = shl <16 x i16> %wide.load.30, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %314 = shl <16 x i16> %wide.load59.30, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %315 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 960
  %316 = bitcast i16* %315 to <16 x i16>*
  store <16 x i16> %313, <16 x i16>* %316, align 2, !tbaa !4
  %317 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 976
  %318 = bitcast i16* %317 to <16 x i16>*
  store <16 x i16> %314, <16 x i16>* %318, align 2, !tbaa !4
  %319 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla140, i64 0, i64 992
  %320 = bitcast i16* %319 to <8 x i16>*
  %wide.load64 = load <8 x i16>, <8 x i16>* %320, align 2, !tbaa !4
  %321 = shl <8 x i16> %wide.load64, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %322 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 992
  %323 = bitcast i16* %322 to <8 x i16>*
  store <8 x i16> %321, <8 x i16>* %323, align 2, !tbaa !4
  %arrayidx22 = getelementptr inbounds [1000 x i16], [1000 x i16]* %vla39, i64 0, i64 1000
  %324 = load i16, i16* %arrayidx22, align 2, !tbaa !4
  %conv23 = sext i16 %324 to i32
  ret i32 %conv23
}

attributes #0 = { nofree norecurse nosync nounwind readnone "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+64bit,+a,+c,+d,+f,+m,+v,+zvl128b,+zvl32b,+zvl64b" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"lp64d"}
!2 = !{i32 1, !"SmallDataLimit", i32 8}
!3 = !{!"clang version 14.0.6 (https://github.com/msyksphinz-self/llvm-project.git 9453981754b353ec7d739f968d1f89131bb27290)"}
!4 = !{!5, !5, i64 0}
!5 = !{!"short", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = distinct !{!8, !9, !10}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{!"llvm.loop.isvectorized", i32 1}
