module test;
  reg [0:3]a,b;
  reg [0:1]sel;
  wire [9:0] o;
  alu c(o,a,b,sel);
initial 
begin
$dumpfile("dump.vcd");
$dumpvars;
 a=4'd1;
 b=4'd2; 
 #10 sel=2'd1;
  
 a=4'd1;
 b=4'd2;
 #10 sel=2'd0;
end
  
initial 
  $monitor($time,"\tOutput op= %d",o);
  
  
endmodule