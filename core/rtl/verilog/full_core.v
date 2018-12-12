module full_core (
 // Outputs
 per_dout_dma_dev0,
 // Inputs 
 cpu_en,          // Enable CPU code execution (asynchronous)
 dbg_en,          // Debug interface enable (asynchronous)
 dbg_uart_rxd,    // Debug interface: UART RXD (asynchronous)
 dmem_dout,       // Data Memory data output
 irq_in,          // Maskable interrupts
 lfxt_clk,        // Low frequency oscillator (typ 32kHz)
 nmi,             // Non-maskable interrupt (asynchronous)
 per_dout,        // Peripheral data output
 pmem_dout,       // Program Memory data output
 reset_n,         // Reset Pin (low active, asynchronous)
 scan_enable,     // ASIC ONLY: Scan enable (active during scan shifting)
 scan_mode:       // ASIC ONLY: Scan mode
 wkup_in,         // ASIC ONLY: System Wake-up (asynchronous)

);

parameter FIFO_DEPTH = 5;
parameter ADD_LEN = 15;
parameter DATA_LEN = 16;

output per_dout_dma_dev0;

input cpu_en;          // Enable CPU code execution (asynchronous)
input dbg_en;          // Debug interface enable (asynchronous)
input dbg_uart_rxd;    // Debug interface: UART RXD (asynchronous)
input dmem_dout;       // Data Memory data output
input irq_in;          // Maskable interrupts
input lfxt_clk;        // Low frequency oscillator (typ 32kHz)
input nmi;             // Non-maskable interrupt (asynchronous)
input per_dout;        // Peripheral data output
input pmem_dout;       // Program Memory data output
input reset_n;         // Reset Pin (low active, asynchronous)
input scan_enable;     // ASIC ONLY: Scan enable (active during scan shifting)
input scan_mode:       // ASIC ONLY: Scan mode
input wkup_in;         // ASIC ONLY: System Wake-up (asynchronous)


// Direct Memory Access interface
wire [15:0] dma_dout;
wire        dma_ready;
wire        dma_resp;
wire [15:1] dma_addr;
wire [15:0] dma_din;
wire        dma_en;
wire        dma_priority;
wire  [1:0] dma_we;
wire        dma_wkup;


// DMA Device
wire [14:0] dma_num_words;
wire [15:0]	dma_start_address;
wire        dma_error_flag;
wire 		dma_rd_wr;
wire		dma_rqst;
wire		dev_ack;
wire [15:0]	dev_out;
wire		dma_ack;
wire [15:0]	dev_in;
wire		dma_end_flag;
wire [15:0] per_dout_dma_dev0;


// ============================
// Instatiation of components
// ============================


