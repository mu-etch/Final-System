module TX_MUX (
  input      wire    [1:0]  mux_sel,      //to choose the transmitted bit
  input      wire           start_bit,    //the beginning the data frame ( = 0 )
  input      wire           stop_bit,     //the end of the data frame ( = 1 )
  input      wire           ser_data,     //serialized data input bit
  input      wire           par_bit,      //parity calculation output
  input      wire           CLK,          //UART TX clock signal
  input      wire           RST,          //asynchronous active-low reset
  output     reg            TX_OUT        //serial data output
  ) ;
  
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        TX_OUT <= 1'b1 ;
      end
    else
      begin
        case (mux_sel)
          2'b00 : TX_OUT <= start_bit ;
          2'b01 : TX_OUT <= ser_data ;
          2'b11 : TX_OUT <= par_bit ;
          2'b10 : TX_OUT <= stop_bit ;
        endcase
      end       
  end
  
endmodule
