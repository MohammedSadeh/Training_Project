module f_thru_rcu__pwm (
                        clk,
                        pwm_en_config_reg_out,
                        pwm_prescalar_config_reg_out,
                        pwm_duty_cycle_config_reg_out,
                        pwm_freq_rsl_config_reg_out,
                        pwm_en_config_reg_out_delayed,
                        pwm_prescalar_config_reg_out_delayed,
                        pwm_duty_cycle_config_reg_out_delayed,
                        pwm_freq_rsl_config_reg_out_delayed
                        );
    
                        
  parameter  PWM_WIDTH    = 8;
  parameter  PWM_COUNT    = 1;
  
  input clk;
  input [PWM_COUNT*4-1:0] pwm_en_config_reg_out;
  input [PWM_COUNT*4-1:0] pwm_prescalar_config_reg_out;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] pwm_duty_cycle_config_reg_out;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] pwm_freq_rsl_config_reg_out;

  output [PWM_COUNT*4-1:0] pwm_en_config_reg_out_delayed;
  output [PWM_COUNT*4-1:0] pwm_prescalar_config_reg_out_delayed;
  output [PWM_COUNT-1:0] [PWM_WIDTH-1:0] pwm_duty_cycle_config_reg_out_delayed;
  output [PWM_COUNT-1:0] [PWM_WIDTH-1:0] pwm_freq_rsl_config_reg_out_delayed;
  
  reg_dealy #(.WIDTH(PWM_COUNT*4),
              .DELAY(2)) 

  pwm_en_config_reg_delayed (
    .clk(clk),
    .reg_val(pwm_en_config_reg_out),
    .reg_val_delayed(pwm_en_config_reg_out_delayed)
  );

  reg_dealy #(.WIDTH(PWM_COUNT*4),
              .DELAY(2))

  pwm_prescalar_config_reg_delayed (
    .clk(clk),
    .reg_val(pwm_prescalar_config_reg_out),
    .reg_val_delayed(pwm_prescalar_config_reg_out_delayed)
  );

  reg_dealy #(.WIDTH(PWM_COUNT*PWM_WIDTH),
              .DELAY(2))

  pwm_duty_cycle_config_reg_delayed (
    .clk(clk),
    .reg_val(pwm_duty_cycle_config_reg_out),
    .reg_val_delayed(pwm_duty_cycle_config_reg_out_delayed)
  );

  reg_dealy #(.WIDTH(PWM_COUNT*PWM_WIDTH),
              .DELAY(2))

  pwm_freq_rsl_config_reg_delayed (
    .clk(clk),
    .reg_val(pwm_freq_rsl_config_reg_out),
    .reg_val_delayed(pwm_freq_rsl_config_reg_out_delayed)
  );


endmodule
