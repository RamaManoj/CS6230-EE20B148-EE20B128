package Stage_1_tb;
import Stage_1::*;
import Type_defs :: *;
module mkTest_Stage_1(Empty);
   Stage_1_Ifc dut<-mkStage_1;
   Reg#(int) i <- mkReg(0); // iterator to run all testcases
   Bit#(64) test_cases[14][3] = {   {'h405EC00000000000, 'h405EC00000000000, 'h406EC00000000000}, // 123 + 123 = 246
                                    {'hC049000000000000, 'hC049000000000000, 'hC059000000000000}, // -50 - 50 = -100
                                    {'hC034000000000000, 'h403E000000000000, 'h4024000000000000}, // 30 - 20 = 10
                                    {'h408F3A7AE147AE14, 'h4038B0A3D70A3D71, 'h408FFFFFFFFFFFFF}, // 999.31 + 24.69 = 1024
                                    {'h7FE0000000000001, 'h7FE0000000000001, 'h7FF0000000000000}, // overflow to infi
                                    {'hFFE0000000000001, 'h8000000000000000, 'hFFE0000000000001}, // addition with -ve 0
                                    {'hFFF9000000000000, 'hD559000000000000, 'h7FFFFFFFFFFFFFFF}, // NaN + const = NaN                                   
                                    {'hFFF0000000000000, 'hD559000000000000, 'hFFF0000000000000}, // -inf + const = -inf                                   
                                    {'h7FE0000000000001, 'h7FE0000000000001, 'h7FF0000000000000}, // overflow to +inf
                                    {'hFFE0000000000001, 'hFFE0000000000001, 'hFFF0000000000000}, // overflow to -inf
                                    {'h4480F0CF064DD592, 'h45208B2A2C280291, 'h45208F665FE99606}, // 1E25 + 1E22
                                    {'h000FFFFFFFFFFFFF, 'h000FFFFFFFFFFFFF, 'h001FFFFFFFFFFFFE}, // addition using largest subnormal number
                                    {'h0000000000000001, 'h0000000000000001, 'h0000000000000002}, // addition using minimum subnormal number
                                    {'h0010000000000001, 'h8010000000000000, 'h0000000000000001}}; // subtraction with subnormal
                                    
   rule test (i<18&&i>=0);
       $display("======================================\nClock Cycle:%d\n",i+1);      
       if(i<14&&i>=0) begin
           dut.feed(unpack(test_cases[i][0]),unpack(test_cases[i][1]),True);
           $display("Feeding inputs %b %b...", test_cases[i][0], test_cases[i][1]);
           $display("Expected final output = %b", test_cases[i][2]);
       end
       i<=i+1;
   endrule

   rule end_test (i>=18);
        $finish (0);
   endrule 

endmodule
endpackage : Stage_1_tb
