module clk_muxing_unit( clk,
                        resetn,
                        pwm_sig,
                        count_sig, 
                        pwm_clk, 
                        counter_clk,
                        arb_clk,
                        pwm_sel_val,
                        count_sel_val,
                        clk_muxing_cfg,
                        fatal_error
                      );

  parameter PWM_COUNT = 2;
  parameter COUNT_WIDTH = 8;

  input clk; 
  input resetn;

  input [PWM_COUNT-1 : 0] pwm_sig;
  input [COUNT_WIDTH-1 : 0] count_sig; 
  input [2-1:0] [PWM_COUNT -1 : 0] pwm_sel_val;
  input [2-1:0] [COUNT_WIDTH-1 : 0] count_sel_val;
  input [2-1:0] [2-1 : 0] clk_muxing_cfg; // clk muxing cfg has 3 active modes, 0 => system clk, 1 => count sig, 2=> pwm_sig
  
  output logic fatal_error;
  output logic pwm_clk; 
  output logic counter_clk;
  output logic arb_clk;


  always_comb begin
    pwm_clk = clk;
    counter_clk = clk;
    arb_clk = clk;
    if (resetn != 0) begin
      if (clk_muxing_cfg[0]==1)      pwm_clk    =|(count_sig&count_sel_val[0]);
      else if (clk_muxing_cfg[0]==2) counter_clk=|(pwm_sig&pwm_sel_val[0]); 
      if (clk_muxing_cfg[1]==1)      arb_clk    =|(count_sig&count_sel_val[1]);
      else if (clk_muxing_cfg[1]==2) arb_clk    =|(pwm_sig&pwm_sel_val[1]); 
    end 
  end
  
  always_comb begin
    if (resetn==0) begin
      fatal_error=0;
  end
    else begin
      if (clk_muxing_cfg[0]==1)      fatal_error=fatal_error | (count_sel_val[0]>=COUNT_WIDTH);
      else if (clk_muxing_cfg[0]==2) fatal_error=fatal_error | (pwm_sel_val[0]>=PWM_COUNT);
      if (clk_muxing_cfg[1]==1)      fatal_error=fatal_error | (count_sel_val[1]>=COUNT_WIDTH);
      else if (clk_muxing_cfg[1]==2) fatal_error=fatal_error | (pwm_sel_val[1]>=PWM_COUNT);
    end
  end
endmodule

