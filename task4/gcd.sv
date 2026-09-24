// -----------------------------------------------------------------------------
//
//  Title      :  System Verilog FSMD implementation template for GCD
//             :
//  Developers :  Otto Westy Rasmussen
//             :
//  Purpose    :  This is a template for the FSMD (finite state machine with datapath) 
//             :  implementation of the GCD circuit
//             :
//  Revision   :  02203 fall 2025 v.1.0
//
// -----------------------------------------------------------------------------


module gcd (
    input  logic          clk,    // The clock signal.
    input  logic          reset,  // Reset the module.
    input  logic          req,    // Start computation.
    input  logic [15 : 0] AB,     // The two operands. One at a time.
    output logic          ack,    // Input received / Computation is complete.
    output logic [15 : 0] C       // The result.
);

  logic n_flag;
  logic z_flag;
  logic ab_or_alu;
  logic load_a;
  logic load_b;
  logic [1:0] alu_fn;

  fsm u_fsm (
      .clk    (clk),
      .reset  (reset),
      .req    (req),
      .N      (n_flag),
      .Z      (z_flag),
      .ack    (ack),
      .ABorALU(ab_or_alu),
      .LDA    (load_a),
      .LDB    (load_b),
      .FN     (alu_fn)
  );

  datapath u_datapath (
      .clk    (clk),
      .reset  (reset),
      .req    (req),
      .ABorALU(ab_or_alu),
      .LDA    (load_a),
      .LDB    (load_b),
      .FN     (alu_fn),
      .AB     (AB),
      .N      (n_flag),
      .Z      (z_flag),
      .C      (C)
  );

endmodule
