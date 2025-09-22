module nBinENCODER 
#(parameter n=4 )(
    input [(n-1) : 0] w,
    input En ,
    output reg [$clog2(n)-1 : 0] s
);   
        integer k;
    always @(w,En) begin
            s = {($clog2(n)){1'b0}};
        if(En)
            for (k = 0; k<n; k=k+1) begin
                if(w[k]) s=k;
            end
    end
endmodule