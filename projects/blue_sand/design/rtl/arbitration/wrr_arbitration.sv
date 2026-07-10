// wrr_arbitration
module wrr_arbitration ( clk,
                         resetn,
                         level_thresholds,
                         level_weights,
                         req_in,
                         req_out,
                         pull,
                         pull_ready,
                         push,
                         push_ready,
                         occupancies
                       );
  import arbitration_pkg::*;

  parameter INPUT_QUEUE_WIDTH = 5;
  
  input                                 clk;
  input                                 resetn;
  input [2-1:0] [INPUT_QUEUE_WIDTH-1:0] level_thresholds;
  input [3-1:0] [4-1:0]                 level_weights;
  input [4-1:0] [INPUT_QUEUE_WIDTH  :0] occupancies;  

  input  request_t [4-1:0] req_in;
  output logic     [4-1:0] pull;
  input            [4-1:0] pull_ready;
  
  output request_t req_out;
  output logic     push;
  input            push_ready;
  
  logic [4-1:0] [4-1:0] counters;
  logic [2-1:0]         max_tmp;
  logic [2-1:0]         max_i;
 

  always @(posedge clk) begin
    if(resetn == 0) begin
      counters <= 0;
    end 
    else begin
      if(counters == 0) begin
        for(int i = 0;i<4;i++) begin
          if(occupancies[i] == 0 || ( occupancies[i]==1 && pull[i]==1 && pull[i]==1) ) begin
            counters[i] <= 0;
          end
          else if(occupancies[i] <= level_thresholds[0]) begin
            counters[i] <= level_weights[0];
          end 
          else if(occupancies[i] <= level_thresholds[1]) begin
            counters[i] <= level_weights[1];
          end 
          else begin 
            counters[i] <= level_weights[2];
          end 
        end
        
      end else begin 
        for(int i = 0;i<4;i++) begin
          if(occupancies[i] == 0) begin
            counters[i] <= 0;
          end
        end
        if(counters[max_i] != 0&&push_ready  == 1) begin
          counters[max_i] <= counters[max_i]-1;
        end
      end
    end
  
  end

  assign max_tmp[0] = ( counters[1]                   > counters[0]          && (pull_ready[1] == 1)                 ) || pull_ready[0] == 0;
  assign max_tmp[1] = ( counters[3]                   > counters[2]          && (pull_ready[3] == 1)                 ) || pull_ready[2] == 0;
  assign max_i[1]   = ( counters[ 2'h2 | max_tmp[1] ] > counters[max_tmp[0]] && (pull_ready[ 2'h2 | max_tmp[1] ]==1) ) || pull_ready[max_tmp[0]] == 0;
  assign max_i[0]   = max_tmp[max_i[1]];

  assign req_out    = req_in[max_i];
  assign push       = pull_ready[max_i];

  for(genvar push_idx = 0; push_idx < 4; push_idx = push_idx + 1) begin 
    assign pull[push_idx] = (push == 1) && (push_ready == 1) && (max_i == push_idx);
  end

endmodule
