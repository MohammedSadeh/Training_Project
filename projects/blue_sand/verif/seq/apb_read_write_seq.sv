class apb_read_write_seq extends uvm_sequence;
  
  //factory register
  `uvm_object_utils(apb_read_write_seq)
  
  function new(string name="apb_read_write_seq");
    super.new(name);
  endfunction
  
  //number of transactions in this sequene
  rand int number_of_transactions;
  
  constraint num_of_trs { number_of_transactions inside {[200:300]}; }
  
  //randomize and send the transactions to the driver via associated seqencer  
  virtual task body();
    for(int i = 0; i < number_of_transactions; i++) begin
      sequence_item_apb item = sequence_item_apb::type_id::create("item");
      
      //can use uvm_do macro instead 
      start_item(item);
      item.randomize();
      `uvm_info("SEQ", $sformatf("Generate new item"), UVM_LOW)
      `uvm_info("SEQ", $sformatf("Seq send PKT to Driver: %s", item.conv2str), UVM_LOW)
      finish_item(item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", number_of_transactions), UVM_LOW)

  endtask
  
endclass
