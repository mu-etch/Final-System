/*synchronize read pointer to write domain*/
module SYNC_R2W (
  input    wire     [3:0]     R_PTR,
  input    wire               W_CLK,
  input    wire               W_RST,
  output   reg      [3:0]     SYNC_R_PTR
  ) ;
  
  reg  [3:0]  SYNC_R2W_FLOP ;  //synchronization flops

//synchronization process  
always @(posedge W_CLK or negedge W_RST)
  begin
    if (!W_RST)
      begin
        SYNC_R2W_FLOP <= 'b0 ;
        SYNC_R_PTR <= 'b0 ;
      end
    else
      begin
        SYNC_R2W_FLOP <= R_PTR ;
        SYNC_R_PTR <= SYNC_R2W_FLOP ;
      end
  end
  
endmodule

