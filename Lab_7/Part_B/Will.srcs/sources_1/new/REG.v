module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, R1Val, R2Val, R1);
  input CLK;
  input RegW;
  input [4:0] DR;
  input [4:0] SR1;
  input [4:0] SR2;
  input [2:0] R1;
  input [31:0] Reg_In;
  output reg [31:0] ReadReg1;
  output reg [31:0] ReadReg2;
  output reg [31:0] R1Val, R2Val;

  reg [31:0] REG [0:31];
  integer i;

  initial begin
    $readmemh("REG_INIT.mem",REG, 0, 31);
    ReadReg1 = 0;
    ReadReg2 = 0;
  end

  always @(posedge CLK)
  begin

    if(RegW == 1'b1)
      REG[DR] <= Reg_In[31:0];

    ReadReg1 <= REG[SR1];
    ReadReg2 <= REG[SR2];
    REG[1] <= {29'd0, R1};
    R2Val <= REG[2];
    R1Val <= R1;
  end
endmodule