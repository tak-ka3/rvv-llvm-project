//===-- MYRISCVXAsmParser.cpp - Parse MYRISCVX assembly to MCInst instructions ----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MYRISCVX.h"

#include "MCTargetDesc/MYRISCVXMCExpr.h"
#include "MCTargetDesc/MYRISCVXMCTargetDesc.h"
#include "MYRISCVXRegisterInfo.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCParser/MCAsmLexer.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/MCParser/MCAsmLexer.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "MYRISCVX-asm-parser"

namespace {
class MYRISCVXAssemblerOptions {
 public:
  MYRISCVXAssemblerOptions():
      reorder(true), macro(true) {
  }

  bool isReorder() {return reorder;}
  void setReorder() {reorder = true;}
  void setNoreorder() {reorder = false;}

  bool isMacro() {return macro;}
  void setMacro() {macro = true;}
  void setNomacro() {macro = false;}

 private:
  bool reorder;
  bool macro;
};
}

// @{ MYRISCVXAsmParser_MYRISCVXAsmParser
// @{ MYRISCVXAsmParser_MYRISCVXAsmParser_Head
namespace {
class MYRISCVXAsmParser : public MCTargetAsmParser {
  MCAsmParser &Parser;
  MYRISCVXAssemblerOptions Options;

#define GET_ASSEMBLER_HEADER
#include "MYRISCVXGenAsmMatcher.inc"

  SMLoc getLoc() const { return getParser().getTok().getLoc(); }

  bool isRV64() const { return getSTI().hasFeature(MYRISCVX::FeatureRV64); }

  // Parse?????????????????????????????????????????????Match?????????????????????
  // MCInst????????????MCStreamer???????????????
  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;
// @{ MYRISCVXAsmParser_MYRISCVXAsmParser_Head ...

  bool needsExpansion(MCInst &Inst);

  void expandInstruction(MCInst &Inst, SMLoc IDLoc,
                         SmallVectorImpl<MCInst> &Instructions,
                         MCStreamer &Out);
  void expandPseudoLI(MCInst &Inst, SMLoc IDLoc,
                     SmallVectorImpl<MCInst> &Instructions,
                     MCStreamer &Out);
  void expandPseudoLA(MCInst &Inst, SMLoc IDLoc,
                      SmallVectorImpl<MCInst> &Instructions,
                      MCStreamer &Out);
  void expandPseudoLLA(MCInst &Inst, SMLoc IDLoc,
                       SmallVectorImpl<MCInst> &Instructions,
                       MCStreamer &Out);

  // @} MYRISCVXAsmParser_MYRISCVXAsmParser_Head ...
  // ????????????????????????????????????????????????
  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                     SMLoc &EndLoc) override;
  OperandMatchResultTy tryParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                        SMLoc &EndLoc) override;
  // ??????????????????????????????????????????
  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;

  // ???????????????????????????????????????????????????????????????
  bool ParseDirective(AsmToken DirectiveID) override;

  OperandMatchResultTy parseMemOperand(OperandVector &);

  unsigned validateTargetOperandClass(MCParsedAsmOperand &Op,
                                      unsigned Kind) override;

  // ????????????????????????????????????
  bool ParseOperand(OperandVector &Operands, StringRef Mnemonic);

  bool reportParseError(StringRef ErrorMsg);

  const MCExpr *evaluateRelocExpr(const MCExpr *Expr, StringRef RelocStr);

  bool parseDirectiveSet();

  // ??????????????????????????????????????????
  OperandMatchResultTy parseImmediate(OperandVector &Operands);
  // ??????????????????????????????????????????????????????
  OperandMatchResultTy parseOperandWithModifier(OperandVector &Operands);
  // ????????????????????????????????????????????????
  OperandMatchResultTy parseRegister(OperandVector &Operands);
  // Call??????????????????????????????????????????????????????
  OperandMatchResultTy parseCallSymbol(OperandVector &Operands);

  // @{ MYRISCVXAsmParser_MYRISCVXAsmParser_Head ...

  bool parseSetAtDirective();
  bool parseSetNoAtDirective();
  bool parseSetMacroDirective();
  bool parseSetNoMacroDirective();
  bool parseSetReorderDirective();
  bool parseSetNoReorderDirective();

 public:
  enum MYRISCVXMatchResultTy {
    Match_Dummy = FIRST_TARGET_MATCH_RESULT_TY,
#define GET_OPERAND_DIAGNOSTIC_TYPES
#include "MYRISCVXGenAsmMatcher.inc"
#undef GET_OPERAND_DIAGNOSTIC_TYPES
  };

  static bool classifySymbolRef(const MCExpr *Expr,
                                MYRISCVXMCExpr::MYRISCVXExprKind &Kind,
                                int64_t &Addend);

  MYRISCVXAsmParser(const MCSubtargetInfo &STI, MCAsmParser &parser,
                    const MCInstrInfo &MII, const MCTargetOptions &Options)
      : MCTargetAsmParser(Options, STI, MII), Parser(parser) {
    // Initialize the set of available features.
    setAvailableFeatures(ComputeAvailableFeatures(getSTI().getFeatureBits()));
  }

  MCAsmParser &getParser() const { return Parser; }
  MCAsmLexer &getLexer() const { return Parser.getLexer(); }

  // @} MYRISCVXAsmParser_MYRISCVXAsmParser_Head ...
};
}
// @} MYRISCVXAsmParser_MYRISCVXAsmParser_Head
// @} MYRISCVXAsmParser_MYRISCVXAsmParser


