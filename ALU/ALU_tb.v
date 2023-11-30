`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2023 15:29:07
// Design Name: ALU
// Module Name: ALU_top_tb
// Description: Module used as testbench for ALU
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_top_tb();

//
// PARAMS DECLARATION
//
parameter DATA_WIDTH   = 8;
parameter OPCODE_WIDTH = 4;


//
// TESTBENCH SIGNALS DECLARATION
//
reg                     clk;
reg                     rst_p;
reg  [  DATA_WIDTH-1:0] A_tb;
reg  [  DATA_WIDTH-1:0] B_tb;
reg  [OPCODE_WIDTH-1:0] opcode_tb;
wire [  DATA_WIDTH-1:0] result_tb;

wire flag_C;
wire flag_Z;
wire flag_P;
wire flag_V;

//
// UNIT UNDER TEST
//
ALU_top #(.DATA_WIDTH   (DATA_WIDTH  ),
          .OPCODE_WIDTH (OPCODE_WIDTH)
  ) i_ALU_TOP_TB (
          .A      (A_tb     ),
          .B      (B_tb     ),
          .opcode (opcode_tb),
          .result (result_tb),
          .flag_C (flag_C   ),
          .flag_Z (flag_Z   ),
          .flag_P (flag_P   ),
          .flag_V (flag_V   )
  );
  
//
// ACTUAL TESTBENCH CODE
//
initial
  clk = 1'b0;
always
  #5 clk = ~clk;
  
initial begin
  rst_p = 1'b1;
  # 30 rst_p = 1'b0;
end

initial begin
  A_tb = 8'hAA;
  B_tb = 8'h05;
  opcode_tb = 0;
  #20
  for(integer i=1; i<16; i=i+1) begin
    #10 opcode_tb = i;
  end
  #100 $finish;
end

endmodule
