//===- AArch64SchedPredicates.td - AArch64 Sched Preds -----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines scheduling predicate definitions that are used by the
// AArch64 subtargets.
//
//===----------------------------------------------------------------------===//

// Function mappers.

// Check the extension type in arithmetic instructions.
let FunctionMapper = "AArch64_AM::getArithExtendType" in {
  def CheckExtUXTB                      : CheckImmOperand_s<3, "AArch64_AM::UXTB">;
  def CheckExtUXTH                      : CheckImmOperand_s<3, "AArch64_AM::UXTH">;
  def CheckExtUXTW                      : CheckImmOperand_s<3, "AArch64_AM::UXTW">;
  def CheckExtUXTX                      : CheckImmOperand_s<3, "AArch64_AM::UXTX">;
  def CheckExtSXTB                      : CheckImmOperand_s<3, "AArch64_AM::SXTB">;
  def CheckExtSXTH                      : CheckImmOperand_s<3, "AArch64_AM::SXTH">;
  def CheckExtSXTW                      : CheckImmOperand_s<3, "AArch64_AM::SXTW">;
  def CheckExtSXTX                      : CheckImmOperand_s<3, "AArch64_AM::SXTX">;
}

// Check for shifting in extended arithmetic instructions.
foreach I = {0-3} in {
  let FunctionMapper = "AArch64_AM::getArithShiftValue" in
  def CheckExtBy#I                      : CheckImmOperand<3, I>;
}

// Check the extension type in the register offset addressing mode.
let FunctionMapper = "AArch64_AM::getMemExtendType" in {
  def CheckMemExtUXTW                   : CheckImmOperand_s<3, "AArch64_AM::UXTW">;
  def CheckMemExtLSL                    : CheckImmOperand_s<3, "AArch64_AM::UXTX">;
  def CheckMemExtSXTW                   : CheckImmOperand_s<3, "AArch64_AM::SXTW">;
  def CheckMemExtSXTX                   : CheckImmOperand_s<3, "AArch64_AM::SXTX">;
}

// Check for scaling in the register offset addressing mode.
let FunctionMapper = "AArch64_AM::getMemDoShift" in
def CheckMemScaled                      : CheckImmOperandSimple<4>;

// Check the shifting type in arithmetic and logic instructions.
let FunctionMapper = "AArch64_AM::getShiftType" in {
  def CheckShiftLSL                : CheckImmOperand_s<3, "AArch64_AM::LSL">;
  def CheckShiftLSR                : CheckImmOperand_s<3, "AArch64_AM::LSR">;
  def CheckShiftASR                : CheckImmOperand_s<3, "AArch64_AM::ASR">;
  def CheckShiftROR                : CheckImmOperand_s<3, "AArch64_AM::ROR">;
  def CheckShiftMSL                : CheckImmOperand_s<3, "AArch64_AM::MSL">;
}

// Check for shifting in arithmetic and logic instructions.
foreach I = {0-4, 8} in {
  let FunctionMapper = "AArch64_AM::getShiftValue" in
  def CheckShiftBy#I        : CheckImmOperand<3, I>;
}

// Generic predicates.

// Identify whether an instruction is the 16-bit NEON form based on its result.
def CheckHForm             : CheckAll<[CheckIsRegOperand<0>,
                                       CheckAny<[CheckRegOperand<0, H0>,
                                                 CheckRegOperand<0, H1>,
                                                 CheckRegOperand<0, H2>,
                                                 CheckRegOperand<0, H3>,
                                                 CheckRegOperand<0, H4>,
                                                 CheckRegOperand<0, H5>,
                                                 CheckRegOperand<0, H6>,
                                                 CheckRegOperand<0, H7>,
                                                 CheckRegOperand<0, H8>,
                                                 CheckRegOperand<0, H9>,
                                                 CheckRegOperand<0, H10>,
                                                 CheckRegOperand<0, H11>,
                                                 CheckRegOperand<0, H12>,
                                                 CheckRegOperand<0, H13>,
                                                 CheckRegOperand<0, H14>,
                                                 CheckRegOperand<0, H15>,
                                                 CheckRegOperand<0, H16>,
                                                 CheckRegOperand<0, H17>,
                                                 CheckRegOperand<0, H18>,
                                                 CheckRegOperand<0, H19>,
                                                 CheckRegOperand<0, H20>,
                                                 CheckRegOperand<0, H21>,
                                                 CheckRegOperand<0, H22>,
                                                 CheckRegOperand<0, H23>,
                                                 CheckRegOperand<0, H24>,
                                                 CheckRegOperand<0, H25>,
                                                 CheckRegOperand<0, H26>,
                                                 CheckRegOperand<0, H27>,
                                                 CheckRegOperand<0, H28>,
                                                 CheckRegOperand<0, H29>,
                                                 CheckRegOperand<0, H30>,
                                                 CheckRegOperand<0, H31>]>]>;