namespace {

/// MYRISCVXOperand - Instances of this class represent a parsed MYRISCVX machine
/// instruction.
class MYRISCVXOperand : public MCParsedAsmOperand {

  enum KindTy {
    k_Immediate,
    k_Memory,
    k_Register,
    k_Token
  } Kind;

 public:
  MYRISCVXOperand(KindTy K) : MCParsedAsmOperand(), Kind(K) {}

  struct Token {
    const char *Data;
    unsigned Length;
  };
  struct PhysRegOp {
    unsigned RegNum; /// Register Number
  };
  struct ImmOp {
    const MCExpr *Val;
  };
  struct MemOp {
    unsigned Base;
    const MCExpr *Off;
  };

  union {
    struct Token Tok;
    struct PhysRegOp Reg;
    struct ImmOp Imm;
    struct MemOp Mem;
  };

  SMLoc StartLoc, EndLoc;

 public:
  void addRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands!");
    Inst.addOperand(MCOperand::createReg(getReg()));
  }

  void addExpr(MCInst &Inst, const MCExpr *Expr) const{
    // Add as immediate when possible.  Null MCExpr = 0.
    if (Expr == 0)
      Inst.addOperand(MCOperand::createImm(0));
    else if (const MCConstantExpr *CE = dyn_cast<MCConstantExpr>(Expr))
      Inst.addOperand(MCOperand::createImm(CE->getValue()));
    else
      Inst.addOperand(MCOperand::createExpr(Expr));
  }

