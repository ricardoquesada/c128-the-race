;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Race: https://github.com/ricardoquesada/c128-the-race
;
; Game
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

;
; **** ZP FIELDS ****
;
f00 = $00
f20 = $20
f21 = $21
f34 = $34
f36 = $36
f45 = $45
f7E = $7E
f95 = $95
fB5 = $B5
fB7 = $B7
fC1 = $C1
;
; **** ZP ABSOLUTE ADRESSES ****
;
a00 = $00
a02 = $02
a05 = $05
a06 = $06
a0C = $0C
a18 = $18
a1B = $1B
a1C = $1C
a1D = $1D
a1E = $1E
a1F = $1F
a21 = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a27 = $27
a28 = $28
a29 = $29
a3A = $3A
a3C = $3C
a3E = $3E
a41 = $41
a42 = $42
a4C = $4C
a4E = $4E
a52 = $52
a53 = $53
a66 = $66
a6A = $6A
a6B = $6B
a6C = $6C
a6D = $6D
a6E = $6E
a6F = $6F
a70 = $70
a71 = $71
a72 = $72
a73 = $73
a74 = $74
a75 = $75
a76 = $76
a7C = $7C
a80 = $80
a81 = $81
a82 = $82
a83 = $83
a84 = $84
a85 = $85
a86 = $86
a87 = $87
a88 = $88
a89 = $89
a8A = $8A
a8B = $8B
a8C = $8C
a8D = $8D
a8E = $8E
a8F = $8F
a94 = $94
a95 = $95
a96 = $96
a97 = $97
a98 = $98
aA6 = $A6
aAA = $AA
aAB = $AB
aAC = $AC
aAD = $AD
aAE = $AE
aAF = $AF
aB0 = $B0
aB1 = $B1
aB9 = $B9
aBC = $BC
aC6 = $C6
aF1 = $F1
aFA = $FA
aFB = $FB
aFC = $FC
aFD = $FD
aFE = $FE
aFF = $FF
;
; **** ZP POINTERS ****
;
p00 = $00
p01 = $01
p03 = $03
p0F = $0F
p18 = $18
p20 = $20
p24 = $24
p26 = $26
p36 = $36
p42 = $42
p43 = $43
p44 = $44
p4C = $4C
p52 = $52
p53 = $53
p60 = $60
p61 = $61
p6A = $6A
p6C = $6C
p6E = $6E
p70 = $70
p72 = $72
p74 = $74
p80 = $80
p81 = $81
p82 = $82
p84 = $84
p85 = $85
p86 = $86
p88 = $88
p89 = $89
p8A = $8A
p8C = $8C
p8E = $8E
p99 = $99
pA2 = $A2
pC3 = $C3
pDC = $DC
pDE = $DE
pE3 = $E3
pFB = $FB
pFD = $FD
pFF = $FF
;
; **** FIELDS ****
;
f003C = $003C
f006E = $006E
f0400 = $0400
f0428 = $0428
f0429 = $0429
f044F = $044F
f0450 = $0450
f0477 = $0477
f049F = $049F
f04C7 = $04C7
f04EF = $04EF
f04F0 = $04F0
f04F1 = $04F1
f0517 = $0517
f053F = $053F
f0567 = $0567
f0568 = $0568
f0590 = $0590
f059A = $059A
f0630 = $0630
f063A = $063A
f0658 = $0658
f0680 = $0680
f0681 = $0681
f06A7 = $06A7
f06CF = $06CF
f06F7 = $06F7
f071F = $071F
f0747 = $0747
f0748 = $0748
f0749 = $0749
f076F = $076F
f0797 = $0797
f07BF = $07BF
f07C0 = $07C0
f0C0C = $0C0C
f0F80 = $0F80
f0FC0 = $0FC0
f30E0 = $30E0
f3C1A = $3C1A
f3C42 = $3C42
f3C60 = $3C60
f3DBD = $3DBD
f66BD = $66BD
f6E60 = $6E60
f6E7E = $6E7E
f83B3 = $83B3
f8991 = $8991
f99C3 = $99C3
fB1B1 = $B1B1
fBDBD = $BDBD
fC381 = $C381
fC399 = $C399
fD800 = $D800
fD900 = $D900
fDA00 = $DA00
fDB00 = $DB00
fDC3D = $DC3D
fE799 = $E799
fE7F3 = $E7F3
fEF3C = $EF3C
fF3F9 = $F3F9
fF8FC = $F8FC
fF9C1 = $F9C1
fF9F9 = $F9F9
fFCEC = $FCEC
fFCFE = $FCFE
fFEFE = $FEFE
fFFFF = $FFFF
;
; **** ABSOLUTE ADRESSES ****
;
a0100 = $0100
a0314 = $0314
a0315 = $0315
a0591 = $0591
a059B = $059B
a059C = $059C
a05A5 = $05A5
a05A6 = $05A6
a05A7 = $05A7
a05A8 = $05A8
a05A9 = $05A9
a05B2 = $05B2
a060C = $060C
a0631 = $0631
a063B = $063B
a063C = $063C
a0645 = $0645
a0646 = $0646
a0647 = $0647
a0648 = $0648
a0649 = $0649
a0652 = $0652
a07F8 = $07F8
a07F9 = $07F9
a07FA = $07FA
a07FB = $07FB
a07FC = $07FC
a07FD = $07FD
a07FE = $07FE
a0A00 = $0A00
a0A01 = $0A01
a0A04 = $0A04
a0A2C = $0A2C
a0B00 = $0B00
a0B01 = $0B01
a0B02 = $0B02
a0B03 = $0B03
a0C0D = $0C0D
a0FC3 = $0FC3
a0FC6 = $0FC6
a3130 = $3130
a3333 = $3333
a33CC = $33CC
a3A05 = $3A05
a4181 = $4181
a4445 = $4445
a4543 = $4543
a4942 = $4942
a4C49 = $4C49
a4C50 = $4C50
a4F44 = $4F44
a5254 = $5254
a606E = $606E
a6666 = $6666
a7878 = $7878
a7E76 = $7E76
aCCCC = $CCCC
aCCCD = $CCCD
aCD7D = $CD7D
aF8CC = $F8CC
aFCCC = $FCCC
aFF00 = $FF00
;
; **** POINTERS ****
;
p0000 = $0000
p0030 = $0030
p0038 = $0038
p0F00 = $0F00
p6067 = $6067
p7078 = $7078
pFA65 = $FA65
;
; **** EXTERNAL JUMPS ****
;
e0313 = $0313
e0914 = $0914
e0B14 = $0B14
e0B8A = $0B8A
e1013 = $1013
e436B = $436B
e436D = $436D
e4420 = $4420
e4520 = $4520
e4D49 = $4D49
e5243 = $5243
e5250 = $5250
e6041 = $6041
e8584 = $8584
e8A89 = $8A89
e8E20 = $8E20
e9392 = $9392
e9D20 = $9D20
eA520 = $A520
eAB20 = $AB20
eB120 = $B120
eC920 = $C920
eCDCC = $CDCC
eFF20 = $FF20
;
; **** PREDEFINED LABELS ****
;
ROM_CINT = $FF81
ROM_IOINIT = $FF84
ROM_RESTOR = $FF8A
ROM_KEY = $FF9F
ROM_CLOSEi = $FFC3
ROM_BSOUTi = $FFD2
ROM_CLALLi = $FFE7

        * = $1300

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void game_init()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export game_init
game_init:
        LDA #$0E
        STA $FF00    ;C128: MMU Configuration Register
        LDA #$00
        JSR s1EA0
