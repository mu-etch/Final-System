module parity_calc # ( parameter DATA_WIDTH = 8 )
  (
  input     wire    [DATA_WIDTH-1:0]    P_DATA,       //parallel input data byte
  input     wire                        Data_Valid,   //valid signal to receive new data
  input     wire                        Busy,         //high during transmission, otherwise low
  input     wire                        PAR_TYP,      //0: even parity, 1: odd parity
  input     wire                        CLK,          //UART TX clock signal
  input     wire                        RST,          //asynchronous active-low reset
  output    reg                         par_bit       //parity calculation output
  ) ;
  
  wire parity_bit_comb ;
   
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      par_bit <= 1'b0 ;
    else if (Data_Valid && !Busy)
      par_bit <= parity_bit_comb ;
  end
      
assign parity_bit_comb = (PAR_TYP) ? ~^P_DATA : ^P_DATA ; 

endmodule 