  void addImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands!");
    const MCExpr *Expr = getImm();
    addExpr(Inst,Expr);
  }

  void addMemOperands(MCInst &Inst, unsigned N) const {
    assert(N == 2 && "Invalid number of operands!");

    Inst.addOperand(MCOperand::createReg(getMemBase()));

    const MCExpr *Expr = getMemOff();
    addExpr(Inst,Expr);
  }

  bool isReg() const override { return Kind == k_Register; }
  bool isImm() const override { return Kind == k_Immediate; }
  bool isToken() const override { return Kind == k_Token; }
  bool isMem() const override { return Kind == k_Memory; }

  static bool evaluateConstantImm(const MCExpr *Expr, int64_t &Imm,
                                  MYRISCVXMCExpr::MYRISCVXExprKind &VK) {
    if (auto *RE = dyn_cast<MYRISCVXMCExpr>(Expr)) {
      VK = RE->getKind();
      return RE->evaluateAsConstant(Imm);
    }

    if (auto CE = dyn_cast<MCConstantExpr>(Expr)) {
      VK = MYRISCVXMCExpr::VK_MYRISCVX_None;
      Imm = CE->getValue();
      return true;
    }

    return false;
  }

  bool isBareSymbol() const {
    int64_t Imm;
    MYRISCVXMCExpr::MYRISCVXExprKind VK = MYRISCVXMCExpr::VK_MYRISCVX_None;
    // Must be of 'immediate' type but not a constant.
    if (!isImm() || evaluateConstantImm(getImm(), Imm, VK))
      return false;
    return MYRISCVXAsmParser::classifySymbolRef(getImm(), VK, Imm) &&
           VK == MYRISCVXMCExpr::VK_MYRISCVX_None;
  }

  bool isCallSymbol() const {
    int64_t Imm;
    MYRISCVXMCExpr::MYRISCVXExprKind VK = MYRISCVXMCExpr::VK_MYRISCVX_None;
    // Must be of 'immediate' type but not a constant.
    if (!isImm() || evaluateConstantImm(getImm(), Imm, VK))
      return false;
    return MYRISCVXAsmParser::classifySymbolRef(getImm(), VK, Imm) &&
        (VK == MYRISCVXMCExpr::VK_MYRISCVX_CALL ||
         VK == MYRISCVXMCExpr::VK_MYRISCVX_CALL_PLT);
  }

  StringRef getToken() const {
    assert(Kind == k_Token && "Invalid access!");
    return StringRef(Tok.Data, Tok.Length);
  }

  unsigned getReg() const override {
    assert((Kind == k_Register) && "Invalid access!");
    return Reg.RegNum;
  }

  const MCExpr *getImm() const {
    assert((Kind == k_Immediate) && "Invalid access!");
    return Imm.Val;
  }

  unsigned getMemBase() const {
    assert((Kind == k_Memory) && "Invalid access!");
    return Mem.Base;
  }

  const MCExpr *getMemOff() const {
    assert((Kind == k_Memory) && "Invalid access!");
    return Mem.Off;
  }

  static std::unique_ptr<MYRISCVXOperand> CreateToken(StringRef Str, SMLoc S) {
    auto Op = std::make_unique<MYRISCVXOperand>(k_Token);
    Op->Tok.Data = Str.data();
    Op->Tok.Length = Str.size();
    Op->StartLoc = S;
    Op->EndLoc = S;
    return Op;
  }

  /// Internal constructor for register kinds
  static std::unique_ptr<MYRISCVXOperand> createReg(unsigned RegNum, SMLoc S,
                                                    SMLoc E) {
    auto Op = std::make_unique<MYRISCVXOperand>(k_Register);
    Op->Reg.RegNum = RegNum;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  static std::unique_ptr<MYRISCVXOperand> createImm(const MCExpr *Val, SMLoc S, SMLoc E) {
    auto Op = std::make_unique<MYRISCVXOperand>(k_Immediate);
    Op->Imm.Val = Val;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  static std::unique_ptr<MYRISCVXOperand> CreateMem(unsigned Base, const MCExpr *Off,
                                                    SMLoc S, SMLoc E) {
    auto Op = std::make_unique<MYRISCVXOperand>(k_Memory);
    Op->Mem.Base = Base;
    Op->Mem.Off = Off;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  /// getStartLoc - Get the location of the first token of this operand.
  SMLoc getStartLoc() const override { return StartLoc; }
  /// getEndLoc - Get the location of the last token of this operand.
  SMLoc getEndLoc() const override { return EndLoc; }

  void print(raw_ostream &OS) const override {
    switch (Kind) {
      case k_Immediate:
        OS << "Imm<";
        OS << *Imm.Val;
        OS << ">";
        break;
      case k_Memory:
        OS << "Mem<";
        OS << Mem.Base;
        OS << ", ";
        OS << *Mem.Off;
        OS << ">";
        break;
      case k_Register:
        OS << "Register<" << Reg.RegNum << ">";
        break;
      case k_Token:
        OS << Tok.Data;
        break;
    }
  }
};
}

#define GET_REGISTER_MATCHER
#define GET_MATCHER_IMPLEMENTATION
#include "MYRISCVXGenAsmMatcher.inc"

void printMYRISCVXOperands(OperandVector &Operands) {
  for (size_t i = 0; i < Operands.size(); i++) {
    MYRISCVXOperand* op = static_cast<MYRISCVXOperand*>(&*Operands[i]);
    assert(op != nullptr);
    LLVM_DEBUG(dbgs() << "<" << *op << ">");
  }
  LLVM_DEBUG(dbgs() << "\n");
}


// @{ MYRISCVXAsmParser_MatchAndEmitInstruction
// @{ MYRISCVXAsmParser_MatchAndEmitInstruction_InstExpansion
// @{ MYRISCVXAsmParser_MatchAndEmitInstruction_MatchInstructionImpl
// MatchAndEmitInstruction()???Parse??????????????????????????????
// ???????????????Match?????????????????????MCInst????????????
// MCStreamer??????????????????????????????
bool MYRISCVXAsmParser::MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                                                OperandVector &Operands,
                                                MCStreamer &Out,
                                                uint64_t &ErrorInfo,
                                                bool MatchingInlineAsm) {
  MCInst Inst;
  // MatchInstructionImpl()???MYRISCVXInstrInfo.td????????????????????????????????????
  unsigned MatchResult = MatchInstructionImpl(Operands, Inst, ErrorInfo,
                                              MatchingInlineAsm);
  switch (MatchResult) {
    default: break;
    case Match_Success: {
      // Match?????????????????????
      if (needsExpansion(Inst)) {
        // ?????????????????????????????????????????????????????????????????????????????????
        SmallVector<MCInst, 4> Instructions;
        expandInstruction(Inst, IDLoc, Instructions, Out);
        return false;
      }
      Inst.setLoc(IDLoc); // setLoc???????????????????????????????????????????????????
      // Match???????????????MCStreamer???????????????
      Out.emitInstruction(Inst, getSTI());
      return false;
    }
      // @{ MYRISCVXAsmParser_MatchAndEmitInstruction_MatchInstructionImpl ...
    case Match_MissingFeature:
      // Match???????????????????????????????????????????????????
      Error(IDLoc, "instruction requires a CPU feature not currently enabled");
      return true;
    case Match_InvalidOperand: {
      // Match???????????????????????????????????????????????????
      // @} MYRISCVXAsmParser_MatchAndEmitInstruction_InstExpansion
      SMLoc ErrorLoc = IDLoc;
      if (ErrorInfo != ~0U) {
        if (ErrorInfo >= Operands.size())
          return Error(IDLoc, "too few operands for instruction");

        ErrorLoc = ((MYRISCVXOperand &)*Operands[ErrorInfo]).getStartLoc();
        if (ErrorLoc == SMLoc()) ErrorLoc = IDLoc;
      }

      return Error(ErrorLoc, "invalid operand for instruction");
    }
    case Match_MnemonicFail:
      return Error(IDLoc, "invalid instruction");
  }
  return true;
  // @} MYRISCVXAsmParser_MatchAndEmitInstruction_MatchInstructionImpl ...
}
// @} MYRISCVXAsmParser_MatchAndEmitInstruction_MatchInstructionImpl
// @} MYRISCVXAsmParser_MatchAndEmitInstruction


