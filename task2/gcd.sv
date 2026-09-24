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
    compute,
    subtract_A,
    subtract_B,
    output_C,
    restart
  } state_t;  // Input your own state names here

  shortint unsigned reg_a, next_reg_a, reg_b, next_reg_b;

  state_t state, next_state;
  logic a_larger_than_b, b_larger_than_a;

  // Combinatorial logic
  always_comb begin
    next_state = state;
    next_reg_a = reg_a;
    next_reg_b = reg_b;
    ack = 0;
    C = 0;

    a_larger_than_b = reg_a > reg_b;
    b_larger_than_a = reg_b > reg_a;

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
        next_state = compute;
      end
      compute: begin
        if (a_larger_than_b) begin
          next_state = subtract_A;
        end else if (b_larger_than_a) begin
          next_state = subtract_B;
        end else begin
          next_state = output_C;
        end
      end
      subtract_A: begin
        next_reg_a = reg_a - reg_b;
        next_state = compute;
      end
      subtract_B: begin
        next_reg_b = reg_b - reg_a;
        next_state = compute;
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

endmodule
