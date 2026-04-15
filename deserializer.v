module deserializer # ( parameter DATA_WIDTH = 8 )
  (
  input         wire     [5:0]                prescale,        //oversampling Prescale
  input         wire     [5:0]                edge_cnt,        //counts clock cycles within one bit period
  input         wire                          CLK,             //UART RX clock signal
  input         wire                          RST,             //asynchronous active-low reset
  input         wire                          sampled_bit,     //correct sampled data bit
  input         wire                          deser_en,        //deserialization enable signal
  output        reg      [DATA_WIDTH-1:0]     P_DATA           //frame data byte
  ) ;
  
  reg   [3:0]   i ;              //counts received serial data bits 
  reg   [DATA_WIDTH-1:0]   parallel_data ;  //register to store received frame data byte
  
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        P_DATA <= 'd0 ;
        parallel_data <= 'd0 ;
        i <= 4'd0 ;
      end
    else if (deser_en && i != 4'd8 && edge_cnt == (prescale/2) + 2'd2)
      begin
        parallel_data [i] <= sampled_bit ;
        i <= i + 1 ;
      end
    else if (i == 4'd8)
      begin
         i <= 4'd0 ;
         P_DATA <= parallel_data ;
      end 
  end

endmodule     
  
  
  
 