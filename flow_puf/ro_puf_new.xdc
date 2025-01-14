# -------------------------------------------------------------------------------------------------
# IO _ assignation
# -------------------------------------------------------------------------------------------------
# 12 MHz System Clock
set_property PACKAGE_PIN F14 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]


set_property PACKAGE_PIN V12 [get_ports Enable]
set_property IOSTANDARD LVCMOS33 [get_ports Enable]
set_property PACKAGE_PIN R12 [get_ports RO_OUT]
set_property IOSTANDARD LVCMOS33 [get_ports RO_OUT]

