;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Race: https://github.com/ricardoquesada/c128-the-race
;
; Game
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; imports
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.import music_play, music_init

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Macros
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.macpack cbm                            ; adds support for scrcode

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Constants
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.include "c64.inc"                      ; c64 constants

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; predefined labels
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
rom_bsouti = $ffd2
rom_cint = $ff81
rom_ioinit = $ff84
rom_restor = $ff8a

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; .segment "GAME_CODE"
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "GAME_CODE"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void game_init()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export game_main
game_main:
        jsr rom_restor
        jsr rom_ioinit
        jsr rom_cint

        lda #$00
        jsr s1ea0

j130a:  sei
        lda #$00
        sta $dc0e                                       ; cia1: cia control register a
        lda $d011                                       ; vic control register 1
        and #$7f
        sta $d011                                       ; vic control register 1
        lda #$32
        sta $d012                                       ; raster position
        lda #$03
        sta $d01a                                       ; vic interrupt mask register (imr)
        lda #$03
        sta $dc0d                                       ; cia1: cia interrupt control register

        lda #<irq_0
        sta $0314
        lda #>irq_0
        sta $0315

        lda #$c0
        sta $0a04
        cli

        lda #$0f
        sta $d015                                       ; sprite display enable
        lda #$00
        sta $d010                                       ; sprites 0-7 msb of x coordinate
        sta $d027                                       ; sprite 0 color
        sta $d028                                       ; sprite 1 color
        sta $d01d                                       ; sprites expand 2x horizontal (x)
        sta $d017                                       ; sprites expand 2x vertical (y)

        lda #$00                                        ; define sprite frame
        ldx #$00
@l0:    sta $0fc0,x
        inx
        cpx #$40
        bne @l0

        lda #$0f                                        ; cont. with sprite frame
        sta $0fc0
        sta $0fc3
        sta $0fc6

        ldx #$27                                        ; clear screen
@l1:    lda #$00
        sta $0400,x
        sta $0568,x
        sta $0658,x
        sta $07c0,x
        dex
        bpl @l1

        ldx #$00
@l2:    lda label_txt_p1,x
        sta $0590,x
        inx
        cpx #$c8
        bne @l2

        lda #$3f                                        ; sprite pointers
        sta $07f8                                       ; $3f = $fc0
        sta $07f9
        sta $07fa
        sta $07fb

        ldx #$18                                        ; init music
@l3:    lda #$00
        sta $d400,x                                     ; voice 1: frequency control - low-byte
        dex
        bpl @l3
        lda #$0f
        sta $d418                                       ; select filter mode and volume

        jsr music_init
        jsr init_vars_p1
        jsr init_vars_p2

j13af:  jmp j13af

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; init_vars_p1
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
init_vars_p1:
        lda #$30
        sta $21
        sta $22
        sta $23
        lda #$00
        sta a1e00
        sta a1e01
        sta $0b00
        sta $0b01
        sta $ff
        sta $fe
        sta $6a
        sta $6c
        sta $6e
        sta $70
        sta $72
        sta $74
        sta $24
        sta $26
        lda #$30
        sta $6b
        lda #$32
        sta $6d
        lda #$34
        sta $6f
        lda #$36
        sta $71
        lda #$38
        sta $73
        lda #$3a
        sta $75
        lda #$3c
        sta $25
        lda #$3e
        sta $27

        lda #$58
        sta $d001                                       ; sprite 0 y pos
        lda #$80
        sta $d000                                       ; sprite 0 x pos
        lda #$04
        sta $1f
        lda #$70
        sta $d004                                       ; sprite 2 x pos
        lda #$90
        sta $d005                                       ; sprite 2 y pos
        lda #$07
        sta $fa
        lda #$00
        sta $28

        ldx #$27
