class double_wrap_point_mode_seq extends base_seq;

    `uvm_object_utils(double_wrap_point_mode_seq)

    function new(string name="double_wrap_point_mode_seq");
    endfunction

    //override this in the derived classes
    virtual task body();
        sequence_item_apb item;
        int val;
        //configure the counter
        config_counter(.run_mode(DOUBLE_WRAP_POINT_MODE));

        for(int i = 0; i < num_of_transactions; i++) begin
            item = sequence_item_apb::type_id::create("item");
      
            //can use uvm_do macro instead 
            start_item(item);
            item.randomize() with { //don't change num_of_cycles while counter is enabled
                                    !(paddr == 'h3 && pwrite == 1);
                                    //don't change the mode
                                    !(paddr == 'h4 && pwrite == 1);
                                };
            `uvm_info("SEQ", $sformatf("Generate new item"), UVM_LOW)
            `uvm_info("SEQ", $sformatf("Seq send PKT to Driver: %s", item.conv2str), UVM_LOW)
            finish_item(item);
        end

        //change the second value when its counting
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with {
                                //change second value
                                paddr == 'h2;
                                pwrite == 1;
                             };
        `uvm_info("CHG_SCD_VALUE", $sformatf("Generate new item, Change the Secondery Value"), UVM_LOW)
        `uvm_info("SEQ", $sformatf("Seq send PKT to Driver: %s", item.conv2str), UVM_LOW)
        finish_item(item);
        

        //change main and second vlaues to be equal:
        val = $urandom_range(1,255);

        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with {
                                //change main value
                                paddr == 'h1;
                                pwrite == 1;
                                pwdata == val;
                             };
        `uvm_info("CHG_MAIN_VALUE", $sformatf("Generate new item, Change the Secondery Value"), UVM_LOW)
        `uvm_info("SEQ", $sformatf("Seq send PKT to Driver: %s", item.conv2str), UVM_LOW)
        finish_item(item);


        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with {
                                //change second value
                                paddr == 'h2;
                                pwrite == 1;
                                pwdata == val;
                             };
        `uvm_info("CHG_SCD_VALUE", $sformatf("Generate new item, Change the Secondery Value"), UVM_LOW)
        `uvm_info("SEQ", $sformatf("Seq send PKT to Driver: %s", item.conv2str), UVM_LOW)
        finish_item(item);

    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num_of_transactions), UVM_LOW)
    endtask

endclass
