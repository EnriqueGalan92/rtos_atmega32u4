
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
	.DEF _timer0=R3
	.DEF _timer1=R5

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

_0x18:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x03
	.DW  _0x18*2

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
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
;unsigned int timer0 = 0, timer1 = 0;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)
; 0000 001E {

	.CSEG
_timer0_compa_isr:
	RCALL SUBOPT_0x0
; 0000 001F // Place your code here
; 0000 0020     timer0 = timer0 + 1;
	__ADDWRR 3,4,30,31
; 0000 0021     if (timer0 > 250)
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x3
; 0000 0022     {
; 0000 0023         timer0 = 0;
	CLR  R3
	CLR  R4
; 0000 0024     }
; 0000 0025 }
_0x3:
	RJMP _0x17
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0029 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 002A // Place your code here
; 0000 002B     timer1 = timer1 + 1;
	__ADDWRR 5,6,30,31
; 0000 002C     if (timer1 > 100)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x4
; 0000 002D     {
; 0000 002E         timer1 = 0;
	CLR  R5
	CLR  R6
; 0000 002F     }
; 0000 0030 }
_0x4:
_0x17:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 0035 {
_main:
; 0000 0036 // Declare your local variables here
; 0000 0037 
; 0000 0038 // Crystal Oscillator division factor: 1
; 0000 0039 #pragma optsize-
; 0000 003A CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 003B CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 003C #ifdef _OPTIMIZE_SIZE_
; 0000 003D #pragma optsize+
; 0000 003E #endif
; 0000 003F 
; 0000 0040 // Input/Output Ports initialization
; 0000 0041 // Port B initialization
; 0000 0042 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0043 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0044 PORTB=0x00;
	OUT  0x5,R30
; 0000 0045 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x4,R30
; 0000 0046 
; 0000 0047 // Port C initialization
; 0000 0048 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0049 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004A PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 004B DDRC=0x00;
	OUT  0x7,R30
; 0000 004C 
; 0000 004D // Port D initialization
; 0000 004E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0050 PORTD=0x00;
	OUT  0xB,R30
; 0000 0051 DDRD=0x00;
	OUT  0xA,R30
; 0000 0052 
; 0000 0053 // Port E initialization
; 0000 0054 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0055 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0056 PORTE=0x00;
	OUT  0xE,R30
; 0000 0057 DDRE=0x00;
	OUT  0xD,R30
; 0000 0058 
; 0000 0059 // Port F initialization
; 0000 005A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005C PORTF=0x00;
	OUT  0x11,R30
; 0000 005D DDRF=0x00;
	OUT  0x10,R30
; 0000 005E 
; 0000 005F // PLL initialization
; 0000 0060 // PLL Enabled: Off
; 0000 0061 PLLCSR=0x00;
	OUT  0x29,R30
; 0000 0062 PLLFRQ=0x00;
	OUT  0x32,R30
; 0000 0063 
; 0000 0064 // Timer/Counter 0 initialization
; 0000 0065 // Clock source: System Clock
; 0000 0066 // Clock value: 31.250 kHz
; 0000 0067 // Mode: CTC top=OCR0A
; 0000 0068 // OC0A output: Disconnected
; 0000 0069 // OC0B output: Disconnected
; 0000 006A TCCR0A=0x02;
	LDI  R30,LOW(2)
	OUT  0x24,R30
; 0000 006B TCCR0B=0x04;
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 006C TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 006D OCR0A=0xFA;
	LDI  R30,LOW(250)
	OUT  0x27,R30
; 0000 006E OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 006F 
; 0000 0070 // Timer/Counter 1 initialization
; 0000 0071 // Clock source: System Clock
; 0000 0072 // Clock value: 31.250 kHz
; 0000 0073 // Mode: Normal top=0xFFFF
; 0000 0074 // OC1A output: Discon.
; 0000 0075 // OC1B output: Discon.
; 0000 0076 // OC1C output: Discon.
; 0000 0077 // Noise Canceler: Off
; 0000 0078 // Input Capture on Falling Edge
; 0000 0079 // Timer1 Overflow Interrupt: On
; 0000 007A // Input Capture Interrupt: Off
; 0000 007B // Compare A Match Interrupt: Off
; 0000 007C // Compare B Match Interrupt: Off
; 0000 007D // Compare C Match Interrupt: Off
; 0000 007E TCCR1A=0x00;
	STS  128,R30
; 0000 007F TCCR1B=0x04;
	LDI  R30,LOW(4)
	STS  129,R30
; 0000 0080 TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0081 TCNT1L=0x00;
	STS  132,R30
; 0000 0082 ICR1H=0x00;
	STS  135,R30
; 0000 0083 ICR1L=0x00;
	STS  134,R30
; 0000 0084 OCR1AH=0x00;
	STS  137,R30
; 0000 0085 OCR1AL=0x00;
	STS  136,R30
; 0000 0086 OCR1BH=0x00;
	STS  139,R30
; 0000 0087 OCR1BL=0x00;
	STS  138,R30
; 0000 0088 OCR1CH=0x00;
	STS  141,R30
; 0000 0089 OCR1CL=0x00;
	STS  140,R30
; 0000 008A 
; 0000 008B // Timer/Counter 3 initialization
; 0000 008C // Clock source: System Clock
; 0000 008D // Clock value: Timer3 Stopped
; 0000 008E // Mode: Normal top=0xFFFF
; 0000 008F // OC3A output: Discon.
; 0000 0090 // OC3B output: Discon.
; 0000 0091 // OC3C output: Discon.
; 0000 0092 // Noise Canceler: Off
; 0000 0093 // Input Capture on Falling Edge
; 0000 0094 // Timer3 Overflow Interrupt: Off
; 0000 0095 // Input Capture Interrupt: Off
; 0000 0096 // Compare A Match Interrupt: Off
; 0000 0097 // Compare B Match Interrupt: Off
; 0000 0098 // Compare C Match Interrupt: Off
; 0000 0099 TCCR3A=0x00;
	STS  144,R30
; 0000 009A TCCR3B=0x00;
	STS  145,R30
; 0000 009B TCNT3H=0x00;
	STS  149,R30
; 0000 009C TCNT3L=0x00;
	STS  148,R30
; 0000 009D ICR3H=0x00;
	STS  151,R30
; 0000 009E ICR3L=0x00;
	STS  150,R30
; 0000 009F OCR3AH=0x00;
	STS  153,R30
; 0000 00A0 OCR3AL=0x00;
	STS  152,R30
; 0000 00A1 OCR3BH=0x00;
	STS  155,R30
; 0000 00A2 OCR3BL=0x00;
	STS  154,R30
; 0000 00A3 OCR3CH=0x00;
	STS  157,R30
; 0000 00A4 OCR3CL=0x00;
	STS  156,R30
; 0000 00A5 
; 0000 00A6 // Timer/Counter 4 initialization
; 0000 00A7 // Clock: Timer4 Stopped
; 0000 00A8 // Mode: Normal top=OCR4C
; 0000 00A9 // OC4A output: OC4A=Disc. /OC4A=Disc.
; 0000 00AA // OC4B output: OC4B=Disc. /OC4B=Disc.
; 0000 00AB // OC4D output: OC4D=Disc. /OC4D=Disc.
; 0000 00AC // Fault Protection: Off
; 0000 00AD // Fault Protection Noise Canceler: Off
; 0000 00AE // Fault Protection triggered on Falling Edge
; 0000 00AF // Timer4 Overflow Interrupt: Off
; 0000 00B0 // Compare A Match Interrupt: Off
; 0000 00B1 // Compare B Match Interrupt: Off
; 0000 00B2 // Compare D Match Interrupt: Off
; 0000 00B3 // Fault Protection Interrupt: Off
; 0000 00B4 // Dead Time Prescaler: 1
; 0000 00B5 // Dead Time Rising Edge: 0.000 us
; 0000 00B6 // Dead Time Falling Edge: 0.000 us
; 0000 00B7 
; 0000 00B8 // Set Timer4 synchronous operation
; 0000 00B9 PLLFRQ&=0xcf;
	IN   R30,0x32
	ANDI R30,LOW(0xCF)
	OUT  0x32,R30
; 0000 00BA 
; 0000 00BB TCCR4A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 00BC TCCR4B=0x00;
	STS  193,R30
; 0000 00BD TCCR4C=0x00;
	STS  194,R30
; 0000 00BE TCCR4D=0x00;
	STS  195,R30
; 0000 00BF TC4H=0x00;
	RCALL SUBOPT_0x1
; 0000 00C0 TCNT4=0x00;
	STS  190,R30
; 0000 00C1 TC4H=0x00;
	RCALL SUBOPT_0x1
; 0000 00C2 OCR4A=0x00;
	STS  207,R30
; 0000 00C3 TC4H=0x00;
	RCALL SUBOPT_0x1
; 0000 00C4 OCR4B=0x00;
	STS  208,R30
; 0000 00C5 TC4H=0x00;
	RCALL SUBOPT_0x1
; 0000 00C6 OCR4C=0x00;
	STS  209,R30
; 0000 00C7 TC4H=0x00;
	RCALL SUBOPT_0x1
; 0000 00C8 OCR4D=0x00;
	STS  210,R30
; 0000 00C9 DT4=0x00;
	LDI  R30,LOW(0)
	STS  212,R30
; 0000 00CA 
; 0000 00CB // External Interrupt(s) initialization
; 0000 00CC // INT0: Off
; 0000 00CD // INT1: Off
; 0000 00CE // INT2: Off
; 0000 00CF // INT3: Off
; 0000 00D0 // INT6: Off
; 0000 00D1 EICRA=0x00;
	STS  105,R30
; 0000 00D2 EICRB=0x00;
	STS  106,R30
; 0000 00D3 EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00D4 // PCINT0 interrupt: Off
; 0000 00D5 // PCINT1 interrupt: Off
; 0000 00D6 // PCINT2 interrupt: Off
; 0000 00D7 // PCINT3 interrupt: Off
; 0000 00D8 // PCINT4 interrupt: Off
; 0000 00D9 // PCINT5 interrupt: Off
; 0000 00DA // PCINT6 interrupt: Off
; 0000 00DB // PCINT7 interrupt: Off
; 0000 00DC PCMSK0=0x00;
	STS  107,R30
; 0000 00DD PCICR=0x00;
	STS  104,R30
; 0000 00DE 
; 0000 00DF // Timer/Counter 0 Interrupt(s) initialization
; 0000 00E0 TIMSK0=0x02;
	LDI  R30,LOW(2)
	STS  110,R30
; 0000 00E1 
; 0000 00E2 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00E3 TIMSK1=0x01;
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 00E4 
; 0000 00E5 // Timer/Counter 3 Interrupt(s) initialization
; 0000 00E6 TIMSK3=0x00;
	LDI  R30,LOW(0)
	STS  113,R30
; 0000 00E7 
; 0000 00E8 // Timer/Counter 4 Interrupt(s) initialization
; 0000 00E9 TIMSK4=0x00;
	STS  114,R30
; 0000 00EA 
; 0000 00EB // USART1 initialization
; 0000 00EC // USART1 disabled
; 0000 00ED UCSR1B=0x00;
	STS  201,R30
; 0000 00EE 
; 0000 00EF // Analog Comparator initialization
; 0000 00F0 // Analog Comparator: Off
; 0000 00F1 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00F2 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00F3 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00F4 DIDR1=0x00;
	STS  127,R30
; 0000 00F5 
; 0000 00F6 // ADC initialization
; 0000 00F7 // ADC disabled
; 0000 00F8 ADCSRA=0x00;
	STS  122,R30
; 0000 00F9 
; 0000 00FA // SPI initialization
; 0000 00FB // SPI disabled
; 0000 00FC SPCR=0x00;
	OUT  0x2C,R30
; 0000 00FD 
; 0000 00FE // TWI initialization
; 0000 00FF // TWI disabled
; 0000 0100 TWCR=0x00;
	STS  188,R30
; 0000 0101 
; 0000 0102 // USB Controller initialization
; 0000 0103 // USB Mode: Disabled
; 0000 0104 // USB Pad Regulator: Off
; 0000 0105 // OTG (VBUS) Pad: Off
; 0000 0106 // VBUS Transition interrupt: Off
; 0000 0107 UHWCON=0x00;
	STS  215,R30
; 0000 0108 USBCON=0x00;
	STS  216,R30
; 0000 0109 USBINT=0; // Clear the interrupt flag
	STS  218,R30
; 0000 010A 
; 0000 010B // Global enable interrupts
; 0000 010C #asm("sei")
	sei
; 0000 010D 
; 0000 010E while (1)
_0x5:
; 0000 010F       {
; 0000 0110       // Place your code here
; 0000 0111           if (timer0 <= 125)
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	CP   R30,R3
	CPC  R31,R4
	BRLO _0x8
; 0000 0112           {
; 0000 0113             PORTB.0 = 1;
	SBI  0x5,0
; 0000 0114           }
; 0000 0115           else if (timer0 > 125)
	RJMP _0xB
_0x8:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0xC
; 0000 0116           {
; 0000 0117             PORTB.0 = 0;
	CBI  0x5,0
; 0000 0118           }
; 0000 0119 
; 0000 011A           if (timer1 <= 50)
_0xC:
_0xB:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R5
	CPC  R31,R6
	BRLO _0xF
; 0000 011B           {
; 0000 011C             PORTB.1 = 1;
	SBI  0x5,1
; 0000 011D           }
; 0000 011E           else if (timer1 > 50)
	RJMP _0x12
_0xF:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R5
	CPC  R31,R6
	BRSH _0x13
; 0000 011F           {
; 0000 0120             PORTB.1 = 0;
	CBI  0x5,1
; 0000 0121           }
; 0000 0122       }
_0x13:
_0x12:
	RJMP _0x5
; 0000 0123 }
_0x16:
	RJMP _0x16

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
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