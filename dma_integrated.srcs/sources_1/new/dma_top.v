`timescale 1ns / 1ps

module dma_top (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] instr,
    input  wire [7:0] data_in,
    output wire done
);

    // control signals
    wire load_ctrl, load_addr, load_word, start;
    wire [1:0] word_inc;
    wire       addr_inc;

    // DMA state
    reg  dma_active;
    wire en_w = dma_active;
    wire en_a = dma_active;
    wire commit;
    wire WCI, ACI;
    

    // FIFO signals
    wire [7:0] fifo_wdata, fifo_rdata;
    wire fifo_wvalid, fifo_wready;
    wire fifo_rvalid, fifo_rready;


     //DMA LATCH
      always @(posedge clk) begin
      if(rst)
         dma_active <= 1'b0;
      else if (start) 
         dma_active <= 1'b1;
      else if (done)
          dma_active <= 1'b0;
      end
     
     
     
  
    instr_decoder u_dec (
        .clk       (clk),
        .rst       (rst),
        .instr     (instr),
        .load_ctrl (load_ctrl),
        .load_addr (load_addr),
        .load_word (load_word),
        .start     (start)
    );

  
    control u_ctrl (
        .clk       (clk),
        .rst       (rst),
        .load_ctrl (load_ctrl),
        .data_in   (data_in),
        .word_inc  (word_inc),
        .addr_inc  (addr_inc)
    );

   
    /* -----------------------------
       DMA source
    ----------------------------- */
    dma_source u_src (
        .clk    (clk),
        .rst    (rst),
        .en_w   (en_w),
        .wvalid (fifo_wvalid),
        .wready (fifo_wready),
        .wdata  (fifo_wdata)
    );

   
    fifo_2entry u_fifo (
        .clk    (clk),
        .rst    (rst),
        .wdata  (fifo_wdata),
        .wvalid (fifo_wvalid),
        .wready (fifo_wready),
        .rdata  (fifo_rdata),
        .rvalid (fifo_rvalid),
        .rready (fifo_rready)
    );

   
    dma_destination u_dst (
        .clk       (clk),
        .rst       (rst),
        .en_w      (en_w),
        .dst_valid (fifo_rvalid),
        .dst_data  (fifo_rdata),
        .dst_ready (fifo_rready)
    );

    
    assign commit = fifo_wvalid && fifo_wready;

   
    word_counter u_word_cnt (
        .clk      (clk),
        .rst      (rst),
        .load_w    (load_word),
        .en_w(en_w),
        .commit(commit),
        .data_in(data_in),
        .WCI(WCI)
        
    );

  
    address_counter u_addr_cnt (
        .clk      (clk),
        .rst      (rst),
        .en_a(en_a),
        .load_a(load_addr),
        .data_in(data_in),
        .addr_inc(addr_inc),
        .commit(commit),
        .ACI(ACI)
    );

   
    done_logic u_done (
    .clk (clk),
    .rst (rst),
    .en_w(en_w),
    .WCI (WCI),
    .commit(commit),
    .done(done)
);

endmodule



