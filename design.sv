// Code your design here
module alu(o,a,b,sel);
  input [3:0]a,b;
  input [0:1]sel;
  output [9:0]o;
  wire [9:0]op1,op2;
  wire [0:3]o1,o2;
  reg  [9:0]op;
  assign o=op;
  reg [0:1]en;
  reg [9:0]d1,d2;
  initial begin
    d1=10'b0001010001;
    d2=10'b0001010001;
  end
  ccmul cm11(op2[9:0],d1[9:0],d2[9:0],1);
  cadd  ca11(op1[9:5],d1[9:5],d2[9:5],1);
  cadd  ca12(op1[4:0],d1[4:0],d2[4:0],1);
  
  always@(sel)
    begin
      if(sel==2'd0)
        begin
          op=op1;
        end
        
      if(sel==2'd1)
        begin
          op=op2;
        end
    end
  
endmodule
  
module cadd(in1,in2,op,en);
  input [4:0] in1,in2;
  input en;
  output reg[4:0] op;
always @* begin
  if(in1[4]==1 && in2[4]==1 && en)
begin
  op[4]<=1;
  op[3:0]<=in1[3:0]+in2[3:0];
end

  else if((in1[4]==1 && in2[4]==0)&&(in1[3:0]>=in2[3:0]) && en)
begin
  op[4]<=1;
  op[3:0]<=in1[3:0]+(~in2[3:0])+1;
end

  else if((in1[4]==1 && in2[4]==0)&&(in1[3:0]<in2[3:0]) && en)
begin
  op[4]<=0;
  op[3:0]<=~in1[3:0]+(in2[3:0])+1;
end

  else if((in1[4]==0 && in2[4]==1)&&(in1[3:0]>=in2[3:0]) && en)
begin
  op[4]<=0;
  op[3:0]<=in1[3:0]+(~in2[3:0])+1;
end

  else if((in1[4]==0 && in2[4]==1)&&(in1[3:0]<in2[3:0]) && en)
begin
  op[4]<=1;
  op[3:0]<=~in1[3:0]+(in2[3:0])+1;
end

  else if(en)
begin
  op[4]<=0;
  op[3:0]<=in1[3:0]+in2[3:0];
end

end
endmodule

module cmul(in1,in2,op,en);
  input [4:0]in1,in2;
  input en;
  output reg[4:0] op;
  always @(en)
        begin
          op[4]=in1[4]^in2[4];
          op[3:0]=in1[3:0]*in2[3:0];
        end

endmodule

module ccmul(i1,i2,op,en);
  input [9:0]i1,i2;
  input en;
  output reg[9:0] op;
  wire [4:0] o1,o2,o3,o4,o5,o6,o7,o8,o9;
  cadd a1(i1[4:0],i2[4:0],o1,en);
  cadd a2(i1[9:5],i2[9:5],o2,en);
  cadd a3(i1[4:0],{~i2[4],i2[3:0]},o3,en);
  cmul m1(i1[4:0],o2[4:0],o4[4:0],en);
  cmul m2(i1[9:5],o3[4:0],o5[4:0],en);
  cmul m3(i2[9:5],o1[4:0],o6[4:0],en);
  cadd a4(o4[4:0],{~o5[4],o5[3:0]},o7[4:0],en);
  cadd a5(o4[4:0],{~o6[4],o6[3:0]},o8[4:0],en);
  always@(en)
    begin
      op[9:0]={o8[4:0],o7[4:0]};
    end  
endmodule

module add(c,a,b,en);
  input [0:3]a,b;
  input en;
  output [0:3]c;
  reg [0:3] sum;
  assign c=sum;
  always@(en)
    begin
      sum=a+b;
    end
  
endmodule

module mul(c,a,b,en);
  input [0:3]a,b;
  input en;
  output [0:3]c;
  reg [0:3] sum;
  assign c=sum;
  always@(en)
    begin
      sum=a*b;
    end
  
endmodule
