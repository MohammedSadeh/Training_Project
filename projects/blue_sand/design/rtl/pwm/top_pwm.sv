// top_pwm to handle connections of pwm and pwm_port.
module top_pwm ( clk,
                 resetn,
                 en_sig,
                 prescalar,
                 quarter_en,
                 duty_cycle,
                 freq_resolution,
                 spwm_n_step,
                 spwm_d_step,
                 trng_n_step,
                 trng_d_step,
                 angle_val,
                 range_val,
                 port_sig,
                 phase_shift_val,
                 boot_done
               ); 

  parameter  PWM_WIDTH    = 8;
  parameter  PWM_COUNT    = 1;
  localparam BITS_OF_X    = 17;
  localparam BITS_OF_X2   = 2*BITS_OF_X;
  localparam BITS_OF_FX   = 16;
  localparam QUARTER_SIZE = 102944;
  localparam FIRST_TERM   = 1<<16;
  localparam INV3         = 17'd43691; //BITS_OF_X'd3 **(1<<(BITS_OF_X-1) -1); //d43691
  localparam INV5         = 17'd52429; //5 ^ (2^(BITS_OF_X-1) -1) mod 2^BITS_OF_X //d52429

  //output wires
  output logic [PWM_COUNT-1:0] port_sig;
  output logic boot_done;

  //input wires
  input                  clk;
  input                  resetn;
  input [PWM_COUNT*4-1:0] en_sig;
  input [PWM_COUNT*4-1:0] prescalar;
  input [PWM_COUNT*4-1:0] quarter_en;
 
  
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] duty_cycle;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] freq_resolution;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] spwm_d_step;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] spwm_n_step;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] trng_n_step;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] trng_d_step;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] angle_val;
  input [PWM_COUNT-1:0] [PWM_WIDTH-1:0] range_val;
  input [PWM_COUNT-1:0] [12-1:0] phase_shift_val;
  
   wire [PWM_COUNT*4-1:0] en_sig; 
   wire [PWM_COUNT*4-1:0] prescalar; 
   wire [PWM_COUNT*4-1:0] quarter_en; 

  logic [PWM_COUNT-1:0] [BITS_OF_X-1:0]  addrs_bus;
  logic [PWM_COUNT-1:0] [BITS_OF_FX-1:0] data_bus;

  logic [BITS_OF_X-1:0]   xi;
  logic [BITS_OF_X2-1:0]  xi_2;// xi^2
  logic [67-1:0]   sin_calc_second_term;

  logic [BITS_OF_FX-1:0] first_quarter_fx[1<<BITS_OF_X];

  function automatic bit [BITS_OF_X-1:0] div_3(bit[BITS_OF_X-1:0] x);
    div_3 = x*INV3;
    repeat(3-1) begin
      if(div_3 > x) div_3 = div_3 - INV3;
    end
    return div_3;
  endfunction

  function automatic bit [BITS_OF_X-1:0] div_5(bit[BITS_OF_X-1:0] x);
    div_5 = x*INV5;
    repeat(5-1) begin
      if(div_5 > x) div_5 = div_5 - INV5;
    end
    return div_5;
  endfunction

  function automatic bit[BITS_OF_FX-1:0] sin_3_ord(bit[BITS_OF_X2-1:0] x);
    sin_calc_second_term = (67'(x)*x);
    sin_3_ord = FIRST_TERM -(x>>18) + div_3(sin_calc_second_term>>52) - div_5(div_3(div_3((100'(x)*sin_calc_second_term)>>85)));
    return sin_3_ord;
  endfunction

   genvar pwm_idx;
   generate 
     for(pwm_idx = 0; pwm_idx < PWM_COUNT; pwm_idx = pwm_idx+1) 
     begin: pwm_blocks

      pwm_port #(.PWM_WIDTH(PWM_WIDTH),
                 .QUARTER_SIZE(QUARTER_SIZE),
                 .BITS_OF_X(BITS_OF_X),
                 .BITS_OF_FX(BITS_OF_FX),
                 .FIRST_TERM(FIRST_TERM))

      spwm_pwm_block ( 
        .clk(clk),
        .resetn(resetn),
        .en_sig(en_sig[pwm_idx*4+:4]),
        .prescalar(prescalar[pwm_idx*4+:4]),
        .duty_cycle(duty_cycle[pwm_idx]),
        .freq_resolution(freq_resolution[pwm_idx]),
        .spwm_n_step(spwm_n_step[pwm_idx]),
        .spwm_d_step(spwm_d_step[pwm_idx]),
        .trng_n_step(trng_n_step[pwm_idx]),
        .trng_d_step(trng_d_step[pwm_idx]),
        .angle_val(angle_val[pwm_idx]),
        .range_val(range_val[pwm_idx]),
        .quarter_en(quarter_en[pwm_idx*4+:4]),
        .addrs_bus(addrs_bus[pwm_idx]),
        .data_bus(data_bus[pwm_idx]),
        .boot_done(boot_done),
        .phase_shift_val(phase_shift_val[pwm_idx]),
        .port_sig(port_sig[pwm_idx])
      );
     end
   endgenerate
  always @(posedge clk) begin 
    if(resetn == 0) begin 
      xi        <= 0;
      xi_2      <= 0;
      boot_done <= 0;
      data_bus  <= 0;
    end 
    else if(boot_done == 0) begin 
      if(xi <= QUARTER_SIZE) begin
        if(xi <= 511) begin
          first_quarter_fx[xi] <= FIRST_TERM -1 ;
        end
        else begin
          first_quarter_fx[xi] <= sin_3_ord(xi_2); 
        end
        xi   <= xi + 1 ;
        xi_2 <= xi_2 + (xi<<1) + 1;
      end
      else begin
        boot_done <=1 ;
      end
    end 
    else begin
      for(int i = 0;i<PWM_WIDTH;i++) begin
        data_bus[i] <= first_quarter_fx[addrs_bus  [i]];
      end
    end
  end 
endmodule 
