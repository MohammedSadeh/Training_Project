// rand_arbitration
module rand_arbitration ( clk,
                          resetn,
                          seed,
                          load_seed,
                          req_in,
                          req_out,
                          pull,
                          pull_ready,
                          push,
                          push_ready,
                          chosen_i,
                          not_chosen
                        );

  import arbitration_pkg::*;

  parameter  LFSR_SIZE              = 16;
  localparam THIRD_OF_MAX           = (1<<LFSR_SIZE)/3;
  localparam TWO_THIRDS_OF_MAX      = 2*THIRD_OF_MAX;
  localparam HALF_OF_MAX            = 1<<(LFSR_SIZE-1);
  localparam QUARTER_OF_MAX         = 1<<(LFSR_SIZE-2);
  localparam THREE_QUARTERS_OF_MAX = 3*QUARTER_OF_MAX;
  
  input clk;
  input resetn;

  input  request_t [4-1:0] req_in;
  output logic     [4-1:0] pull;
  input            [4-1:0] pull_ready;

  input [LFSR_SIZE-1:0] seed;
  input                 load_seed;
  logic [LFSR_SIZE-1:0] random;


  output request_t req_out;
  output logic     push;
  input            push_ready;
  
  input        [3-1:0] not_chosen;
  output logic [3-1:0] chosen_i;
  
  logic [2-1:0]         count;
  logic [4-1:0] [3-1:0] interconnection_tmp;
  logic [5-1:0] [3-1:0] tmp_chosen;
  logic [3-1:0]         intra;
  logic                 not_chosen_flag;
  logic                 disabled; 
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

  assign count                  = 2'b11+pull_ready[0]+pull_ready[1]+pull_ready[2]+pull_ready[3];
  assign interconnection_tmp[3] = pull_ready[3]==1?3:4;
  assign interconnection_tmp[2] = pull_ready[2]==1?2:interconnection_tmp[3];
  assign interconnection_tmp[1] = pull_ready[1]==1?1:interconnection_tmp[2];
  assign interconnection_tmp[0] = pull_ready[0]==1?0:interconnection_tmp[1];

  assign tmp_chosen[0]         = 0;
  assign tmp_chosen[1]         = random>HALF_OF_MAX;
  assign tmp_chosen[2]         = (random>THIRD_OF_MAX)+(random>TWO_THIRDS_OF_MAX);
  assign tmp_chosen[3]         = (random>QUARTER_OF_MAX)+(random>HALF_OF_MAX)+(random>THREE_QUARTERS_OF_MAX);

  assign not_chosen_flag       = tmp_chosen[4]==not_chosen;
  assign disabled              = not_chosen_flag==1&&count==0; 
  assign tmp_chosen[4]         = tmp_chosen[count];
  assign chosen_i              = tmp_chosen[4]+not_chosen_flag;
  assign intra                  = interconnection_tmp[chosen_i[1:0]]+disabled*4; 
  assign req_out                = req_in[intra[1:0]];
  
  assign push                   = pull_ready[intra[1:0]]&~disabled;
  assign pull[0]                = push==1&&push_ready==1&&(intra==0);
  assign pull[1]                = push==1&&push_ready==1&&(intra==1);
  assign pull[2]                = push==1&&push_ready==1&&(intra==2);
  assign pull[3]                = push==1&&push_ready==1&&(intra==3);

endmodule
