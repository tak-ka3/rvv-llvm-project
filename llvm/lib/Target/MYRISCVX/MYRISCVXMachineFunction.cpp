//===-- MYRISCVXMachineFunctionInfo.cpp - Private data used for MYRISCVX --===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MYRISCVXMachineFunction.h"

#include "MYRISCVXInstrInfo.h"
#include "MYRISCVXSubtarget.h"
#include "llvm/IR/Function.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

bool FixGlobalBaseReg;

MYRISCVXFunctionInfo::~MYRISCVXFunctionInfo() {}

MachinePointerInfo MYRISCVXFunctionInfo::callPtrInfo(const char *ES) {
  return MachinePointerInfo(MF.getPSVManager().getExternalSymbolCallEntry(ES));
}

MachinePointerInfo MYRISCVXFunctionInfo::callPtrInfo(const GlobalValue *GV) {
  return MachinePointerInfo(MF.getPSVManager().getGlobalValueCallEntry(GV));
}


void MYRISCVXFunctionInfo::anchor() { }
