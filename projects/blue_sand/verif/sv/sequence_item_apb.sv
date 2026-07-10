class sequence_item_apb extends uvm_sequence_item;
  
  //inputs for the APB Slave (Data signals):
  
  //control the opeation read = 0 or wrtie = 1
  rand bit pwrite;
  //address to read or write
  rand bit [`ADDR_WIDTH-1:0] paddr;
  //data to write
  rand bit [`DATA_WIDTH-1:0] pwdata;
  
  
  //outputs of the APB Slave:
  
  //data that be read
  bit [`DATA_WIDTH-1:0] prdata;
  //error in transfer
  bit pslverr;
  
  //delay between transactions in clock cycles
  int delay;
  
  //register in factory; for uvm built in methods 
  `uvm_object_utils_begin(sequence_item_apb)
    `uvm_field_int(pwrite, UVM_DEFAULT);
    `uvm_field_int(paddr, UVM_DEFAULT);
    `uvm_field_int(pwdata, UVM_DEFAULT);
    `uvm_field_int(prdata, UVM_DEFAULT);
    `uvm_field_int(pslverr, UVM_DEFAULT);
    `uvm_field_int(delay, UVM_DEFAULT);
  `uvm_object_utils_end
  
  
  function new(string name = "sequence_item_apb");
    super.new(name);
    delay = $urandom_range(0,5);
  endfunction
 
  virtual function string conv2str();
    return $sformatf("ADDR = %0h, pwrite = %0b, pwdata = %0h, prdata = %0h, pslverr = %0b, delay = %0h", paddr, pwrite, pwdata, prdata, pslverr, delay);
  endfunction
  //add constraint
 // only for counters
 constraint addr_range { paddr inside {[0:6]}; }  
endclass
