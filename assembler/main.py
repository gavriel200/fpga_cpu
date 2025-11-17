# code for taking the main.asm and creating a bit stream of its result
# then taking it and updatinng the rom.v file with the relevant data.
# would create .hex or .mem (can be binary or hex) and then in the verilog use 
# $readmemh("main.hex/mem", {the rom array})

