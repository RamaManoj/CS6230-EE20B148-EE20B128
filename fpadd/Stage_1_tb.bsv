package Stage_1_tb;
import Stage_1::*;
import Type_defs :: *;
module mkTest_Stage_1(Empty);
   Stage_1_Ifc dut<-mkStage_1;
   Reg#(Int#(32)) i<-mkReg(0);
   rule r1_stage_1_test(i<=5);
       dut.feed(unpack(64'b1100000001001001000000000000000000000000000000000000000000000000),unpack(64'b1100000001001001000000000000000000000000000000000000000000000000),True);
       i<=i+1;
   endrule
endmodule
endpackage : Stage_1_tb