@l0:    lda label_txt_p1,x
        sta $0400 + 40 * 10,x
        dex
        bpl @l0
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; init_vars_p2
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
init_vars_p2:
        lda #$00
        sta $0b02
        sta $0b03
        sta $af
        sta $80
        sta $82
        sta $84
        sta $86
        sta $88
        sta $8a
        sta $8c
        sta $8e
        lda #$30
        sta $81
        lda #$32
        sta $83
        lda #$34
        sta $85
        lda #$36
        sta $87
        lda #$38
        sta $89
        lda #$3a
        sta $8b
        lda #$3c
        sta $8d
        lda #$3e
        sta $8f

        lda #$02
        sta $d029                                       ;sprite 2 color
        sta $d02a                                       ;sprite 3 color
        lda #$70
        sta $d006                                       ;sprite 3 x pos
        lda #$98
        sta $d007                                       ;sprite 3 y pos
        lda #$04
        sta $94
        lda #$00
        sta a1e04
        sta a1e05
        sta $ae
        lda #$30
        sta $95
        sta $96
        sta $97
        lda #$07
        sta $aa
        lda #$80
        sta $d002                                       ;sprite 1 x pos
        lda #$d0
        sta $d003                                       ;sprite 1 y pos
        lda #$00
        sta $29
        sta $ad

        ldx #$27
@l0:    lda label_txt_p1,x
        sta $0400 + 40 * 14,x
        dex
        bpl @l0

        lda #$00
        sta $fd
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_0()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_0:
        lda #$81
        sta $d012                                       ; raster position
        nop
        nop
        lda #$18
        sta $d018                                       ; vic memory control register
        lda #$02
        sta $d021                                       ; background color 0

        lda $fa
        and #$c7
        sta $d016                                       ; vic control register 2

        lda #$01
        sta $d01a                                       ; vic interrupt mask register (imr)

        lda #<irq_1
        sta $0314
        lda #>irq_1
        sta $0315

        lda #$01
        sta $d019                                       ; vic interrupt request register (irr)
        jsr s17b0
        jsr s15cc
        jmp $ff33                                       ; $ff33 return from interrupt

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_1:
        lda #$aa
        sta $d012                                       ; raster position
        nop
        nop
        lda #$14
        sta $d018                                       ; vic memory control register
        lda #$00
        sta $d021                                       ; background color 0
        sta $d020                                       ; border color
        lda #$c0
        sta $d016                                       ; vic control register 2

        lda #<irq_2
        sta $0314
        lda #>irq_2
        sta $0315

        lda #$01
        sta $d019                                       ; vic interrupt request register (irr)
        jmp $ff33                                       ; $ff33 return from interrupt

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_2:
        lda #$12
        sta $d012                                       ; raster position
        nop
        nop
        lda #$18
        sta $d018                                       ; vic memory control register
        lda #$02
        sta $d021                                       ; background color 0
        lda $d021                                       ; background color 0

        lda $aa
        and #$c7
        sta $d016                                       ; vic control register 2

        lda #$01
        sta $d01a                                       ; vic interrupt mask register (imr)

        lda #<irq_0
        sta $0314
        lda #>irq_0
        sta $0315

        lda #$01
        sta $d019                                       ; vic interrupt request register (irr)
        jsr s15b0
        jsr s17ce
        jmp $ff33                                       ; $ff33 return from interrupt

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1500:  lda $ff
        bne @l0
        dec $fb
        bmi @l1
@l0:    rts

@l1:    lda #$00
        sta $fb
@l2:    dec $fa
        bmi @l3
        dec $fc
        bpl @l2
        lda $0b00
        sta $fb
        lda $0b01
        sta $fc
        rts

@l3:    lda #$07
        sta $fa

        ldx #$00
@l4:    lda $0429,x
        sta $0428,x
        inx
        cpx #$c7
        bne @l4

        ldx #$00
@l5:    lda $04f1,x
        sta $04f0,x
        inx
        cpx #$78
        bne @l5

        lda $6b
        cmp #$31
        bne @l6
        lda $6a
        cmp #$ff
        beq @l8
@l6:    clc
        inc $6a
        inc $6c
        inc $6e
        inc $70
        inc $72
        inc $74
        inc $24
        inc $26
        bne @l7
        inc $6b
        inc $6d
        inc $6f
        inc $71
        inc $73
        inc $75
        inc $25
        inc $27

@l7:    ldy #$00
        lda ($6a),y
        sta $044f,y
        lda ($6c),y
        sta $0477,y
        lda ($6e),y
        sta $049f,y
        lda ($70),y
        sta $04c7,y
        lda ($72),y
        sta $04ef,y
        lda ($74),y
        sta $0517,y
        lda ($24),y
        sta $053f,y
        lda ($26),y
        sta $0567,y

        inc $fd
        lda $fd
        cmp #$04
        beq @l9
        rts

