########################################################
# ZedBoard Pin Assignments
########################################################
# clk - Zedboard 100MHz oscillator
set_property -dict { PACKAGE_PIN Y9 IOSTANDARD LVCMOS33 } [get_ports {clk}]

########################################################
##ZedBoard Timing Constraints
########################################################
# define clock and period
create_clock -period 8.150 -name clk -waveform {0.000 4.075} [get_ports {clk}]