// Identify whether an instruction is the 32-bit NEON form based on its result.
def CheckSForm             : CheckAll<[CheckIsRegOperand<0>,
                                       CheckAny<[CheckRegOperand<0, S0>,
                                                 CheckRegOperand<0, S1>,
                                                 CheckRegOperand<0, S2>,
                                                 CheckRegOperand<0, S3>,
                                                 CheckRegOperand<0, S4>,
                                                 CheckRegOperand<0, S5>,
                                                 CheckRegOperand<0, S6>,
                                                 CheckRegOperand<0, S7>,
                                                 CheckRegOperand<0, S8>,
                                                 CheckRegOperand<0, S9>,
                                                 CheckRegOperand<0, S10>,
                                                 CheckRegOperand<0, S11>,
                                                 CheckRegOperand<0, S12>,
                                                 CheckRegOperand<0, S13>,
                                                 CheckRegOperand<0, S14>,
                                                 CheckRegOperand<0, S15>,
                                                 CheckRegOperand<0, S16>,
                                                 CheckRegOperand<0, S17>,
                                                 CheckRegOperand<0, S18>,
                                                 CheckRegOperand<0, S19>,
                                                 CheckRegOperand<0, S20>,
                                                 CheckRegOperand<0, S21>,
                                                 CheckRegOperand<0, S22>,
                                                 CheckRegOperand<0, S23>,
                                                 CheckRegOperand<0, S24>,
                                                 CheckRegOperand<0, S25>,
                                                 CheckRegOperand<0, S26>,
                                                 CheckRegOperand<0, S27>,
                                                 CheckRegOperand<0, S28>,
                                                 CheckRegOperand<0, S29>,
                                                 CheckRegOperand<0, S30>,
                                                 CheckRegOperand<0, S31>]>]>;

// Identify whether an instruction is the 64-bit NEON form based on its result.
def CheckDForm             : CheckAll<[CheckIsRegOperand<0>,
                                       CheckAny<[CheckRegOperand<0, D0>,
                                                 CheckRegOperand<0, D1>,
                                                 CheckRegOperand<0, D2>,
                                                 CheckRegOperand<0, D3>,
                                                 CheckRegOperand<0, D4>,
                                                 CheckRegOperand<0, D5>,
                                                 CheckRegOperand<0, D6>,
                                                 CheckRegOperand<0, D7>,
                                                 CheckRegOperand<0, D8>,
                                                 CheckRegOperand<0, D9>,
                                                 CheckRegOperand<0, D10>,
                                                 CheckRegOperand<0, D11>,
                                                 CheckRegOperand<0, D12>,
                                                 CheckRegOperand<0, D13>,
                                                 CheckRegOperand<0, D14>,
                                                 CheckRegOperand<0, D15>,
                                                 CheckRegOperand<0, D16>,
                                                 CheckRegOperand<0, D17>,
                                                 CheckRegOperand<0, D18>,
                                                 CheckRegOperand<0, D19>,
                                                 CheckRegOperand<0, D20>,
                                                 CheckRegOperand<0, D21>,
                                                 CheckRegOperand<0, D22>,
                                                 CheckRegOperand<0, D23>,
                                                 CheckRegOperand<0, D24>,
                                                 CheckRegOperand<0, D25>,
                                                 CheckRegOperand<0, D26>,
                                                 CheckRegOperand<0, D27>,
                                                 CheckRegOperand<0, D28>,
                                                 CheckRegOperand<0, D29>,
                                                 CheckRegOperand<0, D30>,
                                                 CheckRegOperand<0, D31>]>]>;

