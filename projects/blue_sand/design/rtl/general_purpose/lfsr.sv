module lfsr #(int NUM_OF_BITS = 5, logic TRANSITION = 0) ( clk,
                                                           reset,
                                                           is_triggered,
                                                           trigger,
                                                           max,
                                                           min,
                                                           load,
                                                           seed,
                                                           mode,
                                                           number
                                                         );

  // ---------- Inputs ---------
  // ----- Clock and Reset -----
  input clk;
  input reset;
  // ----- Control -----
  input is_triggered;
  input trigger;
  input mode;
  input load;
  // ----- Data ------
  input [NUM_OF_BITS-1:0] min;
  input [NUM_OF_BITS-1:0] max;
  input [NUM_OF_BITS-1:0] seed;

  // --------- Outputs ---------
  // ----- Data -----
  output [NUM_OF_BITS-1:0] number;

  // -------------------------- Logic starts ----------------------------
  logic [NUM_OF_BITS-1:0] lfsr;
  logic shift_bit;
  logic load_flag;

  // ---- Define the mirrored value of the lfsr
  wire [NUM_OF_BITS-1:0] out_mirror;
  wire [NUM_OF_BITS-1:0] out;

  // ---- Defien the transition matrix variables
  logic [NUM_OF_BITS-1:0] counter;
  logic [NUM_OF_BITS-1:0] transition;
  logic [NUM_OF_BITS-1:0] lfsr_buffer;
  logic [NUM_OF_BITS-1:0] transition_buffer;
  logic [NUM_OF_BITS-1:0] num;

  // ---- Assign the value of the lfsr register to the output
  assign number = (!reset) ? 0
                           : (mode == 0) ? (out<min | out>max) ? ((out & (max-min)) + min)
                                                               : out
                                         : (out_mirror<min | out_mirror>max) ? ((out_mirror & (max-min)) + min)
                                                                             : out_mirror;
 
  generate
    if (TRANSITION == 1) begin
      // ---- Assign the out-mirror value
      assign out_mirror = out; 

      // ----- Generate the transition matrix 
      case (NUM_OF_BITS)
         2 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {0, 1}; end
         3 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {0, 2, 1}; end 
         4 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {2, 3, 0, 1}; end
         5 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {3, 2, 0, 1, 4}; end
         6 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {4, 1, 2, 5, 0, 3}; end
         7 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {3, 0, 2, 5, 6, 4, 1}; end
         8 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {2, 4, 3, 5, 7, 0, 6, 1}; end
         9 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {2, 8, 3, 1, 5, 4, 0, 7, 6}; end
        10 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {5, 8, 0, 6, 9, 3, 2, 4, 1, 7}; end
        11 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {3, 4, 7, 2, 6, 5, 10, 0, 8, 1, 9}; end 
        12 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {11, 10, 2, 7, 1, 8, 4, 0, 6, 5, 9, 3}; end 
        13 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {0, 8, 7, 12, 10, 4, 11, 9, 5, 3, 2, 6, 1}; end 
        14 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {0, 1, 10, 3, 12, 2, 5, 6, 8, 7, 4, 13, 11, 9}; end 
        15 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {12, 14, 6, 0, 7, 3, 13, 10, 11, 1, 9, 2, 4, 8, 5}; end 
        16 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {6, 14, 8, 12, 5, 15, 11, 13, 4, 2, 0, 1, 9, 7, 3, 10}; end
        17 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {6, 9, 14, 16, 3, 11, 7, 1, 4, 2, 15, 10, 8, 0, 5, 13, 12}; end 
        18 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {11, 8, 16, 10, 12, 15, 5, 1, 14, 9, 6, 13, 7, 2, 3, 4, 0, 17}; end 
        19 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {4, 12, 10, 5, 11, 16, 7, 6, 18, 8, 14, 9, 0, 3, 1, 17, 13, 2, 15}; end 
        20 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {12, 15, 14, 10, 2, 9, 4, 6, 17, 5, 18, 16, 1, 3, 11, 8, 13, 7, 0, 19}; end 
        21 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {9, 15, 5, 17, 11, 14, 18, 3, 10, 1, 13, 6, 19, 16, 12, 2, 8, 0, 20, 7, 4}; end 
        22 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {6, 13, 20, 9, 3, 17, 0, 5, 11, 16, 12, 15, 7, 1, 21, 2, 4, 18, 8, 19, 14, 10}; end 
        23 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {16, 19, 8, 0, 12, 17, 18, 22, 5, 4, 2, 15, 20, 6, 11, 9, 21, 3, 7, 14, 1, 10, 13}; end 
        24 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {16, 21, 4, 12, 14, 20, 22, 11, 2, 17, 19, 23, 1, 7, 8, 18, 10, 9, 3, 5, 0, 13, 15, 6}; end 
        25 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {19, 2, 8, 0, 14, 11, 1, 18, 6, 10, 20, 7, 13, 9, 16, 22, 23, 24, 3, 4, 21, 17, 15, 5, 12}; end 
        26 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {6, 19, 14, 25, 11, 1, 18, 4, 17, 22, 20, 5, 15, 3, 12, 7, 8, 21, 9, 2, 16, 23, 13, 24, 10, 0}; end 
        27 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {7, 22, 25, 16, 1, 8, 14, 11, 10, 9, 17, 5, 12, 3, 26, 2, 18, 24, 20, 13, 23, 15, 6, 4, 0, 19, 21}; end   
        28 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {8, 22, 21, 27, 10, 24, 15, 6, 14, 1, 12, 5, 20, 16, 19, 2, 0, 9, 18, 23, 13, 25, 3, 17, 7, 4, 11, 26}; end  
        29 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {20, 15, 23, 22, 26, 21, 10, 25, 11, 1, 6, 2, 27, 17, 18, 14, 0, 5, 8, 7, 9, 3, 24, 12, 19, 16, 28, 4, 13}; end 
        30 : begin : TM  localparam [$clog2(NUM_OF_BITS)-1:0] TRANSITION_MATRIX [NUM_OF_BITS-1:0] = {2, 6, 29, 12, 3, 9, 19, 10, 7, 18, 13, 24, 26, 17, 16, 23, 14, 27, 25, 21, 28, 8, 11, 4, 5, 20, 15, 22, 1, 0}; end 
      endcase

      // ----- Generate the transition register
      for (genvar i=0; i<NUM_OF_BITS; i++) begin
        assign transition[NUM_OF_BITS-1-i] = lfsr_buffer[NUM_OF_BITS-1-TM.TRANSITION_MATRIX[i]]; 
      end 

      // ---- Assign the out value
      assign out = num;

      // ---- Comput the number depending on if the design is triggered by an external signal or not
      always @(posedge clk) begin
        if (reset == 0) begin
          lfsr              <= 0;
          lfsr_buffer       <= 0;
          transition_buffer <= 0;
          num               <= 0;
          counter           <= 0;
          load_flag         <= 0;
        end
        else begin
          if (load == 1) begin
            lfsr              <= seed;
            lfsr_buffer       <= seed;
            transition_buffer <= seed;
            num               <= seed;
            counter           <= 2*NUM_OF_BITS-1;
            load_flag         <= 1;
          end
          else begin
            if (load_flag == 1) begin
              if (is_triggered == 1) begin // the design will generate a new number on the trigger signal
                if (trigger == 1) begin
                  generate_lfsr();
                end
              end
              else begin // every clock the design will generate a new number
                generate_lfsr();
              end
            end
          end
        end
      end

      // ----- Task to generate the lfsr values
      task generate_lfsr ();
        lfsr        <= {shift_bit , lfsr       [NUM_OF_BITS-1:1]};
        lfsr_buffer <= {lfsr[0]   , lfsr_buffer[NUM_OF_BITS-1:1]};
        if (counter >= NUM_OF_BITS) begin
          num <= {lfsr_buffer[0], num[NUM_OF_BITS-1:1]};
          if (counter == NUM_OF_BITS) begin
            transition_buffer <= transition;
          end
        end 
        else begin
          num <= {transition_buffer[0], num[NUM_OF_BITS-1:1]};
          transition_buffer <= {0, transition_buffer[NUM_OF_BITS-1:0]};
        end
        counter <= counter -1;
        if (counter == 0) begin
          counter <= 2*NUM_OF_BITS-1;
        end
      endtask
    end
    else if (TRANSITION == 0) begin
      // ---- Assign the out-mirror value
      for (genvar i=0; i<NUM_OF_BITS; i++) begin
        assign out_mirror[i] = out[NUM_OF_BITS-1-i]; 
      end

      // ---- Assign the out value
      assign out = lfsr;

      // ---- Comput the number depending on if the design is triggered by an external signal or not
      always @(posedge clk) begin
        if (reset == 0) begin
          lfsr      <= 0;
          load_flag <= 0;
        end
        else begin
          if (load == 1) begin
            lfsr      <= seed;
            load_flag <= 1;
          end
          else begin
            if (load_flag == 1) begin
              if (is_triggered == 1) begin // the design will generate a new number on the trigger signal
                if (trigger == 1) begin
                  lfsr <= {shift_bit , lfsr [NUM_OF_BITS-1:1]};
                end
              end
              else begin // every clock the design will generate a new number
                lfsr <= {shift_bit , lfsr [NUM_OF_BITS-1:1]};
              end
            end
          end
        end
      end
    end
  endgenerate 

  // ----- Generate the shift bit primitive function 
  generate
    case (NUM_OF_BITS)  
      2,3,4,6,7,15,22 : assign shift_bit = (lfsr[0] ^ lfsr[1]);
      5,11,21,29      : assign shift_bit = (lfsr[0] ^ lfsr[2]);
      8,19            : assign shift_bit = (lfsr[0] ^ lfsr[1] ^ lfsr[5] ^ lfsr[6]);
      9               : assign shift_bit = (lfsr[0] ^ lfsr[4]);
      10,17,20,25,28  : assign shift_bit = (lfsr[0] ^ lfsr[3]);
      12              : assign shift_bit = (lfsr[0] ^ lfsr[3] ^ lfsr[4]  ^ lfsr[7]);
      13,24           : assign shift_bit = (lfsr[0] ^ lfsr[1] ^ lfsr[3]  ^ lfsr[4]);
      14              : assign shift_bit = (lfsr[0] ^ lfsr[1] ^ lfsr[11] ^ lfsr[12]);
      16              : assign shift_bit = (lfsr[0] ^ lfsr[2] ^ lfsr[3]  ^ lfsr[5]);
      18              : assign shift_bit = (lfsr[0] ^ lfsr[7]);
      23              : assign shift_bit = (lfsr[0] ^ lfsr[5]);
      26,27           : assign shift_bit = (lfsr[0] ^ lfsr[1] ^ lfsr[7]  ^ lfsr[8]);
      30              : assign shift_bit = (lfsr[0] ^ lfsr[1] ^ lfsr[15] ^ lfsr[16]);
      default         : $error("The number of bits that this lfsr supports is in the range of  [2:30]");
    endcase
  endgenerate

endmodule
