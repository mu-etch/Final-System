module ASYNC_FIFO # ( parameter DATA_WIDTH = 8 ) (
  input     wire                          W_CLK,    //source domain clock
  input     wire                          W_RST,    //source domain reset
  input     wire                          W_INC,    //write operation enable
  input     wire                          R_CLK,    //destination domain clock
  input     wire                          R_RST,    //destination domain reset
  input     wire                          R_INC,    //read operation enable
  input     wire     [DATA_WIDTH-1:0]     WR_DATA,  //write data bus
  output    wire                          FULL,     //FIFO buffer full flag
  output    wire                          EMPTY,    //FIFO buffer empty flag
  output    wire     [DATA_WIDTH-1:0]     RD_DATA   //read data bus
  ) ;
  
  wire    [2:0]     W_ADD ;       //write address
  wire    [3:0]     W_PTR ;       //write pointer
  wire    [3:0]     SYNC_W_PTR ;  //synchronized write pointer
  wire    [2:0]     R_ADD ;       //read address
  wire    [3:0]     R_PTR ;       //read pointer
  wire    [3:0]     SYNC_R_PTR ;  //synchronized read pointer

//FIFO memory   
FIFO_MEMORY # ( .DATA_WIDTH(DATA_WIDTH) ) U_mem 
(
.WR_DATA(WR_DATA),
.W_INC(W_INC),
.FULL(FULL),
.W_ADD(W_ADD),
.R_ADD(R_ADD),
.W_CLK(W_CLK),
.W_RST(W_RST),
.RD_DATA(RD_DATA)
) ;

//generate FIFO write address & FIFO full flag
WPTR_FULL U_wptr (
.W_INC(W_INC),
.W_CLK(W_CLK),
.W_RST(W_RST),
.SYNC_R_PTR(SYNC_R_PTR),
.W_ADD(W_ADD),
.W_PTR(W_PTR),
.FULL(FULL)
) ;

//generate FIFO read address & FIFO empty flag
RPTR_EMPTY U_rptr (
.R_INC(R_INC),
.R_CLK(R_CLK),
.R_RST(R_RST),
.SYNC_W_PTR(SYNC_W_PTR),
.R_ADD(R_ADD),
.R_PTR(R_PTR),
.EMPTY(EMPTY)
) ;

//synchronize read pointer to write domain
SYNC_R2W U_r2w (
.R_PTR(R_PTR),
.W_CLK(W_CLK),
.W_RST(W_RST),
.SYNC_R_PTR(SYNC_R_PTR)
) ;

//synchronize write pointer to read domain
SYNC_W2R U_w2r (
.W_PTR(W_PTR),
.R_CLK(R_CLK),
.R_RST(R_RST),
.SYNC_W_PTR(SYNC_W_PTR)
) ;

endmodule







  
