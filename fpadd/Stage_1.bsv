//Date:25-11-2023
//Author:V.V.S.Rama Manoj
/*Goals of the following stage:
1. Extract exponent, Mantissa, Sign bit from given inputs
2. Append 1 and zero extend mantissas
3. find difference of exponents
4. Set all necessary special case flags: isNaN,isInfi
-----------------------------------------------------------------------------
Notes:
1. Input include two Double Precision floating point numbers from testbench.
2. Testbench sets an isvalid flag register, which is carried over across all stages
   to indicate that the output recieved is aquired from operating on valid operands.
*/
package Stage_1;
import  FIFO :: *;
import Type_defs :: *;
import Stage_2 :: *;
import Stage_3 :: *;
import Stage_4 :: *;

//Interface for stage_1
//one method to interface with testbench

interface Stage_1_Ifc;
    method Action feed(Double input_1,Double input_2, Bool is_valid);//allows tb to give input       
    method Output_stage_4 read_output();
endinterface :Stage_1_Ifc

//module declaration
(*synthesize*)
module mkStage_1(Stage_1_Ifc);
    FIFO#(Double) input_1<-mkLFIFO;
    FIFO#(Double) input_2<-mkLFIFO;
    FIFO#(Bool) is_valid<-mkLFIFO;//input registers, will store value from Tb
    Stage_2_Ifc stage_2<-mkStage_2;
    Stage_3_Ifc stage_3<-mkStage_3;
    Stage_4_Ifc stage_4<-mkStage_4;
    //The following function will update the output
    function Output_stage_1 get_stage_1();//allows stage_2 to get stage_1 results
        //A rule will enq the return value to next stage of interface type FIFO#(Output_stage_1) and deq this FIFO
        Double first_input_1=input_1.first;
        Double first_input_2=input_2.first;
        Bool first_is_valid=is_valid.first;
        Bool is_subnorm_1;
        Bool is_subnorm_2;//subnormal numbers will be treated differently for mantissa and exponent
        Output_stage_1 output_stage_1;
        //extracting sign bits and exponents of inputs
        output_stage_1.is_valid=first_is_valid;
        output_stage_1.sign_input_1=first_input_1.sign;
        output_stage_1.sign_input_2=first_input_2.sign;
        output_stage_1.exponent_input_1=first_input_1.exponent;
        output_stage_1.exponent_input_2=first_input_2.exponent;
        //setting flags for all special cases for input 1
        if(first_input_1.exponent==11'b00000000000) begin
            if(first_input_1.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_NaN_1=False;
               output_stage_1.is_infi_1=False;
               is_subnorm_1=False;
            end   
            else begin
               output_stage_1.is_NaN_1=False;
               output_stage_1.is_infi_1=False;
               is_subnorm_1=True;
               output_stage_1.exponent_input_1=11'b00000000001;
               //actual exponent of a subnormal number-for ease of math later

            end   
        end 
        else if(first_input_1.exponent==11'b11111111111) begin
            if(first_input_1.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_NaN_1=False;
               output_stage_1.is_infi_1=True;
               is_subnorm_1=False;
            end   
            else begin
               output_stage_1.is_NaN_1=True;
               output_stage_1.is_infi_1=False;
               is_subnorm_1=False;
            end
        end
        else begin
            output_stage_1.is_NaN_1=False;
            output_stage_1.is_infi_1=False;
            is_subnorm_1=False;
        end
        //setting flags for input 2
        if(first_input_2.exponent==11'b00000000000) begin
            if(first_input_2.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_NaN_2=False;
               output_stage_1.is_infi_2=False;
               is_subnorm_2=False;
            end   
            else begin
               output_stage_1.is_NaN_2=False;
               output_stage_1.is_infi_2=False;
               is_subnorm_2=True;
               output_stage_1.exponent_input_2=11'b00000000001;
            end   
        end 
        else if(first_input_2.exponent==11'b11111111111) begin
            if(first_input_2.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_NaN_2=False;
               output_stage_1.is_infi_2=True;
               is_subnorm_2=False;
            end   
            else begin
               output_stage_1.is_NaN_2=True;
               output_stage_1.is_infi_2=False;
               is_subnorm_2=False;
            end
        end
        else begin
            output_stage_1.is_NaN_2=False;
            output_stage_1.is_infi_2=False;
            is_subnorm_2=False;
        end
        //generating mantissa for input_1, note that when the number is zero or subnornal, the implicit "1" is not considered
        //55th bit is sign,54th is to accomadate last carry while adding,53th is the implicit 1/0
        if(first_input_1.exponent==11'b00000000000) begin
            output_stage_1.mantissa_input_1={3'b000,first_input_1.mantissa};
        end 
        else begin
            output_stage_1.mantissa_input_1={3'b001,first_input_1.mantissa}; 
        end 
        //generating mantissa for first_input_2
        if(first_input_2.exponent==11'b00000000000) begin
            output_stage_1.mantissa_input_2={3'b000,first_input_2.mantissa};
        end 
        else begin
            output_stage_1.mantissa_input_2={3'b001,first_input_2.mantissa}; 
        end
        //identifying smaller exponent and finding difference in exponent
        if(output_stage_1.exponent_input_1>=output_stage_1.exponent_input_2) begin
            output_stage_1.is_1_greater_than_2=True;
            output_stage_1.exponent_diff=output_stage_1.exponent_input_1-output_stage_1.exponent_input_2;
        end 
        else begin
            output_stage_1.is_1_greater_than_2=False;
            output_stage_1.exponent_diff=output_stage_1.exponent_input_2-output_stage_1.exponent_input_1;
        end 
        //calculating exponent diff at end without using primary inputs allows to account for actual exponent in subnormal numbers
        return output_stage_1;
    endfunction:get_stage_1
    rule rl_deq_stage_1;
        input_1.deq;
        input_2.deq;
        is_valid.deq;
    endrule : rl_deq_stage_1
    rule  rl_stage_2;
        stage_2.feed(get_stage_1());
    endrule : rl_stage_2
    rule  rl_stage_3;
        stage_3.feed(stage_2.read_output_2());
    endrule : rl_stage_3
    rule  rl_stage_4;
        stage_4.feed(stage_3.read_output_3());
    endrule : rl_stage_4
    method Output_stage_4 read_output();
        return stage_4.read_output_4();
    endmethod
    method Action feed(Double input_1_tb,Double input_2_tb, Bool is_valid_tb);
        input_1.enq(input_1_tb);
        input_2.enq(input_2_tb);
        is_valid.enq(is_valid_tb);
    endmethod: feed
endmodule
endpackage : Stage_1