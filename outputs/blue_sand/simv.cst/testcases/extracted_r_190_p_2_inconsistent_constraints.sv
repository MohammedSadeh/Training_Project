class c_190_2;
    int val = 208;
    rand bit[0:0] pwrite; // rand_mode = ON 

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (/home/st102/Training/projects/blue_sand/verif/seq/double_wrap_point_mode_seq.sv:48)
    {
       (pwrite == val);
    }
endclass

program p_190_2;
    c_190_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xzzx00z0x011xzzx1z0x11x0xx1x01xxxzzxxzxzxzzxxzzzzzzxzzxxzxzzxzxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
