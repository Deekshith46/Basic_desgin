
base_command =(
        "irun -access +rwc counter.v tes3.sv -coverage all -covdut counter"
        "-covworkdir /co_work - covoverwrite -covfile ./cov_files/cov_cmd.cf"
        )

scenario = {
        1: range(1,9),
        2: range(9,17),
        3: range(17.25)
        }
with open('cmd1' ,'w') as file:
    for scenario ,seeds in scenarios.items():
        for seed in seeds:
           
            ##command = f"{base_command} -seed{seed} +scenario={scenario}\n"
command = "{} -seed {} +scenario={}\n".format(base_command,seed,scenario)           
file.write(command)
            print("File 'cmd' created successfully with all commands.")
