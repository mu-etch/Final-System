module Start_Check (
  input         wire               CLK,            //UART RX clock signal
  input         wire               RST,            //asynchronous active-low reset
  input         wire               sampled_bit,    //correct sampled start bit
  input         wire               start_chk_en,   //start bit check enable signal 
  output        reg                start_glitch    //frame start bit glitch, high when start bit equals 1
  ) ;
  
always @(posedge CLK or negedge RST)    
  begin
    if (!RST)
      start_glitch <= 1'b0 ;
    else if (start_chk_en && sampled_bit == 1'b0)
      start_glitch <= 1'b0 ;
     else if (start_chk_en && sampled_bit == 1'b1)
      start_glitch <= 1'b1 ;
  end

endmodule

