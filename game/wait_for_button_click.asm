&wait_for_button_click:
LDR R0, 1
COM R0, RBO1
JZ @wait_for_button_click_done
COM R0, RBO2
JZ @wait_for_button_click_done
COM R0, RBO3
JZ @wait_for_button_click_done
JMP @wait_for_button_click

&wait_for_button_click_done:
RTN