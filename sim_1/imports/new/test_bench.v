`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 16:39:59
// Design Name: 
// Module Name: test_bench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_bench( );

reg [255:0]A;
reg [63:0]B;
wire [319:0]P;

initial
begin
    A=256'h89375212b2c2846546df998d06b97b0db1f056638484d609c0895e8112153524;
    B=64'h1e8dcd3d3b23f176;
end

booth_top u_boothtop(
    .A(A),
    .B(B),
    .P(P)
);
endmodule
