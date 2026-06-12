/*generate FIFO read address & FIFO empty flag)*/
module RPTR_EMPTY (
  input     wire              R_INC,
  input     wire              R_CLK,
  input     wire              R_RST,
  input     wire    [3:0]     SYNC_W_PTR,
  output    wire    [2:0]     R_ADD,
  output    reg     [3:0]     R_PTR,
  output    reg               EMPTY
  ) ;

  reg   [3:0]  R_BIN ;        //binary read address
  wire  [3:0]  R_BIN_NEXT ;   //next binary read address
  wire  [3:0]  R_GRAY_NEXT ;  //next gray read pointer
  wire         EMPTY_COMB ;   //combinational empty flag

//read operation
always @(posedge R_CLK or negedge R_RST)
  begin
    if (!R_RST)
      begin
        R_BIN <= 'b0 ;
        R_PTR <= 'b0 ;
        EMPTY <= 'b1 ;
      end
    else
      begin
        R_BIN <= R_BIN_NEXT  ;
        R_PTR <= R_GRAY_NEXT ;
        EMPTY <= EMPTY_COMB  ;
      end
  end

//assign statements  
assign R_ADD = R_BIN [2:0] ;
assign R_BIN_NEXT = R_BIN + (R_INC & !EMPTY) ;
assign R_GRAY_NEXT = (R_BIN_NEXT >> 1) ^ R_BIN_NEXT ;
assign EMPTY_COMB = ( R_GRAY_NEXT == SYNC_W_PTR ) ;

endmodule




