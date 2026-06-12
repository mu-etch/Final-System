`timescale 1ns/1ps

module SYS_tb () ;
  
reg RST_N_tb ;
reg UART_CLK_tb ;
reg REF_CLK_tb ;
reg UART_RX_IN_tb ;
wire UART_TX_O_tb ;
wire par_err_tb ;
wire stop_err_tb ;

reg [10:0] captured_bits ;
reg [10:0] ALU_frame_1 ;
reg [10:0] ALU_frame_2 ;

parameter REF_CLK_PERIOD = 20 ;
parameter UART_CLK_PERIOD = 271.267 ;
parameter DATA_WIDTH_tb = 8 ;
parameter RF_ADDR_tb = 4 ;

always # (REF_CLK_PERIOD/2.0) REF_CLK_tb = ~ REF_CLK_tb ;
always # (UART_CLK_PERIOD/2.0) UART_CLK_tb = ~ UART_CLK_tb ;

initial 
  begin
    $dumpfile ("SYSTEM.vcd") ;
    $dumpvars ;
    
    initialization () ;
    
    reset () ; 
    
    receive (8'hAA, 1'b0) ;
    
    receive (8'h09, 1'b0) ;
    
    receive (8'hFB, 1'b1) ;
    
    checkout_write_data (8'hFB) ;
    
    receive (8'hBB, 1'b0) ;
    
    receive (8'h09, 1'b0) ;
    
    tx_operation (captured_bits) ;
    
    checkout_read_data (8'hFB) ;
    
    receive (8'hAA, 1'b0) ;
    
    receive (8'h06, 1'b0) ;
    
    receive (8'h85, 1'b1) ;
    
    checkout_write_data (8'h85) ;
    
    receive (8'hBB, 1'b0) ;
    
    receive (8'h06, 1'b0) ;
    
    tx_operation (captured_bits) ;
    
    checkout_read_data (8'h85) ;
    
    receive (8'hCC, 1'b0) ;
    
    receive (8'hDE, 1'b0) ;
    
    receive (8'hBC, 1'b1) ;
    
    receive (8'h00, 1'b0) ;
    
    ALU_tx_operation (ALU_frame_1, ALU_frame_2) ;
    
    checkout_ALU_frame_1 (8'b10011010) ;
    
    checkout_ALU_frame_2 (8'b00000001) ;
    
    receive (8'hDD, 1'b0) ;
    
    receive (8'h01, 1'b1) ;
    
    ALU_tx_operation (ALU_frame_1, ALU_frame_2) ;
    
    checkout_ALU_frame_1 (8'b100010) ;
    
    checkout_ALU_frame_2 (8'b0) ;
    
    receive (8'hAA, 1'b0) ;
    
    receive (8'h02, 1'b1) ;
    
    receive (8'b01000001, 1'b0) ;
    
    checkout_write_data (8'b01000001) ;
    
    receive (8'hAA, 1'b0) ;
    
    receive (8'h05, 1'b0) ;
    
    receive (8'h77, 1'b0) ;
    
    checkout_write_data (8'h77) ;
    
    receive (8'hBB, 1'b0) ;
    
    receive (8'h05, 1'b0) ;
    
    tx_operation (captured_bits) ;
    
    checkout_read_data (8'h77) ;
    
    
receive (8'hCC, 1'b0) ;
    
    receive (8'd100, 1'b1) ;
    
    receive (8'd50, 1'b1) ;
    
    receive (8'h03, 1'b0) ;
    
    ALU_tx_operation (ALU_frame_1, ALU_frame_2) ;
    
    checkout_ALU_frame_1 (8'b10) ;
    
    checkout_ALU_frame_2 (8'b0) ;
    
    receive (8'hDD, 1'b0) ;
    
    receive (8'h02, 1'b1) ;
    
    ALU_tx_operation (ALU_frame_1, ALU_frame_2) ;
    
    checkout_ALU_frame_1 (8'b10001000) ;
    
    checkout_ALU_frame_2 (8'b10011) ;
        
    #10000 ;
    $stop ;
   end
   
task initialization ;
  begin
    RST_N_tb = 1'b0 ;
    UART_CLK_tb = 1'b0 ;
    REF_CLK_tb = 1'b0  ;
    UART_RX_IN_tb = 1'b0 ;
  end
endtask

task reset ;
  begin
    RST_N_tb = 1'b1 ;
    #(REF_CLK_PERIOD) ;
    RST_N_tb = 1'b0 ;
    #(REF_CLK_PERIOD) ;   
    RST_N_tb = 1'b1 ;
  end
endtask

task receive ;
 input [7:0] command ;
 input parity_bit ;
 integer i ;
 
  begin 
    @(posedge DUT.U_UART.TX_CLK) ;
    UART_RX_IN_tb = 1'b0 ; 
    for (i = 0 ; i < 8 ; i = i + 1)
      begin
        @(posedge DUT.U_UART.TX_CLK) ;
        UART_RX_IN_tb = command [i] ;
      end
    @(posedge DUT.U_UART.TX_CLK) ;
    UART_RX_IN_tb = parity_bit ;
    @(posedge DUT.U_UART.TX_CLK) ;
    UART_RX_IN_tb = 1'b1 ;
    @(posedge DUT.U_SYS_CTRL.RX_D_VLD) ;
  end
endtask

task checkout_write_data ;
 input [7:0] expected_write_data ;
 
  begin
    #(REF_CLK_PERIOD) ;
    @(negedge REF_CLK_tb) ;
    if (DUT.U_RegFile.WrData == expected_write_data)
      begin
        $display ("CHECKOUT PASSED AT TIME = %0t !", $time) ;
        $display ("Write Data = %h", DUT.U_RegFile.WrData ) ;
      end
    else
      begin
        $display ("CHECKOUT FAILED AT TIME = %0t !", $time) ;
        $display ("Expected Write Data = %h", expected_write_data ) ;
        $display ("Actual Write Data = %h", DUT.U_RegFile.WrData ) ;
      end
  end     
endtask

task tx_operation ;
 output reg [10:0] tx_out_p ;
 integer i ;
 
  begin
    @(posedge DUT.U_UART.TX_IN_V) ;
    @(posedge DUT.U_UART.TX_OUT_V) ;
    @(posedge DUT.U_UART.TX_CLK) ;
    
    if (DUT.U_UART.PAR_EN)
      begin
        for (i = 0 ; i < 11 ; i = i + 1)
          begin
            tx_out_p [i] = UART_TX_O_tb ;
            @(posedge DUT.U_UART.TX_CLK) ;
          end 
      end
    else
      begin
        for (i = 0 ; i < 10 ; i = i + 1)
          begin
            tx_out_p [i] = UART_TX_O_tb ;
            @(posedge DUT.U_UART.TX_CLK) ;
          end
      end 
  end
endtask

task ALU_tx_operation ;
 output reg [10:0] tx_out_p_1 ;
 output reg [10:0] tx_out_p_2 ;
 integer i ;
 
  begin
    @(posedge DUT.U_UART.TX_OUT_V) ;
    @(posedge DUT.U_UART.TX_CLK) ;
    
    for (i = 0 ; i < 11 ; i = i + 1)
       begin
         tx_out_p_1 [i] = UART_TX_O_tb ;
          @(posedge DUT.U_UART.TX_CLK) ;
       end 
        
    @(posedge DUT.U_UART.TX_CLK)
    
    for (i = 0 ; i < 11 ; i = i + 1)
       begin
         tx_out_p_2 [i] = UART_TX_O_tb ;
          @(posedge DUT.U_UART.TX_CLK) ;
       end     
  end
endtask

task checkout_read_data ;
 input [7:0] expected_read_data ;
 
  begin
    if (captured_bits [8:1] == expected_read_data)
      begin
        $display ("CHECKOUT PASSED AT TIME = %0t !", $time) ;
        $display ("Read Data = %h", captured_bits [8:1]) ;
      end
    else
      begin
        $display ("CHECKOUT FAILED AT TIME = %0t !", $time) ;
        $display ("Expected Read Data = %b", expected_read_data ) ;
        $display ("Actual Read Data = %b", captured_bits [8:1] ) ;
      end
  end     
endtask

task checkout_ALU_frame_1 ;
 input [7:0] expected_ALU_result ;
 
  begin
    if (ALU_frame_1 [8:1] == expected_ALU_result)
      begin
        $display ("CHECKOUT PASSED AT TIME = %0t !", $time) ;
        $display ("ALU result = %h", ALU_frame_1 [8:1]) ;
      end
    else
      begin
        $display ("CHECKOUT FAILED AT TIME = %0t !", $time) ;
        $display ("Expected ALU result = %b", expected_ALU_result ) ;
        $display ("Actual ALU result = %b", ALU_frame_1 [8:1] ) ;
      end
  end     
endtask    

task checkout_ALU_frame_2 ;
 input [7:0] expected_ALU_result ;
 
  begin
    if (ALU_frame_2 [8:1] == expected_ALU_result)
      begin
        $display ("CHECKOUT PASSED AT TIME = %0t !", $time) ;
        $display ("ALU result = %h", ALU_frame_2 [8:1]) ;
      end
    else
      begin
        $display ("CHECKOUT FAILED AT TIME = %0t !", $time) ;
        $display ("Expected ALU result = %b", expected_ALU_result ) ;
        $display ("Actual ALU result = %b", ALU_frame_2 [8:1] ) ;
      end
  end     
endtask    

SYS_TOP #(.DATA_WIDTH(DATA_WIDTH_tb), .RF_ADDR(RF_ADDR_tb)) DUT (
.RST_N(RST_N_tb),
.UART_CLK(UART_CLK_tb),
.REF_CLK(REF_CLK_tb),
.UART_RX_IN(UART_RX_IN_tb),
.UART_TX_O(UART_TX_O_tb),
.parity_error(par_err_tb),
.framing_error(stop_err_tb)
);


endmodule




    
    
    