module UART_TX # ( parameter DATA_WIDTH = 8 )
  (
  input      wire     [DATA_WIDTH-1:0]    P_DATA,       //parallel input data byte
  input      wire                         Data_Valid,   //valid signal to receive new data
  input      wire                         PAR_TYP,      //0: even parity, 1: odd parity
  input      wire                         PAR_EN,       //to include parity bit
  input      wire                         CLK,          //UART TX clock signal
  input      wire                         RST,          //asynchronous active-low reset
  output     wire                         TX_OUT,       //serial data output
  output     wire                         Busy          //high during transmission, otherwise low
  ) ;
  
  //internal signals
  wire          ser_done ;   //high when serialization of input data is done
  wire          ser_en ;     //seralization enable signal
  wire          ser_data ;   //serialized data input bit
  wire  [1:0]   mux_sel ;    //to choose the transmitted bit
  wire          par_bit ;    //parity calculation output
  wire          start_bit ;  //the beginning the data frame ( = 0 )
  wire          stop_bit ;   //the end of the data frame ( = 1 )
  
  assign start_bit = 1'b0 ;
  assign stop_bit = 1'b1 ;

//seralizer block: converts parallel input to serial
serializer # (.DATA_WIDTH(DATA_WIDTH)) U_serializer (
.P_DATA(P_DATA),
.ser_done(ser_done),
.ser_en(ser_en),
.ser_data(ser_data),
.Busy(Busy),
.Data_Valid(Data_Valid),
.CLK(CLK),
.RST(RST)
) ;

//finite state machine block: controls the transmission process
TX_FSM U_tx_fsm (
.Data_Valid(Data_Valid),
.PAR_EN(PAR_EN),
.ser_done(ser_done),
.ser_en(ser_en),
.mux_sel(mux_sel),
.Busy(Busy),
.CLK(CLK),
.RST(RST) 
) ;

//parity calculation block: calculates even/odd parity
parity_calc # (.DATA_WIDTH(DATA_WIDTH)) U_parity_calc (
.P_DATA(P_DATA),
.Data_Valid(Data_Valid),
.Busy(Busy),
.PAR_TYP(PAR_TYP),
.par_bit(par_bit),
.CLK(CLK),
.RST(RST)
) ;

//multiplexer block: selects correct bit for TX_OUT
TX_MUX U_tx_mux (
.mux_sel(mux_sel),
.start_bit(start_bit),
.stop_bit(stop_bit),
.ser_data(ser_data),
.par_bit(par_bit),
.TX_OUT(TX_OUT),
.CLK(CLK),
.RST(RST)
) ;

endmodule

               
