import os
import sys

from assembler.instructions import (
    Add,
    Clr,
    Dec,
    Inc,
    Instruction,
    Jmi,
    Jmp,
    Jmr,
    Ld,
    Ldr,
    Nop,
    Pop,
    Psh,
    Set,
    Sub,
)


def instruction_factory(line):
    instruction = line.split(" ", 1)[0]
    match instruction:
        case Instruction.NOP.name:
            return Nop()
        case Instruction.LD.name:
            return Ld(line)
        case Instruction.LDR.name:
            return Ldr(line)
        case Instruction.ADD.name:
            return Add(line)
        case Instruction.SUB.name:
            return Sub(line)
        case Instruction.INC.name:
            return Inc(line)
        case Instruction.DEC.name:
            return Dec(line)
        case Instruction.CLR.name:
            return Clr(line)
        case Instruction.FIL.name:
            return Set(line)
        case Instruction.PSH.name:
            return Psh(line)
        case Instruction.POP.name:
            return Pop(line)
        case Instruction.JMP.name:
            return Jmp()
        case Instruction.JMR.name:
            return Jmr(line)
        case Instruction.JMI.name:
            return Jmi(line)
        case _:
            raise ValueError(f"invalid instruction {instruction}")


def comment_or_empty(line: str):
    if line.startswith("#") or line.startswith("//") or not line or line == "":
        return True
    return False


def main():
    if len(sys.argv) != 2:
        raise

    asm_file = sys.argv[1]
    full_file_path = f"assembler/{asm_file}"

    if not os.path.exists(full_file_path):
        raise FileNotFoundError("asm file now found")

    print(f"compiling: {asm_file}")

    instructions = []

    with open(full_file_path, "r") as f:
        for line in f:
            striped_line = line.strip()
            if not comment_or_empty(striped_line):
                instructions.append(instruction_factory(striped_line))

    for i in instructions:
        i.write()


def clean_hex_file():
    open("src/main.hex", "w").close()


if __name__ == "__main__":
    clean_hex_file()
    main()
