module Register_File # (parameter ADDRESS = 4, WIDTH = 8, DEPTH = 16)
  (
  input     wire     [WIDTH-1:0]          WrData ,    //write data input
  input     wire     [ADDRESS-1:0]        Address ,   //register address
  input     wire                          RdEn ,      //read enable
  input     wire                          WrEn ,      //write enable
  input     wire                          CLK ,       //clock input
  input     wire                          RST ,       //asynchronous active-low reset
  output    wire     [WIDTH-1:0]          REG0,
  output    wire     [WIDTH-1:0]          REG1,
  output    wire     [WIDTH-1:0]          REG2,
  output    wire     [WIDTH-1:0]          REG3,
  output    reg      [WIDTH-1:0]          RdData,     //read data output
  output    reg                           RdData_Valid
  ) ;
  
  integer i ;
  
  reg  [WIDTH-1:0]  Reg_File  [DEPTH-1:0] ; 
  
//function behavior: reset, write, or read registers based on control signals  
always @(posedge CLK or negedge RST)
  begin
    //clear all registers on reset
    if (!RST)
      begin
        for (i = 0 ; i < DEPTH ; i = i + 1)
		      begin
		        if(i == 2)
              Reg_File [i] <= 'b100000_01 ;
		        else if (i == 3) 
              Reg_File [i] <= 'b0010_0000 ;
            else
		          Reg_File [i] <= 'b0 ;
		      end 
        RdData <= 'b0 ;
		    RdData_Valid <= 'b0 ;
      end
     
    //write operation 
    else if (WrEn && !RdEn)
      begin
        Reg_File [Address] <= WrData ;
      end 
      
    //read operation 
    else if (RdEn && !WrEn)
      begin
        RdData <= Reg_File [Address] ;
		    RdData_Valid <= 'b1 ;
      end  
    else
	    begin
	      RdData_Valid <= 'b0 ;
	    end
  end
  
assign REG0 = Reg_File [0] ;
assign REG1 = Reg_File [1] ;
assign REG2 = Reg_File [2] ;
assign REG3 = Reg_File [3] ;
  
endmodule