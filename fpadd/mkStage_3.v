//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Mon Dec 11 00:45:24 IST 2023
//
//
// Ports:
// Name                         I/O  size props
// RDY_feed                       O     1
// CLK                            I     1 clock
// RST_N                          I     1 reset
// feed_output_stage_2            I   128 reg
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

module mkStage_3(CLK,
		 RST_N,

		 feed_output_stage_2,
		 EN_feed,
		 RDY_feed);
  input  CLK;
  input  RST_N;

  // action method feed
  input  [127 : 0] feed_output_stage_2;
  input  EN_feed;
  output RDY_feed;

  // signals for module outputs
  wire RDY_feed;

  // ports of submodule input_fifo
  wire [127 : 0] input_fifo$D_IN, input_fifo$D_OUT;
  wire input_fifo$CLR,
       input_fifo$DEQ,
       input_fifo$EMPTY_N,
       input_fifo$ENQ,
       input_fifo$FULL_N;

  // ports of submodule stage_4
  wire [68 : 0] stage_4$feed_output_stage_3;
  wire stage_4$EN_feed, stage_4$RDY_feed;

  // remaining internal signals
  wire [54 : 0] NEG_sum_temp50__q1,
		signed_mantissa_1___1__h287,
		signed_mantissa_2___1__h292,
		sum_temp__h250;
  wire [53 : 0] get_stage_3_mantissa_sum__h306;
  wire [10 : 0] get_stage_3_exponent_sum__h305;
  wire get_stage_3_sign_sum__h304;

  // action method feed
  assign RDY_feed = input_fifo$FULL_N ;

  // submodule input_fifo
  FIFOL1 #( /*width*/ 32'd128) input_fifo(.RST(RST_N),
					  .CLK(CLK),
					  .D_IN(input_fifo$D_IN),
					  .ENQ(input_fifo$ENQ),
					  .DEQ(input_fifo$DEQ),
					  .CLR(input_fifo$CLR),
					  .D_OUT(input_fifo$D_OUT),
					  .FULL_N(input_fifo$FULL_N),
					  .EMPTY_N(input_fifo$EMPTY_N));

  // submodule stage_4
  mkStage_4 stage_4(.CLK(CLK),
		    .RST_N(RST_N),
		    .feed_output_stage_3(stage_4$feed_output_stage_3),
		    .EN_feed(stage_4$EN_feed),
		    .RDY_feed(stage_4$RDY_feed));

  // submodule input_fifo
  assign input_fifo$D_IN = feed_output_stage_2 ;
  assign input_fifo$ENQ = EN_feed ;
  assign input_fifo$DEQ = stage_4$RDY_feed && input_fifo$EMPTY_N ;
  assign input_fifo$CLR = 1'b0 ;

  // submodule stage_4
  assign stage_4$feed_output_stage_3 =
	     { get_stage_3_sign_sum__h304,
	       get_stage_3_exponent_sum__h305,
	       get_stage_3_mantissa_sum__h306,
	       input_fifo$D_OUT[4] || input_fifo$D_OUT[3],
	       !input_fifo$D_OUT[4] && !input_fifo$D_OUT[3] &&
	       (input_fifo$D_OUT[2] || input_fifo$D_OUT[1]),
	       input_fifo$D_OUT[0] } ;
  assign stage_4$EN_feed = stage_4$RDY_feed && input_fifo$EMPTY_N ;

  // remaining internal signals
  assign NEG_sum_temp50__q1 = -sum_temp__h250 ;
  assign get_stage_3_exponent_sum__h305 =
	     (input_fifo$D_OUT[4] || input_fifo$D_OUT[3] ||
	      input_fifo$D_OUT[2] ||
	      input_fifo$D_OUT[1]) ?
	       11'b11111111111 :
	       input_fifo$D_OUT[125:115] ;
  assign get_stage_3_mantissa_sum__h306 =
	     (input_fifo$D_OUT[4] || input_fifo$D_OUT[3]) ?
	       54'h3FFFFFFFFFFFFF :
	       ((input_fifo$D_OUT[2] || input_fifo$D_OUT[1]) ?
		  54'b0 :
		  (sum_temp__h250[54] ?
		     NEG_sum_temp50__q1[53:0] :
		     sum_temp__h250[53:0])) ;
  assign get_stage_3_sign_sum__h304 =
	     !input_fifo$D_OUT[4] && !input_fifo$D_OUT[3] &&
	     (input_fifo$D_OUT[2] ?
		input_fifo$D_OUT[127] :
		(input_fifo$D_OUT[1] ?
		   input_fifo$D_OUT[126] :
		   sum_temp__h250[54])) ;
  assign signed_mantissa_1___1__h287 = -input_fifo$D_OUT[114:60] ;
  assign signed_mantissa_2___1__h292 = -input_fifo$D_OUT[59:5] ;
  assign sum_temp__h250 =
	     (input_fifo$D_OUT[127] ?
		signed_mantissa_1___1__h287 :
		input_fifo$D_OUT[114:60]) +
	     (input_fifo$D_OUT[126] ?
		signed_mantissa_2___1__h292 :
		input_fifo$D_OUT[59:5]) ;

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (stage_4$RDY_feed && input_fifo$EMPTY_N)
	$display("\n**Stage_3_Output**\nsign_sum:%0b\nexponent_sum:%0b\nmantissa_sum:%0b\n",
		 get_stage_3_sign_sum__h304,
		 get_stage_3_exponent_sum__h305,
		 get_stage_3_mantissa_sum__h306);
  end
  // synopsys translate_on
endmodule  // mkStage_3
