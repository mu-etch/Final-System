module RST_SYNC #(parameter NUM_STAGES = 2) 
  (
  input      wire      RST,      //active-low asynchronous reset
  input      wire      CLK,      //system clock input
  output     wire      SYNC_RST  //synchronized reset
  ) ;
  
  reg   [NUM_STAGES-1:0]  sync_reg ;  //synchronization flops

//synchronization process  
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      sync_reg <= 'b0 ;
    else
      sync_reg <= {sync_reg [NUM_STAGES-2:0], 1'b1} ;
  end
  
assign SYNC_RST = sync_reg [NUM_STAGES-1] ;

endmodule