j130A:  SEI
        LDA #$00
        STA $DC0E    ;CIA1: CIA Control Register A
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$32
        STA $D012    ;Raster Position
        LDA #$03
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$03
        STA $DC0D    ;CIA1: CIA Interrupt Control Register

        LDA #<irq_0
        STA $0314
        LDA #>irq_0
        STA $0315

        LDA #$C0
        STA a0A04
        CLI
        LDA #$0F
        STA $D015    ;Sprite display Enable
        LDA #$00
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        STA $D027    ;Sprite 0 Color
        STA $D028    ;Sprite 1 Color
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA $D017    ;Sprites Expand 2x Vertical (Y)

        LDA #$00                                        ; define sprite frame
        LDX #$00
@l0:    STA $0FC0,X
        INX
        CPX #$40
        BNE @l0

        LDA #$0F                                        ; cont. with sprite frame
        STA $0FC0
        STA $0FC3
        STA $0FC6

        LDX #$27                                        ; clear screen
@l1:    LDA #$00
        STA $0400,X
        STA $0568,X
        STA $0658,X
        STA $07C0,X
        DEX
        BPL @l1

        LDX #$00
@l2:    LDA f19C0,X
        STA $0590,X
        INX
        CPX #$C8
        BNE @l2

        LDA #$3F                                        ; sprite pointers
        STA $07F8                                       ; $3f = $fc0
        STA $07F9
        STA $07FA
        STA $07FB

        LDX #$18                                        ; init music
@l3:    LDA #$00
        STA $D400,X                                     ; Voice 1: Frequency Control - Low-Byte
        DEX
        BPL @l3 
        LDA #$0F
        STA $D418                                       ; Select Filter Mode and Volume
        NOP
        NOP
        NOP
        NOP
        NOP
        JSR e0B14
        JSR init_vars
        JSR s1900
