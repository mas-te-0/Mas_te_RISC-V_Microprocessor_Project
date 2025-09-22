module nBinDECODER 
#(parameter n=4 )(
    input [$clog2(n)-1 : 0] s ,
    input En ,
    output reg [(n-1) : 0] w
);   
    always @(s,En) begin
            w= {n{1'b0}};
        if(En)
            w[s]=1'b1;
        
    end
endmodule