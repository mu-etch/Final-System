module edge_bit_counter (
  input       wire    [5:0]     prescale,      //oversampling Prescale
  input       wire              counter_en,    //edge and bit counters enable
  input       wire              CLK,           //UART RX clock signal
  input       wire              RST,           //asynchronous active-low reset
  output      reg     [3:0]     bit_cnt,       //data frame bit counter
  output      reg     [5:0]     edge_cnt       //counts clock cycles within one bit period
  ) ;
  
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        edge_cnt <= 6'd0 ;
        bit_cnt <= 4'd0 ;
      end
    else if (!counter_en)
      begin
        edge_cnt <= 6'd0 ;
        bit_cnt <= 4'd0 ;
      end
    else if (counter_en && edge_cnt != prescale - 1'b1)
      begin
        edge_cnt <= edge_cnt + 1'b1 ;
      end
    else 
      begin
        edge_cnt <= 6'd0 ;
        bit_cnt <= bit_cnt + 1'b1 ;
      end
  end
    
endmodule 