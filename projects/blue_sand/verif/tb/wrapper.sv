module wrapper_dut(apb_if.DUT _apb_if, counter_if.DUT _counter_if);
  

blue_sand dut   (
                  .pclk(_apb_if.pclk),
                  .presetn(_apb_if.presetn),
                  .psel(_apb_if.psel),
                  .penable(_apb_if.penable),
                  .pwrite(_apb_if.pwrite),
                  .paddr(_apb_if.paddr),
                  .pwdata(_apb_if.pwdata),
                  .pready(_apb_if.pready),
                  .prdata(_apb_if.prdata),
                  .pslverr(_apb_if.pslverr),
                  .main_interrupt(),
                  .count(_counter_if.count), 
                  .pwm_port_sig(),
                  .boot_done(),
                  .arbitration_req_sources(),
                  .arbitration_push(),
                  .arbitration_push_ready(),
                  .arbitration_req_output(),
                  .arbitration_pull(),
                  .arbitration_pull_ready(),
                  .arbitration_stage3_input_requests(),
                  .arbitration_threshold_val(),
                  .fatal_error()
                );


endmodule
