module SYS_CTRL (
  input     wire   [15:0]   ALU_OUT,
  input     wire            OUT_Valid,
  input     wire   [7:0]    RX_P_DATA,
  input     wire            RX_D_VLD,
  input     wire   [7:0]    RdData,
  input     wire            RdData_Valid,
  input     wire            CLK,
  input     wire            RST,
  input     wire            FIFO_FULL,
  output    reg             ALU_EN,
  output    reg    [3:0]    ALU_FUN,
  output    reg             CLK_EN,
  output    reg    [3:0]    Address,
  output    reg             WrEn,
  output    reg             RdEn,
  output    reg    [7:0]    WrData,
  output    reg    [7:0]    TX_P_DATA,
  output    reg             TX_D_VLD,
  output    reg             clk_div_en
  ) ;
  
  reg [3:0] current_state ;
  reg [3:0] next_state ;
  
  reg [3:0] Address_reg ;
  reg [7:0] RX_P_DATA_reg ;
  
  localparam [3:0]  IDLE        = 4'b0000,
                    WRITE_CMD   = 4'b0001,
                    WRITE_ADD   = 4'b0011,
                    WRITE_DATA  = 4'b0010,
                    READ_CMD    = 4'b0110,
                    READ_ADD    = 4'b0111,
                    READ_DATA   = 4'b0101,
                    ALU_CMD     = 4'b0100,
                    ALU_OPR_A   = 4'b1100,
                    ALU_OPR_B   = 4'b1101,
                    ALU_FUNC    = 4'b1111,
                    ALU_NOP_CMD = 4'b1110,
                    ALU_OUT_1   = 4'b1010,
                    ALU_OUT_2   = 4'b1011 ; 

always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      current_state <= IDLE ;
    else
      current_state <= next_state ;
  end
  
