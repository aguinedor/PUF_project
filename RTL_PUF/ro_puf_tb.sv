`timescale 1ns/1ps

module tb_ro_puf_s7;
    localparam CLK_PERIOD = 80;   // around 12.5 MHz clock
    localparam BAUD_RATIO = 1250; // Ratio for 9600 bauds
    reg  clk;
    reg  reset_btn;
    wire led1, led2, led3, led4;
    reg  uart_rx;
    wire uart_tx;

// Data storage (2D array) for uart reception over time
    localparam NUM_TRANSACTIONS = 256;
    localparam SIZE_TRANSACTION = 64;
    localparam DATA_WIDTH       = 8;
    localparam NUM_UART_TRANS   = NUM_TRANSACTIONS * ( SIZE_TRANSACTION / DATA_WIDTH );

    reg [DATA_WIDTH-1:0]       received_data [0:NUM_UART_TRANS-1];
    bit [SIZE_TRANSACTION-1:0] RO_mux        [0:NUM_TRANSACTIONS-1];

// Design instantiation
    ro_puf_s7 dut (
        .clk(clk),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .led4(led4),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        .reset_btn(reset_btn)
    );

// Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        reset_btn = 1;
        uart_rx   = 1;
        repeat(5) wait@(posedge clk);
        reset_btn = 0;
    end

/* --------------------------------------------------------------------------------
 * UART TASK
 *  - send_uart()
 *  - collect_uart()
*/
    task send_uart(input [DATA_WIDTH-1:0] tx_data);
        integer i;
        begin
            uart_rx = 1'b0;                                 // Start bit
            repeat(BAUD_RATIO) wait@(posedge clk);
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                uart_rx = tx_data[i];                       // Send each data bit
                repeat(BAUD_RATIO) wait@(posedge clk);
            end
            uart_rx = 1'b1;                                 // Stop bit
            repeat(BAUD_RATIO) wait@(posedge clk);
        end
    endtask

    task collect_uart(output [DATA_WIDTH-1:0] rx_data);
        integer i;
        begin
            @(negedge uart_tx);                             // Wait for start bit
            repeat(BAUD_RATIO) wait@(posedge clk);          // Wait one baud cycle
            repeat(BAUD_RATIO/2) wait@(posedge clk);        // WAit 1/2 baud cycle to sample middle
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                rx_data[i] = uart_tx;                       // Collect each data bit
                repeat(BAUD_RATIO) wait@(posedge clk);
            end
            @(posedge uart_tx);                             // Wait for stop bit
        end
    endtask



/* --------------------------------------------------------------------------------
 * TB section
*/
    initial begin
        integer i;
        reg [DATA_WIDTH-1:0] tx_data;

        wait @(negedge reset_btn); // Wait for reset

        // Send first UART transaction to set the RO_PUF
        // [7]   -> activate         = 1
        // [6]   -> mode selection   = 0
        // [2:0] -> counter_wait     = 3
        send_uart(8'b1000_0011);

        // Gather data until no more
        for (i = 0; i < NUM_UART_TRANS; i = i + 1) begin
            collect_uart(received_data[i]);
        end

        // Rebuild data
        for (i = 0; i < $size(received_data); i = i + 1) begin
            // FIXME this probably won't work due to dynamic indexes on array
            RO_mux[$int(i/DATA_WIDTH)] = RO_mux[$int(i/DATA_WIDTH)] << DATA_WIDTH | received_data[i];
        end

        // Display data
        for (i = 0; i < $size(RO_mux); i = i + 1) begin
            $display("Transaction %0d: %0h", i, RO_mux[i]);
        end

        $finish;
    end

endmodule
