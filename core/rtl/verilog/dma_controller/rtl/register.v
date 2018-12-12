module register (clk, reg_en, data_in, rst, data_out);
parameter REG_DEPTH = 16; // 16 bits words by default, regs[0:15] 
input clk;
input rst;
input reg_en;
input [REG_DEPTH-1:0] data_in;
output reg [REG_DEPTH-1:0] data_out; 

always @(posedge rst or posedge clk)
begin
    if (rst) data_out <= 0;
    else if (clk) begin
	    //data_out <= {REG_DEPTH-1{1'bz}};
	    if (reg_en) begin
		    data_out <= data_in;
		    //data_out <= (wr_rd==0) ? data_out : {REG_DEPTH-1{1'bz}};
	    end else
		    data_out <= data_out;
    end
end   

endmodule
