module UART_TOP # ( parameter DATA_WIDTH = 8 ) (
  input      wire     [DATA_WIDTH-1:0]    TX_IN_P,      //TX parallel input data
  input      wire                         TX_IN_V,      //TX input valid signal
  input      wire                         PAR_TYP,      //0: even parity, 1: odd parity
  input      wire                         PAR_EN,       //to include parity bit
  input      wire                         TX_CLK,       //UART TX clock signal
  input      wire                         RX_CLK,       //UART RX clock signal
  input      wire                         RST,          //asynchronous active-low reset
  input      wire                         RX_IN_S,      //RX serial input data
  input      wire     [5:0]               prescale,     //oversampling prescale
  output     wire                         TX_OUT_V,     //TX output valid signal
  output     wire                         TX_OUT_S,     //TX serial data output
  output     wire     [DATA_WIDTH-1:0]    RX_OUT_P,     //RX parallel output data
  output     wire                         RX_OUT_V,     //RX output valid signal
  output     wire                         par_err,      //frame parity error
  output     wire                         stop_err      //frame stop error, high when stop bit equals 0
  ) ;
  
UART_TX # (.DATA_WIDTH(DATA_WIDTH)) U_UART_TX (
.CLK(TX_CLK),
.RST(RST),
.P_DATA(TX_IN_P),
.Data_Valid(TX_IN_V),
.PAR_EN(PAR_EN),
.PAR_TYP(PAR_TYP), 
.TX_OUT(TX_OUT_S),
.Busy(TX_OUT_V)
) ;
 
UART_RX # (.DATA_WIDTH(DATA_WIDTH)) U_UART_RX (
.CLK(RX_CLK),
.RST(RST),
.RX_IN(RX_IN_S),
.prescale(prescale),
.PAR_EN(PAR_EN),
.PAR_TYP(PAR_TYP),
.P_DATA(RX_OUT_P), 
.data_valid(RX_OUT_V),
.par_err(par_err),
.stop_err(stop_err)
) ;
 

endmodule