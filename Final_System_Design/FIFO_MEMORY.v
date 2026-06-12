/*FIFO memory*/
module FIFO_MEMORY # ( parameter DATA_WIDTH = 8 ) (
  input     wire     [DATA_WIDTH-1:0]     WR_DATA,
  input     wire                          W_INC,
  input     wire                          FULL,
  input     wire     [2:0]                W_ADD,
  input     wire     [2:0]                R_ADD,
  input     wire                          W_CLK,
  input     wire                          W_RST,
  output    wire     [DATA_WIDTH-1:0]     RD_DATA
  ) ;
  
  localparam DEPTH = 8 ;  //FIFO depth
  
  integer i ;
  
  reg   [DATA_WIDTH-1:0]  REG_FILE   [0:DEPTH-1] ;  //register fi;e

//read new data  
assign RD_DATA = REG_FILE [R_ADD] ;

//write new data   
always @(posedge W_CLK or negedge W_RST)
  begin
    if (!W_RST) 
      begin
        for (i = 0 ; i < DEPTH ; i = i + 1)
          REG_FILE [i] <= 'b0 ;
      end
    else if (W_INC && !FULL)
      begin
        REG_FILE [W_ADD] <= WR_DATA ;
      end
  end
    
endmodule