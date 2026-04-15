module serializer # ( parameter DATA_WIDTH = 8 )
  (
  input      wire     [DATA_WIDTH-1:0]    P_DATA,       //parallel input data byte
  input      wire                         ser_en,       //seralization enable signal
  input      wire                         CLK,          //UART TX clock signal
  input      wire                         RST,          //asynchronous active-low reset
  input      wire                         Data_Valid,   //valid signal to receive new data
  input      wire                         Busy,         //high during transmission, otherwise low
  output     wire                         ser_done,     //high when serialization of input data is done
  output     wire                         ser_data      //serialized data input bit
  ) ;

  reg  [7:0]  Data ;
  reg  [2:0]  counter ;
              
 
always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
       Data <= 'b0 ;
       counter <= 'b0 ;
     end
   else if(Data_Valid && !Busy)
     begin
       Data <= P_DATA ;
     end    
   else if(ser_en)
     begin
       Data <= Data >> 1 ; 
       counter <= counter + 'b1 ;         
     end
   else
     begin
       counter <= 'b0 ;
     end
  end

assign ser_done = (counter == 'b111) ? 1'b1 : 1'b0 ;
assign ser_data = Data [0] ;

endmodule
        