@l9:    lda #$00
        sta $fd
        inc $d004                                       ; sprite 2 x pos
        rts

@l8:    lda #$01
        sta $fe
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s15b0:  lda a1e00
        bne @l0
        rts

@l0:    jsr s1500
        jsr s1600
        jsr s16d0
        jsr s1aa6
        jsr s1ae0
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s15cc:  jsr s1d30
        jsr s1d48
        jsr s1c10
        jsr s1c60
        jsr s1e50
        jsr s1e75
        rts

b15e0:
        lda #$02
        sta $1c
        jmp j162a

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1600:  lda $dc00                                       ;cia1: data port register a
        and #$0c
        cmp #$0c
        bne @l0

        lda #$00
        sta $1b

@l0:    lda $1b
        bne @l1

        lda $dc00                                       ;cia1: data port register a
        and #$04
        beq b1639

        lda $dc00                                       ;cia1: data port register a
        and #$08
        beq b1660

@l1:    lda $dc00                                       ;cia1: data port register a
        and #$10
        beq b15e0

        lda #$01
        sta $1c
j162a:  lda $dc00                                       ;cia1: data port register a
        and #$01
        beq b1697

        lda $dc00                                       ;cia1: data port register a
        and #$02
        beq b1687
j1638:  rts

b1639:  lda $0b01
        beq b164b
        dec $0b01
        dec $05b2

b1644:  lda #$01
        sta $1b
        jmp j1638

b164b:  lda $0b00
        cmp #$04
        beq b1644
        inc $0b00
        dec $05b2
        jmp b1644

b1660:  lda $0b00
        beq b1672
        dec $0b00
        inc $05b2

b166b:  lda #$01
        sta $1b
        jmp j1638

b1672:  lda $0b01
        cmp #$04
        beq b166b
        inc $0b01
        inc $05b2
        jmp b166b

b1687:  lda $d001                                       ;sprite 0 y pos
        cmp #$7a
        bcs b169e

b168e:  ldx $1c
@l0:    inc $d001                                       ;sprite 0 y pos
        dex
        bne @l0
        rts

b1697:  lda $d001                                       ;sprite 0 y pos
        cmp #$3a
        bcc b168e

b169e:  ldx $1c
@l0:    dec $d001                                       ;sprite 0 y pos
        dex
        bne @l0
        rts

s16aa:  lda $d019                                       ;vic interrupt request register (irr)
        and #$02
        bne b16ba

        lda #$01
        sta $d019                                       ;vic interrupt request register (irr)
        lda $d01f                                       ;sprite to background collision detect
        rts

b16ba:  jmp j1940


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s16d0:  lda $ff
        bne @l0
@l1:    rts

@l0:    lda $1c
        cmp #$02
        bne @l1
        lda a193e
        cmp #$00
        bne @l1
        lda #$00
        sta $ff
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1700:  lda $af
        bne @l0
        dec $ab
        bmi @l1
@l0:    rts

@l1:    lda #$00
        sta $ab

@l2:    dec $aa
        bmi @l3
        dec $ac
        bpl @l2
        lda $0b02
        sta $ab
        lda $0b03
        sta $ac
        rts

@l3:    lda #$07
        sta $aa

        ldx #$00
@l4:    lda $0681,x
        sta $0680,x
        inx
        cpx #$c7
        bne @l4

        ldx #$00
@l5:    lda $0749,x
        sta $0748,x
        inx
        cpx #$78
        bne @l5

        lda $81
        cmp #$31
        bne @l6
        lda $80
        cmp #$ff
        beq @l9

@l6:    clc
        inc $80
        inc $82
        inc $84
        inc $86
        inc $88
        inc $8a
        inc $8c
        inc $8e
        bne @l7
        inc $81
        inc $83
        inc $85
        inc $87
        inc $89
        inc $8b
        inc $8d
        inc $8f

@l7:    ldy #$00
        lda ($80),y
        sta $06a7,y
        lda ($82),y
        sta $06cf,y
        lda ($84),y
        sta $06f7,y
        lda ($86),y
        sta $071f,y
        lda ($88),y
        sta $0747,y
        lda ($8a),y
        sta $076f,y
        lda ($8c),y
        sta $0797,y
        lda ($8e),y
        sta $07bf,y

        inc $ad
        lda $ad
        cmp #$04
        beq @l8
        rts