unsigned MYRISCVXAsmParser::validateTargetOperandClass(MCParsedAsmOperand &AsmOp,
                                                       unsigned Kind) {
  MYRISCVXOperand &Op = static_cast<MYRISCVXOperand &>(AsmOp);
  if (!Op.isReg())
    return Match_InvalidOperand;

  Register Reg = Op.getReg();
  bool IsRegFPR64 =
      MYRISCVXMCRegisterClasses[MYRISCVX::FPR_DRegClassID].contains(Reg);

  // As the parser couldn't differentiate an FPR32 from an FPR64, coerce the
  // register from FPR64 to FPR32 or FPR64C to FPR32C if necessary.
  if (IsRegFPR64 && Kind == MCK_FPR_S) {
    return Match_Success;
  }
  return Match_InvalidOperand;
}


bool MYRISCVXAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                      SMLoc &EndLoc) {
  const AsmToken &Tok = getParser().getTok();
  StartLoc = Tok.getLoc();
  EndLoc = Tok.getEndLoc();
  RegNo = 0;
  StringRef Name = getLexer().getTok().getIdentifier();

  if (!MatchRegisterName(Name)) {
    getParser().Lex(); // Eat identifier token.n
    return false;
  }

  return Error(StartLoc, "invalid register name");
}


OperandMatchResultTy MYRISCVXAsmParser::tryParseRegister(unsigned &RegNo,
                                                      SMLoc &StartLoc,
                                                      SMLoc &EndLoc) {
  const AsmToken &Tok = getParser().getTok();
  StartLoc = Tok.getLoc();
  EndLoc = Tok.getEndLoc();
  RegNo = 0;
  StringRef Name = getLexer().getTok().getIdentifier();

  if ((RegNo = MatchRegisterName(Name)) == 0) {
    return MatchOperand_NoMatch;
  }
  getParser().Lex(); // Eat identifier token.
  return MatchOperand_Success;
}



OperandMatchResultTy MYRISCVXAsmParser::parseCallSymbol(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
  const MCExpr *Res;

  if (getLexer().getKind() != AsmToken::Identifier)
    return MatchOperand_NoMatch;

  // Avoid parsing the register in `call rd, foo` as a call symbol.
  if (getLexer().peekTok().getKind() != AsmToken::EndOfStatement)
    return MatchOperand_NoMatch;

  StringRef Identifier;
  if (getParser().parseIdentifier(Identifier))
    return MatchOperand_ParseFail;

  MYRISCVXMCExpr::MYRISCVXExprKind Kind = MYRISCVXMCExpr::VK_MYRISCVX_CALL;
  if (Identifier.consume_back("@plt"))
    Kind = MYRISCVXMCExpr::VK_MYRISCVX_CALL_PLT;

  MCSymbol *Sym = getContext().getOrCreateSymbol(Identifier);
  Res = MCSymbolRefExpr::create(Sym, MCSymbolRefExpr::VK_None, getContext());
  Res = MYRISCVXMCExpr::create(Kind, Res, getContext());
  Operands.push_back(MYRISCVXOperand::createImm(Res, S, E));
  return MatchOperand_Success;
}


// @{ MYRISCVXAsmParser_ParseOperand
// ??????Operands??????????????????????????????????????????????????????
bool MYRISCVXAsmParser::ParseOperand(OperandVector &Operands,
                                     StringRef Mnemonic) {
  // ??????????????????Parse???????????????. ?????????OperandMatchResultTy????????????????????????
  // MatchOperandParserImpl()???MMYRISCVXAsmMatcher.inc???????????????????????????(TableGen????????????????????????)
  OperandMatchResultTy ResTy = MatchOperandParserImpl(Operands, Mnemonic);
  if (ResTy == MatchOperand_Success)
    return false;

  if (ResTy == MatchOperand_ParseFail)
    return true;

  LLVM_DEBUG(dbgs() << ".. Generic Parser\n");

  // ?????????????????????Parse???????????????
  if (parseRegister(Operands) == MatchOperand_Success)
    return false;

  // ???????????????Parse???????????????
  if (parseImmediate(Operands) == MatchOperand_Success) {
    // ???????????????????????????????????????????????????,
    // imm(reg)?????????????????????????????????????????????????????????????????????????????????
    if (getLexer().is(AsmToken::LParen)) {
      // parseMemOperand???imm(reg)???(reg)????????????Parse??????
      return parseMemOperand(Operands) != MatchOperand_Success;
    }
    return false;
  }

  LLVM_DEBUG(dbgs() << "unknown operand\n");
  return true;
}
// @} MYRISCVXAsmParser_ParseOperand


