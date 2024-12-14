`timescale 1ns / 1ps 
 
module tb_BKA(); 
 
    // Parameters 
    parameter N = 64; 
 
    // Inputs 
    reg [N-1:0] a; 
    reg [N-1:0] b; 
    reg cin; 
 
    // Outputs 
    wire [N-1:0] sum; 
    wire cout; 
 
    // Instantiate the Unit Under Test (UUT) 
    brent_kung_paralell_prefixAdder #(N) uut ( 
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum), 
        .cout(cout) 
    ); 
 
    initial begin 
        // Initialize Inputs 
        a = 0; 
        b = 0; 
        cin = 0; 
 
        // Apply test vectors 
 
        #10 a = 8'b00000001; b = 8'b00000001; cin = 0; // 1 + 1 = 2 
        #10 a = 8'b00001111; b = 8'b00000001; cin = 0; // 15 + 1 = 16 
        #10 a = 8'b11111111; b = 8'b00000001; cin = 0; // 255 + 1 = 256 
        #10 a = 8'b10101010; b = 8'b01010101; cin = 0; // 170 + 85 = 255 
        #10 a = 8'b11110000; b = 8'b00001111; cin = 1; // 240 + 15 + 1 = 256 
        #10 a = 8'b00000000; b = 8'b00000000; cin = 1; // 0 + 0 + 1 = 1 
 
        // Add more test cases as needed 
        #10 $stop; // Stop the simulation 
    end 
 
    initial begin 
        $monitor("At time %t, a = %b, b = %b, cin = %b, sum = %b, cout = %b", 
                 $time, a, b, cin, sum, cout); 
    end 
 
endmodule
