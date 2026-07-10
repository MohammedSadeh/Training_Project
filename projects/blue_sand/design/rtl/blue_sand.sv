// blue_sand top connections
module blue_sand (
                  pclk,
                  presetn,
                  psel,
                  penable,
                  pwrite,
                  paddr,
                  pwdata,
                  pready,
                  prdata,
                  pslverr,
                  main_interrupt,
                  count, 
                  pwm_port_sig,
                  boot_done,
                  arbitration_req_sources,
                  arbitration_push,
                  arbitration_push_ready,
                  arbitration_req_output,
                  arbitration_pull,
                  arbitration_pull_ready,
                  arbitration_stage3_input_requests,
                  arbitration_threshold_val,
                  fatal_error
                );
  import arbitration_pkg::*;

  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 32;
  parameter PWM_COUNT = 3;
  parameter PWM_WIDTH = 8;
  parameter COUNT_WIDTH = 8;
  parameter INTR_COUNT = 27;
  parameter LFSR_SIZE = 16;
  parameter QUEUE_SIZE = 5;

  //system control

  input pclk;
  input presetn;
  output wor fatal_error;
  logic counter_clk;
  logic arb_clk;
  logic pwm_clk;

  //apb protocol

  input                   psel;
  input                   penable;
  input                   pwrite;
  input  [ADDR_WIDTH-1:0] paddr;
  input  [DATA_WIDTH-1:0] pwdata;

  output                  pready;
  output                  pslverr;
  output [DATA_WIDTH-1:0] prdata;

  wire                   pwrite_out;
  wire  [ADDR_WIDTH-1:0] paddr_out;
  wire  [DATA_WIDTH-1:0] pwdata_out;

  wire                   pready_in;
  wire                   pslverr_in;
  wire  [DATA_WIDTH-1:0] prdata_in;
  wire                   ready_s;
  //interrupt unit output

  output main_interrupt;


  //counter unit output

  output [COUNT_WIDTH-1:0] count;

  //pwm unit output

  output [PWM_COUNT-1:0] pwm_port_sig;
  output boot_done;
  //arbitration unit push
  input  request_t [16-1:0] arbitration_req_sources;
  input            [16-1:0] arbitration_push;
  output logic     [16-1:0] arbitration_push_ready;

  //arbitration unit pull
  output request_t arbitration_req_output;
  input            arbitration_pull;
  output logic     arbitration_pull_ready;

  //arbitration unit stage3_input_requests
  output request_t [2-1:0] arbitration_stage3_input_requests; 
  input [LFSR_SIZE:0]   arbitration_threshold_val;

  wire  [INTR_COUNT-1:0] interrupt_summary;
  wire [23-1:0] [5-1:0] arbitration_almost_full_config_reg_out;
  wire [23-1:0] [6-1:0] arbitration_occupancy_queue_status_reg_out;
  wire [23-1:0]  arbitration_empty_queue_status_reg_out;
  wire [23-1:0]  arbitration_full_queue_status_reg_out;
  wire [3-1:0]  arbitration_lfsr_rseed_config_onWrite_watcher;
  wire [3-1:0] [16-1:0] arbitration_lfsr_rseed_config_reg_out;
  wire [4-1:0] [12-1:0] arbitration_level_weights_config_reg_out;
  wire [4-1:0] [10-1:0] arbitration_level_thresholds_config_reg_out;
  wire [2-1:0] [PWM_COUNT-1:0] clk_muxing_pwm_sel_config_reg_out;
  wire [2-1:0] [8-1:0] clk_muxing_count_sel_config_reg_out;
  wire [2-1:0] [2-1:0] clk_muxing_mode_config_reg_out;
  wire                 spwm_status_status_reg_out;
  
  wire         [PWM_COUNT*4-1:0] spwm_fixed_range_qrtr_en_config_reg_out;
  wire [PWM_COUNT-1:0] [12-1:0] spwm_phase_shift_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] spwm_fixed_range_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] spwm_fixed_range_angle_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] trng_d_step_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] trng_n_step_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] spwm_d_step_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] spwm_n_step_config_reg_out;

  wire [PWM_COUNT-1:0] [8-1:0] pwm_freq_rsl_config_reg_out;
  wire [PWM_COUNT-1:0] [8-1:0] pwm_duty_cycle_config_reg_out;
  wire  [PWM_COUNT*4-1:0] pwm_prescalar_config_reg_out;
  wire  [PWM_COUNT*4-1:0] pwm_en_config_reg_out;

  wire [PWM_COUNT*4-1:0] pwm_en_config_reg_out_delayed;
  wire [PWM_COUNT*4-1:0] pwm_prescalar_config_reg_out_delayed;
  wire [PWM_COUNT-1:0] [PWM_WIDTH-1:0] pwm_duty_cycle_config_reg_out_delayed;
  wire [PWM_COUNT-1:0] [PWM_WIDTH-1:0] pwm_freq_rsl_config_reg_out_delayed;

  wire  [8-1:0] counter_current_count_status_reg_out;
  wire  [3-1:0] counter_mode_control_config_reg_out;
  wire  [8-1:0] counter_number_of_cycles_config_reg_out;
  wire  [8-1:0] counter_secondary_load_config_reg_out;
  wire   counter_main_load_config_onWrite_watcher;
  wire  [8-1:0] counter_main_load_config_reg_out;
  wire   counter_en_config_reg_out;
  wire [23-1:0]  arbitration_size_exceeded_interrupt_reg_sig;
  wire [23-1:0] [6-1:0] arbitration_occupancy_queue_status_reg_in;
  wire [23-1:0]  arbitration_empty_queue_status_reg_in;
  wire [23-1:0]  arbitration_full_queue_status_reg_in;
  wire   spwm_status_status_reg_in;
  wire   counter_region_changed_interrupt_reg_sig;
  wire   counter_wrap_interrupt_reg_sig;
  wire   counter_underflow_interrupt_reg_sig;
  wire   counter_overflow_interrupt_reg_sig;
  wire   counter_wrap_count_counter_reg_sig;
  wire  [8-1:0] counter_current_count_status_reg_in;

  interrupt_summary #(      .INTR_COUNT(INTR_COUNT))
                    inter ( .intr_sum(interrupt_summary),
                            .main_int(main_interrupt)
                          );
  
  top_pwm  #(.PWM_WIDTH(PWM_WIDTH), 
             .PWM_COUNT(PWM_COUNT))
        pwm (.clk(pwm_clk),
             .resetn(presetn),
             .en_sig(pwm_en_config_reg_out_delayed),
             .prescalar(pwm_prescalar_config_reg_out_delayed),
             .quarter_en(spwm_fixed_range_qrtr_en_config_reg_out),
             .duty_cycle(pwm_duty_cycle_config_reg_out_delayed),
             .freq_resolution(pwm_freq_rsl_config_reg_out_delayed),
             .spwm_n_step(spwm_n_step_config_reg_out),
             .spwm_d_step(spwm_d_step_config_reg_out),
             .trng_n_step(trng_n_step_config_reg_out),
             .trng_d_step(trng_d_step_config_reg_out),
             .angle_val(spwm_fixed_range_angle_config_reg_out),
             .range_val(spwm_fixed_range_config_reg_out),
             .port_sig(pwm_port_sig),
             .boot_done(boot_done),
             .phase_shift_val(spwm_phase_shift_config_reg_out)
           );

      
  counter #(   .COUNTER_WIDTH(COUNT_WIDTH)) 
  count_unit ( .clk(counter_clk),
               .resetn(presetn),
               .next_count(counter_current_count_status_reg_in),
               .count(count),
               .enable(counter_en_config_reg_out),
               .mode(counter_mode_control_config_reg_out),
               .main_load_val(counter_main_load_config_reg_out),
               .secondary_load_val(counter_secondary_load_config_reg_out),
               .number_of_cycles_val(counter_number_of_cycles_config_reg_out),
               .main_load_sig(counter_main_load_config_onWrite_watcher),
               .overflow_intr_sig(counter_overflow_interrupt_reg_sig),
               .underflow_intr_sig(counter_underflow_interrupt_reg_sig),
               .wrap_intr_sig(counter_wrap_interrupt_reg_sig),
               .region_changed_intr_sig(counter_region_changed_interrupt_reg_sig),
               .wrap_sig(counter_wrap_count_counter_reg_sig)
              );

  multi_arbitration_design #(         .LFSR_SIZE(LFSR_SIZE),
                                      .QUEUE_SIZE(QUEUE_SIZE))
                           arbi_unit( .clk(arb_clk), 
                                      .resetn(presetn),
                                      .push(arbitration_push),
                                      .push_ready(arbitration_push_ready),
                                      .level_thresholds(arbitration_level_thresholds_config_reg_out),
                                      .level_weights(arbitration_level_weights_config_reg_out),
                                      .rseed(arbitration_lfsr_rseed_config_reg_out),
                                      .load_rseed(arbitration_lfsr_rseed_config_onWrite_watcher),
                                      .req_sources(arbitration_req_sources),
                                      .req_output(arbitration_req_output),
                                      .full_queue_status(arbitration_full_queue_status_reg_in),
                                      .empty_queue_status(arbitration_empty_queue_status_reg_in),
                                      .occupancy_queue_status(arbitration_occupancy_queue_status_reg_in),
                                      .almost_full(arbitration_almost_full_config_reg_out),
                                      .size_exceeded_intr(arbitration_size_exceeded_interrupt_reg_sig),
                                      .threshold_val(arbitration_threshold_val),
                                      .stage3_input_requests(arbitration_stage3_input_requests),
                                      .pull(arbitration_pull),
                                      .pull_ready(arbitration_pull_ready)
                                    );

