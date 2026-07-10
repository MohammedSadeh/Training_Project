// pwm_port is designed to handle spwm operations
module pwm_port ( clk,
                  resetn,
                  en_sig,
                  prescalar,
                  duty_cycle,
                  freq_resolution,
                  spwm_n_step,
                  spwm_d_step,
                  trng_n_step,
                  trng_d_step,
                  angle_val,
                  range_val,
                  quarter_en,
                  phase_shift_val,
                  data_bus,
                  addrs_bus,
                  boot_done,
                  port_sig 
                );


  //PWM PARAMETERS
  parameter PWM_WIDTH              =8;
     
  //SPWM PARAMETER   
  parameter QUARTER_SIZE           =103000;
  parameter FIRST_TERM             =1<<16; 
  parameter BITS_OF_X              =17;
  parameter BITS_OF_FX             =16;

  localparam BITS_OF_X_SIN         =BITS_OF_X+2;
 
  localparam OVE_STEP_DEGREE       =QUARTER_SIZE/90/8; //0.125 degree
  localparam HALF_STEP_DEGREE      =QUARTER_SIZE/90/2; //0.5 degree
  localparam SECOND_QUART          =QUARTER_SIZE;
  localparam THIRD_QUART           =2*QUARTER_SIZE;
  localparam FOURTH_QUART          =3*QUARTER_SIZE;
  localparam FULL_PERIOD           =4*QUARTER_SIZE;
  
  localparam TRNG_DECIMAL_STEP     = ((BITS_OF_X+BITS_OF_FX+2)'(FIRST_TERM)<<BITS_OF_X)/QUARTER_SIZE;
  localparam DECREASING_TRNG_STATE = 1'b0;
  localparam INCREASING_TRNG_STATE = 1'b1;
  //output
  output logic                 port_sig; 
  output logic [17       -1:0] addrs_bus; 


  //input wires 
  input                  clk;
  input                  resetn;
  input                  boot_done;
  input [4         -1:0] en_sig;
  input [4         -1:0] prescalar;
  input [PWM_WIDTH -1:0] duty_cycle;
  input [PWM_WIDTH -1:0] freq_resolution;   
  input [PWM_WIDTH -1:0] spwm_n_step;
  input [PWM_WIDTH -1:0] spwm_d_step;
   
  input [PWM_WIDTH -1:0] trng_n_step;
  input [PWM_WIDTH -1:0] trng_d_step;
  input [PWM_WIDTH -1:0] angle_val;
  input [PWM_WIDTH -1:0] range_val;
  input [4         -1:0] quarter_en;
  input [12        -1:0] phase_shift_val;
  input [BITS_OF_FX-1:0] data_bus;
  
  
  //internal spwm 
  logic [BITS_OF_X_SIN-1:0] x_sin;
  logic [BITS_OF_FX   -1:0] sin_fx;
  logic                     fixed_range_flag;
  logic [PWM_WIDTH    -1:0] spwm_d_step_counter;

  //internal trng signal
  logic                  current_state_trng;
  logic [BITS_OF_X -1:0] x_trng;  
  logic [BITS_OF_FX-1:0] trng_fx;
  logic [BITS_OF_X -1:0] trng_decimal_counter;
  logic [BITS_OF_X -1:0] trng_n_step_decimal;
  logic [PWM_WIDTH -1:0] trng_n_step_value;
  logic [PWM_WIDTH -1:0] trng_d_step_counter;
  //SPWM MODIFED INTERNAL SIGNALS 
  logic [BITS_OF_X -1:0] fixed_range_angle;
  logic [BITS_OF_X -1:0] fixed_range_val;
  
  //PHASE_SHIFT INTERNAL SIGNALS
  logic [12           -1:0] real_phase_shift;
  logic [BITS_OF_X_SIN-1:0] x_sin_counter;

  
  //assigns
  logic                 pwm_sig;
  logic                 spwm_sig;
  logic                 pwm_enable;
  logic                 spwm_enable;

  assign polarity                                = en_sig[1];
  assign port_sig                                = en_sig[2]==1? spwm_sig : pwm_sig;
  assign pwm_enable                              = en_sig[0]==1 && en_sig[2]==0;
  assign spwm_enable                             = en_sig[0]==1 && en_sig[2]==1 && boot_done==1;
  assign fixed_range_angle                       = angle_val*HALF_STEP_DEGREE;
  assign fixed_range_val                         = range_val*HALF_STEP_DEGREE;
  assign real_phase_shift                        = phase_shift_val*OVE_STEP_DEGREE;
  assign {trng_n_step_value,trng_n_step_decimal} = 33'(trng_n_step+1)*TRNG_DECIMAL_STEP;
  assign spwm_sig                                = spwm_enable & ( (fixed_range_flag==1) ? polarity : (sin_fx >= trng_fx) ^ ~polarity);
  
  pwm #(.PWM_WIDTH(PWM_WIDTH))

  pwm_block ( 
    .clk(clk),
    .resetn(resetn),
    .en_sig(pwm_enable),
    .polarity(polarity),
    .prescalar(prescalar),
    .duty_cycle(duty_cycle),
    .freq_resolution(freq_resolution),
    .port_sig(pwm_sig)
  );

  always_comb begin
    if(en_sig[3]==1) begin
      x_sin = x_sin_counter + real_phase_shift;
      if (x_sin >= FULL_PERIOD) begin
        x_sin = x_sin - FULL_PERIOD;
      end
    end else begin
      x_sin = x_sin_counter;
    end
  end

  always_comb begin // don't reduce for readability
    if( x_sin<=fixed_range_val || x_sin-fixed_range_val <= SECOND_QUART) begin
      fixed_range_flag = (quarter_en[0]==1) && (x_sin >= fixed_range_angle);
    end 
    else if( x_sin-fixed_range_val <= THIRD_QUART) begin
      fixed_range_flag = (quarter_en[1]==1) && (x_sin >= fixed_range_angle+QUARTER_SIZE);
    end 
    else if( x_sin-fixed_range_val <= FOURTH_QUART) begin
      fixed_range_flag = (quarter_en[2]==1) && (x_sin >= fixed_range_angle+THIRD_QUART);
    end 
    else begin
      fixed_range_flag = (quarter_en[3]==1) && (x_sin >= fixed_range_angle+FOURTH_QUART);
    end
  end

  always @(posedge clk ) begin 
    if(resetn==0 || spwm_enable==0) begin 
      //spwm signals
      x_sin_counter       <= 0;
      addrs_bus           <= 0;
      sin_fx              <= 0;
      spwm_d_step_counter <= 0;
      trng_d_step_counter <= 0;
      trng_decimal_counter <= 0;
      x_trng              <= 0;
      trng_fx             <= 0;
      current_state_trng  <= DECREASING_TRNG_STATE;
    end 
    else begin //boot_sig=0 

      if( spwm_d_step_counter < spwm_d_step ) begin
        spwm_d_step_counter <= spwm_d_step_counter + 1;
      end else begin
        if (x_sin_counter +spwm_n_step +1 <= FULL_PERIOD) begin //err
          x_sin_counter <= x_sin_counter + spwm_n_step +1;
        end else begin
          x_sin_counter <= spwm_n_step +1;
        end
        spwm_d_step_counter <= 0;
      end
      
      if(x_sin <= SECOND_QUART) begin 
        addrs_bus <= x_sin;
        sin_fx    <= data_bus;
      end 
      else if(x_sin <= THIRD_QUART) begin 
        addrs_bus <= THIRD_QUART - x_sin;
        sin_fx    <= FIRST_TERM - data_bus;
      end 
      else if(x_sin <= FOURTH_QUART) begin 
        addrs_bus <= x_sin - THIRD_QUART;
        sin_fx    <= FIRST_TERM - data_bus;
      end 
      else begin 
        addrs_bus <= FULL_PERIOD - x_sin;
        sin_fx    <= data_bus;
      end 

      if (trng_d_step_counter < trng_d_step) begin
        trng_d_step_counter <= trng_d_step_counter + 1;
      end else begin
        if ((x_trng + trng_n_step +1 )<= QUARTER_SIZE) begin
          x_trng               <= x_trng + trng_n_step+1;
          trng_decimal_counter <= trng_n_step_decimal + trng_decimal_counter;
          if (current_state_trng == INCREASING_TRNG_STATE) begin
            trng_fx <= trng_fx + trng_n_step_value + (trng_n_step_decimal > ~trng_decimal_counter);
          end else begin
            trng_fx <= trng_fx - trng_n_step_value - (trng_n_step_decimal > ~trng_decimal_counter);
          end
        end else begin
          trng_decimal_counter <= 0;
          x_trng               <= 0;
          current_state_trng   <= ~current_state_trng;
          if (current_state_trng == INCREASING_TRNG_STATE) begin // last value of each state
            trng_fx <= FIRST_TERM -1;
          end else begin
            trng_fx <= 0;
          end
        end
        trng_d_step_counter <= 0;
      end
    end
  end //always 
endmodule
