#
#### Synthesis ####
#
set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7s50csga324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.cache/wt [current_project]
set_property parent.project_path /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/UART_RX.vhd
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/UART_TX.vhd
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/random_rom.vhd
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ring_oscillator.vhd
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_array.vhd
  /tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_puf_top.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.srcs/constrs_1/imports/Script_python_puf/ro_puf_new.xdc
set_property used_in_implementation false [get_files /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.srcs/constrs_1/imports/Script_python_puf/ro_puf_new.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top ro_puf_s7 -part xc7s50csga324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef ro_puf_s7.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file ro_puf_s7_utilization_synth.rpt -pb ro_puf_s7_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]

#
#### Implementation ####
#

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param chipscope.maxJobs 4
  create_project -in_memory -part xc7s50csga324-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.cache/wt [current_project]
  set_property parent.project_path /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.xpr [current_project]
  set_property ip_output_repo /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  add_files -quiet /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.runs/synth_1/ro_puf_s7.dcp
  read_xdc /tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.srcs/constrs_1/imports/Script_python_puf/ro_puf_new.xdc
  link_design -top ro_puf_s7 -part xc7s50csga324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design 
  write_checkpoint -force ro_puf_s7_placed.dcp
  create_report "impl_2_place_report_io_0" "report_io -file ro_puf_s7_io_placed.rpt"
  create_report "impl_2_place_report_utilization_0" "report_utilization -file ro_puf_s7_utilization_placed.rpt -pb ro_puf_s7_utilization_placed.pb"
  create_report "impl_2_place_report_control_sets_0" "report_control_sets -verbose -file ro_puf_s7_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force ro_puf_s7_routed.dcp
  create_report "impl_2_route_report_drc_0" "report_drc -file ro_puf_s7_drc_routed.rpt -pb ro_puf_s7_drc_routed.pb -rpx ro_puf_s7_drc_routed.rpx"
  create_report "impl_2_route_report_methodology_0" "report_methodology -file ro_puf_s7_methodology_drc_routed.rpt -pb ro_puf_s7_methodology_drc_routed.pb -rpx ro_puf_s7_methodology_drc_routed.rpx"
  create_report "impl_2_route_report_power_0" "report_power -file ro_puf_s7_power_routed.rpt -pb ro_puf_s7_power_summary_routed.pb -rpx ro_puf_s7_power_routed.rpx"
  create_report "impl_2_route_report_route_status_0" "report_route_status -file ro_puf_s7_route_status.rpt -pb ro_puf_s7_route_status.pb"
  create_report "impl_2_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file ro_puf_s7_timing_summary_routed.rpt -pb ro_puf_s7_timing_summary_routed.pb -rpx ro_puf_s7_timing_summary_routed.rpx -warn_on_violation "
  create_report "impl_2_route_report_incremental_reuse_0" "report_incremental_reuse -file ro_puf_s7_incremental_reuse_routed.rpt"
  create_report "impl_2_route_report_clock_utilization_0" "report_clock_utilization -file ro_puf_s7_clock_utilization_routed.rpt"
  create_report "impl_2_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file ro_puf_s7_bus_skew_routed.rpt -pb ro_puf_s7_bus_skew_routed.pb -rpx ro_puf_s7_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force ro_puf_s7_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

#
#### Bitstream generation ####
#

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force ro_puf_s7.mmi }
  write_bitstream -force ro_puf_s7.bit 
  catch {write_debug_probes -quiet -force ro_puf_s7}
  catch {file copy -force ro_puf_s7.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

#
#### Program device ####
#

open_hw
connect_hw_server
open_hw_target

set_property PROBES.FILE {} [get_hw_devices xc7s50_0]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7s50_0]
set_property PROGRAM.FILE {/tp/xph3app/xph3app605/PUF_PROJECT/Vivado_puf_11_12_2024/PUF_11_12_2024.runs/impl_2/ro_puf_s7.bit} [get_hw_devices xc7s50_0]
program_hw_devices [get_hw_devices xc7s50_0]
refresh_hw_device [lindex [get_hw_devices xc7s50_0] 0]

