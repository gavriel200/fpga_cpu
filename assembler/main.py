import os
import sys
import re

from assembler.instructions import (
    Add,
    And,
    BaseInstruction,
    Cal,
    Cis,
    Clr,
    Com,
    Dec,
    Inc,
    Instruction,
    Jc,
    Jmp,
    Jnc,
    Jnz,
    Jz,
    Ld,
    Ldr,
    Nop,
    Or,
    Pop,
    Psh,
    Rr,
    Rrr,
    Rtn,
    Rwd,
    Rwr,
    Set,
    Sub,
    Wd,
    Wr,
    Xnr,
    Xor,
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
        case Instruction.WD.name:
            return Wd(line)
        case Instruction.RR.name:
            return Rr(line)
        case Instruction.RWR.name:
            return Rwr(line)
        case Instruction.RWD.name:
            return Rwd(line)
        case Instruction.RRR.name:
            return Rrr(line)
        case Instruction.CIS.name:
            return Cis()
        case Instruction.AND.name:
            return And(line)
        case Instruction.OR.name:
            return Or(line)
        case Instruction.XOR.name:
            return Xor(line)
        case Instruction.XNR.name:
            return Xnr(line)
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
    open("assembler/debug_file_asm", "w").close()


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
    len_of_instructions = 0x400

    for i in range(len_of_instructions):
        instructions.append(Nop())

    current_pc = 0

    lines = []
    replace_params = {}

    with open(full_file_path, "r") as f:
        for line in f:
            if line.strip().startswith("import "):
                file = line.strip().split(" ")[1].strip()
                if not os.path.exists(file):
                    raise FileNotFoundError(f"import {file} not found")
                else:
                    with open(file, "r") as file:
                        import_lines = [li for li in file]
                lines += import_lines
            else:
                lines.append(line)

    for line in lines:
        if line.strip().startswith("$"):
            if "=" not in line.strip():
                raise ValueError(f"bad param on line - {line}")
            params = line.strip().split("=")
            if len(params) != 2:
                raise ValueError(f"bad number of params on line - {line}")
            if params[0].strip().replace("$", "") in replace_params:
                raise ValueError(
                    f"param {params[0].strip().replace('$', '')} already in use - {line}"
                )
            replace_params[params[0].strip().replace("$", "")] = params[1].strip()

    for line in lines:
        if is_jump_location(line):
            if get_jump_location(line) in BaseInstruction.jump_locations:
                raise ValueError(
                    f"jump location {get_jump_location(line)} already used"
                )
            BaseInstruction.jump_locations[get_jump_location(line)] = current_pc
        elif not comment_or_empty(line.strip()) and not line.strip().startswith("$"):
            for param, value in replace_params.items():
                pattern = rf"(?:(?<=^)|(?<=[ ,])){re.escape(param)}(?:(?=$)|(?=[ ,]))"
                line = re.sub(pattern, value, line)
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

    print(
        f"usage: used {len([i for i in instructions if not isinstance(i, Nop)])} instructions out of the available {len_of_instructions}, {len_of_instructions - len([i for i in instructions if not isinstance(i, Nop)])} remaining"
    )
    print(f"params : {replace_params}")
    print(f"memory locations:{BaseInstruction.jump_locations}")

    clean_hex_file()

    write_pc = 0
    for i in instructions:
        i.write(write_pc)
        write_pc += 1


if __name__ == "__main__":
    main()
