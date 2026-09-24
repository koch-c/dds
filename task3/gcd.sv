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
  typedef enum logic [4 : 0] {
    idle,
    load_A,
    finished_load,
    load_B,
    smallestA,
    smallestB,
    subtract_A,
    subtract_B,
    output_C,
    restart
  } state_t;  // Input your own state names here

  shortint unsigned reg_a, next_reg_a, reg_b, next_reg_b;

  state_t state, next_state;
  logic comparer_out;
  logic [15:0] subber_src1, subber_src2, subber_out;
  logic [15:0] comparer_src1, comparer_src2;

  // Combinatorial logic
  always_comb begin
    next_state = state;
    next_reg_a = reg_a;
    next_reg_b = reg_b;
    ack = 0;
    C = 0;
    subber_src1 = 16'b0;
    subber_src2 = 16'b0;
    comparer_src1 = 16'b0;
    comparer_src2 = 16'b0;

    case (state)
      // <COMBINATORIAL BODY> 
      idle: begin
        if (req) begin
          next_state = load_A;
        end
      end
      load_A: begin
        next_reg_a = AB;
        ack = 1;
        if (!req) begin
          next_state = finished_load;
        end
      end
      finished_load: begin
        if (req) begin
          next_state = load_B;
        end
      end
      load_B: begin
        next_reg_b = AB;
        next_state = smallestA;
      end
      smallestA: begin
        comparer_src1 = reg_a;
        comparer_src2 = reg_b;
        if (comparer_out) begin
          next_state = subtract_B;
        end else begin
          next_state = smallestB;
        end
      end
      smallestB: begin
        comparer_src1 = reg_b;
        comparer_src2 = reg_a;
        if (comparer_out) begin
          next_state = subtract_A;
        end else begin
          next_state = output_C;
        end
      end
      subtract_A: begin
        subber_src1 = reg_a;
        subber_src2 = reg_b;
        next_reg_a  = subber_out;
        next_state  = smallestA;
      end
      subtract_B: begin
        subber_src1 = reg_b;
        subber_src2 = reg_a;
        next_reg_b = subber_out;
        next_state = smallestA;
      end
      output_C: begin
        C = reg_a;
        ack = 1;
        if (!req) begin
          next_state = restart;
        end
      end
      restart: begin
        next_state = idle;
      end
      default begin
        next_state = idle;
      end
    endcase
  end

  // Register
  always_ff @(posedge clk or posedge reset) begin
    // <REGISTER BODY>
    if (reset) begin
      reg_a <= 0;
      reg_b <= 0;
      state <= idle;
    end else begin
      reg_a <= next_reg_a;
      reg_b <= next_reg_b;
      state <= next_state;
    end
  end

  assign subber_out = subber_src1 - subber_src2;
  assign comparer_out = comparer_src1 < comparer_src2;

endmodule
