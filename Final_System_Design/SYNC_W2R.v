/*synchronize write pointer to read domain*/
module SYNC_W2R (
  input    wire     [3:0]     W_PTR,
  input    wire               R_CLK,
  input    wire               R_RST,
  output   reg      [3:0]     SYNC_W_PTR
  ) ;
  
  reg  [3:0]  SYNC_W2R_FLOP ;  //synchronization flops

//synchronization process  
always @(posedge R_CLK or negedge R_RST)
  begin
    if (!R_RST)
      begin
        SYNC_W2R_FLOP <= 'b0 ;
        SYNC_W_PTR <= 'b0 ;
      end
    else
      begin
        SYNC_W2R_FLOP <= W_PTR ;
        SYNC_W_PTR <= SYNC_W2R_FLOP ;
      end
  end
  
endmodule