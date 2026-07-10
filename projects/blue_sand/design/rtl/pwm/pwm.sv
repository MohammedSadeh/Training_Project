//pwm is to handle regular pwm transactions
module pwm ( clk,
             resetn,
             en_sig,
             polarity,
             prescalar,
             duty_cycle,
             freq_resolution,
             port_sig 
           );
  parameter  PWM_WIDTH =8                      ;
  localparam MAX_SIZE  =26                     ;

  //output
  output logic          port_sig       ; 
  //input wire
  input                 clk            ;
  input                 resetn         ;
  input                 en_sig         ;
  input                 polarity       ;
  input [4-1        :0] prescalar      ;
  input [PWM_WIDTH-1:0] duty_cycle     ;
  input [PWM_WIDTH-1:0] freq_resolution;   

  logic                 current_state_pwm      ;
  logic [MAX_SIZE-1:0]  pwm_period             ;
  logic [MAX_SIZE-1:0]  time_on_sig            ;
  logic [MAX_SIZE-1:0]  time_off_sig           ;
  logic [MAX_SIZE-1:0]  pulse_counter_sig ;
  logic [MAX_SIZE-1:0]  prev_time_on_sig       ;
  assign port_sig = en_sig & ( polarity ^ ~current_state_pwm);
  assign pwm_period   = ((freq_resolution+1)<<prescalar[3:0]);
  assign time_on_sig  =((pwm_period*duty_cycle)>>8);
  assign time_off_sig = pwm_period-time_on_sig;
  always @(posedge clk) begin
    if(resetn==0 || en_sig==0) begin
      pulse_counter_sig<=1;
      current_state_pwm<=0;
    end //reset 
    else begin
      if(pulse_counter_sig< (current_state_pwm==1?time_on_sig:time_off_sig)) begin 
          pulse_counter_sig<=pulse_counter_sig + 1 ;
      end
      else begin
        if(time_on_sig!=0) begin 
            current_state_pwm <=~current_state_pwm;
        end
        else begin
            current_state_pwm<=0;
        end
        pulse_counter_sig<=1 ;
      end
    end
  end //end of always

endmodule
