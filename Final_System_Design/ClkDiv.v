module ClkDiv # ( parameter RATIO_WIDTH = 8 )
  (
  input        wire                           i_ref_clk,     //reference clock input
  input        wire                           i_rst_n,       //active-low asynchronous reset
  input        wire                           i_clk_en,      //clock divider block enable
  input        wire    [RATIO_WIDTH-1:0]      i_div_ratio,   //the division ratio
  output       wire                           o_div_clk      //divided clock output
  ) ;
  
  //internal signals 
  reg   [RATIO_WIDTH-2:0]   counter ;       //counter for clock edge tracking
  reg                       flag ;          //state flag for odd division asymmetry
  reg                       div_clk ;       //internal divided clock register
  wire                      clk_div_en ;    //enable with corner cases checks
  wire  [RATIO_WIDTH-2:0]   half_togg ;     //half the division ratio
  wire  [RATIO_WIDTH-2:0]   half_togg_m1 ;  //half the division ratio minus 1
  wire                      ODD ;           //high when division ratio is odd

//always block: clock divider function    
always @ (posedge i_ref_clk or negedge i_rst_n)
  begin
    if (!i_rst_n)
      begin
        div_clk <= i_ref_clk;  //generate refernce clock during reset
        counter <= 'd0 ;
        flag <= 'b0 ;
      end
    else if (!clk_div_en)
      begin
        counter <= 'd0 ;
        flag <= 'b0 ;
      end
    else if ( !ODD && counter == half_togg_m1 )
      begin
        div_clk <= ! div_clk ;
        counter <= 'd0 ;
      end
    else if ( ODD && ( (counter == half_togg_m1 && flag) || (counter == half_togg && !flag) ) )
      begin
        div_clk <= ! div_clk ;
        counter <= 'd0 ;
        flag <= ! flag ;
      end
    else
      begin
        counter <= counter + 'd1 ;
      end
  end

//assign statements          
assign clk_div_en = ( i_clk_en && (i_div_ratio != 'd1) && (i_div_ratio != 'd0) ) ;  
assign ODD = i_div_ratio [0] ; //check LSB 
assign half_togg = i_div_ratio >> 1 ;
assign half_togg_m1 = half_togg - 'd1 ;
assign o_div_clk = (clk_div_en) ? div_clk : i_ref_clk ; //generate reference clock when enable is low

endmodule 