module ALU # (parameter WIDTH = 8, ADD = 4, OUT_WIDTH = WIDTH * 2)
  (
  input      wire     [WIDTH-1:0]        A,         //first operand
  input      wire     [WIDTH-1:0]        B,         //second operand
  input      wire     [ADD-1:0]          ALU_FUN,   //operation selector
  input      wire                        CLK,       //clock input
  input      wire                        RST,       //active-low asynchronous reset
  input      wire                        Enable,    //ALU block enable
  output     reg      [OUT_WIDTH-1:0]    ALU_OUT,   //registered alu result
  output     reg                         OUT_VALID  //output valid signal
  ) ;
  
  
  reg   [OUT_WIDTH-1:0]  ALU_OUT_comb ;   //combinational result before registering
  reg                    OUT_VALID_comb ;

//register alu output on rising clock edge
always @ (posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        ALU_OUT <= 'b0 ;
        OUT_VALID <= 'b0 ;
      end
    else
      begin
        ALU_OUT <= ALU_OUT_comb ;
        OUT_VALID <= OUT_VALID_comb ;
      end
  end
  
//combinational logic for alu operations and flags 
always @(*)
  begin
    ALU_OUT_comb = 'b0 ;
    OUT_VALID_comb = 'b0 ;
    if (Enable)
      begin
        OUT_VALID_comb = 'b1 ;
        case (ALU_FUN) 
          //arithmetic operations
          4'b0000 : begin
                      ALU_OUT_comb = A + B ; 
                    end  
          4'b0001 : begin
                      ALU_OUT_comb = A - B ;
                    end  
          4'b0010 : begin
                      ALU_OUT_comb = A * B ;
                    end
          4'b0011 : begin
                      ALU_OUT_comb = A / B ;
                    end     
                
          //logic operations          
          4'b0100 : begin
                      ALU_OUT_comb = A & B ;
                    end
          4'b0101 : begin
                      ALU_OUT_comb = A | B ;
                    end
          4'b0110 : begin
                      ALU_OUT_comb = ~(A & B) ;
                    end
          4'b0111 : begin
                      ALU_OUT_comb = ~(A | B) ;
                    end
          4'b1000 : begin
                      ALU_OUT_comb = A ^ B ;
                    end
          4'b1001 : begin
                      ALU_OUT_comb = (A ~^ B) ;
                    end 
      
          //comparison operations
          4'b1010 : begin
                      ALU_OUT_comb = (A == B) ? 'd1 : 'd0  ;
                    end
          4'b1011 : begin
                      ALU_OUT_comb = (A > B) ? 'd2 : 'd0  ;
                    end
          4'b1100 : begin   
                      ALU_OUT_comb = (A < B) ? 'd3 : 'd0  ;
                    end
      
          //shift operations                 
          4'b1101 : begin 
                      ALU_OUT_comb = A >> 1 ;
                    end  
          4'b1110 : begin
                      ALU_OUT_comb = A << 1 ;
                    end 
     
          //NOP
           default : begin 
                       ALU_OUT_comb = 'b0 ;
                     end
        endcase
      end
    else
      begin
        OUT_VALID_comb = 'b0 ;
      end  
  end   
  
      
endmodule  
      



