//Date:25-11-2023
//Author:V.V.S.Rama Manoj
/*Goals of the following stage:
1. This stage will shift the mantissa of the number with the smaller exponent to the right
2. It will return sign bits, exponent, mantissae and flags corresponding to both inputs
-----------------------------------------------------------------------------
Notes:
1. Input will be of same type as output of stage_1.
2. All required flags and the valid bit will be continued to be carried.
*/
package Stage_2;
import  FIFO :: *;
import Type_defs :: *;
import Stage_3::*;

//Interface for stage_2
//method to interface with Stage_1
interface Stage_2_Ifc;
    method Action feed(Output_stage_1 output_stage_1);//enq pipeline FIFO of Stage_2 
endinterface :Stage_2_Ifc

//module declaration
(*synthesize*)
module mkStage_2(Stage_2_Ifc);
    FIFO#(Output_stage_1) input_fifo<-mkLFIFO;
    Stage_3_Ifc stage_3<-mkStage_3;//Interface with Stage_3
    //The following function will update the output
    function Output_stage_2 get_stage_2();//allows stage_2 to get stage_1 results
        Output_stage_2 output_stage_2;
        //passing sign bits and flag bits
        output_stage_2.sign_input_1=input_fifo.first.sign_input_1;
        output_stage_2.sign_input_2=input_fifo.first.sign_input_2;
        output_stage_2.is_NaN_1=input_fifo.first.is_NaN_1;
        output_stage_2.is_NaN_2=input_fifo.first.is_NaN_2;
        output_stage_2.is_infi_1=input_fifo.first.is_infi_1;
        output_stage_2.is_infi_2=input_fifo.first.is_infi_2;
        output_stage_2.is_valid=input_fifo.first.is_valid;
        //passing larger exponent
        if(input_fifo.first.is_1_greater_than_2) begin
            output_stage_2.exponent=input_fifo.first.exponent_input_1;
            output_stage_2.mantissa_input_1=input_fifo.first.mantissa_input_1;
            output_stage_2.mantissa_input_2=(input_fifo.first.mantissa_input_2)>>input_fifo.first.exponent_diff;
            //rightshift the mantissa with smaller exponent
        end
        else begin
            output_stage_2.exponent=input_fifo.first.exponent_input_2;
            output_stage_2.mantissa_input_2=input_fifo.first.mantissa_input_2;
            output_stage_2.mantissa_input_1=(input_fifo.first.mantissa_input_1)>>input_fifo.first.exponent_diff;
        end
        return output_stage_2;
    endfunction:get_stage_2
    rule rl_feed_stage_3;
        $display("\n**Stage_2_Output**\nsign_input_1:%0b\nsign_input_2:%0b\nexponent:%0b\nmant_input_1:%0b\nmant_input_2:%0b\n",
        get_stage_2().sign_input_1,get_stage_2().sign_input_2,
        get_stage_2().exponent,get_stage_2().mantissa_input_1,
        get_stage_2().mantissa_input_2);
        stage_3.feed(get_stage_2());
        input_fifo.deq;
    endrule : rl_feed_stage_3
    method Action feed(Output_stage_1 output_stage_1);
        input_fifo.enq(output_stage_1);
    endmethod: feed
endmodule
endpackage : Stage_2