// @{ MYRISCVXAsmParser_ParseRegister
// ???????????????Parse?????????
// ??????Operands???????????????????????????????????????????????????
OperandMatchResultTy MYRISCVXAsmParser::parseRegister(OperandVector &Operands)
{
  switch (getLexer().getKind()) {
    default:
      return MatchOperand_NoMatch;
    case AsmToken::Identifier:
      StringRef Name = getLexer().getTok().getIdentifier();
      // ?????????????????????????????????????????????????????????????????????
      unsigned RegNo = MatchRegisterName(Name);
      if (RegNo == 0) {
        // ??????????????????, AltName???????????????????????????????????????????????????
        RegNo = MatchRegisterAltName(Name);
        if (RegNo == 0) {
          return MatchOperand_NoMatch;
        }
      }
      SMLoc S = getLoc();
      SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
      getLexer().Lex();
      Operands.push_back(MYRISCVXOperand::createReg(RegNo, S, E));
  }

  return MatchOperand_Success;
}
// @} MYRISCVXAsmParser_ParseRegister


// @{ MYRISCVXAsmParser_parseImmediate
// ?????????Parse?????????
// ??????Operands??????????????????????????????????????????????????????
OperandMatchResultTy MYRISCVXAsmParser::parseImmediate(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
  const MCExpr *Res;

  switch (getLexer().getKind()) {
    default:
      return MatchOperand_NoMatch;
      // (, +, -, [0-9A-Za-z], $ ????????????????????????????????????????????????
    case AsmToken::LParen:
    case AsmToken::Minus:
    case AsmToken::Plus:
    case AsmToken::Integer:
    case AsmToken::String:
    case AsmToken::Identifier:
    case AsmToken::Dollar:
      LLVM_DEBUG(dbgs() << "< parseImmediate Passed >");
      if (getParser().parseExpression(Res))
        return MatchOperand_ParseFail;
      break;
    case AsmToken::Percent:
      // %????????????%hi(Label)???%lo(Label)???????????????????????????
      return parseOperandWithModifier(Operands);
  }

  Operands.push_back(MYRISCVXOperand::createImm(Res, S, E));
  return MatchOperand_Success;
}
// @} MYRISCVXAsmParser_parseImmediate


bool MYRISCVXAsmParser::classifySymbolRef(const MCExpr *Expr,
                                          MYRISCVXMCExpr::MYRISCVXExprKind &Kind,
                                          int64_t &Addend) {
  Kind = MYRISCVXMCExpr::VK_MYRISCVX_None;
  Addend = 0;

  if (const MYRISCVXMCExpr *RE = dyn_cast<MYRISCVXMCExpr>(Expr)) {
    Kind = RE->getKind();
    Expr = RE->getSubExpr();
  }

  // It's a simple symbol reference or constant with no addend.
  if (isa<MCConstantExpr>(Expr) || isa<MCSymbolRefExpr>(Expr))
    return true;

  const MCBinaryExpr *BE = dyn_cast<MCBinaryExpr>(Expr);
  if (!BE)
    return false;

  if (!isa<MCSymbolRefExpr>(BE->getLHS()))
    return false;

  if (BE->getOpcode() != MCBinaryExpr::Add &&
      BE->getOpcode() != MCBinaryExpr::Sub)
    return false;

  // We are able to support the subtraction of two symbol references
  if (BE->getOpcode() == MCBinaryExpr::Sub &&
      isa<MCSymbolRefExpr>(BE->getRHS()))
    return true;

  // See if the addend is a constant, otherwise there's more going
  // on here than we can deal with.
  auto AddendExpr = dyn_cast<MCConstantExpr>(BE->getRHS());
  if (!AddendExpr)
    return false;

  Addend = AddendExpr->getValue();
  if (BE->getOpcode() == MCBinaryExpr::Sub)
    Addend = -Addend;

  // It's some symbol reference + a constant addend
  return false;  // Kind != MYRISCVXMCExpr::VK_MYRISCVX_Invalid;
}


// @{ MYRISCVXAsmParser_parseOperandWithModifier
// ?????????????????????????????????????????????Parse??????(%hi / %lo??????)
// ??????Operands??????????????????????????????????????????????????????
OperandMatchResultTy
MYRISCVXAsmParser::parseOperandWithModifier(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);

  if (getLexer().getKind() != AsmToken::Percent) {
    Error(getLoc(), "expected '%' for operand modifier");
    return MatchOperand_ParseFail;
  }

  getParser().Lex();

  if (getLexer().getKind() != AsmToken::Identifier) {
    Error(getLoc(), "expected valid identifier for operand modifier");
    return MatchOperand_ParseFail;
  }
  StringRef Identifier = getParser().getTok().getIdentifier();
  // getVariantKindForName()??????????????????????????????????????????????????????????????????
  MYRISCVXMCExpr::MYRISCVXExprKind VK = MYRISCVXMCExpr::getVariantKindForName(Identifier);
  if (VK == MYRISCVXMCExpr::VK_MYRISCVX_None) {
    Error(getLoc(), "unrecognized operand modifier");
    return MatchOperand_ParseFail;
  }

  getParser().Lex();
  if (getLexer().getKind() != AsmToken::LParen) {
    Error(getLoc(), "expected '('");
    return MatchOperand_ParseFail;
  }
  getParser().Lex();

  const MCExpr *SubExpr;
  // %hi(label)???"label"????????????????????????Parse??????
  // Parse???????????????SubExpr???????????????
  if (getParser().parseParenExpression(SubExpr, E)) {
    return MatchOperand_ParseFail;
  }

  // ???????????????????????????????????????MachineCode???????????????
  const MCExpr *ModExpr = MYRISCVXMCExpr::create(VK, SubExpr, getContext());
  Operands.push_back(MYRISCVXOperand::createImm(ModExpr, S, E));
  return MatchOperand_Success;
}
// @} MYRISCVXAsmParser_parseOperandWithModifier


