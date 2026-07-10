module bit_to_address_map ( data_in,
                            data_out,
                            valid
                          );

  parameter `DATA_WIDTH = 8;

  input [`DATA_WIDTH - 1 : 0] data_in; 

  output reg [$clog2(`DATA_WIDTH) - 1 : 0] data_out;
  output                                  valid;

  integer i; 

  assign valid = |data_in ;
  
  always_comb begin
    for (i = `DATA_WIDTH - 1; i >= 0; i = i - 1) begin
      if (data_in[i] == 1) begin
        data_out = i;
      end
    end
  end
endmodule