always @ (*)
  begin
    case (current_state)
      IDLE : begin
               if (RX_P_DATA == 8'hAA && RX_D_VLD)
                 next_state = WRITE_CMD ;
               else if (RX_P_DATA == 8'hBB && RX_D_VLD)
                 next_state = READ_CMD ;
               else if (RX_P_DATA == 8'hCC && RX_D_VLD) 
                 next_state = ALU_CMD ;
               else if (RX_P_DATA == 8'hDD && RX_D_VLD) 
                 next_state = ALU_NOP_CMD ; 
               else
                 next_state = IDLE ;
             end 
             
      WRITE_CMD : begin
                    if (RX_D_VLD)
                      next_state = WRITE_ADD ;
                    else
                      next_state = WRITE_CMD ;
                  end
    
      WRITE_ADD : begin
                    if (RX_D_VLD)
                      next_state = WRITE_DATA ;
                    else
                      next_state = WRITE_ADD ;
                  end
     
      WRITE_DATA : begin
                     next_state = IDLE ;
                   end
        
      READ_CMD : begin
                   if (RX_D_VLD)
                     next_state = READ_ADD ;
                   else
                     next_state = READ_CMD ;
                 end
    
      READ_ADD : begin
                   if (RdData_Valid && !FIFO_FULL)
                     next_state = READ_DATA ;
                   else
                     next_state = READ_ADD ;
                 end
     
      READ_DATA : begin
                     next_state = IDLE ;
                  end
        
      ALU_CMD : begin
                  if (RX_D_VLD)
                    next_state = ALU_OPR_A ;
                  else
                    next_state = ALU_CMD ;
                end
                
      ALU_OPR_A : begin
                    if (RX_D_VLD)
                      next_state = ALU_OPR_B ;
                    else
                      next_state = ALU_OPR_A ;
                  end
                 
      ALU_OPR_B : begin
                    if (RX_D_VLD)
                      next_state = ALU_FUNC ;
                    else
                      next_state = ALU_OPR_B ;
                  end
                  
      ALU_FUNC : begin 
                   if (OUT_Valid && !FIFO_FULL)
                     next_state = ALU_OUT_1 ;
                   else
                     next_state = ALU_FUNC ;
                 end
                
      ALU_OUT_1 : begin
                    next_state = ALU_OUT_2 ;
                  end
                  
      ALU_OUT_2 : begin
                    next_state = IDLE ;
                  end 
                  
                  
      ALU_NOP_CMD : begin
                      if (RX_D_VLD)
                        next_state = ALU_FUNC ;
                      else
                        next_state = ALU_NOP_CMD ;
                    end        
                    
      default : begin
                  next_state = IDLE ;
                end
    endcase
  end
                
                   
always @ (*)
  begin
    ALU_FUN = 4'b1111 ;
    CLK_EN = 1'b0 ;
    Address = 4'b0 ;
    ALU_EN = 1'b0 ;
    WrEn = 1'b0 ;
    RdEn = 1'b0 ;
    WrData = 8'b0 ;
    TX_P_DATA = 8'b0 ;
    TX_D_VLD = 1'b0 ;
    clk_div_en = 1'b1 ;
    case (current_state) 
      
      IDLE : begin
               ALU_FUN = 4'b1111 ;
               CLK_EN = 1'b0 ;
               Address = 4'b0 ;
               ALU_EN = 1'b0 ;
               WrEn = 1'b0 ;
               RdEn = 1'b0 ;
               WrData = 8'b0 ;
               TX_P_DATA = 8'b0 ;
               TX_D_VLD = 1'b0 ;
               clk_div_en = 1'b1 ;
             end
      
      WRITE_CMD : begin
                    Address = RX_P_DATA ;
                  end
                  
      WRITE_ADD : begin
                    Address = Address_reg ;
                  end
     
      WRITE_DATA : begin
                     Address = Address_reg ;
                     WrData = RX_P_DATA ;
                     WrEn = 1'b1 ;
                   end
    
      READ_ADD : begin
                   Address = RX_P_DATA ;
                   RdEn = 1'b1 ;
                 end
     
      READ_DATA : begin
                    if (RdData_Valid && !FIFO_FULL)
                      begin
                        TX_P_DATA = RdData ;
                        TX_D_VLD = 1'b1 ;
                      end
                    else
                      begin
                        TX_P_DATA = 'b0 ;
                        TX_D_VLD = 1'b0 ;
                      end
                  end
        
      ALU_CMD : begin
                  WrEn = 1'b1 ;
                  WrData = RX_P_DATA ;
                end
                 
      ALU_OPR_A : begin
                    Address = 'b0 ;
                    WrEn = 1'b1 ;
                    WrData = RX_P_DATA_reg ;
                  end
                 
      ALU_OPR_B : begin
                    ALU_EN = 1'b1 ;
                    Address = 'b1 ;
                    WrEn = 1'b1 ;
                    WrData = RX_P_DATA_reg ;
                  end
                  
      ALU_FUNC : begin
                   ALU_EN = 1'b1 ;
                   ALU_FUN = RX_P_DATA ;
                   CLK_EN = 1'b1 ;
                 end
               
      ALU_OUT_1 : begin
                    if (OUT_Valid && !FIFO_FULL)
                      begin
                        TX_P_DATA = ALU_OUT [7:0] ;
                        TX_D_VLD = 1'b1 ;
                      end
                    else
                      begin
                        TX_P_DATA ='b0 ;
                        TX_D_VLD = 1'b0 ;
                      end
                  end
                  
      ALU_OUT_2 : begin
                    if (OUT_Valid && !FIFO_FULL)
                      begin
                        TX_P_DATA = ALU_OUT [15:8] ;
                        TX_D_VLD = 1'b1 ;
                      end
                    else
                      begin
                        TX_P_DATA ='b0 ;
                        TX_D_VLD = 1'b0 ;
                      end
                  end 
                  
      ALU_NOP_CMD : begin
                      ALU_EN = 1'b0 ;
                      CLK_EN = 1'b0 ;
                    end      
                    
      default : begin
                  ALU_FUN = 4'b1111 ;
                  CLK_EN = 1'b0 ;
                  Address = 4'b0 ;
                  ALU_EN = 1'b0 ;
                  WrEn = 1'b0 ;
                  RdEn = 1'b0 ;
                  WrData = 8'b0 ;
                  TX_P_DATA = 8'b0 ;
                  TX_D_VLD = 1'b0 ;
                  clk_div_en = 1'b1 ;
                end
    endcase
  end
  
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      Address_reg <= '0 ;
    else 
      Address_reg <= Address ;
  end
  
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      RX_P_DATA_reg <= '0 ;
    else 
      RX_P_DATA_reg <= RX_P_DATA ;
  end
 
        
endmodule 



      
                      
                    
                    
                    
                    
                    
                    
                    
                    
  
  
