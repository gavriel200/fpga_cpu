# input file using args

# each line:
# if // or # = comment

# instructions
# NOP should have nothing after it
# LD should have 2 registers
# register starts with big R and then number between 0-7
# LDR first arg register, second either number or hex no more then 255
# ADD 2 registers

import os
import re
import sys
from enum import IntEnum


class Instruction(IntEnum):
    NOP = 0
    LD = 1
    LDR = 2
    ADD = 3
    SUB = 4
    INC = 5
    DEC = 6
    CLR = 7
    SET = 8


class Registers(IntEnum):
    R0 = 0
    R1 = 1
    R2 = 2
    R3 = 3
    R4 = 4
    R5 = 5
    R6 = 6
    R7 = 7


class BaseInstruction:
    hex_file = "src/main.hex"
    instruction_id = None
    arg1 = None
    arg2 = None
    arg_num = 0
    register_pattern = r"^R[0-7]$"

    def is_register(self, arg):
        return re.match(self.register_pattern, arg)

    def is_number(self, arg):
        arg = arg.strip().lower()

        # Check hex
        if arg.startswith("0x"):
            try:
                num = int(arg, 16)
                return 0 <= num <= 0xFF
            except ValueError:
                return False

        # Check decimal
        try:
            num = int(arg, 10)
            return 0 <= num <= 255
        except ValueError:
            return False

    def value(self):
        pass

    def write(self):
        with open(self.hex_file, "a") as f:
            f.write(f"{self.value()}\n")

    def get_args(self, line):
        args = line.split(" ", 1)[1]
        args = args.split(",")
        if len(args) != self.arg_num:
            raise ValueError("invalid num of args")

        return [arg.strip() for arg in args]

    def validate_arg(self, arg, validation):
        return validation(arg)


class Nop(BaseInstruction):
    instruciton_id = Instruction.NOP
    arg_num = 0

    def value(self):
        return f"{0:02X}{0:02X}{0:02X}"


class Ld(BaseInstruction):
    instruciton_id = Instruction.LD
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)
        self.validate_arg(args[1], self.is_register)

        self.arg1 = Registers[args[0]].value
        self.arg2 = Registers[args[1]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Ldr(BaseInstruction):
    instruciton_id = Instruction.LDR
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)
        self.validate_arg(args[1], self.is_number)

        self.arg1 = Registers[args[0]].value
        if args[1].startswith("0x"):
            self.arg2 = int(args[1], 16)
        else:
            self.arg2 = int(args[1], 10)

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Add(BaseInstruction):
    instruciton_id = Instruction.ADD
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)
        self.validate_arg(args[1], self.is_register)

        self.arg1 = Registers[args[0]].value
        self.arg2 = Registers[args[1]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Sub(BaseInstruction):
    instruciton_id = Instruction.SUB
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)
        self.validate_arg(args[1], self.is_register)

        self.arg1 = Registers[args[0]].value
        self.arg2 = Registers[args[1]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Inc(BaseInstruction):
    instruciton_id = Instruction.INC
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)

        self.arg1 = Registers[args[0]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Dec(BaseInstruction):
    instruciton_id = Instruction.DEC
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)

        self.arg1 = Registers[args[0]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Clr(BaseInstruction):
    instruciton_id = Instruction.CLR
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)

        self.arg1 = Registers[args[0]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Set(BaseInstruction):
    instruciton_id = Instruction.SET
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.validate_arg(args[0], self.is_register)

        self.arg1 = Registers[args[0]].value

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


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
        case Instruction.SET.name:
            return Set(line)
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
