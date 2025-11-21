module reset (
    input  clk,
    input  rst_btn,
    output rst
);

  reg [25:0] timer = 0;
  reg rst_reg = 0;

  assign rst = rst_reg;

  always @(posedge clk) begin
    if (!rst_btn) begin
      if (timer < 54000000 - 1) begin
        timer <= timer + 1;
      end else begin
        rst_reg <= 1;
      end
    end else begin
      timer   <= 0;
      rst_reg <= 0;
    end
  end

endmodule
