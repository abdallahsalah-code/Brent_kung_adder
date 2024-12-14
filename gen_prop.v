module gen_prop #(parameter width=64)(
input [width-1:0]x,y,
output [width-1:0]g,p
);
assign g = x & y;
assign p = x ^ y;
endmodule