// Identify whether an instruction is the 128-bit NEON form based on its result.
def CheckQForm             : CheckAll<[CheckIsRegOperand<0>,
                                       CheckAny<[CheckRegOperand<0, Q0>,
                                                 CheckRegOperand<0, Q1>,
                                                 CheckRegOperand<0, Q2>,
                                                 CheckRegOperand<0, Q3>,
                                                 CheckRegOperand<0, Q4>,
                                                 CheckRegOperand<0, Q5>,
                                                 CheckRegOperand<0, Q6>,
                                                 CheckRegOperand<0, Q7>,
                                                 CheckRegOperand<0, Q8>,
                                                 CheckRegOperand<0, Q9>,
                                                 CheckRegOperand<0, Q10>,
                                                 CheckRegOperand<0, Q11>,
                                                 CheckRegOperand<0, Q12>,
                                                 CheckRegOperand<0, Q13>,
                                                 CheckRegOperand<0, Q14>,
                                                 CheckRegOperand<0, Q15>,
                                                 CheckRegOperand<0, Q16>,
                                                 CheckRegOperand<0, Q17>,
                                                 CheckRegOperand<0, Q18>,
                                                 CheckRegOperand<0, Q19>,
                                                 CheckRegOperand<0, Q20>,
                                                 CheckRegOperand<0, Q21>,
                                                 CheckRegOperand<0, Q22>,
                                                 CheckRegOperand<0, Q23>,
                                                 CheckRegOperand<0, Q24>,
                                                 CheckRegOperand<0, Q25>,
                                                 CheckRegOperand<0, Q26>,
                                                 CheckRegOperand<0, Q27>,
                                                 CheckRegOperand<0, Q28>,
                                                 CheckRegOperand<0, Q29>,
                                                 CheckRegOperand<0, Q30>,
                                                 CheckRegOperand<0, Q31>]>]>;

// Identify arithmetic instructions with extend.
def IsArithExtOp           : CheckOpcode<[ADDWrx, ADDXrx, ADDSWrx, ADDSXrx,
                                          SUBWrx, SUBXrx, SUBSWrx, SUBSXrx,
                                          ADDXrx64, ADDSXrx64,
                                          SUBXrx64, SUBSXrx64]>;

// Identify arithmetic immediate instructions.
def IsArithImmOp           : CheckOpcode<[ADDWri, ADDXri, ADDSWri, ADDSXri,
                                          SUBWri, SUBXri, SUBSWri, SUBSXri]>;

// Identify arithmetic instructions with shift.
def IsArithShiftOp         : CheckOpcode<[ADDWrs, ADDXrs, ADDSWrs, ADDSXrs,
                                          SUBWrs, SUBXrs, SUBSWrs, SUBSXrs]>;

// Identify arithmetic instructions without shift.
def IsArithUnshiftOp       : CheckOpcode<[ADDWrr, ADDXrr, ADDSWrr, ADDSXrr,
                                          SUBWrr, SUBXrr, SUBSWrr, SUBSXrr]>;

// Identify logic immediate instructions.
def IsLogicImmOp           : CheckOpcode<[ANDWri, ANDXri,
                                          EORWri, EORXri,
                                          ORRWri, ORRXri]>;

// Identify logic instructions with shift.
def IsLogicShiftOp         : CheckOpcode<[ANDWrs, ANDXrs, ANDSWrs, ANDSXrs,
                                          BICWrs, BICXrs, BICSWrs, BICSXrs,
                                          EONWrs, EONXrs,
                                          EORWrs, EORXrs,
                                          ORNWrs, ORNXrs,
                                          ORRWrs, ORRXrs]>;

// Identify logic instructions without shift.
def IsLogicUnshiftOp       : CheckOpcode<[ANDWrr, ANDXrr, ANDSWrr, ANDSXrr,
                                          BICWrr, BICXrr, BICSWrr, BICSXrr,
                                          EONWrr, EONXrr,
                                          EORWrr, EORXrr,
                                          ORNWrr, ORNXrr,
                                          ORRWrr, ORRXrr]>;

// Identify arithmetic and logic immediate instructions.
def IsArithLogicImmOp      : CheckOpcode<!listconcat(IsArithImmOp.ValidOpcodes,
                                                     IsLogicImmOp.ValidOpcodes)>;

// Identify arithmetic and logic instructions with shift.
def IsArithLogicShiftOp    : CheckOpcode<!listconcat(IsArithShiftOp.ValidOpcodes,
                                                     IsLogicShiftOp.ValidOpcodes)>;

