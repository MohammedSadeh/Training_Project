module interrupt_summary ( intr_sum,
                           main_int
                         );
  parameter INTR_COUNT = 27;
  output logic main_int;

  input [INTR_COUNT-1:0] intr_sum;
    
  assign main_int=intr_sum!=0;

endmodule