j13AF:  JMP j13AF

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; init_vars
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
init_vars:
        LDA #$30
        STA $21
        STA $22
        STA $23
        LDA #$00
        STA a1E00
        STA a1E01
        STA a0B00
        STA a0B01
        STA $FF
        STA $FE
        STA $6A
        STA $6C
        STA $6E
        STA $70
        STA $72
        STA $74
        STA $24
        STA $26
        LDA #$30
        STA $6B
        LDA #$32
        STA $6D
        LDA #$34
        STA $6F
        LDA #$36
        STA $71
        LDA #$38
        STA $73
        LDA #$3A
        STA $75
        LDA #$3C
        STA $25
        LDA #$3E
        STA $27

        LDA #$58
        STA $D001    ;Sprite 0 Y Pos
        LDA #$80
        STA $D000    ;Sprite 0 X Pos
        LDA #$04
        STA $1F
        LDA #$70
        STA $D004    ;Sprite 2 X Pos
        LDA #$90
        STA $D005    ;Sprite 2 Y Pos
        LDA #$07
        STA $FA
        LDA #$00
        STA $28

        LDX #$27
@l0:    LDA f19C0,X
        STA $0400 + 40 * 10,X
        DEX
        BPL @l0
        RTS

        NOP
        NOP
j142A:  LDX #$27
@l0:    LDA f1A60,X
        STA $0400 + 40 * 14,X
        DEX
        BPL @l0
        LDA #$00
        STA $FD
        RTS

        NOP
        NOP
        NOP
        NOP

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_0()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_0:
        LDA #$81
        STA $D012    ;Raster Position
        NOP
        NOP
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$02
        STA $D021    ;Background Color 0

        LDA $FA
        AND #$C7
        STA $D016    ;VIC Control Register 2

        LDA #$01
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        LDA #<irq_1
        STA $0314
        LDA #>irq_1
        STA $0315

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        JSR s17B0
        JSR s15CC
        JMP $FF33    ;$FF33 Return From Interrupt

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_1:
        LDA #$AA
        STA $D012    ;Raster Position
        NOP
        NOP
        LDA #$14
        STA $D018    ;VIC Memory Control Register
        LDA #$00
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
        LDA #$C0
        STA $D016    ;VIC Control Register 2

        LDA #<irq_2
        STA $0314
        LDA #>irq_2
        STA $0315

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        JMP $FF33    ;$FF33 Return From Interrupt

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_2:
        lda #$12
        STA $D012    ;Raster Position
        NOP
        NOP
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$02
        STA $D021    ;Background Color 0
        LDA $D021    ;Background Color 0

        LDA $AA
        AND #$C7
        STA $D016    ;VIC Control Register 2

        LDA #$01
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        LDA #<irq_0
        STA $0314
        LDA #>irq_0
        STA $0315

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        JSR s15B0
        JSR s17CE
        JMP $FF33    ;$FF33 Return From Interrupt

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        .BYTE $33,$FF ;RLA (pFF),Y
        .BYTE $03,$EA ;SLO ($EA,X)
        NOP
        NOP
        NOP
        NOP
        NOP
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$10,$00 ;ISC $0010,X

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1500:  LDA $FF
        BNE @l0
        DEC $FB
        BMI @l1
@l0:    RTS

@l1:    LDA #$00
        STA $FB
@l2:    DEC $FA
        BMI @l3
        DEC $FC
        BPL @l2
        LDA a0B00
        STA aFB
        LDA a0B01
        STA aFC
        RTS

@l3:    LDA #$07
        STA $FA

        LDX #$00
@l4:    LDA $0429,X
        STA $0428,X
        INX
        CPX #$C7
        BNE @l4

        LDX #$00
@l5:    LDA f04F1,X
        STA f04F0,X
        INX
        CPX #$78
        BNE @l5

        LDA $6B
        CMP #$31
        BNE @l6
        LDA $6A
        CMP #$FF
        BEQ @l8
@l6:    CLC
        INC $6A
        INC $6C
        INC $6E
        INC $70
        INC $72
        INC $74
        INC $24
        INC $26
        BNE @l7
        INC $6B
        INC $6D
        INC $6F
        INC $71
        INC $73
        INC $75
        INC $25
        INC $27

@l7:    LDY #$00
        LDA ($6A),Y
        STA $044F,Y
        LDA ($6C),Y
        STA $0477,Y
        LDA ($6E),Y
        STA $049F,Y
        LDA ($70),Y
        STA $04C7,Y
        LDA ($72),Y
        STA $04EF,Y
        LDA ($74),Y
        STA $0517,Y
        LDA ($24),Y
        STA $053F,Y
        LDA ($26),Y
        STA $0567,Y

        INC $FD
        LDA $FD
        CMP #$04
        BEQ @l9
        RTS

