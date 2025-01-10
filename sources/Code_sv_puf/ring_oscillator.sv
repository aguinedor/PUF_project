`timescale 1ns/1ns

module ROs (
    input Enable, 
    output RO_OUT
);
reg ro_in_1;
integer time_delta;

// Assign RO_OUT to ro_in_1, so the output is the state of the oscillator
    assign RO_OUT = ro_in_1; 

    initial begin
        time_delta = $urandom_range(248, 252); // Generate random delay time
        ro_in_1 = 0; // Initial state of the oscillator (could be either 0 or 1)
        
        // Forever loop to toggle the oscillator signal with random delay
        forever begin
            #time_delta ro_in_1 = ~ro_in_1 & Enable;  // Toggle signal when 'Enable' is high
        end
    end

endmodule
