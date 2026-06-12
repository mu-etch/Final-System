module UART_RX # ( parameter DATA_WIDTH = 8 )
  (
  input         wire                            RX_IN,        //serial Data IN
  input         wire      [5:0]                 prescale,     //oversampling Prescale
  input         wire                            PAR_EN,       //to include parity bit
  input         wire                            PAR_TYP,      //0: even parity, 1: odd parity
  input         wire                            CLK,          //UART RX clock signal
  input         wire                            RST,          //asynchronous active-low reset
  output        wire      [DATA_WIDTH-1:0]      P_DATA,       //frame data byte
  output        wire                            par_err,      //frame parity error
  output        wire                            stop_err,     //frame stop error, high when stop bit equals 0
  output        wire                            data_valid    //data byte valid signal, high when there are no errors
  ) ;
  
  wire           start_glitch ;   //frame start bit glitch, high when start bit equals 1
  wire           counter_en ;     //edge and bit counters enable
  wire           data_samp_en ;   //data sampling enable signal
  wire           par_chk_en ;     //parity bit check enable signal
  wire           start_chk_en ;   //start bit check enable signal 
  wire           stop_chk_en ;    //stop bit check enable signal
  wire           deser_en ;       //deserialization enable signal
  wire           sampled_bit ;    //correct sampled bit
  wire   [3:0]   bit_cnt ;        //data frame bit counter
  wire   [5:0]   edge_cnt ;       //counts clock cycles within one bit period

//finite state machine block: controls the UART RX process  
RX_FSM U_rx_fsm (
.RX_IN(RX_IN),
.PAR_EN(PAR_EN),
.bit_cnt(bit_cnt),
.edge_cnt(edge_cnt),
.prescale(prescale),
.par_err(par_err),
.start_glitch(start_glitch),
.stop_err(stop_err),
.CLK(CLK),
.RST(RST),
.counter_en(counter_en),
.data_samp_en(data_samp_en),
.par_chk_en(par_chk_en),
.start_chk_en(start_chk_en),
.stop_chk_en(stop_chk_en),
.deser_en(deser_en),
.data_valid(data_valid)
) ;

//edge bit counter block: counts oversampling edges and frame bits
edge_bit_counter U_edge_bit_counter (
.prescale(prescale),
.counter_en(counter_en),
.CLK(CLK),
.RST(RST),
.bit_cnt(bit_cnt),
.edge_cnt(edge_cnt)
) ;

//deserializer block: converts sampled serial bits into 8-bit parallel data
deserializer # (.DATA_WIDTH(DATA_WIDTH)) U_deserializer (
.prescale(prescale),
.edge_cnt(edge_cnt),
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.deser_en(deser_en),
.P_DATA(P_DATA)
) ;

//data_sampling: samples RX_IN using oversampling
data_sampling U_sampling (
.RX_IN(RX_IN),
.edge_cnt(edge_cnt),
.prescale(prescale),
.data_samp_en(data_samp_en),
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit)
) ;

//start check block: checks if start bit equals 0
Start_Check U_start_check (
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.start_chk_en(start_chk_en),
.start_glitch(start_glitch)
) ;

//parity check block: checks the received parity bit if enabled
Parity_Check # (.DATA_WIDTH(DATA_WIDTH)) U_parity_check (
.PAR_TYP(PAR_TYP),
.P_DATA(P_DATA),
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.par_chk_en(par_chk_en),
.par_err(par_err)
) ;

//stop check block: checks if stop bit equals 1
Stop_Check U_stop_check (
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.stop_chk_en(stop_chk_en),
.stop_err(stop_err)
) ;

endmodule

























  
  
  
  