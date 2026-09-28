module datapath (
    input  logic          clk,
    input  logic          reset,
    input  logic          req,
    input  logic          ABorALU,
    input  logic          LDA,
    input  logic          LDB,
    input  logic [ 1 : 0] FN,
    input  logic [15 : 0] AB,
    output logic          N,
    output logic          Z,
    output logic [15 : 0] C
);
  logic [15:0] Y, mux_out, a_reg_out, b_reg_out;

  c_mux u_mux (
      .data_in1(AB),
      .data_in2(Y),
      .s       (ABorALU),
      .data_out(mux_out)
  );

  c_reg a_reg (
      .clk(clk),
      .en(LDA),
      .data_in(mux_out),
      .data_out(a_reg_out)
  );

  c_reg b_reg (
      .clk(clk),
      .en(LDB),
      .data_in(mux_out),
      .data_out(b_reg_out)
  );


  c_alu u_alu (
      .A (a_reg_out),
      .B (b_reg_out),
      .fn(FN),
      .C (Y),
      .N (N),
      .Z (Z)
  );
  assign C = Y;



endmodule
