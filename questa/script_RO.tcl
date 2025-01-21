#! /bin/bash


# old version with vhdl files

#vdel -lib LIB_PUF -all
vlib /tp/xph3app/xph3app605/PUF_PROJECT/sources/libs/LIB_PUF
vmap LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/libs/LIB_PUF

# sources/Code_vhdl_puf
# Old/sources/vhdl_us/talarmain_guinedor
#Compile counter
vlog +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_sv_puf/ring_oscillator.sv
vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_array.vhd
vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/UART_RX.vhd
vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/UART_TX.vhd
vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/random_rom.vhd
vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_puf_top.vhd

vlog +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_sv_puf/RO_PUF_TB.sv

vsim LIB_PUF.tb_ro_puf_s7 -c

do wave.do
run {10000ms}



# new version with verilog files

#vdel -lib LIB_PUF -all
#vlib /tp/xph3app/xph3app605/PUF_PROJECT/sources/libs/LIB_PUF
#vmap LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/libs/LIB_PUF

# sources/Code_vhdl_puf
# Old/sources/vhdl_us/talarmain_guinedor
#Compile counter
#vlog +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_sv_puf/ring_oscillator.sv

#vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/ro_array.vhd
#vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/UART_RX.vhd
#vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/UART_TX.vhd
#vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/random_rom.vhd
#vcom +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/ro_puf_s7.vhd

#vlog +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/ro_puf_s7.v

#vlog +acc -work LIB_PUF /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_sv_puf/RO_PUF_TB.sv

#vsim LIB_PUF.tb_ro_puf_s7 -c

#do wave.do
#run {10000ms}
