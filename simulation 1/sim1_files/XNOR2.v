module XNOR2 (
    input wire A,
    input wire B,
    output wire Z
);

parameter Tpdlh = 1;
parameter Tpdhl = 1;

xnor #(Tpdlh, Tpdhl) xnor1 (Z, A, B);

endmodule
