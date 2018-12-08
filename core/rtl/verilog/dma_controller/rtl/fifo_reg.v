// Asynchronous FIFO_REG, used to comply with the writing protocol of the openMSP430 DMA interface

module fifo_reg (
	clk,
	reg_en,
	wr_rd,
	data_in,
	rst,
	data_out,
	flag,
	`ifdef SIM register `endif	
);
parameter REG_DEPTH = 16; // 16 bits words by default, regs[0:15] 
input clk;
input wr_rd; // 1 for write, 0 for read
input rst;
input reg_en;
input [REG_DEPTH-1:0] data_in;
output reg [REG_DEPTH-1:0] data_out; 
output flag;
 //Internal variables
reg [REG_DEPTH:0] register;


// reg's content is expanded with the Write_or_read bit, which informs if it has been written or read in the current operation

assign flag = register[REG_DEPTH];
	
//Synch. Write	
always @(posedge rst, posedge clk)
begin
	if (rst) register <= 'h0; 
	else begin 
		if  (reg_en)  begin
		    register[REG_DEPTH]     <= wr_rd;
		    if (wr_rd==1) register[REG_DEPTH-1:0] <= data_in;
		end
	end
end	

//Asynch. Read
always @(wr_rd,reg_en) begin
	data_out <= {REG_DEPTH{1'bz}};
	if (reg_en) data_out <= wr_rd ? {REG_DEPTH{1'bz}}: register[REG_DEPTH-1:0];
end
endmodule
