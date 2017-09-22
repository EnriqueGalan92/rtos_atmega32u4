
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32U4
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 640 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32U4
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2815
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU WDTCSR=0x60
	.EQU UCSR1A=0xC8
	.EQU UDR1=0xCE
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x0AFF
	.EQU __DSTACK_SIZE=0x0280
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index1=R4
	.DEF _rx_rd_index1=R3
	.DEF _rx_counter1=R6
	.DEF _timer0=R7
	.DEF _timer1=R9
	.DEF _tx_wr_index1=R5
	.DEF _tx_rd_index1=R12
	.DEF _tx_counter1=R11

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  _timer0_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2C:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x07
	.DW  _0x2C*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x380

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 18/09/2017
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega32U4
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 640
;*****************************************************/
;
;#include <mega32u4.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
     .EQU __sm_adc_noise_red=0x02 // 26022010_1
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 8
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;#endif
;
;void putchar(char c);
;unsigned int timer0 = 0, timer1 = 0;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)
; 0000 004B {

	.CSEG
_timer0_compa_isr:
	CALL SUBOPT_0x0
; 0000 004C // Place your code here
; 0000 004D     timer0 = timer0 + 1;
	__ADDWRR 7,8,30,31
; 0000 004E     if (timer0 > 250)
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R7
	CPC  R31,R8
	BRSH _0x3
; 0000 004F     {
; 0000 0050         timer0 = 0;
	CLR  R7
	CLR  R8
; 0000 0051         putchar('A');
	LDI  R30,LOW(65)
	ST   -Y,R30
	RCALL _putchar
; 0000 0052     }
; 0000 0053 }
_0x3:
	RJMP _0x2B
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0057 {
_timer1_ovf_isr:
	CALL SUBOPT_0x0
; 0000 0058 // Place your code here
; 0000 0059     timer1 = timer1 + 1;
	__ADDWRR 9,10,30,31
; 0000 005A     if (timer1 > 100)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R9
	CPC  R31,R10
	BRSH _0x4
; 0000 005B     {
; 0000 005C         timer1 = 0;
	CLR  R9
	CLR  R10
; 0000 005D         putchar('p');
	LDI  R30,LOW(112)
	ST   -Y,R30
	RCALL _putchar
; 0000 005E     }
; 0000 005F }
_0x4:
_0x2B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 0067 {
_usart1_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0068 char status,data;
; 0000 0069 status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,200
; 0000 006A data=UDR1;
	LDS  R16,206
; 0000 006B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x5
; 0000 006C    {
; 0000 006D    rx_buffer1[rx_wr_index1++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 006E #if RX_BUFFER_SIZE1 == 256
; 0000 006F    // special case for receiver buffer size=256
; 0000 0070    if (++rx_counter1 == 0)
; 0000 0071       {
; 0000 0072 #else
; 0000 0073    if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x6
	CLR  R4
; 0000 0074    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x6:
	INC  R6
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x7
; 0000 0075       {
; 0000 0076       rx_counter1=0;
	CLR  R6
; 0000 0077 #endif
; 0000 0078       rx_buffer_overflow1=1;
	SBI  0x1E,0
; 0000 0079       }
; 0000 007A    }
_0x7:
; 0000 007B }
_0x5:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x2A
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART1 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0082 {
; 0000 0083 char data;
; 0000 0084 while (rx_counter1==0);
;	data -> R17
; 0000 0085 data=rx_buffer1[rx_rd_index1++];
; 0000 0086 #if RX_BUFFER_SIZE1 != 256
; 0000 0087 if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 0088 #endif
; 0000 0089 #asm("cli")
; 0000 008A --rx_counter1;
; 0000 008B #asm("sei")
; 0000 008C return data;
; 0000 008D }
;#pragma used-
;#endif
;
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 8
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
;#else
;unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
;#endif
;
;// USART1 Transmitter interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 009D {
_usart1_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 009E if (tx_counter1)
	TST  R11
	BREQ _0xE
; 0000 009F    {
; 0000 00A0    --tx_counter1;
	DEC  R11
; 0000 00A1    UDR1=tx_buffer1[tx_rd_index1++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	STS  206,R30
; 0000 00A2 #if TX_BUFFER_SIZE1 != 256
; 0000 00A3    if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0xF
	CLR  R12
; 0000 00A4 #endif
; 0000 00A5    }
_0xF:
; 0000 00A6 }
_0xE:
_0x2A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART1 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00AD {
_putchar:
; 0000 00AE while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
_0x10:
	LDI  R30,LOW(8)
	CP   R30,R11
	BREQ _0x10
; 0000 00AF #asm("cli")
	cli
; 0000 00B0 if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
	TST  R11
	BRNE _0x14
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BRNE _0x13
_0x14:
; 0000 00B1    {
; 0000 00B2    tx_buffer1[tx_wr_index1++]=c;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00B3 #if TX_BUFFER_SIZE1 != 256
; 0000 00B4    if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x16
	CLR  R5
; 0000 00B5 #endif
; 0000 00B6    ++tx_counter1;
_0x16:
	INC  R11
; 0000 00B7    }
; 0000 00B8 else
	RJMP _0x17
_0x13:
; 0000 00B9    UDR1=c;
	LD   R30,Y
	STS  206,R30
; 0000 00BA #asm("sei")
_0x17:
	sei
; 0000 00BB }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 00C6 {
_main:
; 0000 00C7 // Declare your local variables here
; 0000 00C8 
; 0000 00C9 // Crystal Oscillator division factor: 1
; 0000 00CA #pragma optsize-
; 0000 00CB CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00CC CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00CD #ifdef _OPTIMIZE_SIZE_
; 0000 00CE #pragma optsize+
; 0000 00CF #endif
; 0000 00D0 
; 0000 00D1 // Input/Output Ports initialization
; 0000 00D2 // Port B initialization
; 0000 00D3 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00D4 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 00D5 PORTB=0x00;
	OUT  0x5,R30
; 0000 00D6 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x4,R30
; 0000 00D7 
; 0000 00D8 // Port C initialization
; 0000 00D9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00DA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00DB PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 00DC DDRC=0x00;
	OUT  0x7,R30
; 0000 00DD 
; 0000 00DE // Port D initialization
; 0000 00DF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E1 PORTD=0x00;
	OUT  0xB,R30
; 0000 00E2 DDRD=0x00;
	OUT  0xA,R30
; 0000 00E3 
; 0000 00E4 // Port E initialization
; 0000 00E5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E7 PORTE=0x00;
	OUT  0xE,R30
; 0000 00E8 DDRE=0x00;
	OUT  0xD,R30
; 0000 00E9 
; 0000 00EA // Port F initialization
; 0000 00EB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00EC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00ED PORTF=0x00;
	OUT  0x11,R30
; 0000 00EE DDRF=0x00;
	OUT  0x10,R30
; 0000 00EF 
; 0000 00F0 // PLL initialization
; 0000 00F1 // PLL Enabled: Off
; 0000 00F2 PLLCSR=0x00;
	OUT  0x29,R30
; 0000 00F3 PLLFRQ=0x00;
	OUT  0x32,R30
; 0000 00F4 
; 0000 00F5 // Timer/Counter 0 initialization
; 0000 00F6 // Clock source: System Clock
; 0000 00F7 // Clock value: 31.250 kHz
; 0000 00F8 // Mode: CTC top=OCR0A
; 0000 00F9 // OC0A output: Disconnected
; 0000 00FA // OC0B output: Disconnected
; 0000 00FB TCCR0A=0x02;
	LDI  R30,LOW(2)
	OUT  0x24,R30
; 0000 00FC TCCR0B=0x04;
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 00FD TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00FE OCR0A=0xFA;
	LDI  R30,LOW(250)
	OUT  0x27,R30
; 0000 00FF OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 0100 
; 0000 0101 // Timer/Counter 1 initialization
; 0000 0102 // Clock source: System Clock
; 0000 0103 // Clock value: 31.250 kHz
; 0000 0104 // Mode: Normal top=0xFFFF
; 0000 0105 // OC1A output: Discon.
; 0000 0106 // OC1B output: Discon.
; 0000 0107 // OC1C output: Discon.
; 0000 0108 // Noise Canceler: Off
; 0000 0109 // Input Capture on Falling Edge
; 0000 010A // Timer1 Overflow Interrupt: On
; 0000 010B // Input Capture Interrupt: Off
; 0000 010C // Compare A Match Interrupt: Off
; 0000 010D // Compare B Match Interrupt: Off
; 0000 010E // Compare C Match Interrupt: Off
; 0000 010F TCCR1A=0x00;
	STS  128,R30
; 0000 0110 TCCR1B=0x04;
	LDI  R30,LOW(4)
	STS  129,R30
; 0000 0111 TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0112 TCNT1L=0x00;
	STS  132,R30
; 0000 0113 ICR1H=0x00;
	STS  135,R30
; 0000 0114 ICR1L=0x00;
	STS  134,R30
; 0000 0115 OCR1AH=0x00;
	STS  137,R30
; 0000 0116 OCR1AL=0x00;
	STS  136,R30
; 0000 0117 OCR1BH=0x00;
	STS  139,R30
; 0000 0118 OCR1BL=0x00;
	STS  138,R30
; 0000 0119 OCR1CH=0x00;
	STS  141,R30
; 0000 011A OCR1CL=0x00;
	STS  140,R30
; 0000 011B 
; 0000 011C // Timer/Counter 3 initialization
; 0000 011D // Clock source: System Clock
; 0000 011E // Clock value: Timer3 Stopped
; 0000 011F // Mode: Normal top=0xFFFF
; 0000 0120 // OC3A output: Discon.
; 0000 0121 // OC3B output: Discon.
; 0000 0122 // OC3C output: Discon.
; 0000 0123 // Noise Canceler: Off
; 0000 0124 // Input Capture on Falling Edge
; 0000 0125 // Timer3 Overflow Interrupt: Off
; 0000 0126 // Input Capture Interrupt: Off
; 0000 0127 // Compare A Match Interrupt: Off
; 0000 0128 // Compare B Match Interrupt: Off
; 0000 0129 // Compare C Match Interrupt: Off
; 0000 012A TCCR3A=0x00;
	STS  144,R30
; 0000 012B TCCR3B=0x00;
	STS  145,R30
; 0000 012C TCNT3H=0x00;
	STS  149,R30
; 0000 012D TCNT3L=0x00;
	STS  148,R30
; 0000 012E ICR3H=0x00;
	STS  151,R30
; 0000 012F ICR3L=0x00;
	STS  150,R30
; 0000 0130 OCR3AH=0x00;
	STS  153,R30
; 0000 0131 OCR3AL=0x00;
	STS  152,R30
; 0000 0132 OCR3BH=0x00;
	STS  155,R30
; 0000 0133 OCR3BL=0x00;
	STS  154,R30
; 0000 0134 OCR3CH=0x00;
	STS  157,R30
; 0000 0135 OCR3CL=0x00;
	STS  156,R30
; 0000 0136 
; 0000 0137 // Timer/Counter 4 initialization
; 0000 0138 // Clock: Timer4 Stopped
; 0000 0139 // Mode: Normal top=OCR4C
; 0000 013A // OC4A output: OC4A=Disc. /OC4A=Disc.
; 0000 013B // OC4B output: OC4B=Disc. /OC4B=Disc.
; 0000 013C // OC4D output: OC4D=Disc. /OC4D=Disc.
; 0000 013D // Fault Protection: Off
; 0000 013E // Fault Protection Noise Canceler: Off
; 0000 013F // Fault Protection triggered on Falling Edge
; 0000 0140 // Timer4 Overflow Interrupt: Off
; 0000 0141 // Compare A Match Interrupt: Off
; 0000 0142 // Compare B Match Interrupt: Off
; 0000 0143 // Compare D Match Interrupt: Off
; 0000 0144 // Fault Protection Interrupt: Off
; 0000 0145 // Dead Time Prescaler: 1
; 0000 0146 // Dead Time Rising Edge: 0.000 us
; 0000 0147 // Dead Time Falling Edge: 0.000 us
; 0000 0148 
; 0000 0149 // Set Timer4 synchronous operation
; 0000 014A PLLFRQ&=0xcf;
	IN   R30,0x32
	ANDI R30,LOW(0xCF)
	OUT  0x32,R30
; 0000 014B 
; 0000 014C TCCR4A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 014D TCCR4B=0x00;
	STS  193,R30
; 0000 014E TCCR4C=0x00;
	STS  194,R30
; 0000 014F TCCR4D=0x00;
	STS  195,R30
; 0000 0150 TC4H=0x00;
	CALL SUBOPT_0x1
; 0000 0151 TCNT4=0x00;
	STS  190,R30
; 0000 0152 TC4H=0x00;
	CALL SUBOPT_0x1
; 0000 0153 OCR4A=0x00;
	STS  207,R30
; 0000 0154 TC4H=0x00;
	CALL SUBOPT_0x1
; 0000 0155 OCR4B=0x00;
	STS  208,R30
; 0000 0156 TC4H=0x00;
	CALL SUBOPT_0x1
; 0000 0157 OCR4C=0x00;
	STS  209,R30
; 0000 0158 TC4H=0x00;
	CALL SUBOPT_0x1
; 0000 0159 OCR4D=0x00;
	STS  210,R30
; 0000 015A DT4=0x00;
	LDI  R30,LOW(0)
	STS  212,R30
; 0000 015B 
; 0000 015C // External Interrupt(s) initialization
; 0000 015D // INT0: Off
; 0000 015E // INT1: Off
; 0000 015F // INT2: Off
; 0000 0160 // INT3: Off
; 0000 0161 // INT6: Off
; 0000 0162 EICRA=0x00;
	STS  105,R30
; 0000 0163 EICRB=0x00;
	STS  106,R30
; 0000 0164 EIMSK=0x00;
	OUT  0x1D,R30
; 0000 0165 // PCINT0 interrupt: Off
; 0000 0166 // PCINT1 interrupt: Off
; 0000 0167 // PCINT2 interrupt: Off
; 0000 0168 // PCINT3 interrupt: Off
; 0000 0169 // PCINT4 interrupt: Off
; 0000 016A // PCINT5 interrupt: Off
; 0000 016B // PCINT6 interrupt: Off
; 0000 016C // PCINT7 interrupt: Off
; 0000 016D PCMSK0=0x00;
	STS  107,R30
; 0000 016E PCICR=0x00;
	STS  104,R30
; 0000 016F 
; 0000 0170 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0171 TIMSK0=0x02;
	LDI  R30,LOW(2)
	STS  110,R30
; 0000 0172 
; 0000 0173 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0174 TIMSK1=0x01;
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 0175 
; 0000 0176 // Timer/Counter 3 Interrupt(s) initialization
; 0000 0177 TIMSK3=0x00;
	LDI  R30,LOW(0)
	STS  113,R30
; 0000 0178 
; 0000 0179 // Timer/Counter 4 Interrupt(s) initialization
; 0000 017A TIMSK4=0x00;
	STS  114,R30
; 0000 017B 
; 0000 017C // USART1 initialization
; 0000 017D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 017E // USART1 Receiver: On
; 0000 017F // USART1 Transmitter: On
; 0000 0180 // USART1 Mode: Asynchronous
; 0000 0181 // USART1 Baud Rate: 56000
; 0000 0182 UCSR1A=0x00;
	STS  200,R30
; 0000 0183 UCSR1B=0xD8;
	LDI  R30,LOW(216)
	STS  201,R30
; 0000 0184 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  202,R30
; 0000 0185 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  205,R30
; 0000 0186 UBRR1L=0x08;
	LDI  R30,LOW(8)
	STS  204,R30
; 0000 0187 
; 0000 0188 // Analog Comparator initialization
; 0000 0189 // Analog Comparator: Off
; 0000 018A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 018B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 018C ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 018D DIDR1=0x00;
	STS  127,R30
; 0000 018E 
; 0000 018F // ADC initialization
; 0000 0190 // ADC disabled
; 0000 0191 ADCSRA=0x00;
	STS  122,R30
; 0000 0192 
; 0000 0193 // SPI initialization
; 0000 0194 // SPI disabled
; 0000 0195 SPCR=0x00;
	OUT  0x2C,R30
; 0000 0196 
; 0000 0197 // TWI initialization
; 0000 0198 // TWI disabled
; 0000 0199 TWCR=0x00;
	STS  188,R30
; 0000 019A 
; 0000 019B // USB Controller initialization
; 0000 019C // USB Mode: Disabled
; 0000 019D // USB Pad Regulator: Off
; 0000 019E // OTG (VBUS) Pad: Off
; 0000 019F // VBUS Transition interrupt: Off
; 0000 01A0 UHWCON=0x00;
	STS  215,R30
; 0000 01A1 USBCON=0x00;
	STS  216,R30
; 0000 01A2 USBINT=0; // Clear the interrupt flag
	STS  218,R30
; 0000 01A3 
; 0000 01A4 // Global enable interrupts
; 0000 01A5 #asm("sei")
	sei
; 0000 01A6 
; 0000 01A7 while (1)
_0x18:
; 0000 01A8       {
; 0000 01A9       // Place your code here
; 0000 01AA           if (timer0 <= 125)
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	CP   R30,R7
	CPC  R31,R8
	BRLO _0x1B
; 0000 01AB           {
; 0000 01AC             PORTB.0 = 1;
	SBI  0x5,0
; 0000 01AD           }
; 0000 01AE           else if (timer0 > 125)
	RJMP _0x1E
_0x1B:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	CP   R30,R7
	CPC  R31,R8
	BRSH _0x1F
; 0000 01AF           {
; 0000 01B0             PORTB.0 = 0;
	CBI  0x5,0
; 0000 01B1           }
; 0000 01B2 
; 0000 01B3           if (timer1 <= 50)
_0x1F:
_0x1E:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R9
	CPC  R31,R10
	BRLO _0x22
; 0000 01B4           {
; 0000 01B5             PORTB.1 = 1;
	SBI  0x5,1
; 0000 01B6           }
; 0000 01B7           else if (timer1 > 50)
	RJMP _0x25
_0x22:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R9
	CPC  R31,R10
	BRSH _0x26
; 0000 01B8           {
; 0000 01B9             PORTB.1 = 0;
	CBI  0x5,1
; 0000 01BA           }
; 0000 01BB       }
_0x26:
_0x25:
	RJMP _0x18
; 0000 01BC }
_0x29:
	RJMP _0x29
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
     .EQU __sm_adc_noise_red=0x02 // 26022010_1
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer1:
	.BYTE 0x8
_tx_buffer1:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  191,R30
	RET


	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
