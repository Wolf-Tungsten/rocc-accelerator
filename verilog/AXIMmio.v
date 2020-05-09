 module AXIMmio ( 
   input clock,   
   input reset,    

   input uart_RX,
   output uart_TX,
   
   output        io_axi4_0_aw_ready, 
   input         io_axi4_0_aw_valid, 
   input  [3:0]  io_axi4_0_aw_id, 
   input  [30:0] io_axi4_0_aw_addr, 
   input  [7:0]  io_axi4_0_aw_len, 
   input  [2:0]  io_axi4_0_aw_size, 
   input  [1:0]  io_axi4_0_aw_burst, 
   output        io_axi4_0_w_ready, 
   input         io_axi4_0_w_valid, 
   input  [31:0] io_axi4_0_w_data, 
   input  [7:0]  io_axi4_0_w_strb, 
   input         io_axi4_0_w_last, 
   input         io_axi4_0_b_ready, 
   output        io_axi4_0_b_valid, 
   output [3:0]  io_axi4_0_b_id, 
   output [1:0]  io_axi4_0_b_resp, 
   output        io_axi4_0_ar_ready, 
   input         io_axi4_0_ar_valid, 
   input  [3:0]  io_axi4_0_ar_id, 
   input  [30:0] io_axi4_0_ar_addr, 
   input  [7:0]  io_axi4_0_ar_len, 
   input  [2:0]  io_axi4_0_ar_size, 
   input  [1:0]  io_axi4_0_ar_burst, 
   input         io_axi4_0_r_ready, 
   output        io_axi4_0_r_valid, 
   output [3:0]  io_axi4_0_r_id, 
   output [31:0] io_axi4_0_r_data, 
   output [1:0]  io_axi4_0_r_resp, 
   output        io_axi4_0_r_last,
   
   output        interrupt_uart
 );

   wire resetn;
   assign resetn = ~ reset;

   uart uart_inst(

       .uart_axi4_aw_ready (io_axi4_0_aw_ready    ),
       .uart_axi4_aw_valid (io_axi4_0_aw_valid   ),
       .uart_axi4_aw_id    (io_axi4_0_aw_id    ),
       .uart_axi4_aw_addr  (io_axi4_0_aw_addr ),
       .uart_axi4_aw_len   (io_axi4_0_aw_len    ),
       .uart_axi4_aw_size  (io_axi4_0_aw_size[2:0]   ),
       .uart_axi4_aw_burst (io_axi4_0_aw_burst[1:0]  ),
       .uart_axi4_w_ready  (io_axi4_0_w_ready     ),
       .uart_axi4_w_valid  (io_axi4_0_w_valid     ),
       .uart_axi4_w_data   (io_axi4_0_w_data   ),
       .uart_axi4_w_strb   (io_axi4_0_w_strb[7:0]    ),
       .uart_axi4_w_last   (io_axi4_0_w_last     ),
       .uart_axi4_b_ready  (io_axi4_0_b_ready    ),
       .uart_axi4_b_valid  (io_axi4_0_b_valid     ),
       .uart_axi4_b_id     (io_axi4_0_b_id[3:0]      ),
       .uart_axi4_b_resp   (io_axi4_0_b_resp[1:0]    ),
       .uart_axi4_ar_ready (io_axi4_0_ar_ready    ),
       .uart_axi4_ar_valid (io_axi4_0_ar_valid    ),
       .uart_axi4_ar_id    (io_axi4_0_ar_id[3:0]     ),
       .uart_axi4_ar_addr  (io_axi4_0_ar_addr[30:0]  ),
       .uart_axi4_ar_len   (io_axi4_0_ar_len[7:0]    ),
       .uart_axi4_ar_size  (io_axi4_0_ar_size[2:0]   ),
       .uart_axi4_ar_burst (io_axi4_0_ar_burst[1:0]  ),
       .uart_axi4_r_ready  (io_axi4_0_r_ready     ),
       .uart_axi4_r_valid  (io_axi4_0_r_valid     ),
       .uart_axi4_r_id     (io_axi4_0_r_id[3:0]      ),
       .uart_axi4_r_data   (io_axi4_0_r_data[31:0]   ),
       .uart_axi4_r_resp   (io_axi4_0_r_resp[1:0]    ),
       .uart_axi4_r_last   (io_axi4_0_r_last      ),

       .clock(clock),
       .resetn(resetn),
       .uart_TX(uart_TX),
       .uart_RX(uart_RX),
       
       .interrupt(interrupt_uart)

       );

endmodule