@l9:    LDA #$00
        STA $FD
        INC $D004    ;Sprite 2 X Pos
        RTS

@l8:    LDA #$01
        STA $FE
        RTS

        .BYTE $FF,$00,$FF ;ISC aFF00,X

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s15B0:  LDA a1E00
        BNE b15B6
        RTS

b15B6:  JSR s1500
        JSR s1600
        JSR s16D0
        JSR s1AA6
        JSR s1AE0
        RTS

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s15CC:  JSR s1D30
        JSR s1D48
        JSR s1C10
        JSR s1C60
        JSR s1E50
        JSR s1E75
        RTS

        .BYTE $FF,

b15E0:
        lda #$02
        STA $1C
        JMP j162A

        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        .BYTE $27,$00 ;RLA a00

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1600:  LDA $DC00                                       ;CIA1: Data Port Register A
        AND #$0C
        CMP #$0C
        BNE @l0

        LDA #$00
        STA $1B

@l0:    LDA $1B
        BNE @l1

        LDA $DC00    ;CIA1: Data Port Register A
        AND #$04
        BEQ b1639

        LDA $DC00    ;CIA1: Data Port Register A
        AND #$08
        BEQ b1660

@l1:    LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ b15E0

        LDA #$01
        STA $1C
j162A:  LDA $DC00    ;CIA1: Data Port Register A
        AND #$01
        BEQ b1697

        LDA $DC00    ;CIA1: Data Port Register A
        AND #$02
        BEQ b1687
j1638:  RTS

b1639:  LDA a0B01
        BEQ b164B
        DEC a0B01
        DEC $05B2

b1644:  LDA #$01
        STA $1B
        JMP j1638

b164B:  LDA a0B00
        CMP #$04
        BEQ b1644
        INC a0B00
        DEC $05B2
        JMP b1644

        NOP
        NOP
        NOP
        NOP
        NOP
b1660:  LDA a0B00
        BEQ b1672
        DEC a0B00
        INC $05B2

b166B:  LDA #$01
        STA a1B
        JMP j1638

b1672:  LDA a0B01
        CMP #$04
        BEQ b166B
        INC a0B01
        INC a05B2
        JMP b166B

        NOP
        NOP
        NOP
        NOP
        NOP
b1687:  LDA $D001    ;Sprite 0 Y Pos
        CMP #$7A
        BCS b169E

b168E:  LDX $1C
@l0:    INC $D001    ;Sprite 0 Y Pos
        DEX
        BNE @l0
        RTS

b1697:  LDA $D001    ;Sprite 0 Y Pos
        CMP #$3A
        BCC b168E

b169E:  LDX $1C
@l0:    DEC $D001    ;Sprite 0 Y Pos
        DEX
        BNE @l0
        RTS

        NOP
        NOP
        NOP
s16AA:  LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$02
        BNE b16BA

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        LDA $D01F    ;Sprite to Background Collision Detect
        RTS

b16BA:  JMP j1940


        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s16D0:  LDA $FF
        BNE @l0
@l1:    RTS

@l0:    LDA $1C
        CMP #$02
        BNE @l1
        LDA a193E
        CMP #$00
        BNE @l1
        LDA #$00
        STA $FF
        RTS

        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$00 ;ISC p0000,X
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$00 ;ISC p0000,X

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1700:  LDA $AF
        BNE @l0
        DEC $AB
        BMI @l1
@l0:    RTS

@l1:    LDA #$00
        STA $AB

@l2:    DEC $AA
        BMI @l3
        DEC $AC
        BPL @l2
        LDA a0B02
        STA $AB
        LDA a0B03
        STA $AC
        RTS

@l3:    LDA #$07
        STA $AA

        LDX #$00
@l4:    LDA $0681,X
        STA $0680,X
        INX
        CPX #$C7
        BNE @l4

        LDX #$00
@l5:    LDA $0749,X
        STA $0748,X
        INX
        CPX #$78
        BNE @l5

        LDA $81
        CMP #$31
        BNE @l6
        LDA $80
        CMP #$FF
        BEQ @l9

@l6:    CLC
        INC $80
        INC $82
        INC $84
        INC $86
        INC $88
        INC $8A
        INC $8C
        INC $8E
        BNE @l7
        INC $81
        INC $83
        INC $85
        INC $87
        INC $89
        INC $8B
        INC $8D
        INC $8F

