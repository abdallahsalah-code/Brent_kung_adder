module prefix #(parameter n=4)(
    input  [n-1:0] g,p,
    input  [(n/2)-1:0] gin,pin,
    output [n-1:0] g0,p0,
    output [(n/2)-1:0] gout,pout
);
    wire [n-1:0] gm0,pm0;
    genvar i;
    generate
        for(i=0; i<n; i=i+2) begin : gen
            carry_op c0 (g[i], p[i], g[i+1], p[i+1], gm0[i], pm0[i], gout[i/2], pout[i/2]);
            
           
            if(i < (n-2)) begin
                carry_op c1(gin[i/2], pin[i/2], gm0[i+2], pm0[i+2], g0[i+1], p0[i+1], g0[i+2], p0[i+2]);
            end
        end
    endgenerate
    assign g0[0] = gm0[0];
    assign p0[0] = pm0[0];
    assign g0[n-1] = gout[(n/2)-1];
    assign p0[n-1] = pout[(n/2)-1];

   
endmodule