// @{ MYRISCVXAsmParser_parseMemOperand
// ???????????????????????????Parse?????????. imm(reg)????????????(reg)????????????Parse??????
// Operands = {'(', reg, ')'} ?????????OperandVector???????????????
OperandMatchResultTy
MYRISCVXAsmParser::parseMemOperand(OperandVector &Operands) {

  const MCExpr *IdVal = 0;
  SMLoc S;
  S = Parser.getTok().getLoc();

  const AsmToken &Tok = Parser.getTok(); // ??????Token???Parse??????
  if (Tok.isNot(AsmToken::LParen)) {
    Error(Parser.getTok().getLoc(), "'(' expected");
    return MatchOperand_ParseFail;
  }

  Parser.Lex(); // '(' ???Parse??????
  Operands.push_back(MYRISCVXOperand::CreateToken("(", getLoc()));

  // '(' reg ')' ???reg????????????Parse??????
  if (parseRegister(Operands)) {
    Error(Parser.getTok().getLoc(), "unexpected token in operand");
  }

  const AsmToken &Tok2 = Parser.getTok(); // ??????Token???Parse??????
  if (Tok2.isNot(AsmToken::RParen)) {
    Error(Parser.getTok().getLoc(), "')' expected");
    return MatchOperand_ParseFail;
  }

  Parser.Lex(); // ')' ???Parse??????
  Operands.push_back(MYRISCVXOperand::CreateToken(")", getLoc()));

  if (!IdVal)
    IdVal = MCConstantExpr::create(0, getContext());

  return MatchOperand_Success;
}
// @} MYRISCVXAsmParser_parseMemOperand

// @{ MYRISCVXAsmParser_ParseInstruction
// @{ MYRISCVXAsmParser_ParseInstruction_ParseMnemnoic
bool MYRISCVXAsmParser::
ParseInstruction(ParseInstructionInfo &Info, StringRef Name, SMLoc NameLoc,
                 OperandVector &Operands) {
  // ????????????????????????????????????????????????????????????????????????
  Operands.push_back(MYRISCVXOperand::CreateToken(Name, NameLoc));
  // @} MYRISCVXAsmParser_ParseInstruction_ParseMnemnoic

  // ??????????????????Parse????????????
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    // ???????????????????????????????????????
    if (ParseOperand(Operands, Name)) {
      SMLoc Loc = getLexer().getLoc();
      Parser.eatToEndOfStatement();
      return Error(Loc, "unexpected token in argument list");
    }

    // ?????????????????????????????????????????????????????????????????????
    while (getLexer().is(AsmToken::Comma) ) {
      Parser.Lex();  // ????????????????????????

      // ????????????????????????????????????????????????????????????????????????
      if (ParseOperand(Operands, Name)) {
        SMLoc Loc = getLexer().getLoc();
        Parser.eatToEndOfStatement();
        return Error(Loc, "unexpected token in argument list");
      }
    }
  }

  // ???????????????????????????Parse??????????????????????????????????????????
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    SMLoc Loc = getLexer().getLoc();
    Parser.eatToEndOfStatement();
    return Error(Loc, "unexpected token in argument list");
  }

  Parser.Lex(); // EndOfStatement???????????????
  return false;
}
// @} MYRISCVXAsmParser_ParseInstruction


bool MYRISCVXAsmParser::reportParseError(StringRef ErrorMsg) {
  SMLoc Loc = getLexer().getLoc();
  Parser.eatToEndOfStatement();
  return Error(Loc, ErrorMsg);
}

bool MYRISCVXAsmParser::parseSetReorderDirective() {
  Parser.Lex();
  // if this is not the end of the statement, report error
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    reportParseError("unexpected token in statement");
    return false;
  }
  Options.setReorder();
  Parser.Lex(); // Consume the EndOfStatement
  return false;
}

bool MYRISCVXAsmParser::parseSetNoReorderDirective() {
  Parser.Lex();
  // if this is not the end of the statement, report error
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    reportParseError("unexpected token in statement");
    return false;
  }
  Options.setNoreorder();
  Parser.Lex(); // Consume the EndOfStatement
  return false;
}

bool MYRISCVXAsmParser::parseSetMacroDirective() {
  Parser.Lex();
  // if this is not the end of the statement, report error
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    reportParseError("unexpected token in statement");
    return false;
  }
  Options.setMacro();
  Parser.Lex(); // Consume the EndOfStatement
  return false;
}