@l7:    LDY #$00
        LDA ($80),Y
        STA f06A7,Y
        LDA ($82),Y
        STA f06CF,Y
        LDA ($84),Y
        STA f06F7,Y
        LDA ($86),Y
        STA f071F,Y
        LDA ($88),Y
        STA f0747,Y
        LDA ($8A),Y
        STA f076F,Y
        LDA ($8C),Y
        STA f0797,Y
        LDA ($8E),Y
        STA f07BF,Y

        INC $AD
        LDA $AD
        CMP #$04
        BEQ @l8
        RTS

@l8:    LDA #$00
        STA $AD
        INC $D006    ;Sprite 3 X Pos
        RTS

@l9:    LDA #$01
        STA $AE
        RTS

        .BYTE $FF,$00,$FF ;ISC aFF00,X

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s17B0:  LDA a1E04
        BNE @l0
        RTS

@l0:    JSR s1700
        JSR s1800
        JSR s18D0
        JSR s1AF8
        JSR s1E10
        RTS

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

s17CE:  JSR s16AA
        JSR e0B8A
        RTS

        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X

b17E0:  LDA #$02
        STA a1E
        JMP j182A

        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        .BYTE $27,$00 ;RLA a00

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1800   LDA $DC01    ;CIA1: Data Port Register B
        AND #$0C
        CMP #$0C
        BNE b180D
        LDA #$00
f180C   =*+$01
        STA a1D
b180D   LDA a1D
        BNE b181F
        LDA $DC01    ;CIA1: Data Port Register B
        AND #$04
        BEQ b1839
f1818   LDA $DC01    ;CIA1: Data Port Register B
        AND #$08
        BEQ b1860
b181F   LDA $DC01    ;CIA1: Data Port Register B
        AND #$10
        BEQ b17E0
        LDA #$01
        STA a1E
j182A   LDA $DC01    ;CIA1: Data Port Register B
        AND #$01
        BEQ b1897
        LDA $DC01    ;CIA1: Data Port Register B
        AND #$02
        BEQ b1887
j1838   RTS

b1839   LDA a0B03
        BEQ b184B
        DEC a0B03
        DEC a0652
b1844   LDA #$01
        STA a1D
        JMP j1838

b184B   LDA a0B02
        CMP #$04
        BEQ b1844
        INC a0B02
        DEC a0652
        JMP b1844

        NOP
        NOP
        NOP
        NOP
        NOP
b1860   LDA a0B02
        BEQ b1872
        DEC a0B02
        INC a0652
b186B   LDA #$01
        STA a1D
        JMP j1838

b1872   LDA a0B03
        CMP #$04
        BEQ b186B
        INC a0B03
f187E   =*+$02
        INC a0652
        JMP b186B

        NOP
        NOP
        NOP
        NOP
        NOP
b1887   LDA $D003    ;Sprite 1 Y Pos
        CMP #$F0
        BCS b189E
b188E   LDX a1E
b1890   INC $D003    ;Sprite 1 Y Pos
        DEX
        BNE b1890
        RTS

b1897   LDA $D003    ;Sprite 1 Y Pos
        CMP #$AF
        BCC b188E
b189E   LDX a1E
b18A0   DEC $D003    ;Sprite 1 Y Pos
        DEX
        BNE b18A0
        RTS

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
s18D0   LDA aAF
        BNE b18D5
b18D4   RTS

b18D5   LDA a1E
        CMP #$02
        BNE b18D4
        LDA a193F
        BNE b18D4
        LDA #$00
        STA aAF
        RTS

        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$00 ;ISC p0000,X

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1900   LDA #$00
        STA a0B02
        STA a0B03
        STA aAF
        STA a80
        STA a82
        STA a84
        STA a86
        STA a88
        STA a8A
        STA a8C
        STA a8E
        LDA #$30
        STA a81
        LDA #$32
        STA a83
        LDA #$34
        STA a85
        LDA #$36
        STA a87
        LDA #$38
        STA a89
        LDA #$3A
        STA a8B
        LDA #$3C
        STA a8D
        LDA #$3E
        STA a8F
        JMP j1980

f193D   BRK
a193E   BRK
a193F   BRK
j1940   LDA $D01F    ;Sprite to Background Collision Detect
        LDX #$01
b1945   LSR
        BCC b194E
        PHA
        TXA
        STA f193D,X
        PLA
b194E   INX
        CPX #$03
        BNE b1945
        LDA a193E
        BNE b1965
j1958   LDA a193F
        BNE b196C
j195D   LDA #$02
        STA $D019    ;VIC Interrupt Request Register (IRR)
        RTS

        NOP
        NOP
b1965   NOP
        NOP
        NOP
        NOP
        JMP j1B10

