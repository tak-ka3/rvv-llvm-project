//===-- M68kInstrArithmetic.td - Integer Arith Instrs ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file describes the integer arithmetic instructions in the M68k
/// architecture. Here is the current status of the file:
///
///  Machine:
///
///    ADD       [~]   ADDA      [~]   ADDI        [~]   ADDQ [ ]   ADDX [~]
///    CLR       [ ]   CMP       [~]   CMPA        [~]   CMPI [~]   CMPM [ ]
///    CMP2      [ ]   DIVS/DIVU [~]   DIVSL/DIVUL [ ]   EXT  [~]   EXTB [ ]
///    MULS/MULU [~]   NEG       [~]   NEGX        [~]   SUB  [~]   SUBA [~]
///    SUBI      [~]   SUBQ      [ ]   SUBX        [~]
///
///  Map:
///
///   [ ] - was not touched at all
///   [!] - requires extarnal stuff implemented
///   [~] - functional implementation
///   [X] - complete implementation
///
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Encoding
//===----------------------------------------------------------------------===//

/// Encoding for Normal forms
/// ----------------------------------------------------
///  F  E  D  C | B  A  9 | 8  7  6 | 5  4  3 | 2  1  0
/// ----------------------------------------------------
///             |         |         | EFFECTIVE ADDRESS
///  x  x  x  x |   REG   | OP MODE |   MODE  |   REG
/// ----------------------------------------------------
class MxArithEncoding<MxBead4Bits CMD, MxEncOpMode OPMODE, MxBead REG,
                      MxEncEA EA, MxEncExt EXT>
    : MxEncoding<EA.Reg, EA.DA, EA.Mode, OPMODE.B0, OPMODE.B1, OPMODE.B2, REG,
                 CMD,EXT.Imm, EXT.B8, EXT.Scale, EXT.WL, EXT.DAReg>;

/// Encoding for Extended forms
/// ------------------------------------------------------
///  F  E  D  C | B  A  9 | 8 | 7  6 | 5  4 | 3 | 2  1  0
/// ------------------------------------------------------
///  x  x  x  x |  REG Rx | 1 | SIZE | 0  0 | M |  REG Ry
/// ------------------------------------------------------
/// Rx - destination
/// Ry - source
/// M  - address mode switch
class MxArithXEncoding<MxBead4Bits CMD, MxEncSize SIZE, MxBead1Bit MODE,
                       MxBeadDReg SRC, MxBeadDReg DST>
    : MxEncoding<SRC, MODE, MxBead2Bits<0b00>, SIZE, MxBead1Bit<0b1>, DST, CMD>;

/// Encoding for Immediate forms
/// ---------------------------------------------------
///  F  E  D  C  B  A  9  8 | 7  6 | 5  4  3 | 2  1  0
/// ---------------------------------------------------
///                         |      | EFFECTIVE ADDRESS
///  x  x  x  x  x  x  x  x | SIZE |   MODE  |   REG
/// ---------------------------------------------------
///     16-BIT WORD DATA    |     8-BIT BYTE DATA
/// ---------------------------------------------------
///                 32-BIT LONG DATA
/// ---------------------------------------------------
/// NOTE It is used to store an immediate to memory, imm-to-reg are handled with
/// normal version
class MxArithImmEncoding<MxBead4Bits CMD, MxEncSize SIZE,
                         MxEncEA DST_EA, MxEncExt DST_EXT, MxEncExt SRC_EXT>
    : MxEncoding<DST_EA.Reg, DST_EA.DA, DST_EA.Mode, SIZE, CMD, MxBead4Bits<0>,
                 // Source
                 SRC_EXT.Imm, SRC_EXT.B8, SRC_EXT.Scale,
                 SRC_EXT.WL, SRC_EXT.DAReg,
                 // Destination
                 DST_EXT.Imm, DST_EXT.B8, DST_EXT.Scale,
                 DST_EXT.WL, DST_EXT.DAReg>;


//===----------------------------------------------------------------------===//
// Add/Sub
//===----------------------------------------------------------------------===//

