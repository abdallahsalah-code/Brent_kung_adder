module brent_kung_paralell_prefixAdder#(parameter n=64)(
    input          cin,  
	 input  [n-1:0] a,b,
    output [n-1:0] sum,
    output        cout
);
  wire [n-1:0]r,f;
  wire [n-1:0]r0,f0;
  wire [n:0] c;
 
  wire [31:0] gmx0, pmx0, gmy0, pmy0;
  wire [15:0] gmx1, pmx1, gmy1, pmy1;
  wire [7:0] gmx2, pmx2, gmy2, pmy2;
  wire [3:0] gmx3, pmx3, gmy3, pmy3;
  wire [1:0] gmx4, pmx4, gmy4, pmy4;
	
	 gen_prop #(64) x0(a,b,r,f);
	
	prefix #(64) u0(
.g(r),.p(f),
.g0(r0),.p0(f0),
.gin(gmy0),.pin(pmy0),
.gout(gmx0),.pout(pmx0)
);
prefix#(32) u1(
.g(gmx0),.p(pmx0),
.g0(gmy0),.p0(pmy0),
.gin(gmy1),.pin(pmy1),
.gout(gmx1),.pout(pmx1)
);
prefix#(16) u2(
.g(gmx1),.p(pmx1),
.g0(gmy1),.p0(pmy1),
.gin(gmy2),.pin(pmy2),
.gout(gmx2),.pout(pmx2)
);
prefix#(8) u3(
.g(gmx2),.p(pmx2),
.g0(gmy2),.p0(pmy2),
.gin(gmy3),.pin(pmy3),
.gout(gmx3),.pout(pmx3)
);
prefix#(4) u4(
.g(gmx3),.p(pmx3),
.g0(gmy3),.p0(pmy3),
.gin(gmy4),.pin(pmy4),
.gout(gmx4),.pout(pmx4)
);
carry_op u5(gmx4[0],pmx4[0],gmx4[1],pmx4[1]
,gmy4[0],pmy4[0],gmy4[1],pmy4[1]);

assign c[0] = cin;
genvar j;
generate 
for (j = 0; j < 64; j = j + 1) begin: carry_compute 
assign c[j+1] = r0[j] | (f0[j] & c[j]); // Compute carries
 end
 endgenerate 
 assign sum = f0 ^ c[n-1:0]; // Compute sum
 assign cout= c[n];
endmodule
	 