bool MYRISCVXAsmParser::parseSetNoMacroDirective() {
  Parser.Lex();
  // if this is not the end of the statement, report error
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    reportParseError("`noreorder' must be set before `nomacro'");
    return false;
  }
  if (Options.isReorder()) {
    reportParseError("`noreorder' must be set before `nomacro'");
    return false;
  }
  Options.setNomacro();
  Parser.Lex(); // Consume the EndOfStatement
  return false;
}
bool MYRISCVXAsmParser::parseDirectiveSet() {

  // get next token
  const AsmToken &Tok = Parser.getTok();

  if (Tok.getString() == "reorder") {
    return parseSetReorderDirective();
  } else if (Tok.getString() == "noreorder") {
    return parseSetNoReorderDirective();
  } else if (Tok.getString() == "macro") {
    return parseSetMacroDirective();
  } else if (Tok.getString() == "nomacro") {
    return parseSetNoMacroDirective();
  }
  return true;
}

bool MYRISCVXAsmParser::ParseDirective(AsmToken DirectiveID) {

  if (DirectiveID.getString() == ".ent") {
    // ignore this directive for now
    Parser.Lex();
    return false;
  }

  if (DirectiveID.getString() == ".end") {
    // ignore this directive for now
    Parser.Lex();
    return false;
  }

  if (DirectiveID.getString() == ".frame") {
    // ignore this directive for now
    Parser.eatToEndOfStatement();
    return false;
  }

  if (DirectiveID.getString() == ".set") {
    return parseDirectiveSet();
  }

  if (DirectiveID.getString() == ".fmask") {
    // ignore this directive for now
    Parser.eatToEndOfStatement();
    return false;
  }

  if (DirectiveID.getString() == ".mask") {
    // ignore this directive for now
    Parser.eatToEndOfStatement();
    return false;
  }

  if (DirectiveID.getString() == ".gpword") {
    // ignore this directive for now
    Parser.eatToEndOfStatement();
    return false;
  }

  return true;
}


// @{ MYRISCVXAsmParser_needsExpansion
// needsExpansion()??? MatchAndEmitinstruction()???????????????????????????????????????????????????
// ???????????????????????????????????????????????????????????????????????????????????????
bool MYRISCVXAsmParser::needsExpansion(MCInst &Inst) {
  switch(Inst.getOpcode()) {
    case MYRISCVX::LoadImm32Reg:
    case MYRISCVX::PseudoLA:
    case MYRISCVX::PseudoLLA:
      return true;
    default:
      return false;
  }
}
// @} MYRISCVXAsmParser_needsExpansion


void MYRISCVXAsmParser::expandInstruction(MCInst &Inst, SMLoc IDLoc,
                                          SmallVectorImpl<MCInst> &Instructions,
                                          MCStreamer &Out){
  switch(Inst.getOpcode()) {
    case MYRISCVX::LoadImm32Reg:
      return expandPseudoLI(Inst, IDLoc, Instructions, Out);
    case MYRISCVX::PseudoLA:
      return expandPseudoLA(Inst,IDLoc,Instructions, Out);
    case MYRISCVX::PseudoLLA:
      return expandPseudoLLA(Inst,IDLoc,Instructions, Out);
  }
}


// @{ MYRISCVXAsmParser_expandPseudoLI
// LoadImm32Reg (LI????????????)??????????????????????????????
void MYRISCVXAsmParser::expandPseudoLI(MCInst &Inst, SMLoc IDLoc,
                                      SmallVectorImpl<MCInst> &Instructions,
                                      MCStreamer &Out){
  MCInst tmpInst;
  const MCOperand &ImmOp = Inst.getOperand(1);
  assert(ImmOp.isImm() && "expected immediate operand kind");
  const MCOperand &RegOp = Inst.getOperand(0);
  assert(RegOp.isReg() && "expected register operand kind");

  int ImmValue = ImmOp.getImm();
  tmpInst.setLoc(IDLoc);
  if ( -2048 <= ImmValue && ImmValue < 2048) {
    // -2048 ?????? 2048???????????????????????????????????????ADDI?????????????????????
    tmpInst.setOpcode(MYRISCVX::ADDI);
    tmpInst.addOperand(MCOperand::createReg(RegOp.getReg()));
    tmpInst.addOperand(
        MCOperand::createReg(MYRISCVX::ZERO));
    tmpInst.addOperand(MCOperand::createImm(ImmValue));
    Out.emitInstruction(tmpInst, getSTI());
  } else {
    // ???????????????????????????????????????????????????????????? LUI?????????ADDI???????????????????????????????????????
    tmpInst.setOpcode(MYRISCVX::LUI);
    tmpInst.addOperand(MCOperand::createReg(RegOp.getReg()));
    tmpInst.addOperand(MCOperand::createImm((((ImmValue + 0x800) & 0xfffff000) >> 12) & 0xffffff));
    Out.emitInstruction(tmpInst, getSTI());
    tmpInst.clear();
    tmpInst.setOpcode(MYRISCVX::ADDI);
    tmpInst.addOperand(MCOperand::createReg(RegOp.getReg()));
    tmpInst.addOperand(MCOperand::createReg(RegOp.getReg()));
    tmpInst.addOperand(MCOperand::createImm(ImmValue & 0x00fff));
    tmpInst.setLoc(IDLoc);
    Out.emitInstruction(tmpInst, getSTI());
  }
}
// @} MYRISCVXAsmParser_expandPseudoLI