clk_muxing_unit #( .PWM_COUNT(PWM_COUNT),
                          .COUNT_WIDTH(COUNT_WIDTH))
                clk_mux ( .clk(pclk),
                          .resetn(presetn),
                          .pwm_sig(pwm_port_sig),
                          .count_sig(count), 
                          .pwm_clk(pwm_clk), 
                          .counter_clk(counter_clk),
                          .arb_clk(arb_clk),
                          .pwm_sel_val(clk_muxing_pwm_sel_config_reg_out),
                          .count_sel_val(clk_muxing_count_sel_config_reg_out),
                          .clk_muxing_cfg(clk_muxing_mode_config_reg_out),
                          .fatal_error(fatal_error)
                        );


  apb_bridge #( .DATA_WIDTH(DATA_WIDTH), 
                .ADDR_WIDTH(ADDR_WIDTH)) 
  apb (         .pclk(pclk),
                .presetn(presetn),
                .psel(psel),
                .penable(penable),
                .pwrite_in(pwrite),
                .paddr_in(paddr),
                .pwdata_in(pwdata),
                .pready_out(pready),
                .prdata_out(prdata),
                .pslverr_out(pslverr),
                .pwrite_out(pwrite_out),
                .paddr_out(paddr_out),
                .pwdata_out(pwdata_out),
                .pready_in(pready_in),
                .prdata_in(prdata_in),
                .pslverr_in(pslverr_in),
                .ready_s(ready_s)
               );

  reg_file #(.DATA_WIDTH(DATA_WIDTH), 
             .ADDR_WIDTH(ADDR_WIDTH))              
  reg_control ( 
                .clk(pclk),
                .resetn(presetn),
                .addr_t(paddr_out),
                .write_t(pwrite_out),
                .wdata_t(pwdata_out),
                .ready_s(ready_s),
                .counter_current_count_status_reg_in(counter_current_count_status_reg_in),
                .counter_wrap_count_counter_reg_sig(counter_wrap_count_counter_reg_sig),
                .counter_overflow_interrupt_reg_sig(counter_overflow_interrupt_reg_sig),
                .counter_underflow_interrupt_reg_sig(counter_underflow_interrupt_reg_sig),
                .counter_wrap_interrupt_reg_sig(counter_wrap_interrupt_reg_sig),
                .counter_region_changed_interrupt_reg_sig(counter_region_changed_interrupt_reg_sig),
                .spwm_status_status_reg_in(spwm_status_status_reg_in),
                .arbitration_full_queue_status_reg_in(arbitration_full_queue_status_reg_in),
                .arbitration_empty_queue_status_reg_in(arbitration_empty_queue_status_reg_in),
                .arbitration_occupancy_queue_status_reg_in(arbitration_occupancy_queue_status_reg_in),
                .arbitration_size_exceeded_interrupt_reg_sig(arbitration_size_exceeded_interrupt_reg_sig),
                .pready(pready_in),
                .rdata(prdata_in),
                .slv_err(pslverr_in),
                .counter_en_config_reg_out(counter_en_config_reg_out),
                .counter_main_load_config_reg_out(counter_main_load_config_reg_out),
                .counter_main_load_config_onWrite_watcher(counter_main_load_config_onWrite_watcher),
                .counter_secondary_load_config_reg_out(counter_secondary_load_config_reg_out),
                .counter_number_of_cycles_config_reg_out(counter_number_of_cycles_config_reg_out),
                .counter_mode_control_config_reg_out(counter_mode_control_config_reg_out),
                .counter_current_count_status_reg_out(counter_current_count_status_reg_out),
                .pwm_en_config_reg_out(pwm_en_config_reg_out),
                .pwm_prescalar_config_reg_out(pwm_prescalar_config_reg_out),
                .pwm_duty_cycle_config_reg_out(pwm_duty_cycle_config_reg_out),
                .pwm_freq_rsl_config_reg_out(pwm_freq_rsl_config_reg_out),
                .spwm_n_step_config_reg_out(spwm_n_step_config_reg_out),
                .spwm_d_step_config_reg_out(spwm_d_step_config_reg_out),
                .trng_n_step_config_reg_out(trng_n_step_config_reg_out),
                .trng_d_step_config_reg_out(trng_d_step_config_reg_out),
                .spwm_fixed_range_angle_config_reg_out(spwm_fixed_range_angle_config_reg_out),
                .spwm_fixed_range_config_reg_out(spwm_fixed_range_config_reg_out),
                .spwm_phase_shift_config_reg_out(spwm_phase_shift_config_reg_out),
                .spwm_fixed_range_qrtr_en_config_reg_out(spwm_fixed_range_qrtr_en_config_reg_out),
                .spwm_status_status_reg_out(spwm_status_status_reg_out),
                .clk_muxing_mode_config_reg_out(clk_muxing_mode_config_reg_out),
                .clk_muxing_count_sel_config_reg_out(clk_muxing_count_sel_config_reg_out),
                .clk_muxing_pwm_sel_config_reg_out(clk_muxing_pwm_sel_config_reg_out),
                .arbitration_level_thresholds_config_reg_out(arbitration_level_thresholds_config_reg_out),
                .arbitration_level_weights_config_reg_out(arbitration_level_weights_config_reg_out),
                .arbitration_lfsr_rseed_config_reg_out(arbitration_lfsr_rseed_config_reg_out),
                .arbitration_lfsr_rseed_config_onWrite_watcher(arbitration_lfsr_rseed_config_onWrite_watcher),
                .arbitration_full_queue_status_reg_out(arbitration_full_queue_status_reg_out),
                .arbitration_empty_queue_status_reg_out(arbitration_empty_queue_status_reg_out),
                .arbitration_occupancy_queue_status_reg_out(arbitration_occupancy_queue_status_reg_out),
                .arbitration_almost_full_config_reg_out(arbitration_almost_full_config_reg_out),
                .interrupt_summary(interrupt_summary)
);

f_thru_rcu__pwm #(.PWM_WIDTH(PWM_WIDTH),
                  .PWM_COUNT(PWM_COUNT))
f_thru_rcu__pwm_inst
               (
                  .clk(pclk),
                  .pwm_en_config_reg_out(pwm_en_config_reg_out),
                  .pwm_prescalar_config_reg_out(pwm_prescalar_config_reg_out),
                  .pwm_duty_cycle_config_reg_out(pwm_duty_cycle_config_reg_out),
                  .pwm_freq_rsl_config_reg_out(pwm_freq_rsl_config_reg_out),
                  .pwm_en_config_reg_out_delayed(pwm_en_config_reg_out_delayed),
                  .pwm_prescalar_config_reg_out_delayed(pwm_prescalar_config_reg_out_delayed),
                  .pwm_duty_cycle_config_reg_out_delayed(pwm_duty_cycle_config_reg_out_delayed),
                  .pwm_freq_rsl_config_reg_out_delayed(pwm_freq_rsl_config_reg_out_delayed)
                );

endmodule
