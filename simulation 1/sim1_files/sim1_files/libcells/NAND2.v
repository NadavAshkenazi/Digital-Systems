module NAND2 (
    input wire A,
    input wire B,
    output wire Z
);

parameter Tpdlh = 1;
parameter Tpdhl = 1;

nand #(Tpdlh, Tpdhl) nand1 (Z, A, B);

endmodule
