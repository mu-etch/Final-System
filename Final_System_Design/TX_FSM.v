module TX_FSM (
  input      wire           Data_Valid,   //valid signal to receive new data
  input      wire           PAR_EN,       //to include parity bit
  input      wire           ser_done,     //high when serialization of input data is done
  input      wire           CLK,          //UART TX clock signal
  input      wire           RST,          //asynchronous active-low reset
  output     reg            ser_en,       //seralization enable signal
  output     reg    [1:0]   mux_sel,      //to choose the transmitted bit
  output     reg            Busy          //high during transmission, otherwise low
  ) ;
  
  reg  [2:0] current_state ;
  reg  [2:0] next_state ;
  reg        Busy_Comb ;
  
  //state encoding
  localparam  [2:0] IDLE    = 3'b000,   //IDLE state: no data to transmit
                    START   = 3'b001,   //START state: transmit the start bit
                    DATA    = 3'b011,   //DATA state: transmit 8 input data bits
                    PARITY  = 3'b010,   //PARITY state: transmit parity bit if enabled
                    STOP    = 3'b110 ;  //STOP state: transmit the stop bit

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
     IDLE :   begin
                if (Data_Valid)
                  next_state = START ;
                else
                  next_state = IDLE ;
              end
            
     START :  begin
                next_state = DATA ;
              end
              
     DATA :   begin
                if (ser_done && PAR_EN)
                  next_state = PARITY ;
                else if (ser_done && !PAR_EN)
                  next_state = STOP ;
                else
                  next_state = DATA ;
              end
                
                
     PARITY : begin
                next_state = STOP ;
              end
             
     
     STOP :   begin
                next_state = IDLE ;
              end
            
     default :
              begin  
                next_state = IDLE ;
              end
    endcase
  end  

//output logic
always @(*)
  begin
    case (current_state)
     IDLE :   begin
                mux_sel = 2'b10 ;  //default output (TX_OUT = 1)
                ser_en = 1'b0 ;
                Busy_Comb = 1'b0 ;
              end
            
     START :  begin
                mux_sel = 2'b00 ;  //select start bit (0)
                ser_en = 1'b0 ;
                Busy_Comb = 1'b1 ;
              end
              
     DATA :   begin
                mux_sel = 2'b01 ;  //select serialized data bits
                ser_en = 1'b1 ;
                Busy_Comb = 1'b1 ;
              end
                
                
     PARITY : begin
                mux_sel = 2'b11 ;  //select parity bit
                ser_en = 1'b0 ;
                Busy_Comb = 1'b1 ;
              end
             
     
     STOP :   begin
                mux_sel = 2'b10 ;  //select stop bit (1)
                ser_en = 1'b0 ;
                Busy_Comb = 1'b1 ;
              end
            
     default :
              begin  
                mux_sel = 2'b10 ;
                ser_en = 1'b0 ;
                Busy_Comb = 1'b0 ;
              end
    endcase
  end  
  
always @(posedge CLK or negedge RST)
  begin
    if (!RST)
      Busy <= 1'b0 ;
    else
      Busy <= Busy_Comb ;
  end  

endmodule       