@l8:    lda #$00
        sta $ad
        inc $d006                                       ;sprite 3 x pos
        rts

@l9:    lda #$01
        sta $ae
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s17b0:  lda a1e04
        bne @l0
        rts

@l0:    jsr s1700
        jsr s1800
        jsr s18d0
        jsr s1af8
        jsr s1e10
        rts

s17ce:  jsr s16aa
        jsr music_play
        rts

b17e0:  lda #$02
        sta $1e
        jmp j182a

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1800:  lda $dc01                                       ;cia1: data port register b
        and #$0c
        cmp #$0c
        bne b180d
        lda #$00
        sta $1d

b180d:  lda $1d
        bne b181f
        lda $dc01                                       ;cia1: data port register b
        and #$04
        beq b1839

f1818:  lda $dc01                                       ;cia1: data port register b
        and #$08
        beq b1860
b181f:  lda $dc01                                       ;cia1: data port register b
        and #$10
        beq b17e0
        lda #$01
        sta $1e
j182a:  lda $dc01                                       ;cia1: data port register b
        and #$01
        beq b1897
        lda $dc01                                       ;cia1: data port register b
        and #$02
        beq b1887
j1838:  rts

b1839:  lda $0b03
        beq b184b
        dec $0b03
        dec $0652
b1844:  lda #$01
        sta $1d
        jmp j1838

b184b:  lda $0b02
        cmp #$04
        beq b1844
        inc $0b02
        dec $0652
        jmp b1844

b1860:  lda $0b02
        beq b1872
        dec $0b02
        inc $0652
b186b:  lda #$01
        sta $1d
        jmp j1838

b1872:  lda $0b03
        cmp #$04
        beq b186b
        inc $0b03
        inc $0652
        jmp b186b

b1887:  lda $d003                                       ;sprite 1 y pos
        cmp #$f0
        bcs b189e
b188e:  ldx $1e
b1890:  inc $d003                                       ;sprite 1 y pos
        dex
        bne b1890
        rts

b1897:  lda $d003                                       ;sprite 1 y pos
        cmp #$af
        bcc b188e
b189e:  ldx $1e
b18a0:  dec $d003                                       ;sprite 1 y pos
        dex
        bne b18a0
        rts

s18d0:  lda $af
        bne b18d5
b18d4:  rts

b18d5:  lda $1e
        cmp #$02
        bne b18d4
        lda a193f
        bne b18d4
        lda #$00
        sta $af
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
j1940:  lda $d01f                                       ;sprite to background collision detect
        ldx #$01
@l1:    lsr
        bcc @l0
        pha
        txa
        sta f193d,x
        pla
@l0:    inx
        cpx #$03
        bne @l1

        lda a193e
        bne b1965
j1958:  lda a193f
        bne b196c

j195d:  lda #$02
        sta $d019                                       ;vic interrupt request register (irr)
        rts

b1965:  jmp j1b10

b196c:  lda #$ff
        lda $29                                         ; xxx: should it be sta $29 ?

        lda $af
        bne b1b46
        lda #$01
        sta $af
        lda $0652
        and #$0f
        tax
b1b3d:  jsr s1b9d
        dex
s1b41:  bne b1b3d
        jsr s1ce9
b1b46:  lda #$00
        sta a193f
        jmp j195d


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1aa6:  dec $1f
        beq @l0
        rts

@l0:    lda #$10
        sta $1f
        nop
        inc $23
        lda $23
        cmp #$3a
        beq @l1
        rts

@l1:    lda #$30
        sta $23
        inc $22
        lda $22
        cmp #$3a
        beq @l2
        rts

@l2:    lda #$30
        sta $22
        inc $21
        lda $21
        cmp #$3a
        beq @l3
        rts

@l3:    lda #$39
        sta $21
        sta $22
        sta $23
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1ae0:  lda $fe
        beq @l0
        lda #$00
        sta a1e00
        sta a1e01
        rts

@l0:    ldx #$02
@l1:    lda $21,x
        sta $059a,x
        dex
        bpl @l1
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1af8:  lda $ae
        beq @l0
        lda #$00
        sta a1e04
        sta a1e05
        rts

@l0:    ldx #$02
@l1:    lda $95,x
        sta $063a,x
        dex
        bpl @l1
        rts

