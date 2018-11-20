 PRESERVE8
     THUMB
     AREA     appcode, CODE, READONLY
	 IMPORT printMsg	 
     EXPORT __main
	 ENTRY 
__main  FUNCTION

	VMOV.F32 S1, #5;x-Number to find e^x
	MOV R2, #20;Number of terms been considered in e^x expansion
	MOV R3, #1;count
	VMOV.F32 S3, #1;
	VMOV.F32 S4, #1; temp
	VMOV.F32 S5, #1; result
	VMOV.F32 S7, #1;register to hold one
	VMOV.F32 S11,#-10; Stores a constant value of -10
	VMOV.F32 S12,#10; Stores a constat value of 10
	VMOV.F32 S13, #7;Stores a constant value of 7
	VMOV.F32 S14, #8;Stores a constat value of 8
	VMOV.F32 S15, #6;Stores a constat value of 6
	VMOV.F32 S16, #2;Stores a constat value of 2
	VMOV.F32 S19, #5;Stores a constat value of 2
	VMOV.F32 S21, #3;Stores a constat value of 3
	VMOV.F32 S22, #1;Stores the value of x0
	VLDR.F32 S23,=1 ;Stores the value of x1
    VLDR.F32 S24,=1;Stores the value of x2

loop2	 MOV R4, #3;//stores a value of 1 in R4 logic_and
	 CMP R4, #0;Compare the value of R4 to 0 (case 0)
	 BEQ label1;
	 BNE temp1;
label1	 
       VDIV.F32 S10,S7,S11; S10 stores the value of weight0(W0)
       VDIV.F32 S17,S16,s12;S17 stores the value of weight1(W1)
	   VMOV.F32 S18,s17;S18 stores the value of weight1(W2)
	   VDIV.F32 S20,S16,S11; S20 holds the value of bias
	   B new
     
temp1	 CMP R4,#1;Compare the value of R4 to 1 (case 1) logic_or
	     BEQ label2;
		 BNE temp2;
label2
	  VDIV.F32 S10,S7,S11; S10 stores the value of weight0(W0)
      VDIV.F32 S17,S13,s12;S17 stores the value of weight1(W1)
	  VMOV.F32 S18,s17;S18 stores the value of weight1(W2)
	  VDIV.F32 S20,S7,S11; S20 holds the value of bias
	  B new
	
temp2	 CMP R4,#2;Compare the value of R4 to 2 (case 2) logic_not
	     BEQ label3;
		 BNE temp3;
label3
      VDIV.F32 S10,S19,S12; S10 stores the value of weight0(W0)
      VDIV.F32 S17,S13,s11;S17 stores the value of weight1(W1)
	  VDIV.F32 S20,S7,S12; S20 holds the value of bias
	  B new

temp3	  CMP R4,#3;Compare the value of R4 to 3 (case 3) logic_nand
	      BEQ label4;
		  BNE temp4;
label4
      VDIV.F32 S10,S15,S12; S10 stores the value of weight0(W0)
      VDIV.F32 S17,S13,s11;S17 stores the value of weight1(W1)
	  VMOV.F32 S18,s17;S18 stores the value of weight1(W2)
	  VDIV.F32 S20,S21,S12; S20 holds the value of bias
	  B new

temp4 CMP R4,#4;Compare the value of R4 to 4  (case 4) logic_xor
	  BEQ label5;
	  BNE temp5; 
label5
      VMOV.F32 S10,#-5; S10 stores the value of weight0(W0)
      VMOV.F32 S17,#20;S17 stores the value of weight1(W1)
	  VMOV.F32 S18,#10;S18 stores the value of weight1(W2)
	  VMOV.F32 S20,#1; S20 holds the value of bias
	  B new
   
temp5 CMP R4,#5;Compare the value of R4 to  5 (case 5) logic_xnor
	  BEQ label6;
	  B stop;
label6
      VMOV.F32 S10,#-5; S10 stores the value of weight0(W0)
      VMOV.F32 S17,#20;S17 stores the value of weight1(W1)
	  VMOV.F32 S18,#10;S18 stores the value of weight1(W2)
	  VMOV.F32 S20,#1; S20 holds the value of bias
      B new
new   VMUL.F32 S22,S10,S22;gives the result =X0*W0
      VMUL.F32 S23,S17,S23;gives the result =X1*W1
	  VMUL.F32 S24,S18,S24;gives the result =X2*W2
	  VADD.F32 S23,S22,S23;ADDS THE VALUE OF S22 AND S23 and stores it back in S23
	  VADD.F32 S24,S23,S24;ADDS THE VALUE OF S24 AND S23 and stores it back in S24
      VADD.F32 S25,S24,S20;ADDS VALUE OF S24(w0*x0+w1*x1+w2*x2) and s20(bias)
	  B Loop;
Loop 
	 CMP R2, R3;Comparison done for excuting taylor series expansion of e^x for s2 number of terms
	 BLT loop1;
	 VDIV.F32 S6, S25, S3; temp1=x/count
	 VMUL.F32 S4, S4, S6; temp=temp*temp1;
	 VADD.F32 S5, S5, S4; result=result+temp;
	 VADD.F32 S3, S3, S7; incrementing count
	 ADD R3,R3,#1;
	 B Loop; 
loop1
      VADD.F32 S8,S5,S7
      VDIV.F32 S9,S5,S8
      	  
	  B final
final
      VLDR.F32 S26,=0.5;
      VCMP.F32 S9, S26
	  VMRS.F32 APSR_nzcv,FPSCR;Used to copy fpscr to apsr
	  BLT zero_output
      BGT one_output
zero_output
      MOV R0,#0;
	  BL printMsg;
	  B stop;
one_output
      MOV R0,#1;
	  BL printMsg;
	  B stop
stop B stop ; stop program
	 ENDFUNC
	 END

