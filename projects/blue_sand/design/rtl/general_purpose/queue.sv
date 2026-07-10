module queue ( clk,
               resetn,
               almost_full,
               req_in,
               req_out,
               push,
               push_ready,
               pull,
               pull_ready,
               full,
               occupancy,
               empty,
               size_exceeded_intr
              );

  import arbitration_pkg::*;

  parameter  QUEUE_SIZE = 5;
  localparam QUEUE_SIZE_LOCAL = 1<<QUEUE_SIZE;
  
  request_t [QUEUE_SIZE_LOCAL-1:0] data;

  
  input clk;
  input resetn;
  input pull;
  input push;
  
  output logic full;
  output logic empty;
  output logic push_ready;
  output logic pull_ready;
  output logic size_exceeded_intr;

  input        [QUEUE_SIZE-1:0] almost_full;
  output logic [QUEUE_SIZE  :0] occupancy;
  
  input  request_t req_in;    
  output request_t req_out;

  
  logic [QUEUE_SIZE-1:0] w_ptr; 
  logic [QUEUE_SIZE-1:0] r_ptr; 

  always @(posedge clk) begin
    if(resetn == 0) begin
      w_ptr     <= 0;
      r_ptr     <= 0;
      occupancy <= 0;
    end 
    else begin

      if(push == 1 && full == 0) begin
        data[w_ptr] <= req_in;
        w_ptr        <= w_ptr+1;
        if(!(pull == 1 && empty == 0)) begin
          occupancy <= occupancy+1;
        end
      end

      if(pull == 1 && empty == 0) begin
        r_ptr <= r_ptr+1;
        if(!(push == 1 && full == 0)) begin
          occupancy <= occupancy-1;
        end
      end
    end
  
  end

  assign empty              = occupancy == 0;
  assign full               = occupancy > (QUEUE_SIZE_LOCAL-almost_full-1);

  assign push_ready         = full  == 0;
  assign pull_ready         = empty == 0;

  assign size_exceeded_intr = occupancy[QUEUE_SIZE];

  assign req_out            = data[r_ptr];

endmodule
