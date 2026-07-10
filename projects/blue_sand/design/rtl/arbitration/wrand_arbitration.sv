// wrand_arbitration
module wrand_arbitration ( clk,
                           resetn,
                           seed,
                           load_seed,
                           req_in,
                           req_out,
                           pull,
                           pull_ready,
                           push,
                           push_ready,
                           threshold_val
                         );
  import arbitration_pkg::*;

  parameter LFSR_SIZE    = 16;
  input clk;
  input resetn;

  input  request_t [2-1:0] req_in;
  output logic     [2-1:0] pull;
  input            [2-1:0] pull_ready;

  input [LFSR_SIZE-1:0] seed;
  input                 load_seed;
  logic [LFSR_SIZE-1:0] random;
  input [LFSR_SIZE:0]   threshold_val;


  output request_t req_out;
  output logic     push;
  input            push_ready;
  
  lfsr #(.NUM_OF_BITS(LFSR_SIZE)) lfsr_i( .clk          (clk),
                                          .reset        (resetn),
                                          .is_triggered ('0), 
                                          .trigger      ('0),
                                          .seed         (seed), 
                                          .number       (random), 
                                          .max          ('1), 
                                          .min          ('0),
                                          .mode         ('0), 
                                          .load         (load_seed)
                                        ); 

  logic         count;
  logic [2-1:0] interconnection_tmp;
  logic [2-1:0] tmp_choosen;
  logic         intra;

  assign count                  = pull_ready[0]&pull_ready[1];
  assign interconnection_tmp[1] = 1;
  assign interconnection_tmp[0] = pull_ready[0] == 0;

  assign tmp_choosen[0]         = 0;
  assign tmp_choosen[1]         = random<threshold_val;

  assign intra                  = interconnection_tmp[tmp_choosen[count]]; 
  assign req_out                = req_in[intra];
  
  assign push                   = pull_ready[intra];
  assign pull[0]                = push == 1&&push_ready == 1&&(intra == 0);
  assign pull[1]                = push == 1&&push_ready == 1&&(intra == 1);

endmodule