j1b10:  lda $ff
        bne b1b27
        lda #$01
        sta $ff
        lda $05b2
        and #$0f
        tax
b1b1e:  jsr s1b4e
        dex
        bne b1b1e
        jsr s1bf0
b1b27:  lda #$00
        sta a193e
        jmp j1958


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1b4e:  inc $05a9
        lda $05a9
        cmp #$3a
b1b56:  bne b1b9c
        lda #$30
        sta $05a9
        inc $05a8
        lda $05a8
        cmp #$3a
        bne b1b56
        lda #$30
        sta $05a8
        inc $05a7
        lda $05a7
        cmp #$3a
        bne b1b56
        lda #$30
        sta $05a7
        inc $05a6
        lda $05a6
        cmp #$3a
        bne b1b56
        lda #$30
        sta $05a6
        inc $05a5
        lda $05a5
        cmp #$3a
        bne b1b56
        lda #$39
        sta $05a5
        sta $05a6
b1b9c:  rts

s1b9d:  inc $0649
        lda $0649
        cmp #$3a
b1ba5:  bne b1beb
        lda #$30
        sta $0649
        inc $0648
        lda $0648
        cmp #$3a
        bne b1ba5
        lda #$30
        sta $0648
        inc $0647
        lda $0647
        cmp #$3a
        bne b1ba5
        lda #$30
        sta $0647
        inc $0646
        lda $0646
        cmp #$3a
        bne b1ba5
        lda #$30
        sta $0646
        inc $0645
        lda $0645
        cmp #$3a
        bne b1ba5
        lda #$39
        sta $0645
        sta $0646
b1beb:  rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1bf0:  lda #$81
        sta $b0
        jmp j1cb6

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1c10:  lda $fe
        bne @l0
        rts

@l0:    lda $28
        bne b1c53
        dec $059c
        lda $059c
        cmp #$2f
        bne b1c57
        lda #$39
        sta $059c
        dec $059b
        lda $059b
        cmp #$2f
        bne b1c57
        lda #$39
        sta $059b
        dec $059a
        lda $059a
        cmp #$2f
        bne b1c57
        lda #$30
        sta $059a
        sta $059b
        sta $059c
        lda #$ff
        sta $28
b1c53:  rts

b1c57:  jsr s1cac
        jsr s1b4e
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1c60:  lda $ae
        bne @l0
        rts

@l0:    lda $29
        bne b1ca3
        dec $063c
        lda $063c
        cmp #$2f
        bne b1c92
        lda #$39
        sta $063c
        dec $063b
        lda $063b
        cmp #$2f
        bne b1c92
        lda #$39
        sta $063b
        dec $063a
        lda $063a
        cmp #$2f
b1c92:  bne b1ca4
        lda #$30
        sta $063a
        sta $063b
        sta $063c
        lda #$ff
        sta $29
b1ca3:  rts

b1ca4:  jsr s1cf0
        jsr s1b9d
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1cac:  lda #$21
        sta $b0
        dec a1cab
        beq j1cb6
        rts

j1cb6:
        lda #$00
        sta $d404                                       ;voice 1: control register
        lda #$08
        sta a1cab
        lda #$00
        sta $d400                                       ;voice 1: frequency control - low-byte
        lda #$0f
        sta $d401                                       ;voice 1: frequency control - high-byte
        lda #$00
        lda $d402                                       ;voice 1: pulse waveform width - low-byte
        lda #$01
        lda $d403                                       ;voice 1: pulse waveform width - high-nybble
        lda #$09
        lda $d405                                       ;voice 1: attack / decay cycle control
        lda #$01
        lda $d406                                       ;voice 1: sustain / release cycle control
        lda $b0
        sta $d404                                       ;voice 1: control register
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1ce9:
        lda #$81
        sta $b1
        jmp $1cfa

s1cf0:
        lda #$21
        sta $b1
        dec a1ce8
        beq s1cfa
        rts

