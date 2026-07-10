module clk_muxing_to_count ( clk,
                             resetn,
                             clk_cfg ,
                             pwm_status, 
                             pwm_mode, 
                             pwm_clk_selection,
                             pwm_port_sig_val,
                             clk_out
                           );

  parameter DATA_WIDTH = 8; 

  input clk; 
  input resetn;

  input [DATA_WIDTH-1 : 0] clk_cfg;           // 0 -> clk system   1 -> control pwm clk   2 -> control counter clk 
  input [DATA_WIDTH-1 : 0] pwm_status;        // bit 0 contains pwm_done 
  input [DATA_WIDTH-1 : 0] pwm_mode;          // pwm_mode , two mode 
  input [DATA_WIDTH-1 : 0] pwm_clk_selection; // bit map  0 port1 or 1 port2 , [2:7] reserved .. 
  input [DATA_WIDTH-1 : 0] pwm_port_sig_val; 

  output logic clk_out ; 

  bit [3-1 : 0] save_bit;
  bit              valid;
 
  bit_to_address_map #(.DATA_WIDTH(DATA_WIDTH)) p_encoder ( .data_in(pwm_clk_selection),
                                                            .data_out(save_bit) ,
                                                            .valid(valid)
                                                          ); 

  always_comb begin
    if (resetn == 0 || clk_cfg != 2 ) begin
      clk_out = clk;
    end
    else if (clk_cfg == 2 ) begin
      if (valid == 0 )begin
        clk_out = 0 ;
      end 
      else begin
        if (pwm_mode == 0) begin
          clk_out = pwm_port_sig_val[save_bit] ;
        end
        else if (pwm_mode == 1)begin
         if (pwm_port_sig_val[save_bit] == 1) begin
           clk_out = clk;
         end
        end
      end
    end 
  end
endmodule

