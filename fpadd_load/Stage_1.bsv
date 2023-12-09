//Date:25-11-2023
//Author:V.V.S.Rama Manoj
/*Goals of the following stage:
1. Extract exponent, Mantissa, Sign bit from given inputs
2. Append 1 and zero extend mantissas
3. find difference of exponents
4. Set all necessary special case flags: isNaN,isSubNorm,isZero,isInfi
-----------------------------------------------------------------------------
Notes:
1. Input include two Double Precision floating point numbers from testbench.
2. Testbench sets an isvalid flag register, which is carried over across all stages
   to indicate that the output recieved is aquired from operating on valid operands.
*/
package Stage_1;
import  FIFO :: *;
typedef struct {Bit#(1) sign;Bit#(11) exponent;Bit#(52) mantissa;} Double deriving(Bits);
//2 variables of double data type are taken as input

typedef struct
{
    Bit#(1) sign_input_1; 
    Bit#(1) sign_input_2;
    Bit#(11) exponent_input_1;
    Bit#(11) exponent_input_2;
    Bit#(11) exponent_diff;
    Bool is_1_greater_than_2;
    Bit#(55) mantissa_input_1;
    Bit#(55) mantissa_input_2;
    Bool is_zero_1;Bool is_zero_2;Bool is_NaN_1;Bool is_NaN_2;         //Account for invalid and zero numbers
    Bool is_infi_1;Bool is_infi_2;Bool is_subnorm_1;Bool is_subnorm_2; //Account for infinite and subnormal numbers
    Bool is_valid;                                        //function select/validity bit
} Output_stage_1 deriving(Bits);
//stage returns output of this type

//Interface for stage_1
//contains 2 methods
//one to interface with stage_2 and one to interface with testbench
interface Stage_1_Ifc;
    method Action feed(Double input_1,Double input_2, Bool is_valid);//allows tb to give input
    method Output_stage_1 get_output();//temporary          
endinterface :Stage_1_Ifc

//module declaration
(*synthesize*)
module mkStage_1(Stage_1_Ifc);
    FIFO#(Double) input_1<-mkLFIFO;
    FIFO#(Double) input_2<-mkLFIFO;
    FIFO#(Bool) is_valid<-mkLFIFO;//input registers, will store value from Tb
    //The following function will update the output
    function Output_stage_1 get_stage_1();//allows stage_2 to get stage_1 results
        //Dequeing after calculation, a rule will enq the return value to next stage of interface type FIFO#(Output_stage_1)
        Double first_input_1=input_1.first;
        Double first_input_2=input_2.first;
        Bool first_is_valid=is_valid.first;
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
               output_stage_1.is_zero_1=True;
               output_stage_1.is_NaN_1=False;
               output_stage_1.is_infi_1=False;
               output_stage_1.is_subnorm_1=False;
            end   
            else begin
               output_stage_1.is_zero_1=False;
               output_stage_1.is_NaN_1=False;
               output_stage_1.is_infi_1=False;
               output_stage_1.is_subnorm_1=True;
               output_stage_1.exponent_input_1=11'b00000000001;
               //actual exponent of a subnormal number-for ease of math later

            end   
        end 
        else if(first_input_1.exponent==11'b11111111111) begin
            if(first_input_1.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_zero_1=False;
               output_stage_1.is_NaN_1=False;
               output_stage_1.is_infi_1=True;
               output_stage_1.is_subnorm_1=False;
            end   
            else begin
               output_stage_1.is_zero_1=False;
               output_stage_1.is_NaN_1=True;
               output_stage_1.is_infi_1=False;
               output_stage_1.is_subnorm_1=False;
            end
        end
        else begin
            output_stage_1.is_zero_1=False;
            output_stage_1.is_NaN_1=False;
            output_stage_1.is_infi_1=False;
            output_stage_1.is_subnorm_1=False;
        end
        //setting flags for input 2
        if(first_input_2.exponent==11'b00000000000) begin
            if(first_input_2.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_zero_2=True;
               output_stage_1.is_NaN_2=False;
               output_stage_1.is_infi_2=False;
               output_stage_1.is_subnorm_2=False;
            end   
            else begin
               output_stage_1.is_zero_2=False;
               output_stage_1.is_NaN_2=False;
               output_stage_1.is_infi_2=False;
               output_stage_1.is_subnorm_2=True;
               output_stage_1.exponent_input_2=11'b00000000001;
            end   
        end 
        else if(first_input_2.exponent==11'b11111111111) begin
            if(first_input_2.mantissa==52'b0000000000000000000000000000000000000000000000000000) begin
               output_stage_1.is_zero_2=False;
               output_stage_1.is_NaN_2=False;
               output_stage_1.is_infi_2=True;
               output_stage_1.is_subnorm_2=False;
            end   
            else begin
               output_stage_1.is_zero_2=False;
               output_stage_1.is_NaN_2=True;
               output_stage_1.is_infi_2=False;
               output_stage_1.is_subnorm_2=False;
            end
        end
        else begin
            output_stage_1.is_zero_2=False;
            output_stage_1.is_NaN_2=False;
            output_stage_1.is_infi_2=False;
            output_stage_1.is_subnorm_2=False;
        end
        //generating mantissa for input_1, note that when the number is zero or subnornal, the implicit "1" is not considered
        if(output_stage_1.is_zero_1||output_stage_1.is_subnorm_1) begin
            output_stage_1.mantissa_input_1={3'b000,first_input_1.mantissa};
        end 
        else begin
            output_stage_1.mantissa_input_1={3'b001,first_input_1.mantissa}; 
        end 
        //generating mantissa for first_input_2
        if(output_stage_1.is_zero_2||output_stage_1.is_subnorm_2) begin
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
    method Action feed(Double input_1_tb,Double input_2_tb, Bool is_valid_tb);
        input_1.enq(input_1_tb);
        input_2.enq(input_2_tb);
        is_valid.enq(is_valid_tb);
    endmethod: feed
    method Output_stage_1 get_output();//temp
        return get_stage_1();
    endmethod: get_output
endmodule
endpackage : Stage_1