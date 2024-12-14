module carry_op (
    input  g0,p0,g1,p1,
    output gout0,pout0, gout1,pout1
);
// carry operator implementation

    assign gout1 =  g1 |  (g0 & p1);
    assign pout1 = p0 & p1;         
    assign gout0 = g0;
	 assign pout0 = p0;
endmodule
