# -------------------------------------------------------------------------------------------------
# IO _ assignation
# -------------------------------------------------------------------------------------------------
# 12 MHz System Clock
set_property PACKAGE_PIN F14     [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 83.330 -name sys_clk_pin -waveform {0.000 41.660} -add [get_ports clk]
# Reset to state high
set_property PACKAGE_PIN C18     [get_ports reset_btn]
set_property IOSTANDARD LVCMOS33 [get_ports reset_btn]
# UART through USB
#set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports uart_tx]
#set_property -dict {PACKAGE_PIN R12 IOSTANDARD LVCMOS33} [get_ports uart_rx]
# UART through IO's
set_property PACKAGE_PIN M14     [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property PACKAGE_PIN N14     [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]

# Leds assignation
set_property PACKAGE_PIN E18     [get_ports led1]
set_property IOSTANDARD LVCMOS33 [get_ports led1]
set_property PACKAGE_PIN F13     [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led2]
set_property PACKAGE_PIN E13     [get_ports led3]
set_property IOSTANDARD LVCMOS33 [get_ports led3]
set_property PACKAGE_PIN H15     [get_ports led4]
set_property IOSTANDARD LVCMOS33 [get_ports led4]
# Led RGB assignation
set_property PACKAGE_PIN J15     [get_ports ledR_1]
set_property IOSTANDARD LVCMOS33 [get_ports ledR_1]
set_property PACKAGE_PIN G17     [get_ports ledG_1]
set_property IOSTANDARD LVCMOS33 [get_ports ledG_1]
set_property PACKAGE_PIN F15     [get_ports ledB_1]
set_property IOSTANDARD LVCMOS33 [get_ports ledB_1]