// Identify arithmetic and logic instructions without shift.
def IsArithLogicUnshiftOp  : CheckOpcode<!listconcat(IsArithUnshiftOp.ValidOpcodes,
                                                     IsLogicUnshiftOp.ValidOpcodes)>;

// Identify whether an instruction is an ASIMD
// load using the post index addressing mode.
def IsLoadASIMDPostOp      : CheckOpcode<[LD1Onev8b_POST, LD1Onev4h_POST, LD1Onev2s_POST, LD1Onev1d_POST,
                                          LD1Onev16b_POST, LD1Onev8h_POST, LD1Onev4s_POST, LD1Onev2d_POST,
                                          LD1Twov8b_POST, LD1Twov4h_POST, LD1Twov2s_POST, LD1Twov1d_POST,
                                          LD1Twov16b_POST, LD1Twov8h_POST, LD1Twov4s_POST, LD1Twov2d_POST,
                                          LD1Threev8b_POST, LD1Threev4h_POST, LD1Threev2s_POST, LD1Threev1d_POST,
                                          LD1Threev16b_POST, LD1Threev8h_POST, LD1Threev4s_POST, LD1Threev2d_POST,
                                          LD1Fourv8b_POST, LD1Fourv4h_POST, LD1Fourv2s_POST, LD1Fourv1d_POST,
                                          LD1Fourv16b_POST, LD1Fourv8h_POST, LD1Fourv4s_POST, LD1Fourv2d_POST,
                                          LD1i8_POST, LD1i16_POST, LD1i32_POST, LD1i64_POST,
                                          LD1Rv8b_POST, LD1Rv4h_POST, LD1Rv2s_POST, LD1Rv1d_POST,
                                          LD1Rv16b_POST, LD1Rv8h_POST, LD1Rv4s_POST, LD1Rv2d_POST,
                                          LD2Twov8b_POST, LD2Twov4h_POST, LD2Twov2s_POST,
                                          LD2Twov16b_POST, LD2Twov8h_POST, LD2Twov4s_POST, LD2Twov2d_POST,
                                          LD2i8_POST, LD2i16_POST, LD2i32_POST, LD2i64_POST,
                                          LD2Rv8b_POST, LD2Rv4h_POST, LD2Rv2s_POST, LD2Rv1d_POST,
                                          LD2Rv16b_POST, LD2Rv8h_POST, LD2Rv4s_POST, LD2Rv2d_POST,
                                          LD3Threev8b_POST, LD3Threev4h_POST, LD3Threev2s_POST,
                                          LD3Threev16b_POST, LD3Threev8h_POST, LD3Threev4s_POST, LD3Threev2d_POST,
                                          LD3i8_POST, LD3i16_POST, LD3i32_POST, LD3i64_POST,
                                          LD3Rv8b_POST, LD3Rv4h_POST, LD3Rv2s_POST, LD3Rv1d_POST,
                                          LD3Rv16b_POST, LD3Rv8h_POST, LD3Rv4s_POST, LD3Rv2d_POST,
                                          LD4Fourv8b_POST, LD4Fourv4h_POST, LD4Fourv2s_POST,
                                          LD4Fourv16b_POST, LD4Fourv8h_POST, LD4Fourv4s_POST, LD4Fourv2d_POST,
                                          LD4i8_POST, LD4i16_POST, LD4i32_POST, LD4i64_POST,
                                          LD4Rv8b_POST, LD4Rv4h_POST, LD4Rv2s_POST, LD4Rv1d_POST,
                                          LD4Rv16b_POST, LD4Rv8h_POST, LD4Rv4s_POST, LD4Rv2d_POST]>;

