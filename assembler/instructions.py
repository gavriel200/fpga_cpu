from enum import IntEnum

debug = True


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
    JZ = 12
    JNZ = 13
    JC = 14
    JNC = 15
    COM = 16
    CAL = 17
    RTN = 18
    WR = 19
    RD = 20
    CIS = 21


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
    RM = 8
    # RM1 = 9
    RNDMIN = 10
    RNDMAX = 11
    RNDSEED = 12
    RNDWE = 13
    RLD = 14
    RTM0 = 15
    RTM1 = 16
    RTMS = 17
    RTIE = 18
    RIS = 19
    RFBX = 20
    RFBY = 21
    RFBD = 22
    RFBE = 23
    RLCDU = 24

    # ro
    RNDRAW = 32
    RNDRANGE = 33
    RTMD = 34
    RLCDR = 35


class BaseInstruction:
    hex_file = "src/main.hex"
    debug_file = "debug_file"
    instruction_id = None
    arg1 = None
    arg2 = None
    arg_num = 0
    register_pattern = [r.name for r in Registers]
    jump_locations = {}
    memory_place = None

    def __init__(self, line=""):
        self.line = line

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

    def value(self):
        pass

    def generate_args(self):
        pass

    def write(self, pc):
        self.generate_args()
        with open(self.hex_file, "a") as f:
            f.write(f"{self.value()}\n")

        if debug:
            with open(self.debug_file, "a") as f:
                f.write(
                    f"{self.value()} -- {pc:08X} -- {self.instruction_id.name} {self.arg1}, {self.arg2}{f' | to: {self.memory_place}' if self.memory_place else ''} {f' | @{self.debug_get_pc_name(pc)}' if pc in BaseInstruction.jump_locations.values() else ''}\n"
                )

    def debug_get_pc_name(self, pc):
        for key, value in BaseInstruction.jump_locations.items():
            if value == pc:
                return key

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
        self.validate_arg(arg, self.is_number)
        if arg.startswith("0x"):
            return int(arg, 16)
        else:
            return int(arg, 10)

    def get_number_16_bit(self, arg):
        if arg.startswith("@"):
            memory_place = arg.replace("@", "")
            if memory_place in BaseInstruction.jump_locations:
                self.memory_place = memory_place
                return (
                    BaseInstruction.jump_locations[memory_place] >> 8
                ) & 0xFF, BaseInstruction.jump_locations[memory_place] & 0xFF
            else:
                raise KeyError(f"unknown memory place {memory_place}")
        else:
            self.validate_arg(arg, self.is_number)
            if arg.startswith("0x"):
                return (int(arg, 16) >> 8) & 0xFF, int(arg, 16) & 0xFF
            else:
                return (int(arg, 10) >> 8) & 0xFF, int(arg, 16) & 0xFF


class Nop(BaseInstruction):
    instruction_id = Instruction.NOP
    arg_num = 0

    def value(self):
        return f"{0:02X}{0:02X}{0:02X}"


class Ld(BaseInstruction):
    instruction_id = Instruction.LD
    arg_num = 2

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Ldr(BaseInstruction):
    instruction_id = Instruction.LDR
    arg_num = 2

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_number(args[1])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Add(BaseInstruction):
    instruction_id = Instruction.ADD
    arg_num = 2

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Sub(BaseInstruction):
    instruction_id = Instruction.SUB
    arg_num = 2

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Inc(BaseInstruction):
    instruction_id = Instruction.INC
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Dec(BaseInstruction):
    instruction_id = Instruction.DEC
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Clr(BaseInstruction):
    instruction_id = Instruction.CLR
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Set(BaseInstruction):
    instruction_id = Instruction.FIL
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Psh(BaseInstruction):
    instruction_id = Instruction.PSH
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Pop(BaseInstruction):
    instruction_id = Instruction.POP
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Jmp(BaseInstruction):
    instruction_id = Instruction.JMP
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1, self.arg2 = self.get_number_16_bit(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Jz(BaseInstruction):
    instruction_id = Instruction.JZ
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1, self.arg2 = self.get_number_16_bit(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Jnz(BaseInstruction):
    instruction_id = Instruction.JNZ
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1, self.arg2 = self.get_number_16_bit(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Jc(BaseInstruction):
    instruction_id = Instruction.JC
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1, self.arg2 = self.get_number_16_bit(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Jnc(BaseInstruction):
    instruction_id = Instruction.JNC
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1, self.arg2 = self.get_number_16_bit(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Com(BaseInstruction):
    instruction_id = Instruction.COM
    arg_num = 2

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])
        self.arg2 = self.get_reg(args[1])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Cal(BaseInstruction):
    instruction_id = Instruction.CAL
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1, self.arg2 = self.get_number_16_bit(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{self.arg2:02X}"


class Rtn(BaseInstruction):
    instruction_id = Instruction.RTN
    arg_num = 0

    def value(self):
        return f"{self.instruction_id:02X}{0:02X}{0:02X}"


class Wr(BaseInstruction):
    instruction_id = Instruction.WR
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Rd(BaseInstruction):
    instruction_id = Instruction.RD
    arg_num = 1

    def generate_args(self):
        args = self.get_args(self.line)
        self.arg1 = self.get_reg(args[0])

    def value(self):
        return f"{self.instruction_id:02X}{self.arg1:02X}{0:02X}"


class Cis(BaseInstruction):
    instruction_id = Instruction.CIS
    arg_num = 0

    def value(self):
        return f"{self.instruction_id:02X}{0:02X}{0:02X}"
