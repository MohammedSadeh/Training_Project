module reg_file( 
                  clk,
                  resetn,
                  addr_t,
                  write_t,
                  wdata_t,
                  ready_s,
                  counter_current_count_status_reg_in,
                  counter_wrap_count_counter_reg_sig,
                  counter_overflow_interrupt_reg_sig,
                  counter_underflow_interrupt_reg_sig,
                  counter_wrap_interrupt_reg_sig,
                  counter_region_changed_interrupt_reg_sig,
                  spwm_status_status_reg_in,
                  arbitration_full_queue_status_reg_in,
                  arbitration_empty_queue_status_reg_in,
                  arbitration_occupancy_queue_status_reg_in,
                  arbitration_size_exceeded_interrupt_reg_sig,
                  pready,
                  rdata,
                  slv_err,
                  counter_en_config_reg_out,
                  counter_main_load_config_reg_out,
                  counter_main_load_config_onWrite_watcher,
                  counter_secondary_load_config_reg_out,
                  counter_number_of_cycles_config_reg_out,
                  counter_mode_control_config_reg_out,
                  counter_current_count_status_reg_out,
                  pwm_en_config_reg_out,
                  pwm_prescalar_config_reg_out,
                  pwm_duty_cycle_config_reg_out,
                  pwm_freq_rsl_config_reg_out,
                  spwm_n_step_config_reg_out,
                  spwm_d_step_config_reg_out,
                  trng_n_step_config_reg_out,
                  trng_d_step_config_reg_out,
                  spwm_fixed_range_angle_config_reg_out,
                  spwm_fixed_range_config_reg_out,
                  spwm_phase_shift_config_reg_out,
                  spwm_fixed_range_qrtr_en_config_reg_out,
                  spwm_status_status_reg_out,
                  clk_muxing_mode_config_reg_out,
                  clk_muxing_count_sel_config_reg_out,
                  clk_muxing_pwm_sel_config_reg_out,
                  arbitration_level_thresholds_config_reg_out,
                  arbitration_level_weights_config_reg_out,
                  arbitration_lfsr_rseed_config_reg_out,
                  arbitration_lfsr_rseed_config_onWrite_watcher,
                  arbitration_full_queue_status_reg_out,
                  arbitration_empty_queue_status_reg_out,
                  arbitration_occupancy_queue_status_reg_out,
                  arbitration_almost_full_config_reg_out,
                  interrupt_summary
);
  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 32;
  output logic   pready;
  output logic  [DATA_WIDTH-1:0] rdata;
  output logic   slv_err;
  output logic   counter_en_config_reg_out;
  output logic  [8-1:0] counter_main_load_config_reg_out;
  output logic   counter_main_load_config_onWrite_watcher;
  output logic  [8-1:0] counter_secondary_load_config_reg_out;
  output logic  [8-1:0] counter_number_of_cycles_config_reg_out;
  output logic  [3-1:0] counter_mode_control_config_reg_out;
  output logic  [8-1:0] counter_current_count_status_reg_out;
  output logic  [12-1:0] pwm_en_config_reg_out;
  output logic  [12-1:0] pwm_prescalar_config_reg_out;
  output logic [3-1:0] [8-1:0] pwm_duty_cycle_config_reg_out;
  output logic [3-1:0] [8-1:0] pwm_freq_rsl_config_reg_out;
  output logic [3-1:0] [8-1:0] spwm_n_step_config_reg_out;
  output logic [3-1:0] [8-1:0] spwm_d_step_config_reg_out;
  output logic [3-1:0] [8-1:0] trng_n_step_config_reg_out;
  output logic [3-1:0] [8-1:0] trng_d_step_config_reg_out;
  output logic [3-1:0] [8-1:0] spwm_fixed_range_angle_config_reg_out;
  output logic [3-1:0] [8-1:0] spwm_fixed_range_config_reg_out;
  output logic [3-1:0] [12-1:0] spwm_phase_shift_config_reg_out;
  output logic  [12-1:0] spwm_fixed_range_qrtr_en_config_reg_out;
  output logic   spwm_status_status_reg_out;
  output logic [2-1:0] [2-1:0] clk_muxing_mode_config_reg_out;
  output logic [2-1:0] [8-1:0] clk_muxing_count_sel_config_reg_out;
  output logic [2-1:0] [3-1:0] clk_muxing_pwm_sel_config_reg_out;
  output logic [4-1:0] [10-1:0] arbitration_level_thresholds_config_reg_out;
  output logic [4-1:0] [12-1:0] arbitration_level_weights_config_reg_out;
  output logic [3-1:0] [16-1:0] arbitration_lfsr_rseed_config_reg_out;
  output logic [3-1:0]  arbitration_lfsr_rseed_config_onWrite_watcher;
  output logic [23-1:0]  arbitration_full_queue_status_reg_out;
  output logic [23-1:0]  arbitration_empty_queue_status_reg_out;
  output logic [23-1:0] [6-1:0] arbitration_occupancy_queue_status_reg_out;
  output logic [23-1:0] [5-1:0] arbitration_almost_full_config_reg_out;
  output logic  [27-1:0] interrupt_summary;
  input  logic   clk;
  input  logic   resetn;
  input  logic  [ADDR_WIDTH-1:0] addr_t;
  input  logic   write_t;
  input  logic  [DATA_WIDTH-1:0] wdata_t;
  input  logic   ready_s;
  input  logic  [8-1:0] counter_current_count_status_reg_in;
  input  logic   counter_wrap_count_counter_reg_sig;
  input  logic   counter_overflow_interrupt_reg_sig;
  input  logic   counter_underflow_interrupt_reg_sig;
  input  logic   counter_wrap_interrupt_reg_sig;
  input  logic   counter_region_changed_interrupt_reg_sig;
  input  logic   spwm_status_status_reg_in;
  input  logic [23-1:0]  arbitration_full_queue_status_reg_in;
  input  logic [23-1:0]  arbitration_empty_queue_status_reg_in;
  input  logic [23-1:0] [6-1:0] arbitration_occupancy_queue_status_reg_in;
  input  logic [23-1:0]  arbitration_size_exceeded_interrupt_reg_sig;
  logic proc;
  logic  [DATA_WIDTH-1:0] counter_en_config_reg;
  logic  [DATA_WIDTH-1:0] counter_main_load_config_reg;
  logic  [DATA_WIDTH-1:0] counter_secondary_load_config_reg;
  logic  [DATA_WIDTH-1:0] counter_number_of_cycles_config_reg;
  logic  [DATA_WIDTH-1:0] counter_mode_control_config_reg;
  logic  [DATA_WIDTH-1:0] counter_current_count_status_reg;
  logic  [DATA_WIDTH-1:0] counter_wrap_count_counter_reg;
  logic  [DATA_WIDTH-1:0] counter_overflow_interrupt_reg;
  logic   counter_overflow_interrupt_reg_out;
  logic  [DATA_WIDTH-1:0] counter_underflow_interrupt_reg;
  logic   counter_underflow_interrupt_reg_out;
  logic  [DATA_WIDTH-1:0] counter_wrap_interrupt_reg;
  logic   counter_wrap_interrupt_reg_out;
  logic  [DATA_WIDTH-1:0] counter_region_changed_interrupt_reg;
  logic   counter_region_changed_interrupt_reg_out;
  logic  [DATA_WIDTH-1:0] pwm_en_config_reg;
  logic  [DATA_WIDTH-1:0] pwm_prescalar_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] pwm_duty_cycle_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] pwm_freq_rsl_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] spwm_n_step_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] spwm_d_step_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] trng_n_step_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] trng_d_step_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] spwm_fixed_range_angle_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] spwm_fixed_range_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] spwm_phase_shift_config_reg;
  logic  [DATA_WIDTH-1:0] spwm_fixed_range_qrtr_en_config_reg;
  logic  [DATA_WIDTH-1:0] spwm_status_status_reg;
  logic [2-1:0] [DATA_WIDTH-1:0] clk_muxing_mode_config_reg;
  logic [2-1:0] [DATA_WIDTH-1:0] clk_muxing_count_sel_config_reg;
  logic [2-1:0] [DATA_WIDTH-1:0] clk_muxing_pwm_sel_config_reg;
  logic [4-1:0] [DATA_WIDTH-1:0] arbitration_level_thresholds_config_reg;
  logic [4-1:0] [DATA_WIDTH-1:0] arbitration_level_weights_config_reg;
  logic [3-1:0] [DATA_WIDTH-1:0] arbitration_lfsr_rseed_config_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_full_queue_status_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_empty_queue_status_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_occupancy_queue_status_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_almost_full_config_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_size_exceeded_interrupt_reg;
  logic [23-1:0] arbitration_size_exceeded_interrupt_reg_out;
  logic  [DATA_WIDTH-1:0] ext_external_reg;
  logic  [DATA_WIDTH-1:0] counter_overflow_interrupt_mask_reg;
  logic  [DATA_WIDTH-1:0] counter_overflow_interrupt_test_reg;
  logic  [DATA_WIDTH-1:0] counter_underflow_interrupt_mask_reg;
  logic  [DATA_WIDTH-1:0] counter_underflow_interrupt_test_reg;
  logic  [DATA_WIDTH-1:0] counter_wrap_interrupt_mask_reg;
  logic  [DATA_WIDTH-1:0] counter_wrap_interrupt_test_reg;
  logic  [DATA_WIDTH-1:0] counter_region_changed_interrupt_mask_reg;
  logic  [DATA_WIDTH-1:0] counter_region_changed_interrupt_test_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_size_exceeded_interrupt_mask_reg;
  logic [23-1:0] [DATA_WIDTH-1:0] arbitration_size_exceeded_interrupt_test_reg;
  logic  [DATA_WIDTH-1:0] main0_summary_reg;
  assign main0_summary_reg[0] = counter_overflow_interrupt_reg_out;
  assign main0_summary_reg[1] = counter_underflow_interrupt_reg_out;
  assign main0_summary_reg[2] = counter_wrap_interrupt_reg_out;
  assign main0_summary_reg[3] = counter_region_changed_interrupt_reg_out;
  assign main0_summary_reg[4] = arbitration_size_exceeded_interrupt_reg_out[0];
  assign main0_summary_reg[5] = arbitration_size_exceeded_interrupt_reg_out[1];
  assign main0_summary_reg[6] = arbitration_size_exceeded_interrupt_reg_out[2];
  assign main0_summary_reg[7] = arbitration_size_exceeded_interrupt_reg_out[3];
  assign main0_summary_reg[8] = arbitration_size_exceeded_interrupt_reg_out[4];
  assign main0_summary_reg[9] = arbitration_size_exceeded_interrupt_reg_out[5];
  assign main0_summary_reg[10] = arbitration_size_exceeded_interrupt_reg_out[6];
  assign main0_summary_reg[11] = arbitration_size_exceeded_interrupt_reg_out[7];
  assign main0_summary_reg[12] = arbitration_size_exceeded_interrupt_reg_out[8];
  assign main0_summary_reg[13] = arbitration_size_exceeded_interrupt_reg_out[9];
  assign main0_summary_reg[14] = arbitration_size_exceeded_interrupt_reg_out[10];
  assign main0_summary_reg[15] = arbitration_size_exceeded_interrupt_reg_out[11];
  assign main0_summary_reg[16] = arbitration_size_exceeded_interrupt_reg_out[12];
  assign main0_summary_reg[17] = arbitration_size_exceeded_interrupt_reg_out[13];
  assign main0_summary_reg[18] = arbitration_size_exceeded_interrupt_reg_out[14];
  assign main0_summary_reg[19] = arbitration_size_exceeded_interrupt_reg_out[15];
  assign main0_summary_reg[20] = arbitration_size_exceeded_interrupt_reg_out[16];
  assign main0_summary_reg[21] = arbitration_size_exceeded_interrupt_reg_out[17];
  assign main0_summary_reg[22] = arbitration_size_exceeded_interrupt_reg_out[18];
  assign main0_summary_reg[23] = arbitration_size_exceeded_interrupt_reg_out[19];
  assign main0_summary_reg[24] = arbitration_size_exceeded_interrupt_reg_out[20];
  assign main0_summary_reg[25] = arbitration_size_exceeded_interrupt_reg_out[21];
  assign main0_summary_reg[26] = arbitration_size_exceeded_interrupt_reg_out[22];
  assign counter_en_config_reg_out = counter_en_config_reg;
  assign counter_main_load_config_reg_out = counter_main_load_config_reg;
  assign counter_main_load_config_onWrite_watcher = addr_t==(1) && write_t==1 && pready == 1;
  assign counter_secondary_load_config_reg_out = counter_secondary_load_config_reg;
  assign counter_number_of_cycles_config_reg_out = counter_number_of_cycles_config_reg;
  assign counter_mode_control_config_reg_out = counter_mode_control_config_reg;
  assign counter_current_count_status_reg_out = counter_current_count_status_reg;
  assign counter_overflow_interrupt_reg_out = (counter_overflow_interrupt_reg & counter_overflow_interrupt_mask_reg) != 0;
  assign interrupt_summary[0] = counter_overflow_interrupt_reg_out;
  assign counter_underflow_interrupt_reg_out = (counter_underflow_interrupt_reg & counter_underflow_interrupt_mask_reg) != 0;
  assign interrupt_summary[1] = counter_underflow_interrupt_reg_out;
  assign counter_wrap_interrupt_reg_out = (counter_wrap_interrupt_reg & counter_wrap_interrupt_mask_reg) != 0;
  assign interrupt_summary[2] = counter_wrap_interrupt_reg_out;
  assign counter_region_changed_interrupt_reg_out = (counter_region_changed_interrupt_reg & counter_region_changed_interrupt_mask_reg) != 0;
  assign interrupt_summary[3] = counter_region_changed_interrupt_reg_out;
  assign pwm_en_config_reg_out = pwm_en_config_reg;
  assign pwm_prescalar_config_reg_out = pwm_prescalar_config_reg;
  assign pwm_duty_cycle_config_reg_out[0] = pwm_duty_cycle_config_reg[0];
  assign pwm_duty_cycle_config_reg_out[1] = pwm_duty_cycle_config_reg[1];
  assign pwm_duty_cycle_config_reg_out[2] = pwm_duty_cycle_config_reg[2];
  assign pwm_freq_rsl_config_reg_out[0] = pwm_freq_rsl_config_reg[0];
  assign pwm_freq_rsl_config_reg_out[1] = pwm_freq_rsl_config_reg[1];
  assign pwm_freq_rsl_config_reg_out[2] = pwm_freq_rsl_config_reg[2];
  assign spwm_n_step_config_reg_out[0] = spwm_n_step_config_reg[0];
  assign spwm_n_step_config_reg_out[1] = spwm_n_step_config_reg[1];
  assign spwm_n_step_config_reg_out[2] = spwm_n_step_config_reg[2];
  assign spwm_d_step_config_reg_out[0] = spwm_d_step_config_reg[0];
  assign spwm_d_step_config_reg_out[1] = spwm_d_step_config_reg[1];
  assign spwm_d_step_config_reg_out[2] = spwm_d_step_config_reg[2];
  assign trng_n_step_config_reg_out[0] = trng_n_step_config_reg[0];
  assign trng_n_step_config_reg_out[1] = trng_n_step_config_reg[1];
  assign trng_n_step_config_reg_out[2] = trng_n_step_config_reg[2];
  assign trng_d_step_config_reg_out[0] = trng_d_step_config_reg[0];
  assign trng_d_step_config_reg_out[1] = trng_d_step_config_reg[1];
  assign trng_d_step_config_reg_out[2] = trng_d_step_config_reg[2];
  assign spwm_fixed_range_angle_config_reg_out[0] = spwm_fixed_range_angle_config_reg[0];
  assign spwm_fixed_range_angle_config_reg_out[1] = spwm_fixed_range_angle_config_reg[1];
  assign spwm_fixed_range_angle_config_reg_out[2] = spwm_fixed_range_angle_config_reg[2];
  assign spwm_fixed_range_config_reg_out[0] = spwm_fixed_range_config_reg[0];
  assign spwm_fixed_range_config_reg_out[1] = spwm_fixed_range_config_reg[1];
  assign spwm_fixed_range_config_reg_out[2] = spwm_fixed_range_config_reg[2];
  assign spwm_phase_shift_config_reg_out[0] = spwm_phase_shift_config_reg[0];
  assign spwm_phase_shift_config_reg_out[1] = spwm_phase_shift_config_reg[1];
  assign spwm_phase_shift_config_reg_out[2] = spwm_phase_shift_config_reg[2];
  assign spwm_fixed_range_qrtr_en_config_reg_out = spwm_fixed_range_qrtr_en_config_reg;
  assign spwm_status_status_reg_out = spwm_status_status_reg;
  assign clk_muxing_mode_config_reg_out[0] = clk_muxing_mode_config_reg[0];
  assign clk_muxing_mode_config_reg_out[1] = clk_muxing_mode_config_reg[1];
  assign clk_muxing_count_sel_config_reg_out[0] = clk_muxing_count_sel_config_reg[0];
  assign clk_muxing_count_sel_config_reg_out[1] = clk_muxing_count_sel_config_reg[1];
  assign clk_muxing_pwm_sel_config_reg_out[0] = clk_muxing_pwm_sel_config_reg[0];
  assign clk_muxing_pwm_sel_config_reg_out[1] = clk_muxing_pwm_sel_config_reg[1];
  assign arbitration_level_thresholds_config_reg_out[0] = arbitration_level_thresholds_config_reg[0];
  assign arbitration_level_thresholds_config_reg_out[1] = arbitration_level_thresholds_config_reg[1];
  assign arbitration_level_thresholds_config_reg_out[2] = arbitration_level_thresholds_config_reg[2];
  assign arbitration_level_thresholds_config_reg_out[3] = arbitration_level_thresholds_config_reg[3];
  assign arbitration_level_weights_config_reg_out[0] = arbitration_level_weights_config_reg[0];
  assign arbitration_level_weights_config_reg_out[1] = arbitration_level_weights_config_reg[1];
  assign arbitration_level_weights_config_reg_out[2] = arbitration_level_weights_config_reg[2];
  assign arbitration_level_weights_config_reg_out[3] = arbitration_level_weights_config_reg[3];
  assign arbitration_lfsr_rseed_config_reg_out[0] = arbitration_lfsr_rseed_config_reg[0];
  assign arbitration_lfsr_rseed_config_reg_out[1] = arbitration_lfsr_rseed_config_reg[1];
  assign arbitration_lfsr_rseed_config_reg_out[2] = arbitration_lfsr_rseed_config_reg[2];
  assign arbitration_lfsr_rseed_config_onWrite_watcher[0] = addr_t==(64+0) && write_t==1 && pready == 1;
  assign arbitration_lfsr_rseed_config_onWrite_watcher[1] = addr_t==(64+1) && write_t==1 && pready == 1;
  assign arbitration_lfsr_rseed_config_onWrite_watcher[2] = addr_t==(64+2) && write_t==1 && pready == 1;
  assign arbitration_full_queue_status_reg_out[0] = arbitration_full_queue_status_reg[0];
  assign arbitration_full_queue_status_reg_out[1] = arbitration_full_queue_status_reg[1];
  assign arbitration_full_queue_status_reg_out[2] = arbitration_full_queue_status_reg[2];
  assign arbitration_full_queue_status_reg_out[3] = arbitration_full_queue_status_reg[3];
  assign arbitration_full_queue_status_reg_out[4] = arbitration_full_queue_status_reg[4];
  assign arbitration_full_queue_status_reg_out[5] = arbitration_full_queue_status_reg[5];
  assign arbitration_full_queue_status_reg_out[6] = arbitration_full_queue_status_reg[6];
  assign arbitration_full_queue_status_reg_out[7] = arbitration_full_queue_status_reg[7];
  assign arbitration_full_queue_status_reg_out[8] = arbitration_full_queue_status_reg[8];
  assign arbitration_full_queue_status_reg_out[9] = arbitration_full_queue_status_reg[9];
  assign arbitration_full_queue_status_reg_out[10] = arbitration_full_queue_status_reg[10];
  assign arbitration_full_queue_status_reg_out[11] = arbitration_full_queue_status_reg[11];
  assign arbitration_full_queue_status_reg_out[12] = arbitration_full_queue_status_reg[12];
  assign arbitration_full_queue_status_reg_out[13] = arbitration_full_queue_status_reg[13];
  assign arbitration_full_queue_status_reg_out[14] = arbitration_full_queue_status_reg[14];
  assign arbitration_full_queue_status_reg_out[15] = arbitration_full_queue_status_reg[15];
  assign arbitration_full_queue_status_reg_out[16] = arbitration_full_queue_status_reg[16];
  assign arbitration_full_queue_status_reg_out[17] = arbitration_full_queue_status_reg[17];
  assign arbitration_full_queue_status_reg_out[18] = arbitration_full_queue_status_reg[18];
  assign arbitration_full_queue_status_reg_out[19] = arbitration_full_queue_status_reg[19];
  assign arbitration_full_queue_status_reg_out[20] = arbitration_full_queue_status_reg[20];
  assign arbitration_full_queue_status_reg_out[21] = arbitration_full_queue_status_reg[21];
  assign arbitration_full_queue_status_reg_out[22] = arbitration_full_queue_status_reg[22];
  assign arbitration_empty_queue_status_reg_out[0] = arbitration_empty_queue_status_reg[0];
  assign arbitration_empty_queue_status_reg_out[1] = arbitration_empty_queue_status_reg[1];
  assign arbitration_empty_queue_status_reg_out[2] = arbitration_empty_queue_status_reg[2];
  assign arbitration_empty_queue_status_reg_out[3] = arbitration_empty_queue_status_reg[3];
  assign arbitration_empty_queue_status_reg_out[4] = arbitration_empty_queue_status_reg[4];
  assign arbitration_empty_queue_status_reg_out[5] = arbitration_empty_queue_status_reg[5];
  assign arbitration_empty_queue_status_reg_out[6] = arbitration_empty_queue_status_reg[6];
  assign arbitration_empty_queue_status_reg_out[7] = arbitration_empty_queue_status_reg[7];
  assign arbitration_empty_queue_status_reg_out[8] = arbitration_empty_queue_status_reg[8];
  assign arbitration_empty_queue_status_reg_out[9] = arbitration_empty_queue_status_reg[9];
  assign arbitration_empty_queue_status_reg_out[10] = arbitration_empty_queue_status_reg[10];
  assign arbitration_empty_queue_status_reg_out[11] = arbitration_empty_queue_status_reg[11];
  assign arbitration_empty_queue_status_reg_out[12] = arbitration_empty_queue_status_reg[12];
  assign arbitration_empty_queue_status_reg_out[13] = arbitration_empty_queue_status_reg[13];
  assign arbitration_empty_queue_status_reg_out[14] = arbitration_empty_queue_status_reg[14];
  assign arbitration_empty_queue_status_reg_out[15] = arbitration_empty_queue_status_reg[15];
  assign arbitration_empty_queue_status_reg_out[16] = arbitration_empty_queue_status_reg[16];
  assign arbitration_empty_queue_status_reg_out[17] = arbitration_empty_queue_status_reg[17];
  assign arbitration_empty_queue_status_reg_out[18] = arbitration_empty_queue_status_reg[18];
  assign arbitration_empty_queue_status_reg_out[19] = arbitration_empty_queue_status_reg[19];
  assign arbitration_empty_queue_status_reg_out[20] = arbitration_empty_queue_status_reg[20];
  assign arbitration_empty_queue_status_reg_out[21] = arbitration_empty_queue_status_reg[21];
  assign arbitration_empty_queue_status_reg_out[22] = arbitration_empty_queue_status_reg[22];
  assign arbitration_occupancy_queue_status_reg_out[0] = arbitration_occupancy_queue_status_reg[0];
  assign arbitration_occupancy_queue_status_reg_out[1] = arbitration_occupancy_queue_status_reg[1];
  assign arbitration_occupancy_queue_status_reg_out[2] = arbitration_occupancy_queue_status_reg[2];
  assign arbitration_occupancy_queue_status_reg_out[3] = arbitration_occupancy_queue_status_reg[3];
  assign arbitration_occupancy_queue_status_reg_out[4] = arbitration_occupancy_queue_status_reg[4];
  assign arbitration_occupancy_queue_status_reg_out[5] = arbitration_occupancy_queue_status_reg[5];
  assign arbitration_occupancy_queue_status_reg_out[6] = arbitration_occupancy_queue_status_reg[6];
  assign arbitration_occupancy_queue_status_reg_out[7] = arbitration_occupancy_queue_status_reg[7];
  assign arbitration_occupancy_queue_status_reg_out[8] = arbitration_occupancy_queue_status_reg[8];
  assign arbitration_occupancy_queue_status_reg_out[9] = arbitration_occupancy_queue_status_reg[9];
  assign arbitration_occupancy_queue_status_reg_out[10] = arbitration_occupancy_queue_status_reg[10];
  assign arbitration_occupancy_queue_status_reg_out[11] = arbitration_occupancy_queue_status_reg[11];
  assign arbitration_occupancy_queue_status_reg_out[12] = arbitration_occupancy_queue_status_reg[12];
  assign arbitration_occupancy_queue_status_reg_out[13] = arbitration_occupancy_queue_status_reg[13];
  assign arbitration_occupancy_queue_status_reg_out[14] = arbitration_occupancy_queue_status_reg[14];
  assign arbitration_occupancy_queue_status_reg_out[15] = arbitration_occupancy_queue_status_reg[15];
  assign arbitration_occupancy_queue_status_reg_out[16] = arbitration_occupancy_queue_status_reg[16];
  assign arbitration_occupancy_queue_status_reg_out[17] = arbitration_occupancy_queue_status_reg[17];
  assign arbitration_occupancy_queue_status_reg_out[18] = arbitration_occupancy_queue_status_reg[18];
  assign arbitration_occupancy_queue_status_reg_out[19] = arbitration_occupancy_queue_status_reg[19];
  assign arbitration_occupancy_queue_status_reg_out[20] = arbitration_occupancy_queue_status_reg[20];
  assign arbitration_occupancy_queue_status_reg_out[21] = arbitration_occupancy_queue_status_reg[21];
  assign arbitration_occupancy_queue_status_reg_out[22] = arbitration_occupancy_queue_status_reg[22];
  assign arbitration_almost_full_config_reg_out[0] = arbitration_almost_full_config_reg[0];
  assign arbitration_almost_full_config_reg_out[1] = arbitration_almost_full_config_reg[1];
  assign arbitration_almost_full_config_reg_out[2] = arbitration_almost_full_config_reg[2];
  assign arbitration_almost_full_config_reg_out[3] = arbitration_almost_full_config_reg[3];
  assign arbitration_almost_full_config_reg_out[4] = arbitration_almost_full_config_reg[4];
  assign arbitration_almost_full_config_reg_out[5] = arbitration_almost_full_config_reg[5];
  assign arbitration_almost_full_config_reg_out[6] = arbitration_almost_full_config_reg[6];
  assign arbitration_almost_full_config_reg_out[7] = arbitration_almost_full_config_reg[7];
  assign arbitration_almost_full_config_reg_out[8] = arbitration_almost_full_config_reg[8];
  assign arbitration_almost_full_config_reg_out[9] = arbitration_almost_full_config_reg[9];
  assign arbitration_almost_full_config_reg_out[10] = arbitration_almost_full_config_reg[10];
  assign arbitration_almost_full_config_reg_out[11] = arbitration_almost_full_config_reg[11];
  assign arbitration_almost_full_config_reg_out[12] = arbitration_almost_full_config_reg[12];
  assign arbitration_almost_full_config_reg_out[13] = arbitration_almost_full_config_reg[13];
  assign arbitration_almost_full_config_reg_out[14] = arbitration_almost_full_config_reg[14];
  assign arbitration_almost_full_config_reg_out[15] = arbitration_almost_full_config_reg[15];
  assign arbitration_almost_full_config_reg_out[16] = arbitration_almost_full_config_reg[16];
  assign arbitration_almost_full_config_reg_out[17] = arbitration_almost_full_config_reg[17];
  assign arbitration_almost_full_config_reg_out[18] = arbitration_almost_full_config_reg[18];
  assign arbitration_almost_full_config_reg_out[19] = arbitration_almost_full_config_reg[19];
  assign arbitration_almost_full_config_reg_out[20] = arbitration_almost_full_config_reg[20];
  assign arbitration_almost_full_config_reg_out[21] = arbitration_almost_full_config_reg[21];
  assign arbitration_almost_full_config_reg_out[22] = arbitration_almost_full_config_reg[22];
  assign arbitration_size_exceeded_interrupt_reg_out[0] = (arbitration_size_exceeded_interrupt_reg[0] & arbitration_size_exceeded_interrupt_mask_reg[0]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[1] = (arbitration_size_exceeded_interrupt_reg[1] & arbitration_size_exceeded_interrupt_mask_reg[1]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[2] = (arbitration_size_exceeded_interrupt_reg[2] & arbitration_size_exceeded_interrupt_mask_reg[2]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[3] = (arbitration_size_exceeded_interrupt_reg[3] & arbitration_size_exceeded_interrupt_mask_reg[3]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[4] = (arbitration_size_exceeded_interrupt_reg[4] & arbitration_size_exceeded_interrupt_mask_reg[4]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[5] = (arbitration_size_exceeded_interrupt_reg[5] & arbitration_size_exceeded_interrupt_mask_reg[5]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[6] = (arbitration_size_exceeded_interrupt_reg[6] & arbitration_size_exceeded_interrupt_mask_reg[6]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[7] = (arbitration_size_exceeded_interrupt_reg[7] & arbitration_size_exceeded_interrupt_mask_reg[7]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[8] = (arbitration_size_exceeded_interrupt_reg[8] & arbitration_size_exceeded_interrupt_mask_reg[8]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[9] = (arbitration_size_exceeded_interrupt_reg[9] & arbitration_size_exceeded_interrupt_mask_reg[9]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[10] = (arbitration_size_exceeded_interrupt_reg[10] & arbitration_size_exceeded_interrupt_mask_reg[10]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[11] = (arbitration_size_exceeded_interrupt_reg[11] & arbitration_size_exceeded_interrupt_mask_reg[11]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[12] = (arbitration_size_exceeded_interrupt_reg[12] & arbitration_size_exceeded_interrupt_mask_reg[12]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[13] = (arbitration_size_exceeded_interrupt_reg[13] & arbitration_size_exceeded_interrupt_mask_reg[13]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[14] = (arbitration_size_exceeded_interrupt_reg[14] & arbitration_size_exceeded_interrupt_mask_reg[14]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[15] = (arbitration_size_exceeded_interrupt_reg[15] & arbitration_size_exceeded_interrupt_mask_reg[15]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[16] = (arbitration_size_exceeded_interrupt_reg[16] & arbitration_size_exceeded_interrupt_mask_reg[16]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[17] = (arbitration_size_exceeded_interrupt_reg[17] & arbitration_size_exceeded_interrupt_mask_reg[17]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[18] = (arbitration_size_exceeded_interrupt_reg[18] & arbitration_size_exceeded_interrupt_mask_reg[18]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[19] = (arbitration_size_exceeded_interrupt_reg[19] & arbitration_size_exceeded_interrupt_mask_reg[19]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[20] = (arbitration_size_exceeded_interrupt_reg[20] & arbitration_size_exceeded_interrupt_mask_reg[20]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[21] = (arbitration_size_exceeded_interrupt_reg[21] & arbitration_size_exceeded_interrupt_mask_reg[21]) != 0;
  assign arbitration_size_exceeded_interrupt_reg_out[22] = (arbitration_size_exceeded_interrupt_reg[22] & arbitration_size_exceeded_interrupt_mask_reg[22]) != 0;
  assign interrupt_summary[26:4] = arbitration_size_exceeded_interrupt_reg_out;
  always @(posedge clk) begin
    if(resetn==0) begin
      pready <= 0;
      slv_err <= 0;
      rdata <= 0;
      counter_en_config_reg <= 0;
      counter_main_load_config_reg <= 0;
      counter_secondary_load_config_reg <= 0;
      counter_number_of_cycles_config_reg <= 0;
      counter_mode_control_config_reg <= 0;
      counter_current_count_status_reg <= 0;
      counter_wrap_count_counter_reg <= 0;
      counter_overflow_interrupt_reg <= 0;
      counter_underflow_interrupt_reg <= 0;
      counter_wrap_interrupt_reg <= 0;
      counter_region_changed_interrupt_reg <= 0;
      pwm_en_config_reg <= 0;
      pwm_prescalar_config_reg <= 0;
      pwm_duty_cycle_config_reg[0] <= 0;
      pwm_duty_cycle_config_reg[1] <= 0;
      pwm_duty_cycle_config_reg[2] <= 0;
      pwm_freq_rsl_config_reg[0] <= 0;
      pwm_freq_rsl_config_reg[1] <= 0;
      pwm_freq_rsl_config_reg[2] <= 0;
      spwm_n_step_config_reg[0] <= 0;
      spwm_n_step_config_reg[1] <= 0;
      spwm_n_step_config_reg[2] <= 0;
      spwm_d_step_config_reg[0] <= 0;
      spwm_d_step_config_reg[1] <= 0;
      spwm_d_step_config_reg[2] <= 0;
      trng_n_step_config_reg[0] <= 0;
      trng_n_step_config_reg[1] <= 0;
      trng_n_step_config_reg[2] <= 0;
      trng_d_step_config_reg[0] <= 0;
      trng_d_step_config_reg[1] <= 0;
      trng_d_step_config_reg[2] <= 0;
      spwm_fixed_range_angle_config_reg[0] <= 0;
      spwm_fixed_range_angle_config_reg[1] <= 0;
      spwm_fixed_range_angle_config_reg[2] <= 0;
      spwm_fixed_range_config_reg[0] <= 0;
      spwm_fixed_range_config_reg[1] <= 0;
      spwm_fixed_range_config_reg[2] <= 0;
      spwm_phase_shift_config_reg[0] <= 0;
      spwm_phase_shift_config_reg[1] <= 0;
      spwm_phase_shift_config_reg[2] <= 0;
      spwm_fixed_range_qrtr_en_config_reg <= 0;
      spwm_status_status_reg <= 0;
      clk_muxing_mode_config_reg[0] <= 0;
      clk_muxing_mode_config_reg[1] <= 0;
      clk_muxing_count_sel_config_reg[0] <= 0;
      clk_muxing_count_sel_config_reg[1] <= 0;
      clk_muxing_pwm_sel_config_reg[0] <= 0;
      clk_muxing_pwm_sel_config_reg[1] <= 0;
      arbitration_level_thresholds_config_reg[0] <= 0;
      arbitration_level_thresholds_config_reg[1] <= 0;
      arbitration_level_thresholds_config_reg[2] <= 0;
      arbitration_level_thresholds_config_reg[3] <= 0;
      arbitration_level_weights_config_reg[0] <= 0;
      arbitration_level_weights_config_reg[1] <= 0;
      arbitration_level_weights_config_reg[2] <= 0;
      arbitration_level_weights_config_reg[3] <= 0;
      arbitration_lfsr_rseed_config_reg[0] <= 0;
      arbitration_lfsr_rseed_config_reg[1] <= 0;
      arbitration_lfsr_rseed_config_reg[2] <= 0;
      arbitration_full_queue_status_reg[0] <= 0;
      arbitration_full_queue_status_reg[1] <= 0;
      arbitration_full_queue_status_reg[2] <= 0;
      arbitration_full_queue_status_reg[3] <= 0;
      arbitration_full_queue_status_reg[4] <= 0;
      arbitration_full_queue_status_reg[5] <= 0;
      arbitration_full_queue_status_reg[6] <= 0;
      arbitration_full_queue_status_reg[7] <= 0;
      arbitration_full_queue_status_reg[8] <= 0;
      arbitration_full_queue_status_reg[9] <= 0;
      arbitration_full_queue_status_reg[10] <= 0;
      arbitration_full_queue_status_reg[11] <= 0;
      arbitration_full_queue_status_reg[12] <= 0;
      arbitration_full_queue_status_reg[13] <= 0;
      arbitration_full_queue_status_reg[14] <= 0;
      arbitration_full_queue_status_reg[15] <= 0;
      arbitration_full_queue_status_reg[16] <= 0;
      arbitration_full_queue_status_reg[17] <= 0;
      arbitration_full_queue_status_reg[18] <= 0;
      arbitration_full_queue_status_reg[19] <= 0;
      arbitration_full_queue_status_reg[20] <= 0;
      arbitration_full_queue_status_reg[21] <= 0;
      arbitration_full_queue_status_reg[22] <= 0;
      arbitration_empty_queue_status_reg[0] <= 0;
      arbitration_empty_queue_status_reg[1] <= 0;
      arbitration_empty_queue_status_reg[2] <= 0;
      arbitration_empty_queue_status_reg[3] <= 0;
      arbitration_empty_queue_status_reg[4] <= 0;
      arbitration_empty_queue_status_reg[5] <= 0;
      arbitration_empty_queue_status_reg[6] <= 0;
      arbitration_empty_queue_status_reg[7] <= 0;
      arbitration_empty_queue_status_reg[8] <= 0;
      arbitration_empty_queue_status_reg[9] <= 0;
      arbitration_empty_queue_status_reg[10] <= 0;
      arbitration_empty_queue_status_reg[11] <= 0;
      arbitration_empty_queue_status_reg[12] <= 0;
      arbitration_empty_queue_status_reg[13] <= 0;
      arbitration_empty_queue_status_reg[14] <= 0;
      arbitration_empty_queue_status_reg[15] <= 0;
      arbitration_empty_queue_status_reg[16] <= 0;
      arbitration_empty_queue_status_reg[17] <= 0;
      arbitration_empty_queue_status_reg[18] <= 0;
      arbitration_empty_queue_status_reg[19] <= 0;
      arbitration_empty_queue_status_reg[20] <= 0;
      arbitration_empty_queue_status_reg[21] <= 0;
      arbitration_empty_queue_status_reg[22] <= 0;
      arbitration_occupancy_queue_status_reg[0] <= 0;
      arbitration_occupancy_queue_status_reg[1] <= 0;
      arbitration_occupancy_queue_status_reg[2] <= 0;
      arbitration_occupancy_queue_status_reg[3] <= 0;
      arbitration_occupancy_queue_status_reg[4] <= 0;
      arbitration_occupancy_queue_status_reg[5] <= 0;
      arbitration_occupancy_queue_status_reg[6] <= 0;
      arbitration_occupancy_queue_status_reg[7] <= 0;
      arbitration_occupancy_queue_status_reg[8] <= 0;
      arbitration_occupancy_queue_status_reg[9] <= 0;
      arbitration_occupancy_queue_status_reg[10] <= 0;
      arbitration_occupancy_queue_status_reg[11] <= 0;
      arbitration_occupancy_queue_status_reg[12] <= 0;
      arbitration_occupancy_queue_status_reg[13] <= 0;
      arbitration_occupancy_queue_status_reg[14] <= 0;
      arbitration_occupancy_queue_status_reg[15] <= 0;
      arbitration_occupancy_queue_status_reg[16] <= 0;
      arbitration_occupancy_queue_status_reg[17] <= 0;
      arbitration_occupancy_queue_status_reg[18] <= 0;
      arbitration_occupancy_queue_status_reg[19] <= 0;
      arbitration_occupancy_queue_status_reg[20] <= 0;
      arbitration_occupancy_queue_status_reg[21] <= 0;
      arbitration_occupancy_queue_status_reg[22] <= 0;
      arbitration_almost_full_config_reg[0] <= 0;
      arbitration_almost_full_config_reg[1] <= 0;
      arbitration_almost_full_config_reg[2] <= 0;
      arbitration_almost_full_config_reg[3] <= 0;
      arbitration_almost_full_config_reg[4] <= 0;
      arbitration_almost_full_config_reg[5] <= 0;
      arbitration_almost_full_config_reg[6] <= 0;
      arbitration_almost_full_config_reg[7] <= 0;
      arbitration_almost_full_config_reg[8] <= 0;
      arbitration_almost_full_config_reg[9] <= 0;
      arbitration_almost_full_config_reg[10] <= 0;
      arbitration_almost_full_config_reg[11] <= 0;
      arbitration_almost_full_config_reg[12] <= 0;
      arbitration_almost_full_config_reg[13] <= 0;
      arbitration_almost_full_config_reg[14] <= 0;
      arbitration_almost_full_config_reg[15] <= 0;
      arbitration_almost_full_config_reg[16] <= 0;
      arbitration_almost_full_config_reg[17] <= 0;
      arbitration_almost_full_config_reg[18] <= 0;
      arbitration_almost_full_config_reg[19] <= 0;
      arbitration_almost_full_config_reg[20] <= 0;
      arbitration_almost_full_config_reg[21] <= 0;
      arbitration_almost_full_config_reg[22] <= 0;
      arbitration_size_exceeded_interrupt_reg[0] <= 0;
      arbitration_size_exceeded_interrupt_reg[1] <= 0;
      arbitration_size_exceeded_interrupt_reg[2] <= 0;
      arbitration_size_exceeded_interrupt_reg[3] <= 0;
      arbitration_size_exceeded_interrupt_reg[4] <= 0;
      arbitration_size_exceeded_interrupt_reg[5] <= 0;
      arbitration_size_exceeded_interrupt_reg[6] <= 0;
      arbitration_size_exceeded_interrupt_reg[7] <= 0;
      arbitration_size_exceeded_interrupt_reg[8] <= 0;
      arbitration_size_exceeded_interrupt_reg[9] <= 0;
      arbitration_size_exceeded_interrupt_reg[10] <= 0;
      arbitration_size_exceeded_interrupt_reg[11] <= 0;
      arbitration_size_exceeded_interrupt_reg[12] <= 0;
      arbitration_size_exceeded_interrupt_reg[13] <= 0;
      arbitration_size_exceeded_interrupt_reg[14] <= 0;
      arbitration_size_exceeded_interrupt_reg[15] <= 0;
      arbitration_size_exceeded_interrupt_reg[16] <= 0;
      arbitration_size_exceeded_interrupt_reg[17] <= 0;
      arbitration_size_exceeded_interrupt_reg[18] <= 0;
      arbitration_size_exceeded_interrupt_reg[19] <= 0;
      arbitration_size_exceeded_interrupt_reg[20] <= 0;
      arbitration_size_exceeded_interrupt_reg[21] <= 0;
      arbitration_size_exceeded_interrupt_reg[22] <= 0;
      ext_external_reg <= 0;
      counter_overflow_interrupt_mask_reg <= 0;
      counter_overflow_interrupt_test_reg <= 0;
      counter_underflow_interrupt_mask_reg <= 0;
      counter_underflow_interrupt_test_reg <= 0;
      counter_wrap_interrupt_mask_reg <= 0;
      counter_wrap_interrupt_test_reg <= 0;
      counter_region_changed_interrupt_mask_reg <= 0;
      counter_region_changed_interrupt_test_reg <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[0] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[1] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[2] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[3] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[4] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[5] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[6] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[7] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[8] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[9] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[10] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[11] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[12] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[13] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[14] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[15] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[16] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[17] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[18] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[19] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[20] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[21] <= 0;
      arbitration_size_exceeded_interrupt_mask_reg[22] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[0] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[1] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[2] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[3] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[4] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[5] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[6] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[7] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[8] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[9] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[10] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[11] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[12] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[13] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[14] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[15] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[16] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[17] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[18] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[19] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[20] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[21] <= 0;
      arbitration_size_exceeded_interrupt_test_reg[22] <= 0;
    end
    else begin
      if(ready_s==1) begin
        // write_t<=write;
        // addr_t<=addr;
        // wdata_t<=wdata;
        proc<=1;
        slv_err<=0;
      end
      if(proc==1) begin
        proc<=0;
        case(addr_t)
        0: begin
          if(write_t==1) begin
            counter_en_config_reg<=wdata_t;
          end
          else begin
            rdata<=counter_en_config_reg;
          end
        end
        1: begin
          if(write_t==1) begin
            counter_main_load_config_reg<=wdata_t;
          end
          else begin
            rdata<=counter_main_load_config_reg;
          end
        end
        2: begin
          if(write_t==1) begin
            counter_secondary_load_config_reg<=wdata_t;
          end
          else begin
            rdata<=counter_secondary_load_config_reg;
          end
        end
        3: begin
          if(write_t==1) begin
            counter_number_of_cycles_config_reg<=wdata_t;
          end
          else begin
            rdata<=counter_number_of_cycles_config_reg;
          end
        end
        4: begin
          if(write_t==1) begin
            counter_mode_control_config_reg<=wdata_t;
          end
          else begin
            rdata<=counter_mode_control_config_reg;
          end
        end
        5: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=counter_current_count_status_reg;
          end
        end
        6: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=counter_wrap_count_counter_reg;
            counter_wrap_count_counter_reg<=0;
          end
        end
        7: begin
          if(write_t==1) begin
            counter_overflow_interrupt_reg<=0;
          end
          else begin
            rdata<=counter_overflow_interrupt_reg;
          end
        end
        8: begin
          if(write_t==1) begin
            counter_overflow_interrupt_mask_reg<=wdata_t;
          end
          else begin
            rdata<=counter_overflow_interrupt_mask_reg;
          end
        end
        9: begin
          if(write_t==1) begin
            counter_overflow_interrupt_test_reg<=wdata_t;
          end
          else begin
            rdata<=counter_overflow_interrupt_test_reg;
          end
        end
        10: begin
          if(write_t==1) begin
            counter_underflow_interrupt_reg<=0;
          end
          else begin
            rdata<=counter_underflow_interrupt_reg;
          end
        end
        11: begin
          if(write_t==1) begin
            counter_underflow_interrupt_mask_reg<=wdata_t;
          end
          else begin
            rdata<=counter_underflow_interrupt_mask_reg;
          end
        end
        12: begin
          if(write_t==1) begin
            counter_underflow_interrupt_test_reg<=wdata_t;
          end
          else begin
            rdata<=counter_underflow_interrupt_test_reg;
          end
        end
        13: begin
          if(write_t==1) begin
            counter_wrap_interrupt_reg<=0;
          end
          else begin
            rdata<=counter_wrap_interrupt_reg;
          end
        end
        14: begin
          if(write_t==1) begin
            counter_wrap_interrupt_mask_reg<=wdata_t;
          end
          else begin
            rdata<=counter_wrap_interrupt_mask_reg;
          end
        end
        15: begin
          if(write_t==1) begin
            counter_wrap_interrupt_test_reg<=wdata_t;
          end
          else begin
            rdata<=counter_wrap_interrupt_test_reg;
          end
        end
        16: begin
          if(write_t==1) begin
            counter_region_changed_interrupt_reg<=0;
          end
          else begin
            rdata<=counter_region_changed_interrupt_reg;
          end
        end
        17: begin
          if(write_t==1) begin
            counter_region_changed_interrupt_mask_reg<=wdata_t;
          end
          else begin
            rdata<=counter_region_changed_interrupt_mask_reg;
          end
        end
        18: begin
          if(write_t==1) begin
            counter_region_changed_interrupt_test_reg<=wdata_t;
          end
          else begin
            rdata<=counter_region_changed_interrupt_test_reg;
          end
        end
        19: begin
          if(write_t==1) begin
            pwm_en_config_reg<=wdata_t;
          end
          else begin
            rdata<=pwm_en_config_reg;
          end
        end
        20: begin
          if(write_t==1) begin
            pwm_prescalar_config_reg<=wdata_t;
          end
          else begin
            rdata<=pwm_prescalar_config_reg;
          end
        end
        21: begin
          if(write_t==1) begin
            pwm_duty_cycle_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=pwm_duty_cycle_config_reg[0];
          end
        end
        22: begin
          if(write_t==1) begin
            pwm_duty_cycle_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=pwm_duty_cycle_config_reg[1];
          end
        end
        23: begin
          if(write_t==1) begin
            pwm_duty_cycle_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=pwm_duty_cycle_config_reg[2];
          end
        end
        24: begin
          if(write_t==1) begin
            pwm_freq_rsl_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=pwm_freq_rsl_config_reg[0];
          end
        end
        25: begin
          if(write_t==1) begin
            pwm_freq_rsl_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=pwm_freq_rsl_config_reg[1];
          end
        end
        26: begin
          if(write_t==1) begin
            pwm_freq_rsl_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=pwm_freq_rsl_config_reg[2];
          end
        end
        27: begin
          if(write_t==1) begin
            spwm_n_step_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=spwm_n_step_config_reg[0];
          end
        end
        28: begin
          if(write_t==1) begin
            spwm_n_step_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=spwm_n_step_config_reg[1];
          end
        end
        29: begin
          if(write_t==1) begin
            spwm_n_step_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=spwm_n_step_config_reg[2];
          end
        end
        30: begin
          if(write_t==1) begin
            spwm_d_step_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=spwm_d_step_config_reg[0];
          end
        end
        31: begin
          if(write_t==1) begin
            spwm_d_step_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=spwm_d_step_config_reg[1];
          end
        end
        32: begin
          if(write_t==1) begin
            spwm_d_step_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=spwm_d_step_config_reg[2];
          end
        end
        33: begin
          if(write_t==1) begin
            trng_n_step_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=trng_n_step_config_reg[0];
          end
        end
        34: begin
          if(write_t==1) begin
            trng_n_step_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=trng_n_step_config_reg[1];
          end
        end
        35: begin
          if(write_t==1) begin
            trng_n_step_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=trng_n_step_config_reg[2];
          end
        end
        36: begin
          if(write_t==1) begin
            trng_d_step_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=trng_d_step_config_reg[0];
          end
        end
        37: begin
          if(write_t==1) begin
            trng_d_step_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=trng_d_step_config_reg[1];
          end
        end
        38: begin
          if(write_t==1) begin
            trng_d_step_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=trng_d_step_config_reg[2];
          end
        end
        39: begin
          if(write_t==1) begin
            spwm_fixed_range_angle_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_angle_config_reg[0];
          end
        end
        40: begin
          if(write_t==1) begin
            spwm_fixed_range_angle_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_angle_config_reg[1];
          end
        end
        41: begin
          if(write_t==1) begin
            spwm_fixed_range_angle_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_angle_config_reg[2];
          end
        end
        42: begin
          if(write_t==1) begin
            spwm_fixed_range_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_config_reg[0];
          end
        end
        43: begin
          if(write_t==1) begin
            spwm_fixed_range_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_config_reg[1];
          end
        end
        44: begin
          if(write_t==1) begin
            spwm_fixed_range_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_config_reg[2];
          end
        end
        45: begin
          if(write_t==1) begin
            spwm_phase_shift_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=spwm_phase_shift_config_reg[0];
          end
        end
        46: begin
          if(write_t==1) begin
            spwm_phase_shift_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=spwm_phase_shift_config_reg[1];
          end
        end
        47: begin
          if(write_t==1) begin
            spwm_phase_shift_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=spwm_phase_shift_config_reg[2];
          end
        end
        48: begin
          if(write_t==1) begin
            spwm_fixed_range_qrtr_en_config_reg<=wdata_t;
          end
          else begin
            rdata<=spwm_fixed_range_qrtr_en_config_reg;
          end
        end
        49: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=spwm_status_status_reg;
          end
        end
        50: begin
          if(write_t==1) begin
            clk_muxing_mode_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=clk_muxing_mode_config_reg[0];
          end
        end
        51: begin
          if(write_t==1) begin
            clk_muxing_mode_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=clk_muxing_mode_config_reg[1];
          end
        end
        52: begin
          if(write_t==1) begin
            clk_muxing_count_sel_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=clk_muxing_count_sel_config_reg[0];
          end
        end
        53: begin
          if(write_t==1) begin
            clk_muxing_count_sel_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=clk_muxing_count_sel_config_reg[1];
          end
        end
        54: begin
          if(write_t==1) begin
            clk_muxing_pwm_sel_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=clk_muxing_pwm_sel_config_reg[0];
          end
        end
        55: begin
          if(write_t==1) begin
            clk_muxing_pwm_sel_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=clk_muxing_pwm_sel_config_reg[1];
          end
        end
        56: begin
          if(write_t==1) begin
            arbitration_level_thresholds_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_thresholds_config_reg[0];
          end
        end
        57: begin
          if(write_t==1) begin
            arbitration_level_thresholds_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_thresholds_config_reg[1];
          end
        end
        58: begin
          if(write_t==1) begin
            arbitration_level_thresholds_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_thresholds_config_reg[2];
          end
        end
        59: begin
          if(write_t==1) begin
            arbitration_level_thresholds_config_reg[3]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_thresholds_config_reg[3];
          end
        end
        60: begin
          if(write_t==1) begin
            arbitration_level_weights_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_weights_config_reg[0];
          end
        end
        61: begin
          if(write_t==1) begin
            arbitration_level_weights_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_weights_config_reg[1];
          end
        end
        62: begin
          if(write_t==1) begin
            arbitration_level_weights_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_weights_config_reg[2];
          end
        end
        63: begin
          if(write_t==1) begin
            arbitration_level_weights_config_reg[3]<=wdata_t;
          end
          else begin
            rdata<=arbitration_level_weights_config_reg[3];
          end
        end
        64: begin
          if(write_t==1) begin
            arbitration_lfsr_rseed_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=arbitration_lfsr_rseed_config_reg[0];
          end
        end
        65: begin
          if(write_t==1) begin
            arbitration_lfsr_rseed_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=arbitration_lfsr_rseed_config_reg[1];
          end
        end
        66: begin
          if(write_t==1) begin
            arbitration_lfsr_rseed_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=arbitration_lfsr_rseed_config_reg[2];
          end
        end
        67: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[0];
          end
        end
        68: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[1];
          end
        end
        69: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[2];
          end
        end
        70: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[3];
          end
        end
        71: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[4];
          end
        end
        72: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[5];
          end
        end
        73: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[6];
          end
        end
        74: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[7];
          end
        end
        75: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[8];
          end
        end
        76: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[9];
          end
        end
        77: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[10];
          end
        end
        78: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[11];
          end
        end
        79: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[12];
          end
        end
        80: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[13];
          end
        end
        81: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[14];
          end
        end
        82: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[15];
          end
        end
        83: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[16];
          end
        end
        84: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[17];
          end
        end
        85: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[18];
          end
        end
        86: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[19];
          end
        end
        87: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[20];
          end
        end
        88: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[21];
          end
        end
        89: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_full_queue_status_reg[22];
          end
        end
        90: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[0];
          end
        end
        91: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[1];
          end
        end
        92: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[2];
          end
        end
        93: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[3];
          end
        end
        94: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[4];
          end
        end
        95: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[5];
          end
        end
        96: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[6];
          end
        end
        97: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[7];
          end
        end
        98: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[8];
          end
        end
        99: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[9];
          end
        end
        100: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[10];
          end
        end
        101: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[11];
          end
        end
        102: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[12];
          end
        end
        103: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[13];
          end
        end
        104: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[14];
          end
        end
        105: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[15];
          end
        end
        106: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[16];
          end
        end
        107: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[17];
          end
        end
        108: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[18];
          end
        end
        109: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[19];
          end
        end
        110: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[20];
          end
        end
        111: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[21];
          end
        end
        112: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_empty_queue_status_reg[22];
          end
        end
        113: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[0];
          end
        end
        114: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[1];
          end
        end
        115: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[2];
          end
        end
        116: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[3];
          end
        end
        117: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[4];
          end
        end
        118: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[5];
          end
        end
        119: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[6];
          end
        end
        120: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[7];
          end
        end
        121: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[8];
          end
        end
        122: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[9];
          end
        end
        123: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[10];
          end
        end
        124: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[11];
          end
        end
        125: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[12];
          end
        end
        126: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[13];
          end
        end
        127: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[14];
          end
        end
        128: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[15];
          end
        end
        129: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[16];
          end
        end
        130: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[17];
          end
        end
        131: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[18];
          end
        end
        132: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[19];
          end
        end
        133: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[20];
          end
        end
        134: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[21];
          end
        end
        135: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=arbitration_occupancy_queue_status_reg[22];
          end
        end
        136: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[0]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[0];
          end
        end
        137: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[1]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[1];
          end
        end
        138: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[2]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[2];
          end
        end
        139: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[3]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[3];
          end
        end
        140: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[4]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[4];
          end
        end
        141: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[5]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[5];
          end
        end
        142: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[6]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[6];
          end
        end
        143: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[7]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[7];
          end
        end
        144: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[8]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[8];
          end
        end
        145: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[9]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[9];
          end
        end
        146: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[10]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[10];
          end
        end
        147: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[11]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[11];
          end
        end
        148: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[12]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[12];
          end
        end
        149: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[13]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[13];
          end
        end
        150: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[14]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[14];
          end
        end
        151: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[15]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[15];
          end
        end
        152: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[16]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[16];
          end
        end
        153: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[17]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[17];
          end
        end
        154: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[18]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[18];
          end
        end
        155: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[19]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[19];
          end
        end
        156: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[20]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[20];
          end
        end
        157: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[21]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[21];
          end
        end
        158: begin
          if(write_t==1) begin
            arbitration_almost_full_config_reg[22]<=wdata_t;
          end
          else begin
            rdata<=arbitration_almost_full_config_reg[22];
          end
        end
        159: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[0]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[0];
          end
        end
        160: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[1]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[1];
          end
        end
        161: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[2]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[2];
          end
        end
        162: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[3]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[3];
          end
        end
        163: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[4]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[4];
          end
        end
        164: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[5]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[5];
          end
        end
        165: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[6]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[6];
          end
        end
        166: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[7]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[7];
          end
        end
        167: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[8]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[8];
          end
        end
        168: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[9]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[9];
          end
        end
        169: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[10]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[10];
          end
        end
        170: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[11]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[11];
          end
        end
        171: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[12]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[12];
          end
        end
        172: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[13]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[13];
          end
        end
        173: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[14]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[14];
          end
        end
        174: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[15]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[15];
          end
        end
        175: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[16]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[16];
          end
        end
        176: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[17]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[17];
          end
        end
        177: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[18]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[18];
          end
        end
        178: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[19]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[19];
          end
        end
        179: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[20]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[20];
          end
        end
        180: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[21]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[21];
          end
        end
        181: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_reg[22]<=0;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_reg[22];
          end
        end
        182: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[0]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[0];
          end
        end
        183: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[1]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[1];
          end
        end
        184: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[2]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[2];
          end
        end
        185: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[3]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[3];
          end
        end
        186: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[4]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[4];
          end
        end
        187: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[5]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[5];
          end
        end
        188: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[6]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[6];
          end
        end
        189: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[7]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[7];
          end
        end
        190: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[8]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[8];
          end
        end
        191: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[9]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[9];
          end
        end
        192: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[10]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[10];
          end
        end
        193: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[11]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[11];
          end
        end
        194: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[12]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[12];
          end
        end
        195: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[13]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[13];
          end
        end
        196: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[14]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[14];
          end
        end
        197: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[15]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[15];
          end
        end
        198: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[16]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[16];
          end
        end
        199: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[17]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[17];
          end
        end
        200: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[18]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[18];
          end
        end
        201: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[19]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[19];
          end
        end
        202: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[20]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[20];
          end
        end
        203: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[21]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[21];
          end
        end
        204: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_mask_reg[22]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_mask_reg[22];
          end
        end
        205: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[0]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[0];
          end
        end
        206: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[1]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[1];
          end
        end
        207: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[2]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[2];
          end
        end
        208: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[3]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[3];
          end
        end
        209: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[4]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[4];
          end
        end
        210: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[5]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[5];
          end
        end
        211: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[6]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[6];
          end
        end
        212: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[7]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[7];
          end
        end
        213: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[8]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[8];
          end
        end
        214: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[9]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[9];
          end
        end
        215: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[10]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[10];
          end
        end
        216: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[11]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[11];
          end
        end
        217: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[12]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[12];
          end
        end
        218: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[13]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[13];
          end
        end
        219: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[14]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[14];
          end
        end
        220: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[15]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[15];
          end
        end
        221: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[16]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[16];
          end
        end
        222: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[17]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[17];
          end
        end
        223: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[18]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[18];
          end
        end
        224: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[19]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[19];
          end
        end
        225: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[20]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[20];
          end
        end
        226: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[21]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[21];
          end
        end
        227: begin
          if(write_t==1) begin
            arbitration_size_exceeded_interrupt_test_reg[22]<=wdata_t;
          end
          else begin
            rdata<=arbitration_size_exceeded_interrupt_test_reg[22];
          end
        end
        228: begin
          if(write_t==1) begin
            ext_external_reg<=wdata_t;
          end
          else begin
            rdata<=ext_external_reg;
          end
        end
        229: begin
          if(write_t==1) begin
            slv_err<=1;
          end
          else begin
            rdata<=main0_summary_reg;
          end
        end
        default: begin
          slv_err<=1;
        end
        endcase
      end
      if(proc==1&&pready==0) begin
        pready<=1;
      end
      else begin
        pready<=0;
      end
      if(slv_err==1) begin
        slv_err<=0;
      end
    end
    counter_current_count_status_reg <= counter_current_count_status_reg_in;
    counter_wrap_count_counter_reg <= counter_wrap_count_counter_reg_sig + (addr_t == (6) && write_t== 0)? 0 : counter_wrap_count_counter_reg ;
    counter_overflow_interrupt_reg <= counter_overflow_interrupt_reg_sig | counter_overflow_interrupt_test_reg ;
    counter_underflow_interrupt_reg <= counter_underflow_interrupt_reg_sig | counter_underflow_interrupt_test_reg ;
    counter_wrap_interrupt_reg <= counter_wrap_interrupt_reg_sig | counter_wrap_interrupt_test_reg ;
    counter_region_changed_interrupt_reg <= counter_region_changed_interrupt_reg_sig | counter_region_changed_interrupt_test_reg ;
    spwm_status_status_reg <= spwm_status_status_reg_in;
    arbitration_full_queue_status_reg[0] <= arbitration_full_queue_status_reg_in[0];
    arbitration_full_queue_status_reg[1] <= arbitration_full_queue_status_reg_in[1];
    arbitration_full_queue_status_reg[2] <= arbitration_full_queue_status_reg_in[2];
    arbitration_full_queue_status_reg[3] <= arbitration_full_queue_status_reg_in[3];
    arbitration_full_queue_status_reg[4] <= arbitration_full_queue_status_reg_in[4];
    arbitration_full_queue_status_reg[5] <= arbitration_full_queue_status_reg_in[5];
    arbitration_full_queue_status_reg[6] <= arbitration_full_queue_status_reg_in[6];
    arbitration_full_queue_status_reg[7] <= arbitration_full_queue_status_reg_in[7];
    arbitration_full_queue_status_reg[8] <= arbitration_full_queue_status_reg_in[8];
    arbitration_full_queue_status_reg[9] <= arbitration_full_queue_status_reg_in[9];
    arbitration_full_queue_status_reg[10] <= arbitration_full_queue_status_reg_in[10];
    arbitration_full_queue_status_reg[11] <= arbitration_full_queue_status_reg_in[11];
    arbitration_full_queue_status_reg[12] <= arbitration_full_queue_status_reg_in[12];
    arbitration_full_queue_status_reg[13] <= arbitration_full_queue_status_reg_in[13];
    arbitration_full_queue_status_reg[14] <= arbitration_full_queue_status_reg_in[14];
    arbitration_full_queue_status_reg[15] <= arbitration_full_queue_status_reg_in[15];
    arbitration_full_queue_status_reg[16] <= arbitration_full_queue_status_reg_in[16];
    arbitration_full_queue_status_reg[17] <= arbitration_full_queue_status_reg_in[17];
    arbitration_full_queue_status_reg[18] <= arbitration_full_queue_status_reg_in[18];
    arbitration_full_queue_status_reg[19] <= arbitration_full_queue_status_reg_in[19];
    arbitration_full_queue_status_reg[20] <= arbitration_full_queue_status_reg_in[20];
    arbitration_full_queue_status_reg[21] <= arbitration_full_queue_status_reg_in[21];
    arbitration_full_queue_status_reg[22] <= arbitration_full_queue_status_reg_in[22];
    arbitration_empty_queue_status_reg[0] <= arbitration_empty_queue_status_reg_in[0];
    arbitration_empty_queue_status_reg[1] <= arbitration_empty_queue_status_reg_in[1];
    arbitration_empty_queue_status_reg[2] <= arbitration_empty_queue_status_reg_in[2];
    arbitration_empty_queue_status_reg[3] <= arbitration_empty_queue_status_reg_in[3];
    arbitration_empty_queue_status_reg[4] <= arbitration_empty_queue_status_reg_in[4];
    arbitration_empty_queue_status_reg[5] <= arbitration_empty_queue_status_reg_in[5];
    arbitration_empty_queue_status_reg[6] <= arbitration_empty_queue_status_reg_in[6];
    arbitration_empty_queue_status_reg[7] <= arbitration_empty_queue_status_reg_in[7];
    arbitration_empty_queue_status_reg[8] <= arbitration_empty_queue_status_reg_in[8];
    arbitration_empty_queue_status_reg[9] <= arbitration_empty_queue_status_reg_in[9];
    arbitration_empty_queue_status_reg[10] <= arbitration_empty_queue_status_reg_in[10];
    arbitration_empty_queue_status_reg[11] <= arbitration_empty_queue_status_reg_in[11];
    arbitration_empty_queue_status_reg[12] <= arbitration_empty_queue_status_reg_in[12];
    arbitration_empty_queue_status_reg[13] <= arbitration_empty_queue_status_reg_in[13];
    arbitration_empty_queue_status_reg[14] <= arbitration_empty_queue_status_reg_in[14];
    arbitration_empty_queue_status_reg[15] <= arbitration_empty_queue_status_reg_in[15];
    arbitration_empty_queue_status_reg[16] <= arbitration_empty_queue_status_reg_in[16];
    arbitration_empty_queue_status_reg[17] <= arbitration_empty_queue_status_reg_in[17];
    arbitration_empty_queue_status_reg[18] <= arbitration_empty_queue_status_reg_in[18];
    arbitration_empty_queue_status_reg[19] <= arbitration_empty_queue_status_reg_in[19];
    arbitration_empty_queue_status_reg[20] <= arbitration_empty_queue_status_reg_in[20];
    arbitration_empty_queue_status_reg[21] <= arbitration_empty_queue_status_reg_in[21];
    arbitration_empty_queue_status_reg[22] <= arbitration_empty_queue_status_reg_in[22];
    arbitration_occupancy_queue_status_reg[0] <= arbitration_occupancy_queue_status_reg_in[0];
    arbitration_occupancy_queue_status_reg[1] <= arbitration_occupancy_queue_status_reg_in[1];
    arbitration_occupancy_queue_status_reg[2] <= arbitration_occupancy_queue_status_reg_in[2];
    arbitration_occupancy_queue_status_reg[3] <= arbitration_occupancy_queue_status_reg_in[3];
    arbitration_occupancy_queue_status_reg[4] <= arbitration_occupancy_queue_status_reg_in[4];
    arbitration_occupancy_queue_status_reg[5] <= arbitration_occupancy_queue_status_reg_in[5];
    arbitration_occupancy_queue_status_reg[6] <= arbitration_occupancy_queue_status_reg_in[6];
    arbitration_occupancy_queue_status_reg[7] <= arbitration_occupancy_queue_status_reg_in[7];
    arbitration_occupancy_queue_status_reg[8] <= arbitration_occupancy_queue_status_reg_in[8];
    arbitration_occupancy_queue_status_reg[9] <= arbitration_occupancy_queue_status_reg_in[9];
    arbitration_occupancy_queue_status_reg[10] <= arbitration_occupancy_queue_status_reg_in[10];
    arbitration_occupancy_queue_status_reg[11] <= arbitration_occupancy_queue_status_reg_in[11];
    arbitration_occupancy_queue_status_reg[12] <= arbitration_occupancy_queue_status_reg_in[12];
    arbitration_occupancy_queue_status_reg[13] <= arbitration_occupancy_queue_status_reg_in[13];
    arbitration_occupancy_queue_status_reg[14] <= arbitration_occupancy_queue_status_reg_in[14];
    arbitration_occupancy_queue_status_reg[15] <= arbitration_occupancy_queue_status_reg_in[15];
    arbitration_occupancy_queue_status_reg[16] <= arbitration_occupancy_queue_status_reg_in[16];
    arbitration_occupancy_queue_status_reg[17] <= arbitration_occupancy_queue_status_reg_in[17];
    arbitration_occupancy_queue_status_reg[18] <= arbitration_occupancy_queue_status_reg_in[18];
    arbitration_occupancy_queue_status_reg[19] <= arbitration_occupancy_queue_status_reg_in[19];
    arbitration_occupancy_queue_status_reg[20] <= arbitration_occupancy_queue_status_reg_in[20];
    arbitration_occupancy_queue_status_reg[21] <= arbitration_occupancy_queue_status_reg_in[21];
    arbitration_occupancy_queue_status_reg[22] <= arbitration_occupancy_queue_status_reg_in[22];
    arbitration_size_exceeded_interrupt_reg[0] <= arbitration_size_exceeded_interrupt_reg_sig[0] | arbitration_size_exceeded_interrupt_test_reg [0];
    arbitration_size_exceeded_interrupt_reg[1] <= arbitration_size_exceeded_interrupt_reg_sig[1] | arbitration_size_exceeded_interrupt_test_reg [1];
    arbitration_size_exceeded_interrupt_reg[2] <= arbitration_size_exceeded_interrupt_reg_sig[2] | arbitration_size_exceeded_interrupt_test_reg [2];
    arbitration_size_exceeded_interrupt_reg[3] <= arbitration_size_exceeded_interrupt_reg_sig[3] | arbitration_size_exceeded_interrupt_test_reg [3];
    arbitration_size_exceeded_interrupt_reg[4] <= arbitration_size_exceeded_interrupt_reg_sig[4] | arbitration_size_exceeded_interrupt_test_reg [4];
    arbitration_size_exceeded_interrupt_reg[5] <= arbitration_size_exceeded_interrupt_reg_sig[5] | arbitration_size_exceeded_interrupt_test_reg [5];
    arbitration_size_exceeded_interrupt_reg[6] <= arbitration_size_exceeded_interrupt_reg_sig[6] | arbitration_size_exceeded_interrupt_test_reg [6];
    arbitration_size_exceeded_interrupt_reg[7] <= arbitration_size_exceeded_interrupt_reg_sig[7] | arbitration_size_exceeded_interrupt_test_reg [7];
    arbitration_size_exceeded_interrupt_reg[8] <= arbitration_size_exceeded_interrupt_reg_sig[8] | arbitration_size_exceeded_interrupt_test_reg [8];
    arbitration_size_exceeded_interrupt_reg[9] <= arbitration_size_exceeded_interrupt_reg_sig[9] | arbitration_size_exceeded_interrupt_test_reg [9];
    arbitration_size_exceeded_interrupt_reg[10] <= arbitration_size_exceeded_interrupt_reg_sig[10] | arbitration_size_exceeded_interrupt_test_reg [10];
    arbitration_size_exceeded_interrupt_reg[11] <= arbitration_size_exceeded_interrupt_reg_sig[11] | arbitration_size_exceeded_interrupt_test_reg [11];
    arbitration_size_exceeded_interrupt_reg[12] <= arbitration_size_exceeded_interrupt_reg_sig[12] | arbitration_size_exceeded_interrupt_test_reg [12];
    arbitration_size_exceeded_interrupt_reg[13] <= arbitration_size_exceeded_interrupt_reg_sig[13] | arbitration_size_exceeded_interrupt_test_reg [13];
    arbitration_size_exceeded_interrupt_reg[14] <= arbitration_size_exceeded_interrupt_reg_sig[14] | arbitration_size_exceeded_interrupt_test_reg [14];
    arbitration_size_exceeded_interrupt_reg[15] <= arbitration_size_exceeded_interrupt_reg_sig[15] | arbitration_size_exceeded_interrupt_test_reg [15];
    arbitration_size_exceeded_interrupt_reg[16] <= arbitration_size_exceeded_interrupt_reg_sig[16] | arbitration_size_exceeded_interrupt_test_reg [16];
    arbitration_size_exceeded_interrupt_reg[17] <= arbitration_size_exceeded_interrupt_reg_sig[17] | arbitration_size_exceeded_interrupt_test_reg [17];
    arbitration_size_exceeded_interrupt_reg[18] <= arbitration_size_exceeded_interrupt_reg_sig[18] | arbitration_size_exceeded_interrupt_test_reg [18];
    arbitration_size_exceeded_interrupt_reg[19] <= arbitration_size_exceeded_interrupt_reg_sig[19] | arbitration_size_exceeded_interrupt_test_reg [19];
    arbitration_size_exceeded_interrupt_reg[20] <= arbitration_size_exceeded_interrupt_reg_sig[20] | arbitration_size_exceeded_interrupt_test_reg [20];
    arbitration_size_exceeded_interrupt_reg[21] <= arbitration_size_exceeded_interrupt_reg_sig[21] | arbitration_size_exceeded_interrupt_test_reg [21];
    arbitration_size_exceeded_interrupt_reg[22] <= arbitration_size_exceeded_interrupt_reg_sig[22] | arbitration_size_exceeded_interrupt_test_reg [22];
    if(addr_t!=(8) || write_t!=1) begin
      counter_overflow_interrupt_mask_reg <= 0;
    end
    if(addr_t!=(11) || write_t!=1) begin
      counter_underflow_interrupt_mask_reg <= 0;
    end
    if(addr_t!=(14) || write_t!=1) begin
      counter_wrap_interrupt_mask_reg <= 0;
    end
    if(addr_t!=(17) || write_t!=1) begin
      counter_region_changed_interrupt_mask_reg <= 0;
    end
    if(addr_t!=(182+0) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[0] <= 0;
    end
    if(addr_t!=(182+1) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[1] <= 0;
    end
    if(addr_t!=(182+2) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[2] <= 0;
    end
    if(addr_t!=(182+3) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[3] <= 0;
    end
    if(addr_t!=(182+4) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[4] <= 0;
    end
    if(addr_t!=(182+5) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[5] <= 0;
    end
    if(addr_t!=(182+6) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[6] <= 0;
    end
    if(addr_t!=(182+7) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[7] <= 0;
    end
    if(addr_t!=(182+8) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[8] <= 0;
    end
    if(addr_t!=(182+9) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[9] <= 0;
    end
    if(addr_t!=(182+10) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[10] <= 0;
    end
    if(addr_t!=(182+11) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[11] <= 0;
    end
    if(addr_t!=(182+12) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[12] <= 0;
    end
    if(addr_t!=(182+13) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[13] <= 0;
    end
    if(addr_t!=(182+14) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[14] <= 0;
    end
    if(addr_t!=(182+15) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[15] <= 0;
    end
    if(addr_t!=(182+16) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[16] <= 0;
    end
    if(addr_t!=(182+17) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[17] <= 0;
    end
    if(addr_t!=(182+18) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[18] <= 0;
    end
    if(addr_t!=(182+19) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[19] <= 0;
    end
    if(addr_t!=(182+20) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[20] <= 0;
    end
    if(addr_t!=(182+21) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[21] <= 0;
    end
    if(addr_t!=(182+22) || write_t!=1) begin
      arbitration_size_exceeded_interrupt_mask_reg[22] <= 0;
    end
  end
endmodule