// @{ MYRISCVXAsmParser_expandPseudoLLA
void MYRISCVXAsmParser::expandPseudoLLA(MCInst &Inst, SMLoc IDLoc,
                                        SmallVectorImpl<MCInst> &Instructions,
                                        MCStreamer &Out){
  // LLA rd, symbol
  //    AUIPC rd, %pcrel_hi(symbol)
  //    ADDI  rd, rd, %pcrel_lo(symbol)

  MCContext &Ctx = getContext();

  MCSymbol *TmpLabel = Ctx.createNamedTempSymbol("pcrel_hi");
  Out.emitLabel(TmpLabel);

  MCOperand DestReg = Inst.getOperand(0);
  const MYRISCVXMCExpr *Symbol = MYRISCVXMCExpr::create(
      MYRISCVXMCExpr::VK_MYRISCVX_PCREL_HI20, Inst.getOperand(1).getExpr(), Ctx);

  MCInst tmpInst0 = MCInstBuilder(MYRISCVX::AUIPC)
      .addOperand(DestReg)
      .addExpr(Symbol);
  Out.emitInstruction(tmpInst0, getSTI());

  const MCExpr *RefToLinkTmpLabel =
      MYRISCVXMCExpr::create(MYRISCVXMCExpr::VK_MYRISCVX_PCREL_LO12_I,
                             MCSymbolRefExpr::create(TmpLabel, Ctx),
                             Ctx);

  MCInst tmpInst1 = MCInstBuilder(MYRISCVX::ADDI)
      .addOperand(DestReg)
      .addOperand(DestReg)
      .addExpr(RefToLinkTmpLabel);
  Out.emitInstruction(tmpInst1, getSTI());

}
// @} MYRISCVXAsmParser_expandPseudoLLA


// @{ MYRISCVXAsmParser_expandPseudoLA
// LA??????????????????????????????????????????
void MYRISCVXAsmParser::expandPseudoLA(MCInst &Inst, SMLoc IDLoc,
                                       SmallVectorImpl<MCInst> &Instructions,
                                       MCStreamer &Out){
  // LA????????????????????????:
  // LA rd, symbol
  // Static??????????????????:
  //    AUIPC rd, %pcrel_hi(symbol)
  //    ADDI  rd, rd, %pcrel_lo(symbol)
  // PIC??????????????????:
  // 1: AUIPC rd, %got_pcrel_hi(symbol)
  //    LW/LD rd, %pcrel_lo(1b)(rdest)

  MCContext &Ctx = getContext();

  MCOperand DestReg = Inst.getOperand(0);

  if (getContext().getObjectFileInfo()->isPositionIndependent()) {
    // PIC??????????????????
    unsigned GOTLoadOpcode = isRV64() ? MYRISCVX::LD : MYRISCVX::LW;

    MCSymbol *TmpLabel = Ctx.createNamedTempSymbol("pcrel_hi");
    Out.emitLabel(TmpLabel);

    // AUIPC???????????????
    const MYRISCVXMCExpr *Symbol = MYRISCVXMCExpr::create(
        MYRISCVXMCExpr::VK_MYRISCVX_GOT_HI20, Inst.getOperand(1).getExpr(), Ctx);
    MCInst tmpInst0 = MCInstBuilder(MYRISCVX::AUIPC)
        .addOperand(DestReg)
        .addExpr(Symbol);
    Out.emitInstruction(tmpInst0, getSTI());

    const MCExpr *RefToLinkTmpLabel =
        MYRISCVXMCExpr::create(MYRISCVXMCExpr::VK_MYRISCVX_PCREL_LO12_I,
                               MCSymbolRefExpr::create(TmpLabel, Ctx),
                               Ctx);

    // ADDI???????????????
    MCInst tmpInst1 = MCInstBuilder(GOTLoadOpcode)
        .addOperand(DestReg)
        .addOperand(DestReg)
        .addExpr(RefToLinkTmpLabel);
    Out.emitInstruction(tmpInst1, getSTI());
  } else {
    // Static?????????????????????LLA????????????????????????expandPseudoLLA()?????????????????????
    expandPseudoLLA(Inst, IDLoc, Instructions, Out);
  }
}
// @} MYRISCVXAsmParser_expandPseudoLA


extern "C" void LLVMInitializeMYRISCVXAsmParser() {
  RegisterMCAsmParser<MYRISCVXAsmParser> X(getTheMYRISCVX32Target());
  RegisterMCAsmParser<MYRISCVXAsmParser> Y(getTheMYRISCVX64Target());
}
