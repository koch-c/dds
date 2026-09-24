module fsm (
    input  logic         clk,
    input  logic         reset,
    input  logic         req,
    input  logic         N,
    input  logic         Z,
    output logic         ack,
    output logic         ABorALU,
    output logic         LDA,
    output logic         LDB,
    output logic [1 : 0] FN
);
  typedef enum logic [4 : 0] {
    idle,
    load_A,
    finished_load,
    load_B,
    compute,
    compute1,
    output_C
  } state_t;  // Input your own state names here
  state_t state, next_state;

  always_comb begin
    next_state = state;

    // Outputs
    ack = 0;
    ABorALU = 0;
    LDA = 0;
    LDB = 0;
    FN = 2'b00;

    case (state)
      idle: begin
        if (req) begin
          next_state = load_A;
        end
      end
      load_A: begin
        LDA = 1;
        ack = 1;
        ABorALU = 1;
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
        LDB = 1;
        ABorALU = 1;
        next_state = compute;
      end
      compute: begin
        next_state = compute;
        if (Z) begin
          next_state = output_C;
        end else if (N) begin
          next_state = compute1;
        end else begin
          LDA = 1;
        end
      end
      compute1: begin
        FN = 2'b01;
        LDB = 1;
        next_state = compute;
      end
      output_C: begin
        FN  = 2'b11;
        ack = 1;
        if (!req) begin
          next_state = idle;
        end
      end
      default begin
        next_state = idle;
      end
    endcase
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= idle;
    end else begin
      state <= next_state;
    end
  end
endmodule
