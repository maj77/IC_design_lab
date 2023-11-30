`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH
// Engineer: Marcin Maj
// 
// Create Date: 29.11.2023 12:45:58
// Project Name: FSM
// Description: testbench for fsm module
//////////////////////////////////////////////////////////////////////////////////


module FSM_tb();

localparam CLK_PERIOD = 10;
bit clk;
bit rst_n;
bit A;
bit B;
bit M;
bit R;
bit W;
bit error_ind;

bit [2:0] A_bus;
bit [2:0] B_bus;
bit [2:0] result_bus;

typedef enum logic [2:0] {A_eq_B = 3'b010, // A=B
                          A_gt_B = 3'b001, // A>B
                          A_ls_B = 3'b100, // A<B
                          OTHER  = 3'b000
                          } output_e;
initial begin
  rst_n = 1'b1;
  #2  rst_n = 1'b0;
  #40 rst_n = 1'b1;
end

initial
  clk = 1'b0;
always
  #(CLK_PERIOD/2) clk = ~clk;

initial begin
  #45; // delay to allign with reset
  for(int t=0; t<64; t=t+1) begin
    A_bus = $urandom_range(0,7);
    B_bus = $urandom_range(0,7);
    for(int i=0; i<3; i=i+1) begin
      A = A_bus[i];
      B = B_bus[i];
      #(CLK_PERIOD);
    end
    
    if(A_bus>B_bus) begin
      if(result_bus==A_gt_B) 
        error_ind = 0;
      else
        error_ind = 1;
    end else if(A_bus<B_bus) begin
      if(result_bus==A_ls_B) 
        error_ind = 0;
      else
        error_ind = 1;     
    end else if(A_bus==B_bus) begin
      if(result_bus==A_eq_B) 
        error_ind = 0;
      else
        error_ind = 1;
    end
  end
  $finish;
end

FSM uut_fsm (
  .clk(clk),
  .rst_n(rst_n),
  .A(A),
  .B(B),
  .M(M),
  .R(R),
  .W(W)
);

assign result_bus = {M, R, W};

endmodule
