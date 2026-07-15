class sequence_item_counter extends uvm_sequence_item;
    
  //inputs for the apb
  bit [`COUNT_WIDTH-1:0] count;
  //add the input for the counter
  
  `uvm_object_utils_begin(sequence_item_counter)
  `uvm_field_int(count, UVM_DEFAULT);
  `uvm_object_utils_end
  
  
  function new(string name = "sequence_item_counter");
    super.new(name);
  endfunction
    
  function string conv2str();
    return $sformatf("[Count Trans]: @%0t => count = %0d", $time, this.count);
  endfunction
endclass
