`include "environment.sv"
program test(intf i_intf);

    environment env;

    initial begin

        env = new(i_intf);
        env.gen.repeat_count = 4;
        env.run();
        end
        endprogram
