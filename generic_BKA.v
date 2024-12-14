module generic_BKA #(parameter n = 64)(
    input          cin,  
    input  [n-1:0] a, b,
    output [n-1:0] sum,
    output         cout
);

    wire [n-1:0] r, f;   // Generate and propagate signals
    wire [n-1:0] r0, f0; // Intermediate signals
    wire [n:0]   c;      // Carry signals

    // Generate the initial propagate and generate signals
    gen_prop #(n) x0 (a, b, r, f);

    // Dynamic wires and prefix modules
    genvar i,j;
    generate
        for (i = 0; i < $clog2(n); i = i + 1) begin: w
            wire [((n/2) >> i) - 1:0] gmx, pmx,gmy,pmy; // Dynamic wires for each stage
        end
    endgenerate

    // First stage of the prefix tree
    prefix #(n) u0 (
        .g(r),
        .p(f),
        .g0(r0),
        .p0(f0),
        .gin(w[0].gmy),
        .pin(w[0].pmy), 
        .gout(w[0].gmx), // Assign first stage output to w[0]
        .pout(w[0].pmx)  // Assign first stage output to w[0]
    );

    // Intermediate stages of the prefix tree
    generate
        for (j = 1; j < $clog2(n)-1; j = j + 1) begin: prefix_tree
            prefix #(n >> j) u1 (
                .g(w[j-1].gmx), // Use previous stage's gm
                .p(w[j-1].pmx), // Use previous stage's pm
                .g0(w[j-1].gmy),  // Current stage's gm
                .p0(w[j-1].pmy),  // Current stage's pm
                .gin(w[j].gmy),       
                .pin(w[j].pmy),        
                .gout(w[j].gmx), // Output to next stage
                .pout(w[j].pmx)  // Output to next stage
            );
        end
    endgenerate
	 //Last stage
carry_op u5( 
 .g0(w[$clog2(n)-2].gmx[0]),
 .p0(w[$clog2(n)-2].pmx[0]),
 .g1(w[$clog2(n)-2].gmx[1]),
 .p1(w[$clog2(n)-2].pmx[1]),
 .gout0(w[$clog2(n)-2].gmy[0]),
 .pout0(w[$clog2(n)-2].pmy[0]),
 .gout1(w[$clog2(n)-2].gmy[1]),
 .pout1(w[$clog2(n)-2].pmy[1]) );
    // Carry computation
    assign c[0] = cin; // Initial carry
    generate
        for (i = 0; i < n; i = i + 1) begin: carry_compute
            assign c[i + 1] = r0[i] | (f0[i] & c[i]);
        end
    endgenerate

    // Compute sum and carry-out
    assign sum = f0 ^ c[n-1:0]; // Sum calculation
    assign cout = c[n];         // Final carry-out

endmodule
