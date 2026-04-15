module Parity_Check # ( parameter DATA_WIDTH = 8 )
  (
  input         wire                          PAR_TYP,        //0: even parity, 1: odd parity
  input         wire     [DATA_WIDTH-1:0]     P_DATA,         //frame data byte
  input         wire                          CLK,            //UART RX clock signal
  input         wire                          RST,            //asynchronous active-low reset
  input         wire                          sampled_bit,    //correct sampled parity bit
  input         wire                          par_chk_en,     //parity bit check enable signal
  output        reg                           par_err         //frame parity error
  ) ;
  
  wire  parity_bit ;  //calculated parity bit
  
always @(posedge CLK or negedge RST)    
  begin
    if (!RST)
      par_err <= 1'b0 ;
    else if (par_chk_en && sampled_bit == parity_bit) 
      par_err <= 1'b0 ;
    else if (par_chk_en && sampled_bit != parity_bit)
      par_err <= 1'b1 ;
  end
      
assign parity_bit = (PAR_TYP) ? ~^P_DATA : ^P_DATA ; 

endmodule