// Identify whether an instruction is an ASIMD
// store using the post index addressing mode.
def IsStoreASIMDPostOp     : CheckOpcode<[ST1Onev8b_POST, ST1Onev4h_POST, ST1Onev2s_POST, ST1Onev1d_POST,
                                          ST1Onev16b_POST, ST1Onev8h_POST, ST1Onev4s_POST, ST1Onev2d_POST,
                                          ST1Twov8b_POST, ST1Twov4h_POST, ST1Twov2s_POST, ST1Twov1d_POST,
                                          ST1Twov16b_POST, ST1Twov8h_POST, ST1Twov4s_POST, ST1Twov2d_POST,
                                          ST1Threev8b_POST, ST1Threev4h_POST, ST1Threev2s_POST, ST1Threev1d_POST,
                                          ST1Threev16b_POST, ST1Threev8h_POST, ST1Threev4s_POST, ST1Threev2d_POST,
                                          ST1Fourv8b_POST, ST1Fourv4h_POST, ST1Fourv2s_POST, ST1Fourv1d_POST,
                                          ST1Fourv16b_POST, ST1Fourv8h_POST, ST1Fourv4s_POST, ST1Fourv2d_POST,
                                          ST1i8_POST, ST1i16_POST, ST1i32_POST, ST1i64_POST,
                                          ST2Twov8b_POST, ST2Twov4h_POST, ST2Twov2s_POST,
                                          ST2Twov16b_POST, ST2Twov8h_POST, ST2Twov4s_POST, ST2Twov2d_POST,
                                          ST2i8_POST, ST2i16_POST, ST2i32_POST, ST2i64_POST,
                                          ST3Threev8b_POST, ST3Threev4h_POST, ST3Threev2s_POST,
                                          ST3Threev16b_POST, ST3Threev8h_POST, ST3Threev4s_POST, ST3Threev2d_POST,
                                          ST3i8_POST, ST3i16_POST, ST3i32_POST, ST3i64_POST,
                                          ST4Fourv8b_POST, ST4Fourv4h_POST, ST4Fourv2s_POST,
                                          ST4Fourv16b_POST, ST4Fourv8h_POST, ST4Fourv4s_POST, ST4Fourv2d_POST,
                                          ST4i8_POST, ST4i16_POST, ST4i32_POST, ST4i64_POST]>;

// Identify whether an instruction is an ASIMD load
// or store using the post index addressing mode.
def IsLoadStoreASIMDPostOp : CheckOpcode<!listconcat(IsLoadASIMDPostOp.ValidOpcodes,
                                                     IsStoreASIMDPostOp.ValidOpcodes)>;

// Identify whether an instruction is a load
// using the register offset addressing mode.
def IsLoadRegOffsetOp      : CheckOpcode<[PRFMroW, PRFMroX,
                                          LDRBBroW, LDRBBroX,
                                          LDRSBWroW, LDRSBWroX, LDRSBXroW, LDRSBXroX,
                                          LDRHHroW, LDRHHroX,
                                          LDRSHWroW, LDRSHWroX, LDRSHXroW, LDRSHXroX,
                                          LDRWroW, LDRWroX,
                                          LDRSWroW, LDRSWroX,
                                          LDRXroW, LDRXroX,
                                          LDRBroW, LDRBroX,
                                          LDRHroW, LDRHroX,
                                          LDRSroW, LDRSroX,
                                          LDRDroW, LDRDroX,
                                          LDRQroW, LDRQroX]>;

// Identify whether an instruction is a store
// using the register offset addressing mode.
def IsStoreRegOffsetOp     : CheckOpcode<[STRBBroW, STRBBroX,
                                          STRHHroW, STRHHroX,
                                          STRWroW, STRWroX,
                                          STRXroW, STRXroX,
                                          STRBroW, STRBroX,
                                          STRHroW, STRHroX,
                                          STRSroW, STRSroX,
                                          STRDroW, STRDroX,
                                          STRQroW, STRQroX]>;

// Identify whether an instruction is a load or
// store using the register offset addressing mode.
def IsLoadStoreRegOffsetOp : CheckOpcode<!listconcat(IsLoadRegOffsetOp.ValidOpcodes,
                                                     IsStoreRegOffsetOp.ValidOpcodes)>;

// Target predicates.

