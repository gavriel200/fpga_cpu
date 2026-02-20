create_clock -name clk -period 37.037 [get_ports {clk}]
create_generated_clock -name lcd_clk -source [get_ports {clk}] -divide_by 1 -invert [get_ports {lcd_clk}]