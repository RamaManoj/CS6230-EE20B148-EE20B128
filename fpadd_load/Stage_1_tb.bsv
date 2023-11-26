package Stage_1_tb;
import Stage_1::*;
(*synthesize*)
module mkTest_Stage_1(Empty);
   Stage_1_Ifc dut<-mkStage_1;
   rule rl_stage_1_test;
      dut.feed(unpack(64'b1100000001001001000000000000000000000000000000000000000000000000),unpack(64'b1100000001001001000000000000000000000000000000000000000000000000),True);
      if(dut.get_stage_1().is_valid) begin
         $display ("sign:%0b \nmantissa:%0b \nexponent:%0b\nexponent_diff:%0b",dut.get_stage_1().sign_input_1,
         dut.get_stage_1().mantissa_input_1,dut.get_stage_1().exponent_input_1,
         dut.get_stage_1().exponent_diff);
         $finish;
      end
      
   endrule
endmodule
endpackage : Stage_1_tb