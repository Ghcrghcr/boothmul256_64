create_clock -name vclk -period 10
set_input_delay -clock vclk 0 [get_ports A] -max
set_input_delay -clock vclk 0 [get_ports B] -max
set_output_delay -clock vclk 0 [get_ports P] -max

set_max_delay -from [get_ports A] -to [get_ports P] 10
set_min_delay -from [get_ports A] -to [get_ports P] 0

set_max_delay -from [get_ports B] -to [get_ports P] 10
set_min_delay -from [get_ports B] -to [get_ports P] 2