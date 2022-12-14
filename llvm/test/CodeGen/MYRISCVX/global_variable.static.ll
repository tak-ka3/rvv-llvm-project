; RUN: llc --march=myriscvx32 --relocation-model=static --code-model=small < %s \
; RUN:   | FileCheck -check-prefix=MYRVX32I_STATIC_MEDLOW %s
; RUN: llc --march=myriscvx64 --relocation-model=static --code-model=small < %s \
; RUN:   | FileCheck -check-prefix=MYRVX64I_STATIC_MEDLOW %s
; RUN: llc --march=myriscvx32 --relocation-model=static --code-model=medium < %s \
; RUN:   | FileCheck -check-prefix=MYRVX32I_STATIC_MEDANY %s
; RUN: llc --march=myriscvx64 --relocation-model=static --code-model=medium < %s \
; RUN:   | FileCheck -check-prefix=MYRVX64I_STATIC_MEDANY %s

target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64-unknown-unknown-elf"

;; clang --static

@global_val = external dso_local local_unnamed_addr global i32, align 4

; Function Attrs: nofree norecurse nounwind
define dso_local void @update_global() local_unnamed_addr #0 {

; MYRVX32I_STATIC_MEDLOW-LABEL:update_global:
; MYRVX32I_STATIC_MEDLOW:      # %bb.0:
; MYRVX32I_STATIC_MEDLOW-NEXT:	lui	x10, %hi(global_val)
; MYRVX32I_STATIC_MEDLOW-NEXT:	addi	x10, x10, %lo(global_val)
; MYRVX32I_STATIC_MEDLOW-NEXT:	lw	x11, 0(x10)
; MYRVX32I_STATIC_MEDLOW-NEXT:	addi	x11, x11, 1
; MYRVX32I_STATIC_MEDLOW-NEXT:	sw	x11, 0(x10)
; MYRVX32I_STATIC_MEDLOW-NEXT:	ret

; MYRVX64I_STATIC_MEDLOW-LABEL:update_global:
; MYRVX64I_STATIC_MEDLOW:      # %bb.0:
; MYRVX64I_STATIC_MEDLOW-NEXT:	lui	x10, %hi(global_val)
; MYRVX64I_STATIC_MEDLOW-NEXT:	addi	x10, x10, %lo(global_val)
; MYRVX64I_STATIC_MEDLOW-NEXT:	lw	x11, 0(x10)
; MYRVX64I_STATIC_MEDLOW-NEXT:	addi	x11, x11, 1
; MYRVX64I_STATIC_MEDLOW-NEXT:	sw	x11, 0(x10)
; MYRVX64I_STATIC_MEDLOW-NEXT:	ret

; MYRVX32I_STATIC_MEDANY-LABEL:update_global:
; MYRVX32I_STATIC_MEDANY:      # %bb.0:
; MYRVX32I_STATIC_MEDANY-NEXT:	$BB0_1:                                 # %entry
; MYRVX32I_STATIC_MEDANY-NEXT:	                                # Label of block must be emitted
; MYRVX32I_STATIC_MEDANY-NEXT:	auipc   x10, %pcrel_hi(global_val)
; MYRVX32I_STATIC_MEDANY-NEXT:	addi    x10, x10, %pcrel_lo($BB0_1)
; MYRVX32I_STATIC_MEDANY-NEXT:	lw	x11, 0(x10)
; MYRVX32I_STATIC_MEDANY-NEXT:	addi	x11, x11, 1
; MYRVX32I_STATIC_MEDANY-NEXT:	sw	x11, 0(x10)
; MYRVX32I_STATIC_MEDANY-NEXT:	ret

; MYRVX64I_STATIC_MEDANY-LABEL:update_global:
; MYRVX64I_STATIC_MEDANY:      # %bb.0:
; MYRVX64I_STATIC_MEDANY-NEXT:	$BB0_1:                                 # %entry
; MYRVX64I_STATIC_MEDANY-NEXT:	                                # Label of block must be emitted
; MYRVX64I_STATIC_MEDANY-NEXT:	auipc   x10, %pcrel_hi(global_val)
; MYRVX64I_STATIC_MEDANY-NEXT:	addi    x10, x10, %pcrel_lo($BB0_1)
; MYRVX64I_STATIC_MEDANY-NEXT:	lw	x11, 0(x10)
; MYRVX64I_STATIC_MEDANY-NEXT:	addi	x11, x11, 1
; MYRVX64I_STATIC_MEDANY-NEXT:	sw	x11, 0(x10)
; MYRVX64I_STATIC_MEDANY-NEXT:	ret

entry:
  %0 = load i32, i32* @global_val, align 4, !tbaa !3
  %add = add nsw i32 %0, 1
  store i32 %add, i32* @global_val, align 4, !tbaa !3
  ret void
}


attributes #0 = { nofree norecurse nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="+a,+c,+m,+relax" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"lp64"}
!2 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git db54ce914efd241fed3f9f08616bc448997eaa96)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
