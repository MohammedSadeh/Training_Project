module clk_muxing_to_pwm ( clk,
                           resetn,
                           count,
                           clk_cfg ,
                           select_bit,
                           clk_out,
                           boot_done_val
                         );

  parameter `DATA_WIDTH = 8;

  input clk;
  input resetn;

  input [`DATA_WIDTH-1 : 0] count;
  input [`DATA_WIDTH-1 : 0] clk_cfg;    // 0 -> clk , 1 -> control pwm clk ,2 -> control counter clk  
  input [`DATA_WIDTH-1 : 0] select_bit; // 0 -> clk sys   1 -> depends on counter bit 
  input [`DATA_WIDTH-1 : 0] boot_done_val; 
  
  output logic clk_out;
  
  bit [3-1 : 0] save_bit;
  bit           valid;

  
  bit_to_address_map #(.`DATA_WIDTH(`DATA_WIDTH)) p_encoder ( .data_in(select_bit),
                                                            .data_out(save_bit),
                                                            .valid(valid)
                                                          ); 

  always_comb begin
    if (resetn == 0 || clk_cfg != 1 || boot_done_val[0] == 0)  begin
      clk_out = clk;
    end
    else if (boot_done_val[0] == 1) begin
      // sleep mode 
      if (valid == 0)begin
        clk_out = 0;
      end
      else begin
        clk_out = count[save_bit];
      end 
    end 
  end
endmodule 

