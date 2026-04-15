module DATA_SYNC #(parameter NUM_STAGES = 2, BUS_WIDTH = 8) 
  (
  input        wire     [BUS_WIDTH-1:0]       unsync_bus,    //unsynchronized data bus
  input        wire                           bus_enable,    //data bus enable signal
  input        wire                           CLK,           //system clock input
  input        wire                           RST,           //active-low asynchronous reset
  output       reg      [BUS_WIDTH-1:0]       sync_bus,      //synchronized data bus
  output       reg                            enable_pulse   //enable pulse signal
  ) ;
  
  reg   [NUM_STAGES-1:0]  sync_reg ;  //synchronization flops
  
  reg   enable_reg ;  //enable signal register 
  wire  enable_pulse_comb ;  //combinational enable pulse sginal
  
 assign enable_pulse_comb = sync_reg [NUM_STAGES-1] & !enable_reg ;

//synchronization process 
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        sync_reg <= 'b0 ;
      end
    else
      begin
        sync_reg <= {sync_reg [NUM_STAGES-2:0], bus_enable} ;
      end
  end

//enable register function        
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        enable_reg <= 'b0 ;
      end
    else
      begin
        enable_reg <= sync_reg [NUM_STAGES-1] ;
      end
  end  

//enable pulse output      
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        enable_pulse <= 'b0 ;
      end
    else
      begin
        enable_pulse <= enable_pulse_comb ;
      end
  end  

//synchronized data bus output   
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        sync_bus <= 'b0 ;
      end
    else if (enable_pulse_comb)
      begin 
        sync_bus <= unsync_bus ;
      end
  end  

endmodule    