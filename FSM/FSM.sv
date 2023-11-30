`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH <3
// Engineer: Marcin Maj
// Create Date: 26.11.2023 14:19:44 
// Project Name: FSM
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module FSM(
  input  logic clk,
  input  logic rst_n,
  input  logic A,
  input  logic B,
  output logic M,
  output logic R,
  output logic W
);

typedef enum logic [1:0] {IDLE       = 2'b00,
                          FIRST_BIT  = 2'b01,
                          SECOND_BIT = 2'b10,
                          THIRD_BIT  = 2'b11
                          } state_e;

typedef enum logic [2:0] {A_eq_B = 3'b010, // A=B
                          A_gt_B = 3'b001, // A>B
                          A_ls_B = 3'b100, // A<B
                          OTHER  = 3'b000
                          } output_e;

state_e state;
state_e next_state;

logic [2:0] A_r;
logic [2:0] B_r;

always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  case (state)
    IDLE       : next_state = FIRST_BIT;
    FIRST_BIT  : next_state = SECOND_BIT;
    SECOND_BIT : next_state = THIRD_BIT;
    THIRD_BIT  : next_state = FIRST_BIT;
    default    : next_state = IDLE;
  endcase
end

always_ff @(posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    A_r <= '0;
    B_r <= '0;
  end else begin
    A_r   <= {A, A_r[2:1]};
    B_r   <= {B, B_r[2:1]};
  end
end

always_comb begin
  if (state == THIRD_BIT) begin
    if      (A_r == B_r) {M,R,W} = A_eq_B;
    else if (A_r > B_r)  {M,R,W} = A_gt_B;
    else if (A_r < B_r)  {M,R,W} = A_ls_B;
    else                 {M,R,W} = OTHER;
  end else begin
    {M,R,W} = OTHER;
  end
end

endmodule
