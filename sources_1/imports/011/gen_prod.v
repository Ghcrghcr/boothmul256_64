
module gen_prod #(
	parameter a_len = 256,
	parameter prod_len = 320
)
(
	input [a_len-1:0] A,
	input neg,
	input zero,
	input one,
	input two,
	output [prod_len-1:0] prod
);
reg [prod_len-1:0] prod_pre;


always @ (*) 
begin
	prod_pre = 0;
	if (zero)
		prod_pre = 0;
	else if (one)
		prod_pre = { { (prod_len-a_len){1'b0} }, A};		//prod_pre = { { (prod_len-a_len){A[a_len-1]} }, A};
	else if (two)
		prod_pre = { { (prod_len-a_len-1){1'b0} }, A, 1'b0};		//prod_pre = { { (prod_len-a_len-1){A[a_len-1]} }, A, 1'b0};
end

assign prod = neg ? ( ~prod_pre+1'b1 ) : prod_pre;
		
endmodule