b196C   LDA #$FF
        LDA $29                                         ; XXX: should it be STA $29 ?
        JMP j1B2F

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
j1980   LDA #$02
        STA $D029    ;Sprite 2 Color
        STA $D02A    ;Sprite 3 Color
        LDA #$70
        STA $D006    ;Sprite 3 X Pos
        LDA #$98
        STA $D007    ;Sprite 3 Y Pos
        LDA #$04
        STA a94
        LDA #$00
        STA a1E04
        STA a1E05
        STA aAE
        LDA #$30
        STA a95
        STA a96
        STA a97
        LDA #$07
        STA aAA
        LDA #$80
        STA $D002    ;Sprite 1 X Pos
        LDA #$D0
        STA $D003    ;Sprite 1 Y Pos
        LDA #$00
        STA a29
        STA aAD
        JMP j142A

        NOP
f19C0   JSR s2020
        JSR s1420
        ORA #$0D
        ORA a3A
        BMI b19FC
        BMI b19EE
        JSR e0313
        .BYTE $0F,$12,$05 ;SLO $0512
        .BYTE $3A    ;NOP
        BMI b1A07
        BMI b1A09
        BMI b19FB
        JSR e1013
        ORA a05
        .BYTE $04,$3A ;NOP a3A
        AND f20,X
        JSR s2020
        JSR s2020
        JSR s2020
b19EE   =*+$01
        JSR s2020
        JSR s2020
        BVS b1A38
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
b19FC   =*+$01
b19FB   .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$6E ;SRE (p6E,X)
b1A07   =*+$02
        JSR s2020
b1A09   =*+$01
        JSR s2020
        JSR s2020
        JSR s2020
        JSR s2020
        JSR s2020
        JSR s2020
        JSR e436B
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$73 ;SRE (p73,X)
        JSR s2020
        JSR s2020
        JSR s2020
b1A38   =*+$02
        JSR s2020
        JSR s2020
        JSR s2020
        JSR s2020
        JSR e436D
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$43 ;SRE (p43,X)
        .BYTE $43,$7D ;SRE ($7D,X)
        JSR s2020
        JSR s2020
        JSR s2020
f1A60   =*+$02
        JSR s2020
        JSR s2020
        JSR e0914
        ORA a3A05
        BMI b1A9C
        BMI b1A8E
        JSR e0313
        .BYTE $0F,$12,$05 ;SLO $0512
        .BYTE $3A    ;NOP
        BMI b1AA7
        BMI b1AA9
        BMI b1A9B
        JSR e1013
        ORA a05
        .BYTE $04,$3A ;NOP a3A
        AND f20,X
        JSR s2020
        JSR eFF20
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
b1A8E   BRK
        RTS

        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
b1A9B   BRK
b1A9C   BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1AA6:  DEC a1F
        BEQ @l0
        RTS

@l0:    LDA #$10
        STA $1F
        NOP
        INC $23
        LDA $23
        CMP #$3A
        BEQ @l1
        RTS

@l1:    LDA #$30
        STA $23
        INC $22
        LDA $22
        CMP #$3A
        BEQ @l2
        RTS

@l2:    LDA #$30
        STA $22
        INC $21
        LDA $21
        CMP #$3A
        BEQ @l3
        RTS

@l3:    LDA #$39
        STA $21
        STA $22
        STA $23
        RTS

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1AE0:  LDA $FE
        BEQ @l0
        LDA #$00
        STA a1E00
        STA a1E01
        RTS

@l0:    LDX #$02
@l1:    LDA $21,X
        STA $059A,X
        DEX
        BPL @l1
        RTS

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1AF8:  LDA $AE
        BEQ @l0
        LDA #$00
        STA a1E04
        STA a1E05
        RTS

@l0:    LDX #$02
@l1:    LDA $95,X
        STA $063A,X
        DEX
        BPL @l1
        RTS

j1B10:  LDA $FF
        BNE b1B27
        LDA #$01
        STA $FF
        LDA $05B2
        AND #$0F
        TAX
b1B1E:  JSR s1B4E
        DEX
        BNE b1B1E
        JSR s1BF0
b1B27:  LDA #$00
        STA a193E
        JMP j1958

j1B2F:  LDA aAF
        BNE b1B46
        LDA #$01
        STA aAF
        LDA a0652
        AND #$0F
        TAX
b1B3D:  JSR s1B9D
        DEX
s1B41:  BNE b1B3D
        JSR s1CE9
b1B46:  LDA #$00
        STA a193F
        JMP j195D

s1B4E:  INC a05A9
        LDA a05A9
        CMP #$3A