// Identify an instruction that effectively transfers a register to another.
def IsCopyIdiomFn     : TIIPredicate<"isCopyIdiom",
                                     MCOpcodeSwitchStatement<
                                       [// MOV {Rd, SP}, {SP, Rn} =>
                                        // ADD {Rd, SP}, {SP, Rn}, #0
                                        MCOpcodeSwitchCase<
                                          [ADDWri, ADDXri],
                                          MCReturnStatement<
                                            CheckAll<
                                              [CheckIsRegOperand<0>,
                                               CheckIsRegOperand<1>,
                                               CheckAny<
                                                 [CheckRegOperand<0, WSP>,
                                                  CheckRegOperand<0, SP>,
                                                  CheckRegOperand<1, WSP>,
                                                  CheckRegOperand<1, SP>]>,
                                               CheckZeroOperand<2>]>>>,
                                        // MOV Rd, Rm =>
                                        // ORR Rd, ZR, Rm, LSL #0
                                        MCOpcodeSwitchCase<
                                          [ORRWrs, ORRXrs],
                                          MCReturnStatement<
                                            CheckAll<
                                              [CheckIsRegOperand<1>,
                                               CheckIsRegOperand<2>,
                                               CheckAny<
                                                 [CheckRegOperand<1, WZR>,
                                                  CheckRegOperand<1, XZR>]>,
                                               CheckShiftBy0]>>>],
                                       MCReturnStatement<FalsePred>>>;
def IsCopyIdiomPred   : MCSchedPredicate<IsCopyIdiomFn>;

// Identify arithmetic instructions with an extended register.
def RegExtendedFn     : TIIPredicate<"hasExtendedReg",
                                     MCOpcodeSwitchStatement<
                                       [MCOpcodeSwitchCase<
                                         IsArithExtOp.ValidOpcodes,
                                         MCReturnStatement<
                                           CheckNot<CheckZeroOperand<3>>>>],
                                       MCReturnStatement<FalsePred>>>;
def RegExtendedPred   : MCSchedPredicate<RegExtendedFn>;

// Identify arithmetic and logic instructions with a shifted register.
def RegShiftedFn      : TIIPredicate<"hasShiftedReg",
                                     MCOpcodeSwitchStatement<
                                       [MCOpcodeSwitchCase<
                                          IsArithLogicShiftOp.ValidOpcodes,
                                          MCReturnStatement<
                                            CheckNot<CheckZeroOperand<3>>>>],
                                       MCReturnStatement<FalsePred>>>;
def RegShiftedPred    : MCSchedPredicate<RegShiftedFn>;

// Identify a load or store using the register offset addressing mode
// with an extended or scaled register.
def ScaledIdxFn       : TIIPredicate<"isScaledAddr",
                                     MCOpcodeSwitchStatement<
                                       [MCOpcodeSwitchCase<
                                          IsLoadStoreRegOffsetOp.ValidOpcodes,
                                          MCReturnStatement<
                                            CheckAny<[CheckNot<CheckMemExtLSL>,
                                                      CheckMemScaled]>>>],
                                       MCReturnStatement<FalsePred>>>;
def ScaledIdxPred     : MCSchedPredicate<ScaledIdxFn>;

// Identify an instruction that effectively resets a FP register to zero.
def IsZeroFPIdiomFn   : TIIPredicate<"isZeroFPIdiom",
                                     MCOpcodeSwitchStatement<
                                       [// MOVI Vd, #0
                                        MCOpcodeSwitchCase<
                                          [MOVIv8b_ns, MOVIv16b_ns,
                                           MOVID, MOVIv2d_ns],
                                          MCReturnStatement<CheckZeroOperand<1>>>,
                                        // MOVI Vd, #0, LSL #0
                                        MCOpcodeSwitchCase<
                                          [MOVIv4i16, MOVIv8i16,
                                           MOVIv2i32, MOVIv4i32],
                                          MCReturnStatement<
                                            CheckAll<
                                              [CheckZeroOperand<1>,
                                               CheckZeroOperand<2>]>>>],
                                       MCReturnStatement<FalsePred>>>;
def IsZeroFPIdiomPred : MCSchedPredicate<IsZeroFPIdiomFn>;

// Identify an instruction that effectively resets a GP register to zero.
def IsZeroIdiomFn     : TIIPredicate<"isZeroIdiom",
                                    MCOpcodeSwitchStatement<
                                      [// ORR Rd, ZR, #0
                                       MCOpcodeSwitchCase<
                                         [ORRWri, ORRXri],
                                         MCReturnStatement<
                                           CheckAll<
                                             [CheckIsRegOperand<1>,
                                              CheckAny<
                                                [CheckRegOperand<1, WZR>,
                                                 CheckRegOperand<1, XZR>]>,
                                              CheckZeroOperand<2>]>>>],
                                      MCReturnStatement<FalsePred>>>;
def IsZeroIdiomPred   : MCSchedPredicate<IsZeroIdiomFn>;
