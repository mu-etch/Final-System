module data_sampling (
  input         wire                 RX_IN,           //serial data input
  input         wire      [5:0]      edge_cnt,        //counts clock cycles within one bit period
  input         wire      [5:0]      prescale,        //oversampling prescale value
  input         wire                 data_samp_en,    //data sampling enable signal
  input         wire                 CLK,             //UART RX clock signal
  input         wire                 RST,             //asynchronous active-low reset
  output        reg                  sampled_bit      //majority-voted sampled bit
  ) ;
  
  reg   [2:0]   data_bits ;   //register to store sampled bits 
  
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        data_bits <= 3'b0 ;
      end
    else if (data_samp_en && edge_cnt == (prescale/2) - 1'b1)
      begin
        data_bits [0] <= RX_IN ;
      end
     else if (data_samp_en && edge_cnt == (prescale/2))
      begin
        data_bits [1] <= RX_IN ;
      end
    else if (data_samp_en && edge_cnt == (prescale/2) + 1'b1)
      begin
        data_bits [2] <= RX_IN ;  
      end
  end
  
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        sampled_bit <= 1'b1 ;
      end
    else if (data_samp_en && edge_cnt == (prescale/2) + 1'b1)
      begin
        case (data_bits) //selects the majority value of the sampled bits as the valid sampled bit
          3'b000 : sampled_bit <= 1'b0 ;
          3'b001 : sampled_bit <= 1'b0 ;
          3'b010 : sampled_bit <= 1'b0 ;
          3'b011 : sampled_bit <= 1'b1 ;
          3'b100 : sampled_bit <= 1'b0 ;
          3'b101 : sampled_bit <= 1'b1 ;
          3'b110 : sampled_bit <= 1'b1 ;
          3'b111 : sampled_bit <= 1'b1 ;
        endcase
      end
  end
  
endmodule