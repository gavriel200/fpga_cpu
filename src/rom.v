// reg [7:0] my_array[0:255];

// initial begin
//   $readmemh("my_data.hex", my_array);
// end

module rom (
    input clk
);

  reg pc;  // points to the current location in the rom

endmodule
