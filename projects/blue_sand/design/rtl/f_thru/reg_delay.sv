// reg_delay
module reg_dealy( clk,
                  reg_val,
                  reg_val_delayed
                );
  parameter WIDTH = 8;
  parameter DELAY = 1;
  input clk;
  input [WIDTH-1:0] reg_val;
  output logic [WIDTH-1:0] reg_val_delayed;
  logic [DELAY-1:0] [WIDTH-1:0] reg_ff_delayed;

  assign reg_val_delayed = reg_ff_delayed[DELAY-1];
  always_ff @(posedge clk) begin
    reg_ff_delayed <= {reg_ff_delayed[DELAY-2:0], reg_val};
  end
endmodule
