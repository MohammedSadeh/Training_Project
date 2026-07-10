// multi-mode up/down counter with programmable load values, wrap detection, and interrupt generation.
module counter( clk,
                resetn,
                next_count,
                count,
                enable,
                mode,
                main_load_val,
                secondary_load_val,
                number_of_cycles_val,
                main_load_sig,
                overflow_intr_sig,
                underflow_intr_sig,
                wrap_intr_sig,
                region_changed_intr_sig,
                wrap_sig
               );

  parameter COUNTER_WIDTH = 8;

  input                  clk;
  input                  resetn;
  input                  main_load_sig;
  input [2:0]            mode;
  input                  enable;
  input [COUNTER_WIDTH-1:0] main_load_val;
  input [COUNTER_WIDTH-1:0] secondary_load_val;
  input [COUNTER_WIDTH-1:0] number_of_cycles_val;

  output logic       wrap_sig;
  output logic overflow_intr_sig; //0: overflow, 1:underflow, 2:wrap, 3:region_changed
  output logic underflow_intr_sig;
  output logic wrap_intr_sig;
  output logic region_changed_intr_sig;
  output logic [COUNTER_WIDTH-1:0] next_count;
  output logic [COUNTER_WIDTH-1:0] count;
  
  logic                  prev_main_load_wrap;
  logic                  prev_secondary_load_wrap;
  logic                  prev_enable;
  logic [2:0]            prev_mode;
  logic [COUNTER_WIDTH-1:0] prev_count;
  logic [COUNTER_WIDTH-1:0] cycles_count;

  localparam MAX_VALUE = ((1<<COUNTER_WIDTH)-1);

  always @(posedge clk) begin
    if(resetn == 0) begin
      count                    <= 0;
      wrap_sig                 <= 0;
      next_count               <= 0;
      prev_enable              <= 0;
      prev_mode                <= 0;
      cycles_count             <= 0;
      overflow_intr_sig        <= 0;
      underflow_intr_sig       <= 0;
      wrap_intr_sig            <= 0;
      region_changed_intr_sig  <= 0;
      prev_main_load_wrap      <= 1;
      prev_secondary_load_wrap <= 1;
    end
    else begin
      //main load catch
      if(main_load_sig == 1) begin
        cycles_count             <= 0; 
        overflow_intr_sig        <= 0;
        underflow_intr_sig       <= 0;
        wrap_intr_sig            <= 0;
        region_changed_intr_sig  <= 0;
        prev_main_load_wrap      <= 1;
        prev_secondary_load_wrap <= 1;
        next_count               <= main_load_val;
      end
      //Counter is enabled
      else if (enable == 1) begin
        //cycle counting
        prev_enable <= 1;
        if(prev_enable == 0) begin
          cycles_count <= 0;
        end
        else if(cycles_count!=number_of_cycles_val) begin 
          wrap_sig                <= 0;
          cycles_count            <= cycles_count+1;
          overflow_intr_sig       <= 0;
          underflow_intr_sig      <= 0;
          wrap_intr_sig           <= 0;
          region_changed_intr_sig <= 0;
        end
        //finished round
        else begin
          count        <= next_count;
          prev_count   <= count;
          cycles_count <= 0;
          //overflow interrupt handle
          overflow_intr_sig <= (next_count == MAX_VALUE) && (mode[2] == 1);

          //underflow interrupt handle
          underflow_intr_sig <= (next_count == 0) && (mode[2] == 0);
          
          //the wrap_sig, wrap interrupt is handled for each case independently
          //free running mode
          if(mode[1:0] == 0) begin
            prev_main_load_wrap      <= 1;
            prev_secondary_load_wrap <= 1;
            wrap_sig                 <= (next_count == MAX_VALUE && mode[2]==1) ||
                                        (next_count == 0         && mode[2]==0);
            next_count<= next_count +  (mode[2] == 1 ? 1 : -1);
            wrap_intr_sig            <= 0;
          end
          //single wrap point
          else if(mode[1:0] == 1) begin
            prev_secondary_load_wrap <= 1;
            if((next_count == MAX_VALUE && mode[2]==1) ||
               (next_count == 0         && mode[2]==0)) begin
              wrap_sig       <= 1;
              prev_main_load_wrap <= 1;
              wrap_intr_sig  <= next_count == main_load_val;
              next_count     <= main_load_val;
            end
            else if((next_count == main_load_val) && (prev_main_load_wrap == 0) && (mode[2] == prev_mode[2])) begin
                wrap_sig       <= 1;
                prev_main_load_wrap <= 1;
                wrap_intr_sig  <= 1;
                next_count     <= (mode[2] == 1 ? 0 : MAX_VALUE);
            end
            else begin
                wrap_sig       <= 0;
                prev_main_load_wrap <= 0;
                wrap_intr_sig  <= 0;
                next_count     <= next_count+(mode[2] == 1 ? 1 : -1);
            end                            
          end
          //double wrap point
          else if(mode[1:0] == 2) begin
            if((next_count == main_load_val) && (prev_secondary_load_wrap == 0) && (mode[2] == prev_mode[2])) begin
              wrap_sig                 <= 1;
              next_count               <= secondary_load_val;
              prev_secondary_load_wrap <= 0;
              prev_main_load_wrap      <= 1;
              wrap_intr_sig            <= 1;
            end
            else if(next_count==secondary_load_val && prev_main_load_wrap==0 && (mode[2] == prev_mode[2])) begin
              wrap_sig                 <= 1;
              next_count               <= main_load_val;
              prev_secondary_load_wrap <= 1;
              prev_main_load_wrap      <= 0;
              wrap_intr_sig            <= 1;
            end
            else begin
              wrap_sig                 <= 0;
              next_count               <= next_count+(mode[2] == 1 ? 1 : -1);
              prev_secondary_load_wrap <= 0;
              prev_main_load_wrap      <= 0;
              wrap_intr_sig            <= 0;  
            end
          end
          //special single wrap point
          else if(mode[1:0] == 3) begin
            prev_main_load_wrap      <= 1;
            prev_secondary_load_wrap <= 1;
            wrap_intr_sig            <= 0;
            if((next_count == MAX_VALUE && mode[2]==1) ||
               (next_count == 0         && mode[2]==0)) begin
                wrap_sig   <= 1;
                next_count <= main_load_val;
            end
            else begin
                wrap_sig   <= 0;
                next_count <= next_count+(mode[2] == 1 ? 1 : -1);
            end                         
          end
        end 
        //region change interrupt handle
        prev_mode <= mode;
        //The mode didn't change, and the mode is 01 or 10 : single wrap or double wrap
        if(prev_enable==1 && (prev_mode[1:0] == mode[1:0]) && (mode[2] != prev_mode[2])) begin
          if(mode[1:0] == 1) begin
            if(next_count == main_load_val) begin
              prev_main_load_wrap <= 1;
            end
            if(mode[2] == 1) begin
              if((prev_count == 0) && (count == main_load_val)) begin
                region_changed_intr_sig <= 1;        
              end 
            end
            else begin
              if((prev_count == MAX_VALUE) && (count == main_load_val)) begin
                region_changed_intr_sig <= 1;
              end
            end 
          end
          else if(mode[1:0] == 2) begin
            if(next_count == main_load_val || next_count == secondary_load_val) begin
              prev_secondary_load_wrap <= 1;
            end
            if(((prev_count == main_load_val) && (count == secondary_load_val)) || ((prev_count == secondary_load_val) && (count == main_load_val))) begin
              region_changed_intr_sig <= 1;
            end
          end 
        end
      end
      else begin
        //if the register aren't enabled there won't be interrupts signals
        wrap_sig                <= 0;
        prev_enable             <= 0;
        cycles_count            <= 0;
        overflow_intr_sig       <= 0;
        underflow_intr_sig      <= 0;
        wrap_intr_sig           <= 0;
        region_changed_intr_sig <= 0;
      end
      //second handle for the load operation
      if(count != next_count) begin
        count      <= next_count;
        prev_count <= count;
      end
      
      //if the register control aren't able to change on consecutive clock cycles, this line remains correct.
      if(region_changed_intr_sig == 1) begin
        region_changed_intr_sig <= 0;
      end

    end
  end
endmodule
