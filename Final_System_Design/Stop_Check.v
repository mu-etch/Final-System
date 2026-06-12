module Stop_Check (
  input         wire               CLK,            //UART RX clock signal
  input         wire               RST,            //asynchronous active-low reset
  input         wire               sampled_bit,    //correct sampled stop bit
  input         wire               stop_chk_en,    //stop bit check enable signal
  output        reg                stop_err        //frame stop error, high when stop bit equals 0
  ) ;
  
always @(posedge CLK or negedge RST)    
  begin
    if (!RST)
      stop_err <= 1'b0 ;
    else if (stop_chk_en && sampled_bit == 1'b1)
      stop_err <= 1'b0 ;
    else if (stop_chk_en && sampled_bit == 1'b0)
      stop_err <= 1'b1 ;
  end

endmodule



