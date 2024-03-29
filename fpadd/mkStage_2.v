//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Thu Dec 14 00:57:55 IST 2023
//
//
// Ports:
// Name                         I/O  size props
// RDY_feed                       O     1
// read_output_2                  O   128
// RDY_read_output_2              O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// feed_output_stage_1            I   151 reg
// EN_feed                        I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkStage_2(CLK,
		 RST_N,

		 feed_output_stage_1,
		 EN_feed,
		 RDY_feed,

		 read_output_2,
		 RDY_read_output_2);
  input  CLK;
  input  RST_N;

  // action method feed
  input  [150 : 0] feed_output_stage_1;
  input  EN_feed;
  output RDY_feed;

  // value method read_output_2
  output [127 : 0] read_output_2;
  output RDY_read_output_2;

  // signals for module outputs
  wire [127 : 0] read_output_2;
  wire RDY_feed, RDY_read_output_2;

  // ports of submodule input_fifo
  wire [150 : 0] input_fifo$D_IN, input_fifo$D_OUT;
  wire input_fifo$CLR,
       input_fifo$DEQ,
       input_fifo$EMPTY_N,
       input_fifo$ENQ,
       input_fifo$FULL_N;

  // remaining internal signals
  wire [54 : 0] get_stage_2_mantissa_input_1__h209,
		get_stage_2_mantissa_input_2__h210;
  wire [10 : 0] get_stage_2_exponent__h208;

  // action method feed
  assign RDY_feed = input_fifo$FULL_N ;

  // value method read_output_2
  assign read_output_2 =
	     { input_fifo$D_OUT[150:149],
	       get_stage_2_exponent__h208,
	       get_stage_2_mantissa_input_1__h209,
	       get_stage_2_mantissa_input_2__h210,
	       input_fifo$D_OUT[4:0] } ;
  assign RDY_read_output_2 = input_fifo$EMPTY_N ;

  // submodule input_fifo
  FIFOL1 #( /*width*/ 32'd151) input_fifo(.RST(RST_N),
					  .CLK(CLK),
					  .D_IN(input_fifo$D_IN),
					  .ENQ(input_fifo$ENQ),
					  .DEQ(input_fifo$DEQ),
					  .CLR(input_fifo$CLR),
					  .D_OUT(input_fifo$D_OUT),
					  .FULL_N(input_fifo$FULL_N),
					  .EMPTY_N(input_fifo$EMPTY_N));

  // submodule input_fifo
  assign input_fifo$D_IN = feed_output_stage_1 ;
  assign input_fifo$ENQ = EN_feed ;
  assign input_fifo$DEQ = input_fifo$EMPTY_N ;
  assign input_fifo$CLR = 1'b0 ;

  // remaining internal signals
  assign get_stage_2_exponent__h208 =
	     input_fifo$D_OUT[115] ?
	       input_fifo$D_OUT[148:138] :
	       input_fifo$D_OUT[137:127] ;
  assign get_stage_2_mantissa_input_1__h209 =
	     input_fifo$D_OUT[115] ?
	       input_fifo$D_OUT[114:60] :
	       input_fifo$D_OUT[114:60] >> input_fifo$D_OUT[126:116] ;
  assign get_stage_2_mantissa_input_2__h210 =
	     input_fifo$D_OUT[115] ?
	       input_fifo$D_OUT[59:5] >> input_fifo$D_OUT[126:116] :
	       input_fifo$D_OUT[59:5] ;

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (input_fifo$EMPTY_N)
	$display("\n**Stage_2_Output**\nsign_input_1:%0b\nsign_input_2:%0b\nexponent:%0b\nmant_input_1:%0b\nmant_input_2:%0b\n",
		 input_fifo$D_OUT[150],
		 input_fifo$D_OUT[149],
		 get_stage_2_exponent__h208,
		 get_stage_2_mantissa_input_1__h209,
		 get_stage_2_mantissa_input_2__h210);
  end
  // synopsys translate_on
endmodule  // mkStage_2

