// multi_arbitration_design
module multi_arbitration_design ( clk, 
                                  resetn,
                                  push,
                                  push_ready,
                                  level_thresholds,
                                  level_weights,
                                  rseed,
                                  load_rseed,
                                  req_sources,
                                  req_output,
                                  full_queue_status,
                                  empty_queue_status,
                                  occupancy_queue_status,
                                  almost_full,
                                  size_exceeded_intr,
                                  threshold_val,
                                  stage3_input_requests,
                                  pull,
                                  pull_ready
                                );
  import arbitration_pkg::*;

  parameter  LFSR_SIZE    = 16;
  parameter  QUEUE_SIZE   = 5;
  localparam INPUT_COUNT  = 16;
  localparam LEVEL1_COUNT = 4;
  localparam LEVEL2_COUNT = 2;
  localparam OUTPUT_COUNT = 1;
  localparam ALL_COUNT    = INPUT_COUNT+ LEVEL1_COUNT+ LEVEL2_COUNT+ OUTPUT_COUNT;
  input clk;
  input resetn;
  
  input        [ALL_COUNT-1:0] [5-1:0] almost_full;
  output logic [ALL_COUNT-1:0]         full_queue_status;
  output logic [ALL_COUNT-1:0]         empty_queue_status;
  output logic [ALL_COUNT-1:0] [5  :0] occupancy_queue_status;
  output logic [ALL_COUNT-1:0]         size_exceeded_intr;

  input [LEVEL1_COUNT-1:0] [2-1:0] [5-1:0] level_thresholds;
  input [LEVEL1_COUNT-1:0] [3-1:0] [4-1:0] level_weights;
  
  input  request_t [INPUT_COUNT-1:0] req_sources;
  input            [INPUT_COUNT-1:0] push;
  output logic     [INPUT_COUNT-1:0] push_ready;

  request_t [INPUT_COUNT-1:0] stage1_input_requests; 
  logic     [INPUT_COUNT-1:0] stage1_input_pull;
  logic     [INPUT_COUNT-1:0] stage1_input_pull_ready;

  request_t [LEVEL1_COUNT-1:0] stage1_output_requests; 
  logic     [LEVEL1_COUNT-1:0] stage1_output_push;
  logic     [LEVEL1_COUNT-1:0] stage1_output_push_ready;

  request_t [LEVEL1_COUNT-1:0] stage2_input_requests; 
  wor       [LEVEL1_COUNT-1:0] stage2_input_pull;
  wor       [LEVEL1_COUNT-1:0] stage2_input_pull_ready;

  request_t [LEVEL2_COUNT-1:0] stage2_output_requests; 
  logic     [LEVEL2_COUNT-1:0] stage2_output_push;
  logic     [LEVEL2_COUNT-1:0] stage2_output_push_ready;

  output request_t [LEVEL2_COUNT-1:0] stage3_input_requests; 
         logic     [LEVEL2_COUNT-1:0] stage3_input_pull;
         logic     [LEVEL2_COUNT-1:0] stage3_input_pull_ready;
  
  request_t stage3_output_requests; 
  logic     stage3_output_push;
  logic     stage3_output_push_ready;

  input [LEVEL2_COUNT+OUTPUT_COUNT-1:0] [LFSR_SIZE-1:0] rseed;
  input [LEVEL2_COUNT+OUTPUT_COUNT-1:0]                 load_rseed;
  logic [3-1:0]                                         first_chosen_i;
  logic [3-1:0]                                         second_chosen_i;

  input [LFSR_SIZE:0]   threshold_val;
  
  output request_t req_output;
  input            pull;
  output logic     pull_ready;

  genvar input_queue_idx;
  generate 
    for(input_queue_idx = 0; input_queue_idx < INPUT_COUNT; input_queue_idx = input_queue_idx+1) 
    begin: input_queue
      queue #(.QUEUE_SIZE(QUEUE_SIZE))
            input_queue( .clk                (clk),
                         .resetn             (resetn),
                         .almost_full        (almost_full             [input_queue_idx]),
                         .req_in             (req_sources             [input_queue_idx]),
                         .req_out            (stage1_input_requests   [input_queue_idx]),
                         .push               (push                    [input_queue_idx]),
                         .push_ready         (push_ready              [input_queue_idx]),
                         .pull               (stage1_input_pull       [input_queue_idx]),
                         .pull_ready         (stage1_input_pull_ready [input_queue_idx]),
                         .full               (full_queue_status        [input_queue_idx]),
                         .empty              (empty_queue_status       [input_queue_idx]),
                         .occupancy          (occupancy_queue_status   [input_queue_idx]),
                         .size_exceeded_intr (size_exceeded_intr      [input_queue_idx])
                       );
    end
  endgenerate
 
  genvar wrr_block_idx; 
  generate
    for(wrr_block_idx = 0; wrr_block_idx < LEVEL1_COUNT;wrr_block_idx = wrr_block_idx+1)
    begin: wrr_block
    wrr_arbitration #(.INPUT_QUEUE_WIDTH(QUEUE_SIZE))
                    wrr_block ( .clk              (clk),
                                .resetn           (resetn),
                                .level_thresholds (level_thresholds        [wrr_block_idx]),
                                .level_weights    (level_weights           [wrr_block_idx]),
                                .req_in           (stage1_input_requests   [wrr_block_idx*4 +: 4]),
                                .req_out          (stage1_output_requests  [wrr_block_idx]),
                                .pull             (stage1_input_pull       [wrr_block_idx*4 +: 4]),
                                .pull_ready       (stage1_input_pull_ready [wrr_block_idx*4 +: 4]),
                                .push             (stage1_output_push      [wrr_block_idx]),
                                .push_ready       (stage1_output_push      [wrr_block_idx]),
                                .occupancies      (occupancy_queue_status   [wrr_block_idx*4 +: 4])
                              );
                          
    end
  endgenerate
  
  genvar stage1_queue_idx;
  generate 
    for(stage1_queue_idx = 0; stage1_queue_idx < LEVEL1_COUNT; stage1_queue_idx = stage1_queue_idx+1) 
    begin: stage1_queue
      queue #(.QUEUE_SIZE(QUEUE_SIZE))
            stage1_queue( .clk                (clk),
                          .resetn             (resetn),
                          .req_in             (stage1_output_requests   [stage1_queue_idx]),
                          .req_out            (stage2_input_requests    [stage1_queue_idx]),
                          .push               (stage1_output_push       [stage1_queue_idx]),
                          .push_ready         (stage1_output_push_ready [stage1_queue_idx]),
                          .pull               (stage2_input_pull        [stage1_queue_idx]),
                          .pull_ready         (stage2_input_pull_ready  [stage1_queue_idx]),
                          .almost_full        (almost_full              [INPUT_COUNT+stage1_queue_idx]),
                          .full               (full_queue_status         [INPUT_COUNT+stage1_queue_idx]),
                          .empty              (empty_queue_status        [INPUT_COUNT+stage1_queue_idx]),
                          .occupancy          (occupancy_queue_status    [INPUT_COUNT+stage1_queue_idx]),
                          .size_exceeded_intr (size_exceeded_intr       [INPUT_COUNT+stage1_queue_idx])
                        );
    end
  endgenerate

  rand_arbitration rand_block_0 ( .clk         (clk),
                                  .resetn      (resetn),
                                  .seed        (rseed[0]),
                                  .load_seed   (load_rseed[0]),
                                  .req_in      (stage2_input_requests),
                                  .req_out     (stage2_output_requests[0]),
                                  .pull        (stage2_input_pull), 
                                  .pull_ready  (stage2_input_pull_ready),
                                  .push        (stage2_output_push[0]),
                                  .push_ready  (stage2_output_push_ready[0]),
                                  .chosen_i   (first_chosen_i),
                                  .not_chosen (3'b111)
                                );

  rand_arbitration rand_block_1 ( .clk         (clk),
                                  .resetn      (resetn),
                                  .seed        (rseed[1]),
                                  .load_seed   (load_rseed[1]),
                                  .req_in      (stage2_input_requests),
                                  .req_out     (stage2_output_requests[1]),
                                  .pull        (stage2_input_pull), 
                                  .pull_ready  (stage2_input_pull_ready),
                                  .push        (stage2_output_push[1]),
                                  .push_ready  (stage2_output_push_ready[1]),
                                  .chosen_i   (second_chosen_i),
                                  .not_chosen (first_chosen_i)
                                );


  genvar stage2_queue_idx;
  generate 
    for(stage2_queue_idx = 0; stage2_queue_idx < LEVEL2_COUNT; stage2_queue_idx = stage2_queue_idx+1) 
    begin: stage2_queue
      queue #(.QUEUE_SIZE(QUEUE_SIZE))
            stage2_queue( .clk                (clk),
                          .resetn             (resetn),
                          .req_in             (stage2_output_requests   [stage2_queue_idx]),
                          .req_out            (stage3_input_requests    [stage2_queue_idx]),
                          .push               (stage2_output_push       [stage2_queue_idx]),
                          .push_ready         (stage2_output_push_ready [stage2_queue_idx]),
                          .pull               (stage3_input_pull        [stage2_queue_idx]),
                          .pull_ready         (stage3_input_pull_ready  [stage2_queue_idx]),
                          .almost_full        (almost_full              [INPUT_COUNT+LEVEL1_COUNT+stage2_queue_idx]),
                          .full               (full_queue_status         [INPUT_COUNT+LEVEL1_COUNT+stage2_queue_idx]),
                          .empty              (empty_queue_status        [INPUT_COUNT+LEVEL1_COUNT+stage2_queue_idx]),
                          .occupancy          (occupancy_queue_status    [INPUT_COUNT+LEVEL1_COUNT+stage2_queue_idx]),
                          .size_exceeded_intr (size_exceeded_intr       [INPUT_COUNT+LEVEL1_COUNT+stage2_queue_idx])
                        );
    end
  endgenerate

  wrand_arbitration wrand_block ( .clk           (clk),
                                  .resetn        (resetn),
                                  .seed          (rseed[2]),
                                  .load_seed     (load_rseed[2]),
                                  .req_in        (stage3_input_requests),
                                  .req_out       (stage3_output_requests),
                                  .pull          (stage3_input_pull), 
                                  .pull_ready    (stage3_input_pull_ready),
                                  .push          (stage3_output_push),
                                  .push_ready    (stage3_output_push_ready),
                                  .threshold_val (threshold_val)
                                 );

  queue #(.QUEUE_SIZE(QUEUE_SIZE))
        output_queue( .clk                (clk),
                      .resetn             (resetn),
                      .req_in             (stage3_output_requests),
                      .req_out            (req_output),
                      .push               (stage3_output_push),
                      .push_ready         (stage3_output_push_ready),
                      .pull               (pull),
                      .pull_ready         (pull_ready),
                      .almost_full        (almost_full           [INPUT_COUNT+LEVEL1_COUNT+LEVEL2_COUNT]),
                      .full               (full_queue_status      [INPUT_COUNT+LEVEL1_COUNT+LEVEL2_COUNT]),
                      .empty              (empty_queue_status     [INPUT_COUNT+LEVEL1_COUNT+LEVEL2_COUNT]),
                      .occupancy          (occupancy_queue_status [INPUT_COUNT+LEVEL1_COUNT+LEVEL2_COUNT]),
                      .size_exceeded_intr (size_exceeded_intr    [INPUT_COUNT+LEVEL1_COUNT+LEVEL2_COUNT])
                    );

endmodule
