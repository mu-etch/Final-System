module RX_FSM (
  input         wire                 RX_IN,           //serial data input
  input         wire                 PAR_EN,          //to include parity bit
  input         wire      [3:0]      bit_cnt,         //data frame bit counter
  input         wire      [5:0]      edge_cnt,        //counts clock cycles within one bit period
  input         wire      [5:0]      prescale,        //oversampling prescale value
  input         wire                 par_err,         //frame parity error
  input         wire                 start_glitch,    //frame start bit glitch, high when start bit equals 1
  input         wire                 stop_err,        //frame stop error, high when stop bit equals 0
  input         wire                 CLK,             //UART RX clock signal
  input         wire                 RST,             //asynchronous active-low reset
  output        reg                  counter_en,      //edge and bit counters enable
  output        reg                  data_samp_en,    //data sampling enable signal
  output        reg                  par_chk_en,      //parity bit check enable signal
  output        reg                  start_chk_en,    //start bit check enable signal
  output        reg                  stop_chk_en,     //stop bit check enable signal
  output        reg                  deser_en,        //deserialization enable signal
  output        reg                  data_valid       //data byte valid signal, high when there are no errors
  ) ;
  
  reg   [2:0]   current_state ;
  reg   [2:0]   next_state ;
  
  //state encoding
  localparam  [2:0]  IDLE    =  3'b000 ,  //waiting for start bit 
                     START   =  3'b001 ,  //receiving and checking the start bit
                     DATA    =  3'b011 ,  //receiving and deserializing data bits
                     PARITY  =  3'b010 ,  //receiving and checking the parity bit
                     STOP    =  3'b110 ,  //receiving and checking the stop bit
                     VALID   =  3'b111 ;  //data frame received successfully

//state transition                   
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      current_state <= IDLE ;
    else
      current_state <= next_state ;
  end
                       
//next state logic                   
always @(*)
  begin
    case (current_state)
      IDLE   :   begin
                  if (!RX_IN) 
                    next_state = START ;
                  else         
                    next_state = IDLE ;
                 end
               
     
      START  :   begin
                  if (start_glitch)
                    next_state = IDLE ;
                  else if (bit_cnt == 4'd0 && edge_cnt == prescale - 1'b1) 
                    next_state = DATA ;
                  else 
                    next_state = START ;
                 end       
                
      DATA   :   begin
                  if (PAR_EN && bit_cnt == 4'd8 && edge_cnt == prescale - 1'b1)
                    next_state = PARITY ;
                  else if (!PAR_EN && bit_cnt == 4'd8 && edge_cnt == prescale - 1'b1)
                    next_state = STOP ;
                  else
                    next_state = DATA ;
                 end
                    
                    
      PARITY :   begin
                   if (par_err)
                     next_state = IDLE ;
                   else if (bit_cnt == 4'd9 && edge_cnt == prescale - 1'b1)
                     next_state = STOP ;
                   else
                     next_state = PARITY ;
                 end

      STOP   :   begin
                   if (stop_err)
                     next_state = IDLE ;
                   else if (bit_cnt == 4'd10 && edge_cnt == prescale - 'd2)
                     next_state = VALID ;
                   else if (bit_cnt == 4'd9 && edge_cnt == prescale - 'd2)
                     next_state = VALID ;
                   else
                     next_state = STOP ;
                 end  
                 
      VALID  :   begin
                   if (!RX_IN)
                     next_state = START ;
                   else
                     next_state = IDLE ; 
                 end
                 
      default :  begin
                   next_state = IDLE ;
                 end 
    endcase   
  end           

//output logic                
always @(*)
  begin
    case (current_state)
      IDLE   :   begin
                   counter_en = 1'b0 ;
                   data_samp_en = 1'b0 ;
                   par_chk_en = 1'b0 ;
                   start_chk_en = 1'b0 ;
                   stop_chk_en = 1'b0 ;
                   deser_en = 1'b0 ;
                   data_valid = 1'b0 ;
                 end
               
      START  :   begin
                   counter_en = 1'b1 ;
                   data_samp_en = 1'b1 ;
                   par_chk_en = 1'b0 ;
                   if (edge_cnt == (prescale/2) + 2'd2)
                     start_chk_en = 1'b1 ;
                   else
                     start_chk_en = 1'b0 ;
                   stop_chk_en = 1'b0 ;
                   deser_en = 1'b0 ;
                   data_valid = 1'b0 ;      
                 end       
                
      DATA   :   begin
                   counter_en = 1'b1 ;
                   data_samp_en = 1'b1 ;
                   par_chk_en = 1'b0 ;
                   start_chk_en = 1'b0 ;
                   stop_chk_en = 1'b0 ;
                   if (edge_cnt == (prescale/2) + 2'd2)
                     deser_en = 1'b1 ;
                   else
                     deser_en = 1'b0 ;
                   data_valid = 1'b0 ;
                 end
                    
                    
      PARITY :   begin
                   counter_en = 1'b1 ;
                   data_samp_en = 1'b1 ;
                   if (edge_cnt == (prescale/2) + 2'd2)
                     par_chk_en = 1'b1 ;
                   else
                     par_chk_en = 1'b0 ;
                   start_chk_en = 1'b0 ;
                   stop_chk_en = 1'b0 ;
                   deser_en = 1'b0 ;
                   data_valid = 1'b0 ;  
                 end

      STOP   :   begin
                   counter_en = 1'b1 ;
                   data_samp_en = 1'b1 ;
                   par_chk_en = 1'b0 ;
                   start_chk_en = 1'b0 ;
                   if (edge_cnt == (prescale/2) + 2'd2)
                     stop_chk_en = 1'b1 ;
                   else
                     stop_chk_en = 1'b0 ;
                   deser_en = 1'b0 ;
                   data_valid = 1'b0 ;
                 end  
                 
      VALID  :   begin
                   counter_en = 1'b0 ;
                   data_samp_en = 1'b0 ;
                   par_chk_en = 1'b0 ;
                   start_chk_en = 1'b0 ;
                   stop_chk_en = 1'b0 ;
                   deser_en = 1'b0 ;
                   if (stop_err || par_err)
                     data_valid = 1'b0 ;
                   else
                     data_valid = 1'b1 ;
                 end
                 
      default :  begin
                   counter_en = 1'b0 ;
                   data_samp_en = 1'b0 ;
                   par_chk_en = 1'b0 ;
                   start_chk_en = 1'b0 ;
                   stop_chk_en = 1'b0 ;
                   deser_en = 1'b0 ;
                   data_valid = 1'b0 ;
                 end
    endcase   
  end 

endmodule        
                   
                   
                   
                   
                   
                   
                   
                   
                   
                  
