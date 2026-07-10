class base_seq extends uvm_sequence;

    //factory register
    `uvm_object_utils(base_seq)

    function new(string name="base_seq");
        super.new(name);
    endfunction
    rand int num_of_transactions;

    constraint num_of_trs { soft num_of_transactions inside {[50:200]}; }
    typedef enum bit [1:0] {
                            FREE_RUNNING_MODE,
                            SINGLE_WRAP_POINT_MODE,
                            DOUBLE_WRAP_POINT_MODE,
                            SPECIAL_SINGLE_WRAP_POINT_MODE
                        } mode_e;

    typedef enum bit {
                        DOWN, 
                        UP
                    } direction_e;


    //task to disable the counter
    virtual task disable_counter();
        sequence_item_apb item;
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with { pwrite == 1;
                                paddr == 0;
                                pwdata == 0;
                            };
        `uvm_info("SEQ", $sformatf("Disable Counter Transaction"), UVM_LOW)
        finish_item(item);
    endtask

    //task to set number of cycles
    virtual task load_number_of_cycles(input n = 1);
        sequence_item_apb item;
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with { pwrite == 1;
                                paddr == 'h03;
                                pwdata == n;
                            };
        `uvm_info("SEQ", $sformatf("Transaction to set number of cycles to %0d", n), UVM_HIGH)
        finish_item(item);
    endtask

    //task to progeam the counter mode
    virtual task program_counter(input mode_e mode = FREE_RUNNING_MODE, direction_e direction = UP);
    // 1 count up, 0 count down
    // mode = 0 : Free running, 
    // mode = 1 : signl point wrap
    // mode = 2 : double point wrap
    // mode = 3 : special point wrap
        sequence_item_apb item;
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with { pwrite == 1;
                                paddr == 'h04;
                                pwdata == {direction, mode};
                            };
        `uvm_info("SEQ", $sformatf("Program Counter to %s w/ %s direction", mode.name(), direction.name()), UVM_HIGH)
        finish_item(item);
    endtask
   
    virtual task load_main_value (input  bit [7:0] main_value = 128);
        sequence_item_apb item;
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with { pwrite == 1;
                                paddr == 'h01;
                                pwdata == main_value;
                            };
        `uvm_info("SEQ", $sformatf("Transaction that set main_load_value to %0d", main_value), UVM_HIGH)
        finish_item(item);
    endtask


    virtual task load_second_value (input bit [7:0] second_value = 32);
        sequence_item_apb item;
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with { pwrite == 1;
                                paddr == 'h02;
                                pwdata == second_value;
                            };
        `uvm_info("SEQ", $sformatf("Transaction that set secondery_load_value to %0d", second_value), UVM_HIGH)
        finish_item(item);
    endtask

    
    //task to enable the counter
    virtual task enable_counter();
        sequence_item_apb item;
        item = sequence_item_apb::type_id::create("item");
        start_item(item);
        item.randomize() with { pwrite == 1;
                                paddr == 0;
                                pwdata == 1;
                            };
        `uvm_info("SEQ", $sformatf("Disable Counter Transaction"), UVM_HIGH)
        finish_item(item);
    endtask

    //config the counter
    virtual task config_counter(input int num_of_cycles = 1, mode_e run_mode = FREE_RUNNING_MODE,
                                direction_e run_direction = UP, int main_value = 128, second_value = 32);      
       //configure the counter
       //disable it
       disable_counter();
       load_number_of_cycles(num_of_cycles);
       program_counter(.mode(run_mode), .direction(run_direction));
       load_main_value(main_value);
       load_second_value(second_value);
       enable_counter();
   endtask

    //override this in the derived classes
    virtual task body();
        //configure the counter
        config_counter();

        for(int i = 0; i < num_of_transactions; i++) begin
            sequence_item_apb item = sequence_item_apb::type_id::create("item");
      
            //can use uvm_do macro instead 
            start_item(item);
            item.randomize();
            `uvm_info("SEQ", $sformatf("Generate new item"), UVM_LOW)
            `uvm_info("SEQ", $sformatf("Seq send PKT to Driver: %s", item.conv2str), UVM_LOW)
            finish_item(item);
        end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num_of_transactions), UVM_LOW)
    endtask

endclass
