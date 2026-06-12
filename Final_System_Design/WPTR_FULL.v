/*generate FIFO write address & FIFO full flag*/
module WPTR_FULL (
  input     wire              W_INC,
  input     wire              W_CLK,
  input     wire              W_RST,
  input     wire    [3:0]     SYNC_R_PTR,
  output    wire    [2:0]     W_ADD,
  output    reg     [3:0]     W_PTR,
  output    reg               FULL
  ) ;

  reg   [3:0]  W_BIN ;        //binary write address
  wire  [3:0]  W_BIN_NEXT ;   //next binary write address
  wire  [3:0]  W_GRAY_NEXT ;  //next gray write pointer
  wire         FULL_COMB ;    //combinational full flag 

//write operation
always @(posedge W_CLK or negedge W_RST)
  begin
    if (!W_RST)
      begin
        W_BIN <= 'b0 ;
        W_PTR <= 'b0 ;
        FULL  <= 'b0 ;
      end
    else
      begin
        W_BIN <= W_BIN_NEXT  ;
        W_PTR <= W_GRAY_NEXT ;
        FULL  <= FULL_COMB   ;
      end
  end

//assign statements  
assign W_ADD = W_BIN [2:0] ; 
assign W_BIN_NEXT = W_BIN + (W_INC & !FULL) ;
assign W_GRAY_NEXT = (W_BIN_NEXT >> 1) ^ W_BIN_NEXT ;
assign FULL_COMB = ( (W_GRAY_NEXT [3] != SYNC_R_PTR [3]) && (W_GRAY_NEXT [2] != SYNC_R_PTR [2]) && (W_GRAY_NEXT [1:0] == SYNC_R_PTR [1:0]) ) ;

endmodule


