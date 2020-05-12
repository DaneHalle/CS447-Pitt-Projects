Dane Halle
dmh148
dmh148@pitt.edu
Things that work:
- add
- sub
- and
- nor
- addui
- addi
- div
- mul
- srlv
- sllv
- lw
- sw
- li
- bp
- bn
- bx
- bz
- jr
- jal
- j
- halt
- put

Bug Report:
	None to my knowledge. 

Purposes:
	Going to start at the ROM module for reasons. From the ROM we have an instruction taken and put into the control sub-circuit. From that, all sorts of things are parsed out. Included is the immediate, PC OpCode, ALU OpCode, WriteOpCode, DoMem switch, I-type switch, WriteEnable switch, halt instruction, put instruction, RS getter, and RT getter. Using the RS getter, it gets RS from the register file and has that go back into control to check for branches. Next we go to the ALU. Inputs is RS, a mux with either RT or Immediate which is toggled by I-type, and the OpCode. Outputs are the standard output, Remainder/Hi (div/mul), and WriteEnable switch for if div/mul were used. The register file has RS and RT getters reading and RS getter to the Write port 1. The write data for 1 is a mix with ALUout, Immediate, PC+1, and Data which is determined from the control sub-circuit. There is also another write data input which takes the remainder and if that WriteEnable switch is on, it writes. The RAM module takes in the first 8 bits of RT for address and RS for data. Select is controlled by DoMem switch from Control. Output data goes to Register File. The PC has a standard adder that changes if a branch or jump is called which is controlled by the PC OpCode from Control. The HEX display LED takes RS and the put instruction. The LED panel prints my name until the "halt" instruction is called from the ROM module and then it prints HALT. The clock tunnel connects to all circuits that need it and is controlled by the halt instruction. If halt is called, the data will no longer be transferred through the clock line, the PC register, and the PC line into the ROM module. It also controls an LED. Note that the reason my Register File is all color coded and nothing else really is is because I did that for the lab and I still had hope of being nice an organized throughout this project. 