let Defs = [CCR] in {
let Constraints = "$src = $dst" in {

// $reg, $ccr <- $reg op $reg
class MxBiArOp_RFRR_xEA<string MN, SDNode NODE, MxType DST_TYPE, MxType SRC_TYPE,
                        bits<4> CMD, MxBead REG>
    : MxInst<(outs DST_TYPE.ROp:$dst), (ins DST_TYPE.ROp:$src, SRC_TYPE.ROp:$opd),
             MN#"."#DST_TYPE.Prefix#"\t$opd, $dst",
             [(set DST_TYPE.VT:$dst, CCR, (NODE DST_TYPE.VT:$src, SRC_TYPE.VT:$opd))],
             MxArithEncoding<MxBead4Bits<CMD>,
                             !cast<MxEncOpMode>("MxOpMode"#DST_TYPE.Size#DST_TYPE.RLet#"EA"),
                             REG,
                             !cast<MxEncEA>("MxEncEA"#SRC_TYPE.RLet#"_2"),
                             MxExtEmpty>>;

/// This Op is similar to the one above except it uses reversed opmode, some
/// commands(e.g. eor) do not support dEA or rEA modes and require EAd for
/// register only operations.
/// NOTE when using dd commands it is irrelevant which opmode to use(as it seems)
/// but some opcodes support address register and some do not which creates this
/// mess.
class MxBiArOp_RFRR_EAd<string MN, SDNode NODE, MxType TYPE, bits<4> CMD>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src, TYPE.ROp:$opd),
             MN#"."#TYPE.Prefix#"\t$opd, $dst",
             [(set TYPE.VT:$dst, CCR, (NODE TYPE.VT:$src, TYPE.VT:$opd))],
             MxArithEncoding<MxBead4Bits<CMD>,
                             !cast<MxEncOpMode>("MxOpMode"#TYPE.Size#"EAd"),
                             MxBeadDReg<2>, MxEncEAd_0, MxExtEmpty>>;

// $reg <- $reg op $imm
class MxBiArOp_RFRI_xEA<string MN, SDNode NODE, MxType TYPE, bits<4> CMD>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src, TYPE.IOp:$opd),
             MN#"."#TYPE.Prefix#"\t$opd, $dst",
             [(set TYPE.VT:$dst, CCR, (NODE TYPE.VT:$src, TYPE.IPat:$opd))],
             MxArithEncoding<MxBead4Bits<CMD>,
                             !cast<MxEncOpMode>("MxOpMode"#TYPE.Size#TYPE.RLet#"EA"),
                             MxBeadDReg<0>, MxEncEAi,
                             !cast<MxEncExt>("MxExtI"#TYPE.Size#"_2")>>;

// Again, there are two ways to write an immediate to Dn register either dEA
// opmode or using *I encoding, and again some instrucitons also support address
// registers some do not.
class MxBiArOp_RFRI<string MN, SDNode NODE, MxType TYPE, bits<4> CMD>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src, TYPE.IOp:$opd),
             MN#"i."#TYPE.Prefix#"\t$opd, $dst",
             [(set TYPE.VT:$dst, CCR, (NODE TYPE.VT:$src, TYPE.IPat:$opd))],
             MxArithImmEncoding<MxBead4Bits<CMD>, !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                                !cast<MxEncEA>("MxEncEA"#TYPE.RLet#"_0"), MxExtEmpty,
                                !cast<MxEncExt>("MxExtI"#TYPE.Size#"_2")>>;

let mayLoad = 1 in
class MxBiArOp_RFRM<string MN, SDNode NODE, MxType TYPE, MxOperand OPD, ComplexPattern PAT,
                    bits<4> CMD, MxEncEA EA, MxEncExt EXT>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src, OPD:$opd),
             MN#"."#TYPE.Prefix#"\t$opd, $dst",
             [(set TYPE.VT:$dst, CCR, (NODE TYPE.VT:$src, (TYPE.Load PAT:$opd)))],
             MxArithEncoding<MxBead4Bits<CMD>,
                             !cast<MxEncOpMode>("MxOpMode"#TYPE.Size#TYPE.RLet#"EA"),
                             MxBeadDReg<0>, EA, EXT>>;

} // Constraints

let mayLoad = 1, mayStore = 1 in {

// FIXME MxBiArOp_FMR/FMI cannot consume CCR from MxAdd/MxSub which leads for
// MxAdd to survive the match and subsequent mismatch.
class MxBiArOp_FMR<string MN, MxType TYPE, MxOperand MEMOpd,
                   bits<4> CMD, MxEncEA EA, MxEncExt EXT>
    : MxInst<(outs), (ins MEMOpd:$dst, TYPE.ROp:$opd),
             MN#"."#TYPE.Prefix#"\t$opd, $dst",
             [],
             MxArithEncoding<MxBead4Bits<CMD>,
                             !cast<MxEncOpMode>("MxOpMode"#TYPE.Size#"EA"#TYPE.RLet),
                             MxBeadDReg<1>, EA, EXT>>;

class MxBiArOp_FMI<string MN, MxType TYPE, MxOperand MEMOpd,
                   bits<4> CMD, MxEncEA MEMEA, MxEncExt MEMExt>
    : MxInst<(outs), (ins MEMOpd:$dst, TYPE.IOp:$opd),
             MN#"."#TYPE.Prefix#"\t$opd, $dst",
             [],
             MxArithImmEncoding<MxBead4Bits<CMD>,
                                !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                                MEMEA, MEMExt,
                                !cast<MxEncExt>("MxExtI"#TYPE.Size#"_1")>>;
} // mayLoad, mayStore
} // Defs = [CCR]

multiclass MxBiArOp_DF<string MN, SDNode NODE, bit isComm,
                       bits<4> CMD, bits<4> CMDI> {

  // op $mem, $reg
  def NAME#"8dk"  : MxBiArOp_RFRM<MN, NODE, MxType8d,  MxType8.KOp,  MxType8.KPat,
                                  CMD, MxEncEAk, MxExtBrief_2>;
  def NAME#"16dk" : MxBiArOp_RFRM<MN, NODE, MxType16d, MxType16.KOp, MxType16.KPat,
                                  CMD, MxEncEAk, MxExtBrief_2>;
  def NAME#"32dk" : MxBiArOp_RFRM<MN, NODE, MxType32d, MxType32.KOp, MxType32.KPat,
                                  CMD, MxEncEAk, MxExtBrief_2>;

  def NAME#"8dq"  : MxBiArOp_RFRM<MN, NODE, MxType8d,  MxType8.QOp,  MxType8.QPat,
                                  CMD, MxEncEAq, MxExtI16_2>;
  def NAME#"16dq" : MxBiArOp_RFRM<MN, NODE, MxType16d, MxType16.QOp, MxType16.QPat,
                                  CMD, MxEncEAq, MxExtI16_2>;
  def NAME#"32dq" : MxBiArOp_RFRM<MN, NODE, MxType32d, MxType32.QOp, MxType32.QPat,
                                  CMD, MxEncEAq, MxExtI16_2>;

  def NAME#"8dp"  : MxBiArOp_RFRM<MN, NODE, MxType8d,  MxType8.POp,  MxType8.PPat,
                                  CMD, MxEncEAp_2, MxExtI16_2>;
  def NAME#"16dp" : MxBiArOp_RFRM<MN, NODE, MxType16d, MxType16.POp, MxType16.PPat,
                                  CMD, MxEncEAp_2, MxExtI16_2>;
  def NAME#"32dp" : MxBiArOp_RFRM<MN, NODE, MxType32d, MxType32.POp, MxType32.PPat,
                                  CMD, MxEncEAp_2, MxExtI16_2>;

  def NAME#"8df"  : MxBiArOp_RFRM<MN, NODE, MxType8d,  MxType8.FOp,  MxType8.FPat,
                                  CMD, MxEncEAf_2, MxExtBrief_2>;
  def NAME#"16df" : MxBiArOp_RFRM<MN, NODE, MxType16d, MxType16.FOp, MxType16.FPat,
                                  CMD, MxEncEAf_2, MxExtBrief_2>;
  def NAME#"32df" : MxBiArOp_RFRM<MN, NODE, MxType32d, MxType32.FOp, MxType32.FPat,
                                  CMD, MxEncEAf_2, MxExtBrief_2>;

  def NAME#"8dj"  : MxBiArOp_RFRM<MN, NODE, MxType8d,  MxType8.JOp,  MxType8.JPat,
                                  CMD, MxEncEAj_2, MxExtEmpty>;
  def NAME#"16dj" : MxBiArOp_RFRM<MN, NODE, MxType16d, MxType16.JOp, MxType16.JPat,
                                  CMD, MxEncEAj_2, MxExtEmpty>;
  def NAME#"32dj" : MxBiArOp_RFRM<MN, NODE, MxType32d, MxType32.JOp, MxType32.JPat,
                                  CMD, MxEncEAj_2, MxExtEmpty>;

  // op $imm, $reg
  def NAME#"8di"  : MxBiArOp_RFRI_xEA<MN, NODE, MxType8d,  CMD>;
  def NAME#"16di" : MxBiArOp_RFRI_xEA<MN, NODE, MxType16d, CMD>;
  def NAME#"32di" : MxBiArOp_RFRI_xEA<MN, NODE, MxType32d, CMD>;

  // op $reg, $mem
  def NAME#"8pd"  : MxBiArOp_FMR<MN, MxType8d,  MxType8.POp,
                                 CMD, MxEncEAp_0, MxExtI16_0>;
  def NAME#"16pd" : MxBiArOp_FMR<MN, MxType16d, MxType16.POp,
                                 CMD, MxEncEAp_0, MxExtI16_0>;
  def NAME#"32pd" : MxBiArOp_FMR<MN, MxType32d, MxType32.POp,
                                 CMD, MxEncEAp_0, MxExtI16_0>;

  def NAME#"8fd"  : MxBiArOp_FMR<MN, MxType8d,  MxType8.FOp,
                                 CMD, MxEncEAf_0, MxExtBrief_0>;
  def NAME#"16fd" : MxBiArOp_FMR<MN, MxType16d, MxType16.FOp,
                                 CMD, MxEncEAf_0, MxExtBrief_0>;
  def NAME#"32fd" : MxBiArOp_FMR<MN, MxType32d, MxType32.FOp,
                                 CMD, MxEncEAf_0, MxExtBrief_0>;

  def NAME#"8jd"  : MxBiArOp_FMR<MN, MxType8d,  MxType8.JOp,
                                 CMD, MxEncEAj_0, MxExtEmpty>;
  def NAME#"16jd" : MxBiArOp_FMR<MN, MxType16d, MxType16.JOp,
                                 CMD, MxEncEAj_0, MxExtEmpty>;
  def NAME#"32jd" : MxBiArOp_FMR<MN, MxType32d, MxType32.JOp,
                                 CMD, MxEncEAj_0, MxExtEmpty>;

  // op $imm, $mem
  def NAME#"8pi"  : MxBiArOp_FMI<MN, MxType8,  MxType8.POp,
                                 CMDI, MxEncEAp_0, MxExtI16_0>;
  def NAME#"16pi" : MxBiArOp_FMI<MN, MxType16, MxType16.POp,
                                 CMDI, MxEncEAp_0, MxExtI16_0>;
  def NAME#"32pi" : MxBiArOp_FMI<MN, MxType32, MxType32.POp,
                                 CMDI, MxEncEAp_0, MxExtI16_0>;

  def NAME#"8fi"  : MxBiArOp_FMI<MN, MxType8,  MxType8.FOp,
                                 CMDI, MxEncEAf_0, MxExtBrief_0>;
  def NAME#"16fi" : MxBiArOp_FMI<MN, MxType16, MxType16.FOp,
                                 CMDI, MxEncEAf_0, MxExtBrief_0>;
  def NAME#"32fi" : MxBiArOp_FMI<MN, MxType32, MxType32.FOp,
                                 CMDI, MxEncEAf_0, MxExtBrief_0>;

  def NAME#"8ji"  : MxBiArOp_FMI<MN, MxType8,  MxType8.JOp,
                                 CMDI, MxEncEAj_0, MxExtEmpty>;
  def NAME#"16ji" : MxBiArOp_FMI<MN, MxType16, MxType16.JOp,
                                 CMDI, MxEncEAj_0, MxExtEmpty>;
  def NAME#"32ji" : MxBiArOp_FMI<MN, MxType32, MxType32.JOp,
                                 CMDI, MxEncEAj_0, MxExtEmpty>;

  def NAME#"16dr" : MxBiArOp_RFRR_xEA<MN, NODE, MxType16d, MxType16r,
                                      CMD, MxBeadDReg<0>>;
  def NAME#"32dr" : MxBiArOp_RFRR_xEA<MN, NODE, MxType32d, MxType32r,
                                      CMD, MxBeadDReg<0>>;

  let isCommutable = isComm in {

    def NAME#"8dd"  : MxBiArOp_RFRR_xEA<MN, NODE, MxType8d, MxType8d,
                                        CMD, MxBeadDReg<0>>;
    def NAME#"16dd" : MxBiArOp_RFRR_xEA<MN, NODE, MxType16d, MxType16d,
                                        CMD, MxBeadDReg<0>>;
    def NAME#"32dd" : MxBiArOp_RFRR_xEA<MN, NODE, MxType32d, MxType32d,
                                        CMD, MxBeadDReg<0>>;

  } // isComm

} // MxBiArOp_DF


// These special snowflakes allowed to match address registers but since *A
// operations do not produce CCR we should not match them against Mx nodes that
// produce it.
let Pattern = [(null_frag)] in
multiclass MxBiArOp_AF<string MN, SDNode NODE, bits<4> CMD> {

  def NAME#"32ak" : MxBiArOp_RFRM<MN, NODE, MxType32a, MxType32.KOp, MxType32.KPat,
                                  CMD, MxEncEAk, MxExtBrief_2>;
  def NAME#"32aq" : MxBiArOp_RFRM<MN, NODE, MxType32a, MxType32.QOp, MxType32.QPat,
                                  CMD, MxEncEAq, MxExtI16_2>;
  def NAME#"32af" : MxBiArOp_RFRM<MN, NODE, MxType32a, MxType32.FOp, MxType32.FPat,
                                  CMD, MxEncEAf_2, MxExtBrief_2>;
  def NAME#"32ap" : MxBiArOp_RFRM<MN, NODE, MxType32a, MxType32.POp, MxType32.PPat,
                                  CMD, MxEncEAp_2, MxExtI16_2>;
  def NAME#"32aj" : MxBiArOp_RFRM<MN, NODE, MxType32a, MxType32.JOp, MxType32.JPat,
                                  CMD, MxEncEAj_2, MxExtEmpty>;
  def NAME#"32ai" : MxBiArOp_RFRI_xEA<MN, NODE, MxType32a, CMD>;

  def NAME#"32ar" : MxBiArOp_RFRR_xEA<MN, NODE, MxType32a, MxType32r,
                                      CMD, MxBeadReg<0>>;

} // MxBiArOp_AF

// NOTE These naturally produce CCR

defm ADD : MxBiArOp_DF<"add",  MxAdd, 1, 0xD, 0x6>;
defm ADD : MxBiArOp_AF<"adda", MxAdd, 0xD>;
defm SUB : MxBiArOp_DF<"sub",  MxSub, 0, 0x9, 0x4>;
defm SUB : MxBiArOp_AF<"suba", MxSub, 0x9>;


let Uses = [CCR], Defs = [CCR] in {
let Constraints = "$src = $dst" in {

// $reg, ccr <- $reg op $reg op ccr
class MxBiArOp_RFRRF<string MN, SDNode NODE, MxType TYPE, bits<4> CMD>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src, TYPE.ROp:$opd),
             MN#"."#TYPE.Prefix#"\t$opd, $dst",
             [(set TYPE.VT:$dst, CCR, (NODE TYPE.VT:$src, TYPE.VT:$opd, CCR))],
             MxArithXEncoding<MxBead4Bits<CMD>,
                              !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                              MxBead1Bit<0>, MxBeadDReg<2>, MxBeadDReg<0>>>;

} // Constraints
} // Uses, Defs

multiclass MxBiArOp_RFF<string MN, SDNode NODE, bit isComm, bits<4> CMD> {

let isCommutable = isComm in {

  def NAME#"8dd"  : MxBiArOp_RFRRF<MN, NODE, MxType8d,  CMD>;
  def NAME#"16dd" : MxBiArOp_RFRRF<MN, NODE, MxType16d, CMD>;
  def NAME#"32dd" : MxBiArOp_RFRRF<MN, NODE, MxType32d, CMD>;

} // isComm

} // MxBiArOp_RFF

// NOTE These consume and produce CCR
defm ADDX : MxBiArOp_RFF<"addx", MxAddX, 1, 0xD>;
defm SUBX : MxBiArOp_RFF<"subx", MxSubX, 0, 0x9>;


//===----------------------------------------------------------------------===//
// And/Xor/Or
//===----------------------------------------------------------------------===//

defm AND : MxBiArOp_DF<"and", MxAnd, 1, 0xC, 0x2>;
defm OR  : MxBiArOp_DF<"or",  MxOr,  1, 0x8, 0x0>;

multiclass MxBiArOp_DF_EAd<string MN, SDNode NODE, bits<4> CMD, bits<4> CMDI> {

  let isCommutable = 1 in {

  def NAME#"8dd"  : MxBiArOp_RFRR_EAd<MN, NODE, MxType8d,  CMD>;
  def NAME#"16dd" : MxBiArOp_RFRR_EAd<MN, NODE, MxType16d, CMD>;
  def NAME#"32dd" : MxBiArOp_RFRR_EAd<MN, NODE, MxType32d, CMD>;

  } // isCommutable = 1

  def NAME#"8di"  : MxBiArOp_RFRI<MN, NODE,  MxType8d, CMDI>;
  def NAME#"16di" : MxBiArOp_RFRI<MN, NODE, MxType16d, CMDI>;
  def NAME#"32di" : MxBiArOp_RFRI<MN, NODE, MxType32d, CMDI>;

} // MxBiArOp_DF_EAd

defm XOR : MxBiArOp_DF_EAd<"eor", MxXor, 0xB, 0xA>;


//===----------------------------------------------------------------------===//
// CMP
//===----------------------------------------------------------------------===//

let Defs = [CCR] in {
class MxCmp_RR<MxType LHS_TYPE, MxType RHS_TYPE = LHS_TYPE,
               MxBead REG = MxBeadDReg<1>>
    : MxInst<(outs), (ins LHS_TYPE.ROp:$lhs, RHS_TYPE.ROp:$rhs),
             "cmp."#RHS_TYPE.Prefix#"\t$lhs, $rhs",
             [(set CCR, (MxCmp LHS_TYPE.VT:$lhs, RHS_TYPE.VT:$rhs))],
             MxArithEncoding<MxBead4Bits<0xB>,
                             !cast<MxEncOpMode>("MxOpMode"#RHS_TYPE.Size#RHS_TYPE.RLet#"EA"),
                             REG,
                             !cast<MxEncEA>("MxEncEA"#LHS_TYPE.RLet#"_0"),
                             MxExtEmpty>>;

class MxCmp_RI<MxType TYPE>
    : MxInst<(outs), (ins TYPE.IOp:$imm, TYPE.ROp:$reg),
             "cmpi."#TYPE.Prefix#"\t$imm, $reg",
             [(set CCR, (MxCmp TYPE.IPat:$imm, TYPE.VT:$reg))],
             MxArithImmEncoding<MxBead4Bits<0xC>,
                                !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                                MxEncEAd_1, MxExtEmpty,
                                !cast<MxEncExt>("MxExtI"#TYPE.Size#"_0")>>;

let mayLoad = 1 in {

class MxCmp_MI<MxType TYPE, MxOperand MEMOpd, ComplexPattern MEMPat,
               MxEncEA EA, MxEncExt EXT>
    : MxInst<(outs), (ins TYPE.IOp:$imm, MEMOpd:$mem),
             "cmpi."#TYPE.Prefix#"\t$imm, $mem",
             [(set CCR, (MxCmp TYPE.IPat:$imm, (load MEMPat:$mem)))],
             MxArithImmEncoding<MxBead4Bits<0xC>,
                                !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                                EA, EXT,
                                !cast<MxEncExt>("MxExtI"#TYPE.Size#"_0")>>;

class MxCmp_BI<MxType TYPE>
    : MxInst<(outs), (ins TYPE.IOp:$imm, MxAL32:$abs),
             "cmpi."#TYPE.Prefix#"\t$imm, $abs",
             [(set CCR, (MxCmp TYPE.IPat:$imm,
                               (load (i32 (MxWrapper tglobaladdr:$abs)))))],
             MxArithImmEncoding<MxBead4Bits<0xC>,
                                !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                                MxEncEAb, MxExtI32_1,
                                !cast<MxEncExt>("MxExtI"#TYPE.Size#"_0")>>;

class MxCmp_RM<MxType TYPE, MxOperand MEMOpd, ComplexPattern MEMPat,
               MxEncEA EA, MxEncExt EXT>
    : MxInst<(outs), (ins TYPE.ROp:$reg, MEMOpd:$mem),
             "cmp."#TYPE.Prefix#"\t$mem, $reg",
             [(set CCR, (MxCmp (load MEMPat:$mem), TYPE.ROp:$reg))],
             MxArithEncoding<MxBead4Bits<0xB>,
                             !cast<MxEncOpMode>("MxOpMode"#TYPE.Size#"dEA"),
                             MxBeadDReg<0>, EA, EXT>>;
} // let mayLoad = 1

} // let Defs = [CCR]

multiclass MMxCmp_RM<MxType TYPE> {
  def NAME#TYPE.KOp.Letter : MxCmp_RM<TYPE, TYPE.KOp, TYPE.KPat, MxEncEAk,
                                      MxExtBrief_1>;
  def NAME#TYPE.QOp.Letter : MxCmp_RM<TYPE, TYPE.QOp, TYPE.QPat, MxEncEAq,
                                      MxExtI16_1>;
  def NAME#TYPE.POp.Letter : MxCmp_RM<TYPE, TYPE.POp, TYPE.PPat, MxEncEAp_1,
                                      MxExtI16_1>;
  def NAME#TYPE.FOp.Letter : MxCmp_RM<TYPE, TYPE.FOp, TYPE.FPat, MxEncEAf_1,
                                      MxExtBrief_1>;
  def NAME#TYPE.JOp.Letter : MxCmp_RM<TYPE, TYPE.JOp, TYPE.JPat, MxEncEAj_1,
                                      MxExtEmpty>;
}

multiclass MMxCmp_MI<MxType TYPE> {
  def NAME#TYPE.KOp.Letter#"i" : MxCmp_MI<TYPE, TYPE.KOp, TYPE.KPat, MxEncEAk,
                                          MxExtBrief_1>;
  def NAME#TYPE.QOp.Letter#"i" : MxCmp_MI<TYPE, TYPE.QOp, TYPE.QPat, MxEncEAq,
                                          MxExtI16_1>;
  def NAME#TYPE.POp.Letter#"i" : MxCmp_MI<TYPE, TYPE.POp, TYPE.PPat, MxEncEAp_1,
                                          MxExtI16_1>;
  def NAME#TYPE.FOp.Letter#"i" : MxCmp_MI<TYPE, TYPE.FOp, TYPE.FPat, MxEncEAf_1,
                                          MxExtBrief_1>;
  def NAME#TYPE.JOp.Letter#"i" : MxCmp_MI<TYPE, TYPE.JOp, TYPE.JPat, MxEncEAj_1,
                                          MxExtEmpty>;
}

foreach S = [8, 16, 32] in {
  def CMP#S#di : MxCmp_RI<!cast<MxType>("MxType"#S#"d")>;
  def CMP#S#bi : MxCmp_BI<!cast<MxType>("MxType"#S#"d")>;
} // foreach

def CMP8dd : MxCmp_RR<MxType8d>;
foreach S = [16, 32] in {
  def CMP#S#dr : MxCmp_RR<!cast<MxType>("MxType"#S#"r"),
                          !cast<MxType>("MxType"#S#"d")>;
}

// cmp mem, Dn
defm CMP8d  : MMxCmp_RM<MxType8d>;
defm CMP16d : MMxCmp_RM<MxType16d>;
defm CMP32d : MMxCmp_RM<MxType32d>;

// cmp #imm, mem
defm CMP8  : MMxCmp_MI<MxType8d>;
defm CMP16 : MMxCmp_MI<MxType16d>;
defm CMP32 : MMxCmp_MI<MxType32d>;


//===----------------------------------------------------------------------===//
// EXT
//===----------------------------------------------------------------------===//

def MxExtOpmode_wb : MxBead3Bits<0b010>;
def MxExtOpmode_lw : MxBead3Bits<0b011>;
def MxExtOpmode_lb : MxBead3Bits<0b111>;

/// ---------------------------------------------------
///  F  E  D  C  B  A  9 | 8  7  6 | 5  4  3 | 2  1  0
/// ---------------------------------------------------
///  0  1  0  0  1  0  0 |  OPMODE | 0  0  0 |   REG
/// ---------------------------------------------------
class MxExtEncoding<MxBead3Bits OPMODE>
    : MxEncoding<MxBeadDReg<0>, MxBead3Bits<0b000>, OPMODE,
                 MxBead3Bits<0b100>, MxBead4Bits<0b0100>>;

let Defs = [CCR] in
let Constraints = "$src = $dst" in
class MxExt<MxType TO, MxType FROM>
    : MxInst<(outs TO.ROp:$dst), (ins TO.ROp:$src),
             "ext."#TO.Prefix#"\t$src", [],
             MxExtEncoding<!cast<MxBead3Bits>("MxExtOpmode_"#TO.Prefix#FROM.Prefix)>>;

def EXT16 : MxExt<MxType16d, MxType8d>;
def EXT32 : MxExt<MxType32d, MxType16d>;

def : Pat<(sext_inreg i16:$src, i8),  (EXT16 $src)>;
def : Pat<(sext_inreg i32:$src, i16), (EXT32 $src)>;
def : Pat<(sext_inreg i32:$src, i8),
          (EXT32 (MOVXd32d16 (EXT16 (EXTRACT_SUBREG $src, MxSubRegIndex16Lo))))>;


//===----------------------------------------------------------------------===//
// DIV/MUL
//===----------------------------------------------------------------------===//

def MxSDiMuOpmode : MxBead3Bits<0b111>;
def MxUDiMuOpmode : MxBead3Bits<0b011>;

/// Word operation:
/// ----------------------------------------------------
///  F  E  D  C | B  A  9 | 8  7  6 | 5  4  3 | 2  1  0
/// ----------------------------------------------------
///             |         |         | EFFECTIVE ADDRESS
///  x  x  x  x |   REG   | OP MODE |   MODE  |   REG
/// ----------------------------------------------------
class MxDiMuEncoding<MxBead4Bits CMD, MxBead3Bits OPMODE, MxEncEA EA, MxEncExt EXT>
    : MxEncoding<EA.Reg, EA.DA, EA.Mode, OPMODE, MxBeadDReg<0>, CMD,
                 EXT.Imm, EXT.B8, EXT.Scale, EXT.WL, EXT.DAReg>;

let Defs = [CCR] in {
let Constraints = "$src = $dst" in {
// $reg <- $reg op $reg
class MxDiMuOp_DD<string MN, bits<4> CMD, MxBead3Bits OPMODE,
                  MxOperand DST, MxOperand OPD>
    : MxInst<(outs DST:$dst), (ins DST:$src, OPD:$opd), MN#"\t$opd, $dst", [],
             MxDiMuEncoding<MxBead4Bits<CMD>, OPMODE, MxEncEAd_2, MxExtEmpty>>;

// $reg <- $reg op $imm
class MxDiMuOp_DI<string MN, bits<4> CMD, MxBead3Bits OPMODE,
                  MxOperand DST, MxOperand OPD>
    : MxInst<(outs DST:$dst), (ins DST:$src, OPD:$opd), MN#"\t$opd, $dst", [],
             MxDiMuEncoding<MxBead4Bits<CMD>, OPMODE, MxEncEAi, MxExtI16_2>>;
} // let Constraints
} // Defs = [CCR]

multiclass MxDiMuOp<string MN, bits<4> CMD, bit isComm = 0> {

  let isCommutable = isComm in {
    def "S"#NAME#"d32d16" : MxDiMuOp_DD<MN#"s", CMD, MxSDiMuOpmode, MxDRD32,
                                        MxDRD16>;
    def "U"#NAME#"d32d16" : MxDiMuOp_DD<MN#"u", CMD, MxUDiMuOpmode, MxDRD32,
                                        MxDRD16>;
  }

  def "S"#NAME#"d32i16" : MxDiMuOp_DI<MN#"s", CMD, MxSDiMuOpmode, MxDRD32,
                                      Mxi16imm>;
  def "U"#NAME#"d32i16" : MxDiMuOp_DI<MN#"u", CMD, MxUDiMuOpmode, MxDRD32,
                                      Mxi16imm>;

}

defm DIV : MxDiMuOp<"div", 0x8>;

// This is used to cast immediates to 16-bits for operations which don't
// support smaller immediate sizes.
def as_i16imm : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(N->getSExtValue(), SDLoc(N), MVT::i16);
}]>;

// RR i8
def : Pat<(sdiv i8:$dst, i8:$opd),
          (EXTRACT_SUBREG
            (SDIVd32d16 (MOVSXd32d8 $dst), (MOVSXd16d8 $opd)),
             MxSubRegIndex8Lo)>;

def : Pat<(udiv i8:$dst, i8:$opd),
          (EXTRACT_SUBREG
            (UDIVd32d16 (MOVZXd32d8 $dst), (MOVZXd16d8 $opd)),
             MxSubRegIndex8Lo)>;

def : Pat<(srem i8:$dst, i8:$opd),
          (EXTRACT_SUBREG
            (ASR32di (ASR32di (SDIVd32d16 (MOVSXd32d8 $dst), (MOVSXd16d8 $opd)), 8), 8),
             MxSubRegIndex8Lo)>;

def : Pat<(urem i8:$dst, i8:$opd),
          (EXTRACT_SUBREG
            (LSR32di (LSR32di (UDIVd32d16 (MOVZXd32d8 $dst), (MOVZXd16d8 $opd)), 8), 8),
             MxSubRegIndex8Lo)>;

// RR i16
def : Pat<(sdiv i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (SDIVd32d16 (MOVSXd32d16 $dst), $opd),
             MxSubRegIndex16Lo)>;

def : Pat<(udiv i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (UDIVd32d16 (MOVZXd32d16 $dst), $opd),
             MxSubRegIndex16Lo)>;

def : Pat<(srem i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (ASR32di (ASR32di (SDIVd32d16 (MOVSXd32d16 $dst), $opd), 8), 8),
             MxSubRegIndex16Lo)>;

def : Pat<(urem i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (LSR32di (LSR32di (UDIVd32d16 (MOVZXd32d16 $dst), $opd), 8), 8),
             MxSubRegIndex16Lo)>;


// RI i8
def : Pat<(sdiv i8:$dst, MximmSExt8:$opd),
          (EXTRACT_SUBREG
            (SDIVd32i16 (MOVSXd32d8 $dst), (as_i16imm $opd)),
             MxSubRegIndex8Lo)>;

def : Pat<(udiv i8:$dst, MximmSExt8:$opd),
          (EXTRACT_SUBREG
            (UDIVd32i16 (MOVZXd32d8 $dst), (as_i16imm $opd)),
             MxSubRegIndex8Lo)>;

def : Pat<(srem i8:$dst, MximmSExt8:$opd),
          (EXTRACT_SUBREG
            (ASR32di (ASR32di (SDIVd32i16 (MOVSXd32d8 $dst), (as_i16imm $opd)), 8), 8),
             MxSubRegIndex8Lo)>;

def : Pat<(urem i8:$dst, MximmSExt8:$opd),
          (EXTRACT_SUBREG
            (LSR32di (LSR32di (UDIVd32i16 (MOVZXd32d8 $dst), (as_i16imm $opd)), 8), 8),
             MxSubRegIndex8Lo)>;

// RI i16
def : Pat<(sdiv i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (SDIVd32i16 (MOVSXd32d16 $dst), imm:$opd),
             MxSubRegIndex16Lo)>;

def : Pat<(udiv i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (UDIVd32i16 (MOVZXd32d16 $dst), imm:$opd),
             MxSubRegIndex16Lo)>;

def : Pat<(srem i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (ASR32di (ASR32di (SDIVd32i16 (MOVSXd32d16 $dst), imm:$opd), 8), 8),
             MxSubRegIndex16Lo)>;

def : Pat<(urem i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (LSR32di (LSR32di (UDIVd32i16 (MOVZXd32d16 $dst), imm:$opd), 8), 8),
             MxSubRegIndex16Lo)>;


defm MUL : MxDiMuOp<"mul", 0xC, 1>;

// RR
def : Pat<(mul i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (SMULd32d16 (MOVXd32d16 $dst), $opd),
             MxSubRegIndex16Lo)>;

def : Pat<(mulhs i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (ASR32di (ASR32di (SMULd32d16 (MOVXd32d16 $dst), $opd), 8), 8),
             MxSubRegIndex16Lo)>;

def : Pat<(mulhu i16:$dst, i16:$opd),
          (EXTRACT_SUBREG
            (LSR32di (LSR32di (UMULd32d16 (MOVXd32d16 $dst), $opd), 8), 8),
             MxSubRegIndex16Lo)>;


// RI
def : Pat<(mul i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (SMULd32i16 (MOVXd32d16 $dst), imm:$opd),
             MxSubRegIndex16Lo)>;

def : Pat<(mulhs i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (ASR32di (ASR32di (SMULd32i16 (MOVXd32d16 $dst), imm:$opd), 8), 8),
             MxSubRegIndex16Lo)>;

def : Pat<(mulhu i16:$dst, MximmSExt16:$opd),
          (EXTRACT_SUBREG
            (LSR32di (LSR32di (UMULd32i16 (MOVXd32d16 $dst), imm:$opd), 8), 8),
             MxSubRegIndex16Lo)>;


//===----------------------------------------------------------------------===//
// NEG/NEGX
//===----------------------------------------------------------------------===//

/// ------------+------------+------+---------+---------
///  F  E  D  C | B  A  9  8 | 7  6 | 5  4  3 | 2  1  0
/// ------------+------------+------+-------------------
///             |            |      | EFFECTIVE ADDRESS
///  0  1  0  0 | x  x  x  x | SIZE |   MODE  |   REG
/// ------------+------------+------+---------+---------
class MxNEGEncoding<MxBead4Bits CMD, MxEncSize SIZE, MxEncEA EA, MxEncExt EXT>
    : MxEncoding<EA.Reg, EA.DA, EA.Mode, SIZE, CMD, MxBead4Bits<0b0100>,
                 EXT.Imm, EXT.B8, EXT.Scale, EXT.WL, EXT.DAReg>;

let Defs = [CCR] in {
let Constraints = "$src = $dst" in {

class MxNeg_D<MxType TYPE>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src),
             "neg."#TYPE.Prefix#"\t$dst",
             [(set TYPE.VT:$dst, (ineg TYPE.VT:$src))],
             MxNEGEncoding<MxBead4Bits<0x4>,
                           !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                           MxEncEAd_0, MxExtEmpty>>;

let Uses = [CCR] in {
class MxNegX_D<MxType TYPE>
    : MxInst<(outs TYPE.ROp:$dst), (ins TYPE.ROp:$src),
             "negx."#TYPE.Prefix#"\t$dst",
             [(set TYPE.VT:$dst, (MxSubX 0, TYPE.VT:$src, CCR))],
             MxNEGEncoding<MxBead4Bits<0x0>,
                           !cast<MxEncSize>("MxEncSize"#TYPE.Size),
                           MxEncEAd_0, MxExtEmpty>>;
}

} // let Constraints
} // let Defs = [CCR]

foreach S = [8, 16, 32] in {
  def NEG#S#d  : MxNeg_D<!cast<MxType>("MxType"#S#"d")>;
  def NEGX#S#d : MxNegX_D<!cast<MxType>("MxType"#S#"d")>;
}

def : Pat<(MxSub 0, i8 :$src), (NEG8d  MxDRD8 :$src)>;
def : Pat<(MxSub 0, i16:$src), (NEG16d MxDRD16:$src)>;
def : Pat<(MxSub 0, i32:$src), (NEG32d MxDRD32:$src)>;

//===----------------------------------------------------------------------===//
// no-CCR Patterns
//===----------------------------------------------------------------------===//

/// Basically the reason for this stuff is that add and addc share the same
/// operand types constraints for whatever reasons and I had to define a common
/// MxAdd and MxSub instructions that produce CCR and then pattern-map add and addc
/// to it.
/// NOTE On the other hand I see no reason why I cannot just drop explicit CCR
/// result. Anyway works for now, hopefully I will better understand how this stuff
/// is designed later
foreach N = ["add", "addc"] in {

  // add reg, reg
  def : Pat<(!cast<SDNode>(N) i8 :$src, i8 :$opd),
            (ADD8dd  MxDRD8 :$src, MxDRD8 :$opd)>;
  def : Pat<(!cast<SDNode>(N) i16:$src, i16:$opd),
            (ADD16dr MxXRD16:$src, MxDRD16:$opd)>;
  def : Pat<(!cast<SDNode>(N) i32:$src, i32:$opd),
            (ADD32dr MxXRD32:$src, MxDRD32:$opd)>;

  // add (An), reg
  def : Pat<(!cast<SDNode>(N) MxType8.VT:$src, (Mxloadi8 MxType8.JPat:$opd)),
            (ADD8dj MxDRD8:$src, MxType8.JOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType16.VT:$src, (Mxloadi16 MxType16.JPat:$opd)),
            (ADD16dj MxDRD16:$src, MxType16.JOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType32.VT:$src, (Mxloadi32 MxType32.JPat:$opd)),
            (ADD32dj MxDRD32:$src, MxType32.JOp:$opd)>;

  // add (i,An), reg
  def : Pat<(!cast<SDNode>(N) MxType8.VT:$src, (Mxloadi8 MxType8.PPat:$opd)),
            (ADD8dp MxDRD8:$src, MxType8.POp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType16.VT:$src, (Mxloadi16 MxType16.PPat:$opd)),
            (ADD16dp MxDRD16:$src, MxType16.POp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType32.VT:$src, (Mxloadi32 MxType32.PPat:$opd)),
            (ADD32dp MxDRD32:$src, MxType32.POp:$opd)>;

  // add (i,An,Xn), reg
  def : Pat<(!cast<SDNode>(N) MxType8.VT:$src, (Mxloadi8 MxType8.FPat:$opd)),
            (ADD8df MxDRD8:$src, MxType8.FOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType16.VT:$src, (Mxloadi16 MxType16.FPat:$opd)),
            (ADD16df MxDRD16:$src, MxType16.FOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType32.VT:$src, (Mxloadi32 MxType32.FPat:$opd)),
            (ADD32df MxDRD32:$src, MxType32.FOp:$opd)>;

  // add reg, imm
  def : Pat<(!cast<SDNode>(N) i8: $src, MximmSExt8:$opd),
            (ADD8di  MxDRD8 :$src, imm:$opd)>;
  def : Pat<(!cast<SDNode>(N) i16:$src, MximmSExt16:$opd),
            (ADD16di MxDRD16:$src, imm:$opd)>;

  // LEAp is more complex and thus will be selected over normal ADD32ri but it cannot
  // be used with data registers, here by adding complexity to a simple ADD32ri insts
  // we make sure it will be selected over LEAp
  let AddedComplexity = 15 in {
  def : Pat<(!cast<SDNode>(N) i32:$src, MximmSExt32:$opd),
            (ADD32di MxDRD32:$src, imm:$opd)>;
  } // AddedComplexity = 15

  // add imm, (An)
  def : Pat<(store (!cast<SDNode>(N) (load MxType8.JPat:$dst), MxType8.IPat:$opd),
                   MxType8.JPat:$dst),
            (ADD8ji MxType8.JOp:$dst, imm:$opd)>;
  def : Pat<(store (!cast<SDNode>(N) (load MxType16.JPat:$dst), MxType16.IPat:$opd),
                   MxType16.JPat:$dst),
            (ADD16ji MxType16.JOp:$dst, imm:$opd)>;
  def : Pat<(store (!cast<SDNode>(N) (load MxType32.JPat:$dst), MxType32.IPat:$opd),
                   MxType32.JPat:$dst),
            (ADD32ji MxType32.JOp:$dst, imm:$opd)>;

} // foreach add, addc

def : Pat<(adde i8 :$src, i8 :$opd), (ADDX8dd  MxDRD8 :$src, MxDRD8 :$opd)>;
def : Pat<(adde i16:$src, i16:$opd), (ADDX16dd MxDRD16:$src, MxDRD16:$opd)>;
def : Pat<(adde i32:$src, i32:$opd), (ADDX32dd MxDRD32:$src, MxDRD32:$opd)>;



foreach N = ["sub", "subc"] in {

  // sub reg, reg
  def : Pat<(!cast<SDNode>(N) i8 :$src, i8 :$opd),
            (SUB8dd  MxDRD8 :$src, MxDRD8 :$opd)>;
  def : Pat<(!cast<SDNode>(N) i16:$src, i16:$opd),
            (SUB16dd MxDRD16:$src, MxDRD16:$opd)>;
  def : Pat<(!cast<SDNode>(N) i32:$src, i32:$opd),
            (SUB32dd MxDRD32:$src, MxDRD32:$opd)>;


  // sub (An), reg
  def : Pat<(!cast<SDNode>(N) MxType8.VT:$src, (Mxloadi8 MxType8.JPat:$opd)),
            (SUB8dj MxDRD8:$src, MxType8.JOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType16.VT:$src, (Mxloadi16 MxType16.JPat:$opd)),
            (SUB16dj MxDRD16:$src, MxType16.JOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType32.VT:$src, (Mxloadi32 MxType32.JPat:$opd)),
            (SUB32dj MxDRD32:$src, MxType32.JOp:$opd)>;

  // sub (i,An), reg
  def : Pat<(!cast<SDNode>(N) MxType8.VT:$src, (Mxloadi8 MxType8.PPat:$opd)),
            (SUB8dp MxDRD8:$src, MxType8.POp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType16.VT:$src, (Mxloadi16 MxType16.PPat:$opd)),
            (SUB16dp MxDRD16:$src, MxType16.POp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType32.VT:$src, (Mxloadi32 MxType32.PPat:$opd)),
            (SUB32dp MxDRD32:$src, MxType32.POp:$opd)>;

  // sub (i,An,Xn), reg
  def : Pat<(!cast<SDNode>(N) MxType8.VT:$src, (Mxloadi8 MxType8.FPat:$opd)),
            (SUB8df MxDRD8:$src, MxType8.FOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType16.VT:$src, (Mxloadi16 MxType16.FPat:$opd)),
            (SUB16df MxDRD16:$src, MxType16.FOp:$opd)>;
  def : Pat<(!cast<SDNode>(N) MxType32.VT:$src, (Mxloadi32 MxType32.FPat:$opd)),
            (SUB32df MxDRD32:$src, MxType32.FOp:$opd)>;

  // sub reg, imm
  def : Pat<(!cast<SDNode>(N) i8 :$src, MximmSExt8 :$opd),
            (SUB8di  MxDRD8 :$src, imm:$opd)>;
  def : Pat<(!cast<SDNode>(N) i16:$src, MximmSExt16:$opd),
            (SUB16di MxDRD16:$src, imm:$opd)>;
  def : Pat<(!cast<SDNode>(N) i32:$src, MximmSExt32:$opd),
            (SUB32di MxDRD32:$src, imm:$opd)>;

  // sub imm, (An)
  def : Pat<(store (!cast<SDNode>(N) (load MxType8.JPat:$dst), MxType8.IPat:$opd),
                   MxType8.JPat:$dst),
            (SUB8ji MxType8.JOp:$dst, imm:$opd)>;
  def : Pat<(store (!cast<SDNode>(N) (load MxType16.JPat:$dst), MxType16.IPat:$opd),
                   MxType16.JPat:$dst),
            (SUB16ji MxType16.JOp:$dst, imm:$opd)>;
  def : Pat<(store (!cast<SDNode>(N) (load MxType32.JPat:$dst), MxType32.IPat:$opd),
                   MxType32.JPat:$dst),
            (SUB32ji MxType32.JOp:$dst, imm:$opd)>;

} // foreach sub, subx

def : Pat<(sube i8 :$src, i8 :$opd), (SUBX8dd  MxDRD8 :$src, MxDRD8 :$opd)>;
def : Pat<(sube i16:$src, i16:$opd), (SUBX16dd MxDRD16:$src, MxDRD16:$opd)>;
def : Pat<(sube i32:$src, i32:$opd), (SUBX32dd MxDRD32:$src, MxDRD32:$opd)>;

multiclass BitwisePat<string INST, SDNode OP> {
  // op reg, reg
  def : Pat<(OP i8 :$src, i8 :$opd),
            (!cast<MxInst>(INST#"8dd")  MxDRD8 :$src, MxDRD8 :$opd)>;
  def : Pat<(OP i16:$src, i16:$opd),
            (!cast<MxInst>(INST#"16dd") MxDRD16:$src, MxDRD16:$opd)>;
  def : Pat<(OP i32:$src, i32:$opd),
            (!cast<MxInst>(INST#"32dd") MxDRD32:$src, MxDRD32:$opd)>;
  // op reg, imm
  def : Pat<(OP i8: $src, MximmSExt8 :$opd),
            (!cast<MxInst>(INST#"8di")  MxDRD8 :$src, imm:$opd)>;
  def : Pat<(OP i16:$src, MximmSExt16:$opd),
            (!cast<MxInst>(INST#"16di") MxDRD16:$src, imm:$opd)>;
  def : Pat<(OP i32:$src, MximmSExt32:$opd),
            (!cast<MxInst>(INST#"32di") MxDRD32:$src, imm:$opd)>;
}

defm : BitwisePat<"AND", and>;
defm : BitwisePat<"OR",  or>;
defm : BitwisePat<"XOR", xor>;