b1B56:  BNE b1B9C
        LDA #$30
        STA a05A9
        INC a05A8
        LDA a05A8
        CMP #$3A
        BNE b1B56
        LDA #$30
        STA a05A8
        INC a05A7
        LDA a05A7
        CMP #$3A
        BNE b1B56
        LDA #$30
        STA a05A7
        INC a05A6
        LDA a05A6
        CMP #$3A
        BNE b1B56
        LDA #$30
        STA a05A6
        INC a05A5
        LDA a05A5
        CMP #$3A
        BNE b1B56
        LDA #$39
        STA a05A5
        STA a05A6
b1B9C:  RTS

s1B9D:  INC a0649
        LDA a0649
        CMP #$3A
b1BA5:  BNE b1BEB
        LDA #$30
        STA a0649
        INC a0648
        LDA a0648
        CMP #$3A
        BNE b1BA5
        LDA #$30
        STA a0648
        INC a0647
        LDA a0647
        CMP #$3A
        BNE b1BA5
        LDA #$30
        STA a0647
        INC a0646
        LDA a0646
        CMP #$3A
        BNE b1BA5
        LDA #$30
        STA a0646
        INC a0645
        LDA a0645
        CMP #$3A
        BNE b1BA5
        LDA #$39
        STA a0645
        STA a0646
b1BEB   RTS

        BRK
        BRK
        BRK
        BRK
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1BF0   LDA #$81
        STA $B0
        JMP j1CB6

        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        ORA (p00,X)
        .BYTE $9E,$34,$38 ;STX $3834,Y
        ROL f34,X
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
s1C10   LDA aFE
        BNE b1C18
        NOP
        NOP
        NOP
        RTS

b1C18   LDA a28
        BNE b1C53
        DEC a059C
        LDA a059C
        CMP #$2F
        BNE b1C57
        LDA #$39
        STA a059C
        DEC a059B
        LDA a059B
        CMP #$2F
        BNE b1C57
        LDA #$39
        STA a059B
        DEC f059A
        LDA f059A
        CMP #$2F
        BNE b1C57
        LDA #$30
        STA f059A
        STA a059B
        STA a059C
        LDA #$FF
        STA a28
b1C53   RTS

        NOP
        NOP
        NOP
b1C57   JSR s1CAC
        JSR s1B4E
        RTS

        BRK
        BRK
s1C60   LDA aAE
        BNE b1C68
        RTS

        NOP
        NOP
        NOP
b1C68   LDA a29
        BNE b1CA3
        DEC a063C
        LDA a063C
        CMP #$2F
        BNE b1C92
        LDA #$39
        STA a063C
        DEC a063B
        LDA a063B
        CMP #$2F
        BNE b1C92
        LDA #$39
        STA a063B
        DEC f063A
        LDA f063A
        CMP #$2F
b1C92   BNE b1CA4
        LDA #$30
        STA f063A
        STA a063B
        STA a063C
        LDA #$FF
        STA a29
b1CA3   RTS

b1CA4   JSR s1CF0
        JSR s1B9D
        RTS

a1CAB   PHP
s1CAC   LDA #$21
        STA aB0
        DEC a1CAB
        BEQ j1CB6
        RTS

j1CB6   LDA #$00
        STA $D404    ;Voice 1: Control Register
        LDA #$08
        STA a1CAB
        LDA #$00
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA #$0F
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        LDA #$00
        LDA $D402    ;Voice 1: Pulse Waveform Width - Low-Byte
        LDA #$01
        LDA $D403    ;Voice 1: Pulse Waveform Width - High-Nybble
        LDA #$09
        LDA $D405    ;Voice 1: Attack / Decay Cycle Control
        LDA #$01
f1CDC   =*+$01
        LDA $D406    ;Voice 1: Sustain / Release Cycle Control
        LDA aB0
        STA $D404    ;Voice 1: Control Register
        RTS

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
s1CE9   =*+$01
a1CE8   .BYTE $04,$A9 ;NOP $A9
        STA (p85,X)
        LDA (p4C),Y
        .BYTE $FA    ;NOP
s1CF0   =*+$01
        .BYTE $1C,$A9,$21 ;NOP $21A9,X
        STA aB1
        DEC a1CE8
        BEQ b1CFA
        RTS

b1CFA   LDA #$00
        STA $D404    ;Voice 1: Control Register
        LDA #$08
        STA a1CE8
        LDA #$00
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA #$15
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        LDA #$00
        LDA $D409    ;Voice 2: Pulse Waveform Width - Low-Byte
        LDA #$00
        LDA $D40A    ;Voice 2: Pulse Waveform Width - High-Nybble
        LDA #$09
        LDA $D40C    ;Voice 2: Attack / Decay Cycle Control
        LDA #$01
        LDA $D40D    ;Voice 2: Sustain / Release Cycle Control
        LDA aB1
        STA $D404    ;Voice 1: Control Register
        RTS

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
s1D30   LDA aFE
        BEQ b1D35
        RTS