openMSP430 openMSP (
// OUTPUTs
    .aclk         (aclk),              // ASIC ONLY: ACLK
    .aclk_en      (aclk_en),           // FPGA ONLY: ACLK enable
    .dbg_freeze   (dbg_freeze),        // Freeze peripherals
    .dbg_uart_txd (dbg_uart_txd),      // Debug interface: UART TXD
    .dco_enable   (dco_enable),        // ASIC ONLY: Fast oscillator enable
    .dco_wkup     (dco_wkup),          // ASIC ONLY: Fast oscillator wake-up (asynchronous)
    .dmem_addr    (dmem_addr),         // Data Memory address
    .dmem_cen     (dmem_cen),          // Data Memory chip enable (low active)
    .dmem_din     (dmem_din),          // Data Memory data input
    .dmem_wen     (dmem_wen),          // Data Memory write enable (low active)
    .irq_acc      (irq_acc),           // Interrupt request accepted (one-hot signal)
    .lfxt_enable  (lfxt_enable),       // ASIC ONLY: Low frequency oscillator enable
    .lfxt_wkup    (lfxt_wkup),         // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
    .mclk         (mclk),              // Main system clock
    .dma_dout     (dma_dout),          // Direct Memory Access data output
    .dma_ready    (dma_ready),         // Direct Memory Access is complete
    .dma_resp     (dma_resp),          // Direct Memory Access response (0:Okay / 1:Error)
    .per_addr     (per_addr),          // Peripheral address
    .per_din      (per_din),           // Peripheral data input
    .per_we       (per_we),            // Peripheral write enable (high active)
    .per_en       (per_en),            // Peripheral enable (high active)
    .pmem_addr    (pmem_addr),         // Program Memory address
    .pmem_cen     (pmem_cen),          // Program Memory chip enable (low active)
    .pmem_din     (pmem_din),          // Program Memory data input (optional)
    .pmem_wen     (pmem_wen),          // Program Memory write enable (low active) (optional)
    .puc_rst      (puc_rst),           // Main system reset
    .smclk        (smclk),             // ASIC ONLY: SMCLK
    .smclk_en     (smclk_en),          // FPGA ONLY: SMCLK enable
    .spm_violation (sm_violation),
    .dma_violation (dma_violation),

// INPUTs
    .cpu_en       (cpu_en),            // Enable CPU code execution (asynchronous)
    .dbg_en       (dbg_en),            // Debug interface enable (asynchronous)
    .dbg_uart_rxd (dbg_uart_rxd),      // Debug interface: UART RXD (asynchronous)
    .dco_clk      (dco_clk),           // Fast oscillator (fast clock)
    .dmem_dout    (dmem_dout),         // Data Memory data output
    .irq          (irq_in),            // Maskable interrupts
    .lfxt_clk     (lfxt_clk),          // Low frequency oscillator (typ 32kHz)
    .dma_addr     (dma_addr),          // Direct Memory Access address
    .dma_din      (dma_din),           // Direct Memory Access data input
    .dma_en       (dma_en),            // Direct Memory Access enable (high active)
    .dma_priority (dma_priority),      // Direct Memory Access priority (0:low / 1:high)
    .dma_we       (dma_we),            // Direct Memory Access write byte enable (high active)
    .dma_wkup     (dma_wkup),          // ASIC ONLY: DMA Sub-System Wake-up (asynchronous and non-glitchy)
    .nmi          (nmi),               // Non-maskable interrupt (asynchronous)
    .per_dout     (per_dout),          // Peripheral data output
    .pmem_dout    (pmem_dout),         // Program Memory data output
    .reset_n      (reset_n),           // Reset Pin (low active, asynchronous)
    .scan_enable  (scan_enable),       // ASIC ONLY: Scan enable (active during scan shifting)
    .scan_mode	  (scan_mode),         // ASIC ONLY: Scan mode
    .wkup         (|wkup_in)           // ASIC ONLY: System Wake-up (asynchronous)
);



//
// DMA Controller
//----------------------------------
dma_controller #( .ADD_LEN(ADD_LEN),
				  .DATA_LEN(DATA_LEN),
				  .FIFO_DEPTH(FIFO_DEPTH))	
	dma_cntrl (
	// Outputs to Device
	.dma_ack		(dma_ack),
	.end_flag		(dma_end_flag),
	.error_flag     (dma_error_flag),
	.dev_out		(dev_in),
	// Outputs to OpenMSP430
	.dma_addr		(dma_addr),
	.dma_out		(dma_din),
	.dma_en			(dma_en),
	.dma_priority	(dma_priority),
	.dma_we			(dma_we),
	// Inputs from Device
	.num_words		(dma_num_words),
	.start_addr		(dma_start_address),
	.rd_wr			(dma_rd_wr),
	.rqst			(dma_rqst),
	.dev_ack		(dev_ack),
	.dev_in			(dev_out),	
	// Inputs from OpenMSP430
	.dma_in			(dma_dout),
	.dma_ready		(dma_ready), 
	.dma_resp		(dma_resp),
	.clk			(mclk),
	.reset			(puc_rst)	
	);
	
//
// Simple DMA Device
//----------------------------------
simple_dma_device dma_dev0 (
	// OUTPUTs to uP 
    .per_dout		(per_dout_dma_dev0),// Peripheral data output
	// OUTPUTs to DMA
	.dev_ack		(dev_ack),	// Ackowledge for the 2-phase handshake
	.dev_out		(dev_out),			// Output to DMA in write op.
	.dma_num_words	(dma_num_words),	// Number of words to be read
	.dma_rd_wr		(dma_rd_wr),		// Read or write request
	.dma_rqst		(dma_rqst),			// DMA op. request
	.dma_start_address (dma_start_address), // Starting address for DMA op.
	// INPUTs from uP
    .clk		    (mclk),		// Main system clock
    .reset			(puc_rst),	// Main system reset
	.per_addr       (per_addr), // Peripheral address
    .per_din        (per_din),  // Peripheral data input
    .per_en         (per_en),   // Peripheral enable (high active)
    .per_we         (per_we),   // Peripheral write enable (high active)
    // INPUTs from DMA
	.dev_in			(dev_in),
	.dma_ack		(dma_ack),
	.dma_end_flag	(dma_end_flag),
	.dma_error_flag (dma_error_flag)
	);	


endmodule