s1cfa:
        lda #$00
        sta $d404                                       ;voice 1: control register
        lda #$08
        sta a1ce8
        lda #$00
        sta $d400                                       ;voice 1: frequency control - low-byte
        lda #$15
        sta $d401                                       ;voice 1: frequency control - high-byte
        lda #$00
        lda $d409                                       ;voice 2: pulse waveform width - low-byte
        lda #$00
        lda $d40a                                       ;voice 2: pulse waveform width - high-nybble
        lda #$09
        lda $d40c                                       ;voice 2: attack / decay cycle control
        lda #$01
        lda $d40d                                       ;voice 2: sustain / release cycle control
        lda $b1
        sta $d404                                       ;voice 1: control register
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1d30:  lda $fe
        beq @l0
        rts

@l0:    lda $dc00                                       ;cia1: data port register a
        and #$10
        bne b1d41
        lda #$01
        sta a1e01

b1d41:  jsr s1d60
        jsr s1db5
        rts

s1d48:  lda $ae
        beq b1d4d
        rts

b1d4d:  lda $dc01                                       ;cia1: data port register b
        and #$10
        bne b1d41
        lda #$01
        sta a1e05
        jmp b1d41


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1d60:  lda a1e00
        beq b1d68
        rts

b1d68:  lda a1e01
        bne b1d70
        rts

b1d70:  lda a1e05
        bne b1da4
        lda $0591
        cmp #$20
        beq b1d99
        dec a1e02
        beq b1d84
b1d83:  rts

b1d84:  lda #$30
        sta a1e02
        dec $0591
        lda $0591
        cmp #$30
        bne b1d83
        lda #$01
        sta a1e00
        rts

b1d99:  lda #$39
        sta $0591
        lda #$30
        sta a1e02
        rts

b1da4:  lda #$20
        sta $0591
        sta $0631
        lda #$04
        sta a1e00
        sta a1e04
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1db5:  lda a1e04
        beq b1dbd
        rts

b1dbd:  lda a1e05
        bne b1dc5
        rts

b1dc5:  lda a1e01
        bne b1da4
        lda $0631
        cmp #$20
        beq b1df1
        dec a1e06
        beq b1dd9
b1dd8:  rts

b1dd9:  lda #$30
        sta a1e06
        dec $0631
        lda $0631
        cmp #$30
        bne b1dd8
        lda #$01
        sta a1e04
        rts

b1df1:  lda #$39
        sta $0631
        lda #$30
        sta a1e06
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1e10:  dec $94
        beq b1e15
        rts

b1e15:  lda #$10
        sta $94
        nop
        inc $97
        lda $97
        cmp #$3a
        beq b1e23
        rts

b1e23:  lda #$30
        sta $97
        inc $96
        lda $96
        cmp #$3a
        beq b1e30
        rts

b1e30:  lda #$30
        sta $96
        inc $95
        lda $95
        cmp #$3a
        beq b1e3d
        rts

b1e3d:  lda #$39
        sta $95
        sta $96
        sta $97
        rts

s1e50:  lda $28
        bne b1e55
b1e54:  rts

b1e55:  lda $dc00                                       ;cia1: data port register a
        and #$10
        bne b1e54
        ldx #$f0
b1e5e:  lda #$20
        sta $0477,x
        dex
        bne b1e5e
        ldx #$50
b1e68:  sta $0428,x
        dex
        bpl b1e68
        jmp init_vars_p1

s1e75:  lda $29
        bne b1e7a
b1e79:  rts

b1e7a:  lda $dc01                                       ;cia1: data port register b
        and #$10
        bne b1e79
        ldx #$f0
b1e83:  lda #$20
        sta $06cf,x
        dex
        bne b1e83
        ldx #$50
b1e8d:  sta $0680,x
        dex
        bpl b1e8d
        jmp init_vars_p2

s1ea0:  lda #>p1eb0
        sta $0a01
        lda #<p1eb0
        sta $0a00
        lda #$93
        jmp rom_bsouti                                  ;$ffd2 (ind) ibsout output vector, chrout [ef79]

p1eb0:
        lda #$93
        jsr rom_bsouti                                  ;$ffd2 (ind) ibsout output vector, chrout [ef79]
        jmp j130a

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; variables
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
f193d:  .byte 0
a193e:  .byte 0
a193f:  .byte 0

a1ce8:  .byte $04

a1cab:  .byte $08

a1e00:  .byte $00
a1e01:  .byte $00
a1e02:  .byte $2a
a1e04:  .byte $00
a1e05:  .byte $00
a1e06:  .byte $12


label_txt_p1:
        .incbin "therace-game-central-map.bin"

