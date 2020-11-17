module OR2 (
    input wire A,
    input wire B,
    output wire Z
);

parameter Tpdlh = 1;
parameter Tpdhl = 1;

or #(Tpdlh, Tpdhl) or1 (Z, A, B);

endmodule