b1D35   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BNE b1D41
        LDA #$01
        STA a1E01
b1D41   JSR s1D60
        JSR s1DB5
        RTS

s1D48   LDA aAE
        BEQ b1D4D
        RTS

b1D4D   LDA $DC01    ;CIA1: Data Port Register B
        AND #$10
        BNE b1D41
        LDA #$01
        STA a1E05
        JMP b1D41

        NOP
        NOP
        NOP
        NOP
s1D60   LDA a1E00
        BEQ b1D68
        NOP
        NOP
        RTS

b1D68   LDA a1E01
        BNE b1D70
        NOP
        NOP
        RTS

b1D70   LDA a1E05
        BNE b1DA4
        NOP
        NOP
        LDA a0591
        CMP #$20
        BEQ b1D99
        DEC a1E02
        BEQ b1D84
b1D83   RTS

b1D84   LDA #$30
        STA a1E02
        DEC a0591
        LDA a0591
        CMP #$30
        BNE b1D83
        LDA #$01
        STA a1E00
        RTS

b1D99   LDA #$39
        STA a0591
        LDA #$30
        STA a1E02
        RTS

b1DA4   LDA #$20
        STA a0591
        STA a0631
        LDA #$04
        STA a1E00
        STA a1E04
        RTS

s1DB5   LDA a1E04
        BEQ b1DBD
        NOP
        NOP
        RTS

b1DBD   LDA a1E05
        BNE b1DC5
        NOP
        NOP
        RTS

b1DC5   LDA a1E01
        BNE b1DA4
        NOP
        NOP
        LDA a0631
        CMP #$20
        BEQ b1DF1
        DEC a1E06
        BEQ b1DD9
b1DD8   RTS

b1DD9   LDA #$30
        STA a1E06
        DEC a0631
        LDA a0631
        CMP #$30
        BNE b1DD8
        LDA #$01
        STA a1E04
        RTS

        NOP
        NOP
        NOP
b1DF1   LDA #$39
        STA a0631
        LDA #$30
        STA a1E06
        RTS

        NOP
        NOP
        NOP
        NOP
a1E00   BRK
a1E01   BRK
a1E02   ROL
        BRK
a1E04   BRK
a1E05   BRK
a1E06   .BYTE $12    ;JAM
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
s1E10   DEC a94
        BEQ b1E15
        RTS

b1E15   LDA #$10
        STA a94
        NOP
        INC a97
        LDA a97
        CMP #$3A
        BEQ b1E23
        RTS

b1E23   LDA #$30
        STA a97
        INC a96
        LDA a96
        CMP #$3A
        BEQ b1E30
        RTS

b1E30   LDA #$30
        STA a96
        INC a95
        LDA a95
        CMP #$3A
        BEQ b1E3D
        RTS

b1E3D   LDA #$39
        STA a95
        STA a96
        STA a97
        RTS

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        BRK
        BRK
        BRK
        BRK
        BRK
s1E50   LDA a28
        BNE b1E55
b1E54   RTS

b1E55   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BNE b1E54
        LDX #$F0
b1E5E   LDA #$20
        STA f0477,X
        DEX
        BNE b1E5E
        LDX #$50
b1E68   STA f0428,X
        DEX
        BPL b1E68
        JMP init_vars

        NOP
        NOP
        NOP
        NOP
s1E75   LDA a29
        BNE b1E7A
b1E79   RTS

b1E7A   LDA $DC01    ;CIA1: Data Port Register B
        AND #$10
        BNE b1E79
        LDX #$F0
b1E83   LDA #$20
        STA f06CF,X
        DEX
        BNE b1E83
        LDX #$50
b1E8D   STA f0680,X
        DEX
        BPL b1E8D
        JMP s1900

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        BRK
s1EA0   LDA #>p1EB0
        STA a0A01
        LDA #<p1EB0
        STA a0A00
        LDA #$93
        JMP ROM_BSOUTi ;$FFD2 (ind) ibsout Output Vector, chrout [ef79]

p1EB0   =*+$01
        .BYTE $FF,$A9,$93 ;ISC $93A9,X
        JSR ROM_BSOUTi ;$FFD2 (ind) ibsout Output Vector, chrout [ef79]
        JMP j130A

        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$73,$00 ;ISC $0073,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
f1FF8   BRK
        .BYTE $FF,$00,$FF ;ISC aFF00,X
        BRK
        .BYTE $FF,$F7,$00 ;ISC $00F7,X
