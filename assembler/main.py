import os
import sys

from assembler.instructions import (
    Add,
    BaseInstruction,
    Cal,
    Cis,
    Clr,
    Com,
    Dec,
    Inc,
    Instruction,
    Jmp,
    Jz,
    Jnz,
    Jc,
    Jnc,
    Ld,
    Ldr,
    Nop,
    Pop,
    Psh,
    Rd,
    Rtn,
    Set,
    Sub,
    Wr,
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
            return Jmp(line)
        case Instruction.JZ.name:
            return Jz(line)
        case Instruction.JNZ.name:
            return Jnz(line)
        case Instruction.JC.name:
            return Jc(line)
        case Instruction.JNC.name:
            return Jnc(line)
        case Instruction.COM.name:
            return Com(line)
        case Instruction.CAL.name:
            return Cal(line)
        case Instruction.RTN.name:
            return Rtn()
        case Instruction.WR.name:
            return Wr(line)
        case Instruction.RD.name:
            return Rd(line)
        case Instruction.CIS.name:
            return Cis()
        case _:
            raise ValueError(f"invalid instruction {instruction}")


def comment_or_empty(line: str):
    if line.startswith("#") or line.startswith("//") or not line or line == "":
        return True
    return False


def is_jump_location(line: str):
    if line.startswith("&") and line.strip().endswith(":"):
        if len(line.strip().split(" ")) != 1:
            raise ValueError("bad memory location")
        return True
    return False


def get_jump_location(line: str):
    return line.strip().replace("&", "").replace(":", "")


def clean_hex_file():
    open("src/main.hex", "w").close()


def is_memory_location(line: str):
    if line.startswith("[") and line.endswith("]"):
        value = line.replace("[", "").replace("]", "").strip()
        if value.startswith("0x"):
            try:
                int(value, 16)
                return True
            except ValueError:
                return False
        else:
            try:
                int(value, 10)
                return True
            except ValueError:
                return False


def get_memory_location(line: str):
    value = line.replace("[", "").replace("]", "").strip()
    if value.startswith("0x"):
        return int(value, 16)
    else:
        return int(value, 10)


def main():
    if len(sys.argv) != 2:
        raise

    asm_file = sys.argv[1]
    full_file_path = f"assembler/{asm_file}"

    if not os.path.exists(full_file_path):
        raise FileNotFoundError("asm file now found")

    print(f"compiling: {asm_file}")

    instructions = []

    for i in range(0x400):
        instructions.append(Nop())

    current_pc = 0

    with open(full_file_path, "r") as f:
        for line in f:
            if is_jump_location(line):
                BaseInstruction.jump_locations[get_jump_location(line)] = current_pc
            elif not comment_or_empty(line.strip()):
                if is_memory_location(line.strip()):
                    memory_location = get_memory_location(line.strip())
                    if memory_location >= current_pc:
                        current_pc = memory_location
                    else:
                        raise IndexError(
                            f"memory location cant be before current pc- {current_pc}, memory_location- {memory_location}"
                        )
                else:
                    instructions[current_pc] = instruction_factory(line.strip())
                    current_pc += 1

    print(f"memory locations:{BaseInstruction.jump_locations}")

    clean_hex_file()

    for i in instructions:
        i.write()


if __name__ == "__main__":
    main()
