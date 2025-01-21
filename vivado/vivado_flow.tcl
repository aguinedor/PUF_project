create_project PUF /tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_vivado/bin -part xc7s50csga324-1 -force

add_files -norecurse {
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/UART_TX.vhd 
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/random_rom.vhd 
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_array.vhd 
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/UART_RX.vhd 
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_puf_top.vhd 
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ring_oscillator.vhd
}

add_files -fileset constrs_1 -norecurse /tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/constraints/ro_puf_new.xdc



update_compile_order -fileset sources_1


set_property STEPS.OPT_DESIGN.IS_ENABLED false [get_runs impl_1]

launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

open_hw
connect_hw_server
open_hw_target
set_property PROGRAM.FILE {/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_vivado/bin/PUF.runs/impl_1/ro_puf_s7.bit} [get_hw_devices xc7s50_0]
current_hw_device [get_hw_devices xc7s50_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7s50_0] 0]
set_property PROBES.FILE {} [get_hw_devices xc7s50_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7s50_0]
set_property PROGRAM.FILE {/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_vivado/bin/PUF.runs/impl_1/ro_puf_s7.bit} [get_hw_devices xc7s50_0]
program_hw_devices [get_hw_devices xc7s50_0]
refresh_hw_device [lindex [get_hw_devices xc7s50_0] 0]
