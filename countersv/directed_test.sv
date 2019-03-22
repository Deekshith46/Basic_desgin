
`include "environment.sv"
program test(intf i_intf);

    class my_trans extends transaction;

        bit[1:0] cmt;

        function void pre_randomize();
        mod.rand_mode(0);
        mod = 1;
        endfunction
        endclass

        environment env;
        my_trans my_tr;

            initial begin
            env = new(i_intf);
            my_tr = new();
            env.gen.repeat_count = 10;
            env.gen.trans = my_tr;
            env.run();
            end
            endprogram
