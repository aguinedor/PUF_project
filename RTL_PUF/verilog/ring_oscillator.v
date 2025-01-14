module ring_oscillator
  (input  enable,
   output ro_out);
  reg [6:0] inverters;
  (* KEEP="TRUE" *) wire nand_out;
  (* KEEP="TRUE" *) wire n11036_o;
  (* KEEP="TRUE" *) wire n11037_o;
  (* KEEP="TRUE" *) wire n11042_o;
  (* KEEP="TRUE" *) wire n11046_o;
  (* KEEP="TRUE" *) wire n11049_o;
  (* KEEP="TRUE" *) wire n11053_o;
  (* KEEP="TRUE" *) wire n11056_o;
  (* KEEP="TRUE" *) wire n11060_o;
  (* KEEP="TRUE" *) wire n11063_o;
  (* KEEP="TRUE" *) wire n11067_o;
  (* KEEP="TRUE" *) wire n11070_o;
  (* KEEP="TRUE" *) wire n11074_o;
  (* KEEP="TRUE" *) wire n11077_o;
  (* KEEP="TRUE" *) wire n11081_o;
  (* KEEP="TRUE" *) wire n11084_o;
  (* KEEP="TRUE" *) wire n11086_o;
  (* KEEP="TRUE" *) wire [6:0] n11087_o;
  assign ro_out = n11086_o;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:16:12  */
  always @*
    inverters = n11087_o; // (isignal)
  initial
    inverters = 7'b0000000;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:17:12  */
  assign nand_out = n11037_o; // (signal)
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:24:38  */
  assign n11036_o = inverters[5];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:24:24  */
  assign n11037_o = ~(enable & n11036_o);
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:29:9  */
  assign n11042_o = nand_out ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:25  */
  assign n11046_o = inverters[0];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:13  */
  assign n11049_o = n11046_o ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:25  */
  assign n11053_o = inverters[1];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:13  */
  assign n11056_o = n11053_o ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:25  */
  assign n11060_o = inverters[2];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:13  */
  assign n11063_o = n11060_o ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:25  */
  assign n11067_o = inverters[3];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:13  */
  assign n11070_o = n11067_o ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:25  */
  assign n11074_o = inverters[4];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:13  */
  assign n11077_o = n11074_o ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:25  */
  assign n11081_o = inverters[5];
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:40:13  */
  assign n11084_o = n11081_o ? 1'b0 : 1'b1;
  /* RTL_PUF/vhdl/ring_oscillator_no_lut.vhd:49:24  */
  assign n11086_o = inverters[6];
  /* RTL_PUF/vhdl/ro_array.vhd:37:5  */
  assign n11087_o = {n11084_o, n11077_o, n11070_o, n11063_o, n11056_o, n11049_o, n11042_o};
endmodule