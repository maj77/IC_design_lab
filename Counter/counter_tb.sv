`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH
// Engineer: Marcin Maj
// 
// Create Date: 16.11.2023 18:34:51
// Design Name: pssw105 counter
// Module Name: counter_tb
// Description: testbench for counter module

//////////////////////////////////////////////////////////////////////////////////


module counter_tb();

logic       clk;
logic       rst_n;
logic       control;
logic [3:0] result;

initial begin
  rst_n = 1'b0;
  #10 rst_n = 1'b1;
end

initial
  clk <= 1'b0;
always
  #5 clk = ~clk;
  
initial begin
  control = 1'b0;
  #100 control = 1'b1;
  #33  control = 1'b0;
  #49  control = 1'b1;
  #70  control = 1'b0;
  #200 control = 1'b1;
end

counter counter_uut (
  .clk    (clk),
  .rst_n  (rst_n),
  .control(control),
  .result (result)
);

endmodule
