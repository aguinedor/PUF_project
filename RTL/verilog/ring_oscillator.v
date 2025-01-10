module lut1_3f29546453678b855931c174a97d6c0894b8f546
  (input  i0,
   output o);
  reg [1:0] functionalbehavior_init_reg;
  wire n36_o;
  wire n37_o;
  wire n38_o;
  wire n39_o;
  wire n40_o;
  wire n41_o;
  wire n42_o;
  wire n44_o;
  wire n45_o;
  wire n46_o;
  assign o = n46_o;
  /* unisims/primitive/LUT1.vhd:40:14  */
  always @*
    functionalbehavior_init_reg = 2'b01; // (isignal)
  initial
    functionalbehavior_init_reg = 2'b01;
  /* unisims/primitive/LUT1.vhd:42:17  */
  assign n36_o = functionalbehavior_init_reg[0];
  /* unisims/primitive/LUT1.vhd:42:31  */
  assign n37_o = functionalbehavior_init_reg[1];
  /* unisims/primitive/LUT1.vhd:42:21  */
  assign n38_o = n36_o == n37_o;
  /* unisims/primitive/LUT1.vhd:43:20  */
  assign n39_o = functionalbehavior_init_reg[0];
  /* unisims/primitive/LUT1.vhd:44:15  */
  assign n40_o = ~i0;
  /* unisims/primitive/LUT1.vhd:45:20  */
  assign n41_o = functionalbehavior_init_reg[0];
  /* unisims/primitive/LUT1.vhd:47:20  */
  assign n42_o = functionalbehavior_init_reg[1];
  /* unisims/primitive/LUT1.vhd:46:5  */
  assign n44_o = i0 ? n42_o : 1'bX;
  /* unisims/primitive/LUT1.vhd:44:5  */
  assign n45_o = n40_o ? n41_o : n44_o;
  /* unisims/primitive/LUT1.vhd:42:5  */
  assign n46_o = n38_o ? n39_o : n45_o;
endmodule

module ring_oscillator
  (input  Enable,
   output RO_OUT);
  reg [6:0] inverters;
  wire nand_out;
  wire n2_o;
  wire n3_o;
  wire inverter1_n4;
  wire inverter1_o;
  wire inverseur_n1_inverter1_n7;
  wire n8_o;
  wire inverseur_n1_inverter1_o;
  wire inverseur_n2_inverter1_n11;
  wire n12_o;
  wire inverseur_n2_inverter1_o;
  wire inverseur_n3_inverter1_n15;
  wire n16_o;
  wire inverseur_n3_inverter1_o;
  wire inverseur_n4_inverter1_n19;
  wire n20_o;
  wire inverseur_n4_inverter1_o;
  wire inverseur_n5_inverter1_n23;
  wire n24_o;
  wire inverseur_n5_inverter1_o;
  wire inverseur_n6_inverter1_n27;
  wire n28_o;
  wire inverseur_n6_inverter1_o;
  wire n31_o;
  wire [6:0] n32_o;
  assign RO_OUT = n31_o;
  /* RTL/vhdl/ring_oscillator.vhd:19:8  */
  always @*
    inverters = n32_o; // (isignal)
  initial
    inverters = 7'b0000000;
  /* RTL/vhdl/ring_oscillator.vhd:20:8  */
  assign nand_out = n3_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:26:34  */
  assign n2_o = inverters[5];
  /* RTL/vhdl/ring_oscillator.vhd:26:20  */
  assign n3_o = ~(Enable & n2_o);
  /* RTL/vhdl/ring_oscillator.vhd:34:7  */
  assign inverter1_n4 = inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:29:1  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverter1 (
    .i0(nand_out),
    .o(inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:45:18  */
  assign inverseur_n1_inverter1_n7 = inverseur_n1_inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:46:28  */
  assign n8_o = inverters[0];
  /* RTL/vhdl/ring_oscillator.vhd:40:5  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverseur_n1_inverter1 (
    .i0(n8_o),
    .o(inverseur_n1_inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:45:18  */
  assign inverseur_n2_inverter1_n11 = inverseur_n2_inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:46:28  */
  assign n12_o = inverters[1];
  /* RTL/vhdl/ring_oscillator.vhd:40:5  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverseur_n2_inverter1 (
    .i0(n12_o),
    .o(inverseur_n2_inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:45:18  */
  assign inverseur_n3_inverter1_n15 = inverseur_n3_inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:46:28  */
  assign n16_o = inverters[2];
  /* RTL/vhdl/ring_oscillator.vhd:40:5  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverseur_n3_inverter1 (
    .i0(n16_o),
    .o(inverseur_n3_inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:45:18  */
  assign inverseur_n4_inverter1_n19 = inverseur_n4_inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:46:28  */
  assign n20_o = inverters[3];
  /* RTL/vhdl/ring_oscillator.vhd:40:5  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverseur_n4_inverter1 (
    .i0(n20_o),
    .o(inverseur_n4_inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:45:18  */
  assign inverseur_n5_inverter1_n23 = inverseur_n5_inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:46:28  */
  assign n24_o = inverters[4];
  /* RTL/vhdl/ring_oscillator.vhd:40:5  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverseur_n5_inverter1 (
    .i0(n24_o),
    .o(inverseur_n5_inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:45:18  */
  assign inverseur_n6_inverter1_n27 = inverseur_n6_inverter1_o; // (signal)
  /* RTL/vhdl/ring_oscillator.vhd:46:28  */
  assign n28_o = inverters[5];
  /* RTL/vhdl/ring_oscillator.vhd:40:5  */
  lut1_3f29546453678b855931c174a97d6c0894b8f546 inverseur_n6_inverter1 (
    .i0(n28_o),
    .o(inverseur_n6_inverter1_o));
  /* RTL/vhdl/ring_oscillator.vhd:52:20  */
  assign n31_o = inverters[6];
  assign n32_o = {inverseur_n6_inverter1_n27, inverseur_n5_inverter1_n23, inverseur_n4_inverter1_n19, inverseur_n3_inverter1_n15, inverseur_n2_inverter1_n11, inverseur_n1_inverter1_n7, inverter1_n4};
endmodule

