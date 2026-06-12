module PULSE_GEN (
  input    wire    RST,
  input    wire    CLK,
  input    wire    LVL_SIG,
  output   wire    PULSE_SIG
  ) ;
  
  reg  RECV_FLOP ;
  reg  PULSE_FLOP ;
  
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        RECV_FLOP <= 'b0 ;
        PULSE_FLOP <= 'b0 ;
      end
    else
      begin
        RECV_FLOP <= LVL_SIG ;
        PULSE_FLOP <= RECV_FLOP ;
      end
  end

assign PULSE_SIG = RECV_FLOP && !PULSE_FLOP ;
        
endmodule