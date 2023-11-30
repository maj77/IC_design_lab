`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH <3
// Engineer: Marcin Maj
// 
// Create Date: 16.11.2023 18:09:22
// Design Name: pssw105 counter
// Module Name: counter
// Description: Synchronous counter counting in NBC from 0 to 7 when
//              control signal is 0. When control signal is 1 then
//              counter counts down from 15 to 8
// 
//////////////////////////////////////////////////////////////////////////////////


module counter(
  input  logic       clk    ,
  input  logic       rst_n  ,
  input  logic       control,
  output logic [3:0] result 
);

logic [2:0] cnt_r;
logic       control_r;

always_ff @(posedge clk, negedge rst_n) begin
  if(rst_n == 1'b0) begin
    cnt_r     <= '0;
    control_r <= '0;
  end else begin
    cnt_r     <= cnt_r + 1'b1;
    control_r <= control;
  end
end

assign result = (control_r==1'b0) ? {1'b0, cnt_r} : ~{1'b0, cnt_r};
endmodule