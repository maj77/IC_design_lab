`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH
// Engineer: Marcin Maj
// 
// Create Date: 21.10.2023 14:42:28
// Design Name: ALU
// Module Name: ALU_top
// Description: Code representing ALU functionality
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_top #(
    DATA_WIDTH   = 8,
    OPCODE_WIDTH = 4
 )(
    input  [  DATA_WIDTH-1:0] A,
    input  [  DATA_WIDTH-1:0] B,
    input  [OPCODE_WIDTH-1:0] opcode,
    output [  DATA_WIDTH-1:0] result,
    output  reg               flag_V, // overflow flag
    output  reg               flag_C, // carry flag
    output  reg               flag_Z, // zero flag
    output  reg               flag_P  // parity flag
 );
 
// --------------------------------------------------------------------------------
function check_overflow (input [DATA_WIDTH-1:0] A, B,
                         input [  DATA_WIDTH:0] result_s );
  begin
    check_overflow = ((A[DATA_WIDTH-1]==1'b0 && B[DATA_WIDTH-1]==1'b0) && result_s[DATA_WIDTH-1]==1'b1) 
                     || ((A[DATA_WIDTH-1]==1'b1 && B[DATA_WIDTH-1]==1'b1) && result_s[DATA_WIDTH-1]==1'b0)
                     ?  1'b1 : 1'b0 ;   
  end
endfunction

// defines for mux
parameter op_neg = 0,
          op_or  = 1,
          op_and = 2,
          op_xor = 3,
          op_add = 4,
          op_sub = 5,
          op_mul = 6,
          op_div = 7,
          op_lsl = 8,
          op_lsr = 9,
          op_asl = 10,
          op_asr = 11,
          op_inc = 12,
          op_dec = 13,
          op_cmp = 14,
          op_eq  = 15,
          op_clr = 16;

reg  [DATA_WIDTH:0] result_s; // signal 1bit larger to check overflow
// --------------------------------------------------------------------------------


always @(*) begin : alu_process_c
  case(opcode)
    op_neg  : begin 
                result_s = ~A;
                flag_C = 1'b0;
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = 1'b0;        
              end
    op_or  : begin 
                result_s = A | B;
                flag_C = 1'b0;
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = 1'b0;    
              end
    op_and : begin 
                result_s = A & B;
                flag_C = 1'b0;
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = 1'b0;      
              end
    op_xor : begin 
                result_s = A ^ B;
                flag_C = 1'b0;
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = 1'b0;    
              end
    op_add : begin 
                result_s = A + B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s); 
              end
    op_sub : begin 
                result_s = A - B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s);   
              end
    op_mul : begin 
                result_s = A * B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s); 
              end
    op_div : begin // it should be replaced with separate module implementing optimal division algorithm
                result_s = B == 0 ? 0 : A / B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s); 
              end
    op_lsl : begin 
                result_s = A << B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s);  
              end
    op_lsr : begin 
                result_s = A >> B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s);  
              end
    op_asl : begin 
                result_s = A <<< B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s); 
              end
    op_asr : begin 
                result_s = A >>> B;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s); 
              end
    op_inc : begin 
                result_s = A + 1'b1;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s);  
              end
    op_dec : begin 
                result_s = A - 1'b1;
                flag_C = result_s[DATA_WIDTH];
                flag_Z = (result_s==0) ? 1'b1 : 1'b0;
                flag_P = result_s[0];
                flag_V = check_overflow(A, B, result_s);  
              end
    op_cmp : begin 
                result_s = A > B ? 1'b1 : 1'b0;
                flag_C = 1'b0;
                flag_Z = 1'b0;
                flag_P = 1'b0;
                flag_V = 1'b0;
              end
    op_eq : begin 
                result_s = A == B ? 1'b1 : 1'b0;
                flag_C = 1'b0;
                flag_Z = 1'b0;
                flag_P = 1'b0;
                flag_V = 1'b0;
              end
    op_clr : begin
                result_s = 0;
                flag_C = 1'b0;
                flag_Z = 1'b1;
                flag_P = 1'b0;
                flag_V = 1'b0;
              end
    default : begin // state where everything is set to 0
                result_s = {DATA_WIDTH{1'b0}};
                flag_C = 1'b0;
                flag_Z = 1'b0;
                flag_P = 1'b0;
                flag_V = 1'b0;
              end  
  endcase
end

assign result = result_s;

endmodule
