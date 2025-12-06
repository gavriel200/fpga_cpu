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
    FIL = 8
    PSH = 9
    POP = 10
    JMP = 11
    JMR = 12
    JMI = 13
    COM = 14
    CAL = 15
    RTN = 16
    WR = 17
    RD = 18


class Registers(IntEnum):
    # rw
    R0 = 0
    R1 = 1
    R2 = 2
    R3 = 3
    R4 = 4
    R5 = 5
    R6 = 6
    R7 = 7
    RJ = 8
    RM0 = 9
    RM1 = 10
    RNDMIN = 11
    RNDMAX = 12
    RNDSEED = 13
    RNDWE = 14
    RLD = 15
    RTM0 = 16
    RTM1 = 17
    RTMS = 18

    # ro
    RNDRAW = 32
    RNDRANGE = 33
    RTMD = 34


class Flag(IntEnum):
    Z = 0
    NZ = 1
    C = 2
    NC = 3


class BaseInstruction:
    hex_file = "src/main.hex"
    instruction_id = None
    arg1 = None
    arg2 = None
    arg_num = 0
    register_pattern = [r.name for r in Registers]
    memory_locations = {}

    def is_register(self, arg):
        return arg in self.register_pattern

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

    def is_flag(self, arg):
        return arg == "Z" or arg == "NZ" or arg == "C" or arg == "NC"

    def value(self):
        pass

    def write(self):
        with open(self.hex_file, "a") as f:
            f.write(f"{self.value()}\n")

    def get_args(self, line):
        args = line.split(" ", 1)[1]
        args = args.split(",")
        if len(args) != self.arg_num:
            raise ValueError(f"invalid num of args {args}")

        return [arg.strip() for arg in args]

    def validate_arg(self, arg, validation):
        if not validation(arg):
            raise TypeError(f"invalid type {arg}, {validation}")

    def get_reg(self, arg):
        self.validate_arg(arg, self.is_register)
        return Registers[arg].value

    def get_number(self, arg):
        if arg.startswith("@"):
            memory_place = arg.replace("@", "")
            if memory_place in BaseInstruction.memory_locations:
                return BaseInstruction.memory_locations[memory_place]
            else:
                raise KeyError(f"unknown memory place {memory_place}")
        else:
            self.validate_arg(arg, self.is_number)
            if arg.startswith("0x"):
                return int(arg, 16)
            else:
                return int(arg, 10)

    def get_flag(self, arg):
        self.validate_arg(arg, self.is_flag)
        return Flag[arg].value


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
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Ldr(BaseInstruction):
    instruciton_id = Instruction.LDR
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_number(args[1])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Add(BaseInstruction):
    instruciton_id = Instruction.ADD
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Sub(BaseInstruction):
    instruciton_id = Instruction.SUB
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Inc(BaseInstruction):
    instruciton_id = Instruction.INC
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Dec(BaseInstruction):
    instruciton_id = Instruction.DEC
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Clr(BaseInstruction):
    instruciton_id = Instruction.CLR
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Set(BaseInstruction):
    instruciton_id = Instruction.FIL
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Psh(BaseInstruction):
    instruciton_id = Instruction.PSH
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Pop(BaseInstruction):
    instruciton_id = Instruction.POP
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Jmp(BaseInstruction):
    instruciton_id = Instruction.JMP
    arg_num = 0

    def value(self):
        return f"{self.instruciton_id:02X}{0:02X}{0:02X}"


class Jmr(BaseInstruction):
    instruciton_id = Instruction.JMR
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_number(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Jmi(BaseInstruction):
    instruciton_id = Instruction.JMI
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_flag(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Com(BaseInstruction):
    instruciton_id = Instruction.COM
    arg_num = 2

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Cal(BaseInstruction):
    instruciton_id = Instruction.CAL
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_number(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Rtn(BaseInstruction):
    instruciton_id = Instruction.RTN
    arg_num = 0

    def value(self):
        return f"{self.instruciton_id:02X}{0:02X}{0:02X}"


class Wr(BaseInstruction):
    instruciton_id = Instruction.WR
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"


class Rd(BaseInstruction):
    instruciton_id = Instruction.RD
    arg_num = 1

    def __init__(self, line):
        args = self.get_args(line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruciton_id:02X}{self.arg1:02X}{0:02X}"
