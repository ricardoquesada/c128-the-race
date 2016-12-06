;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Race: https://github.com/ricardoquesada/c128-the-race
;
; Intro
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Macros
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.macpack cbm                            ; adds support for scrcode

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Constants
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.include "c64.inc"                      ; c64 constants

.segment "INIT"
.segment "STARTUP"
;
; **** predefined labels ****
;
rom_bsouti = $ffd2

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; intro_main
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
intro_main:
        lda #$00
        jsr $ff90                                       ; Control OS Messages

        lda #%11000000                                  ; no VCD charset, disable screen editor
        sta $0a04                                       ; init status

        sei
        lda #<irq_0
        sta $0314
        lda #>irq_0
        sta $0315
        cli

        lda #$00
        sta $fb
        sta $ff                                         ; scroll speed
        lda #$08
        sta $fa                                         ; spaced pressed ?

        lda #$ff
        sta $d015                                       ; sprite display enable

        lda #$00
        ldx #$00
@l0:    sta $d027,x                                     ; sprite 0 color
        inx
        cpx #$08
        bne @l0
        lda #$ff
        sta $d01c                                       ; sprites multi-color mode select
        lda #$01
        sta $d025                                       ; sprite multi-color register 0
        sta $d026                                       ; sprite multi-color register 1

        ldx #$00
@l1:    lda sprite_default_values,x
        sta sprite_runtime_values,x
        inx
        cpx #$28
        bne @l1

        lda #$4a                                        ; $4a = lsr
        sta a14b0
        lda #$93
        jsr rom_bsouti                                  ; $ffd2 (ind) ibsout output vector, chrout [ef79]

        ldx #$07
@l2:    lda sprite_ptrs,x
        sta $07f8,x                                     ; sprite pointers
        dex
        bpl @l2

        jsr init_screen

        ldx #$00
@l3:    lda labels_2,x
        sta $0400,x
        inx
        cpx #$28
        bne @l3

        ldx #$00
@l4:    lda #$01
        sta $d800,x                                     ; color RAM
        lda #$00
        sta $d900,x
        sta $da00,x
        inx
        bne @l4

main_loop:
        lda $dc01                                       ; cia1: data port register b
        cmp #$ef
        bne main_loop

        lda #$00
        sta $a1                                         ; reset jiffy time
        sta $a2

        lda #$00
        sta $fa                                         ; space pressed
        lda #$ea                                        ; $ea = nop
        sta a14b0
        rts


init_screen:
        sei
        lda #$00
        sta $dc0e                               ; cia1: cia control register a
        lda $d011                               ; vic control register 1
        and #$7f
        sta $d011                               ; vic control register 1
        lda #$32
        sta $d012                               ; raster position
        lda #$01
        sta $d01a                               ; vic interrupt mask register (imr)
        lda #$01
        sta $dc0d                               ; cia1: cia interrupt control register
        cli

        ldx #$00                                ; display "cracked by..."
@l0:    lda labels_0,x
        sta $0400 + 40 * 7,x
        inx
        bne @l0

        ldx #$0c
@l1:    lda labels_1,x
        sta $0400 + 40 * 2 + 13,x               ; display "erasoft '92"
        dex
        bpl @l1

        lda #$50
        sta $fe                                 ; $fe = top raster position
        lda #$b0
        sta $fd                                 ; $fd = bottom raster position

        lda #$e6                                ; $e6 = inc
        sta a17ed
        lda #$c6                                ; $c6 = dec
        sta a16bd                               ; inc/dec raster position

        lda #<scroll_txt
        sta $6a
        lda #>scroll_txt
        sta $6b
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_0
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_0:
        nop
        nop
        nop
        nop
        lda $fe                                 ; top raster position
        sta $d012                               ;raster position
        lda #$c8
        sta $d016                               ;vic control register 2

        nop

        ldx #$00
@l0:    lda #$01
        sta $d021                               ;background color 0
        sta $d020                               ;border color
        inx
        cpx #$04
        bne @l0

        lda #$00
        sta $d020                               ;border color
        sta $d021                               ;background color 0
        lda #<irq_1
        sta $0314
        lda #>irq_1
        sta $0315
        jsr animate
        lda $d019                               ;vic interrupt request register (irr)
        sta $d019                               ;vic interrupt request register (irr)
        jmp $fa65                               ;$fa65 (irq) normal entry

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_1
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_1:
        nop
        nop
        nop
        nop
        lda $fd
        sta $d012                               ;raster position
        nop
        nop
        nop
        nop
        nop

        ldx #$00
@l0:    lda colors,x
        sta $d021                               ;background color 0
        sta $d020                               ;border color
        inx
        cpx #$10
        bne @l0

        lda #$01
        sta $d020                               ;border color
        sta $d021                               ;background color 0
        lda #<irq_2
        sta $0314
        lda #>irq_2
        sta $0315
        jmp irq_exit

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_2
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_2:
        lda #$d6
        sta $d012                               ;raster position
        nop
        nop
        nop
        nop
        nop

        ldx #$10
@l0:    lda colors,x
        sta $d021                               ;background color 0
        sta $d020                               ;border color
        dex
        bpl @l0

        lda #$00
        sta $d020                               ;border color
        sta $d021                               ;background color 0

        nop
        nop
        nop
        nop
        nop

        lda #<irq_3
        sta $0314
        lda #>irq_3
        sta $0315

irq_exit:
        lda $d019                               ;vic interrupt request register (irr)
        sta $d019                               ;vic interrupt request register (irr)
        jmp $ff33                               ;$ff33 return from interrupt

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_3
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_3:
        lda #$e4
        sta $d012    ;raster position

        ldx #$04
@l0:    lda #$01
        sta $d020    ;border color
        sta $d021    ;background color 0
        dex
        bpl @l0

        lda #$02
        sta $d020    ;border color
        sta $d021    ;background color 0
        lda $ff
        sta $d016    ;vic control register 2

        lda #<irq_0
        sta $0314
        lda #>irq_0
        sta $0315
        jmp irq_exit


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void animate()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
animate:
        jsr update_sprites
        nop
        nop
        nop
        jsr check_space_pressed
        jsr scroll_top_colors
        jsr update_bottom_raster_position
        jsr update_top_raster_position
        jsr do_the_scroll
        jmp update_top_colors

check_space_pressed:
        lda $fa                                         ; space pressed
        beq b13ad
b13ac:  rts

b13ad:  lda $a2                                         ; jiffy time: lo
        cmp #$a0                                        ; turnoff irq?
        bne b13ac

        sei
        lda #<$fa65
        sta $0314                                       ; set IRQ vector
        lda #>$fa65
        sta $0315
        cli
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void scroll_top_colors()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
scroll_top_colors:
        lda $fb                                 ; $fb = color_scroll_speed
        beq @l1
        dec $fb
        rts

@l1:    lda #$01
        sta $fb
        lda colors
        pha

        ldx #$00
@l0:    lda colors+1,x
        sta colors,x
        inx
        cpx #$3f
        bne @l0

        pla
        sta colors + $3f
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void update_top_colors()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_top_colors:
        ldy #$00
        ldx #$27
@l0:    lda colors,x
        sta $d800,x
        sta $d800 + 40 * 21,y
        iny
        dex
        bpl @l0
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void update_bottom_raster_position()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_bottom_raster_position:
        ldx #$01
a16bd:  dec $fd                                         ; self modifying
        lda $fd
        cmp #$85
        beq @l0
        cmp #$b0
        beq @l0
        dex
        bne a16bd
        rts
@l0:
        lda a16bd                                       ; switch between $e6 / $c6
        eor #$20                                        ; dec / inc
        sta a16bd
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void update_top_raster_position()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_top_raster_position:
        ldx #$01
a17ed:  inc $fe                                         ; self modifying: inc/dec
        lda $fe
        cmp #$50
        beq @l0
        cmp #$7b
        beq @l0
        dex
        bne a17ed
        rts

@l0:    lda a17ed                                       ; switch between inc/dec
        eor #$20
        sta a17ed
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_the_scroll()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_the_scroll:
        ldx #$02
@l0:    txa
        pha
        jsr s18ad
        pla
        tax
        dex
        bpl @l0
        rts

s18ad:  dec $ff                                         ; scroll speed
        lda $ff
        cmp #$ff
        beq b18b6
        rts

b18b6:  lda #$07                                        ; reset speed counter
        sta $ff

        ldx #$00
@l1:    lda $0400 + 40 * 21 + 1,x                       ; scroll
        sta $0400 + 40 * 21,x
        inx
        cpx #$28
        bne @l1

        ldy #$00
        lda ($6a),y
        beq restart_scroll
        sta $0400 + 40 * 21 + 39

        lda $6a                                         ; increment scroll ptr by 1
        clc
        adc #$01
        sta $6a
        lda $6b
        adc #$00
        sta $6b

        rts

restart_scroll:
        lda #<scroll_txt
        sta $6a
        lda #>scroll_txt
        sta $6b
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void update_sprites()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_sprites:
        ldx #7

b1402:  lda sprite_y_dir,x
        bne b1480

        lda sprite_y,x
        cmp #$80
        bcc b1418

        lda #$01
        sta sprite_y_dir,x

        lda #$20
        sta sprite_y_vel,x

b1418:  jsr s141e
        jmp j1430

s141e:  txa
        asl
        tay
        lda sprite_x_lsb,x
        sta $d000,y                             ; sprite 0 x pos
        lda sprite_y,x
        sta $d001,y                             ; sprite 0 y pos
        jmp j14dc

j1430:  clc
        lda sprite_x_lsb,x
        adc #$01
        sta sprite_x_lsb,x
        bcc b1443
        lda sprite_x_msb,x
        eor #$01
        sta sprite_x_msb,x
b1443:  nop
        nop
        nop
        nop
        nop
        lda sprite_y_vel,x
        bmi b145a
        lsr
        lsr
        lsr
        clc
        adc sprite_y,x
        sta sprite_y,x
        jmp j1468

b145a:  eor #$ff
        lsr
        lsr
        lsr
        eor #$ff
        clc
        adc sprite_y,x
        sta sprite_y,x
j1468:  lda sprite_y_vel,x
        clc
        adc #$01
        sta sprite_y_vel,x
        dex
        bpl b1402
        rts

b1480:  lda sprite_y,x
        cmp #$80
        bcs b1492
        lda #$00
        sta sprite_y_dir,x
        lda #$e7
        sta sprite_y_vel,x
        nop
b1492:  jsr s141e

        nop
        nop
        nop

        clc
        lda sprite_x_lsb,x
        adc #$ff
        sta sprite_x_lsb,x
        bcs b14ab
        lda sprite_x_msb,x
        eor #$01
        sta sprite_x_msb,x
b14ab:  lda sprite_y_vel,x
        bmi b14bd
a14b0:  nop
        lsr
        lsr
        clc
        adc sprite_y,x
        sta sprite_y,x
        jmp j14cb

b14bd:  eor #$ff
        lsr
        lsr
        lsr
        eor #$ff
        clc
        adc sprite_y,x
        sta sprite_y,x

j14cb:  lda sprite_y_vel,x
        clc
        adc #$ff
        sta sprite_y_vel,x
        dex
        bpl b14d8
        rts

b14d8:  jmp b1402

        nop
j14dc:  lda sprite_x_msb + 7
        asl
        ora sprite_x_msb + 6
        asl
        ora sprite_x_msb + 5
        asl
        ora sprite_x_msb + 4
        asl
        ora sprite_x_msb + 3
        asl
        ora sprite_x_msb + 2
        asl
        ora sprite_x_msb + 1
        asl
        ora sprite_x_msb + 0
        sta $d010                               ; sprites 0-7 msb of x coordinate
        rts

;hexdump -e '".byte " 16/1 "$%02x," "\n"' scroll.txt
; dumped used 'ii' from vice
scroll_txt:
        scrcode "hola gente   para empezar el dia contento que hay que hacer?...   si tu no lo sabes quien lo va a saber?..."
        scrcode "pero la pregunta  no empieza por ahi si no por la mente... los dejo porque me voy a  comer"
        scrcode "... erasoft'92... space now!...         "
        scrcode "@"
        scrcode "que       que       que esta re fuerte, y a todos los nabos que pierden el tiempo lellendo scrolls... "
        scrcode " space now!...                     @"

labels_0:
                ;0123456789012345678901234567890123456789
        scrcode "                the race                "
        scrcode "          was written,composed          "
        scrcode "  cracked,broken,busted,performed and   "
        scrcode "           erasofted by the             "
        scrcode "                soldier                 "
        scrcode "            ricardo quesada             "
        scrcode "                "

labels_1:
        scrcode "erasoft 1992   "

labels_2:
        scrcode "        this game was erasofted        "
        ; unused ??
        .byte $20, $20, $20, $20,  $20, $20, $20, $20
        .byte $00, $00, $00, $00,  $00, $00, $00, $00

sprite_runtime_values:
sprite_y_dir:
        .byte $00, $01, $00, $00,  $01, $00, $01, $00
sprite_x_lsb:
        .byte $91, $a3, $d0, $e5,  $c8, $b9, $94, $7d
sprite_x_msb:
        .byte $00, $00, $00, $00,  $00, $00, $00, $00
sprite_y:
        .byte $fc, $00, $fc, $fc,  $00, $fc, $00, $fc
sprite_y_vel:
        .byte $e6, $21, $e6, $e6,  $21, $e6, $21, $e6

sprite_default_values:
        ; sprite y direction ???
        .byte $00, $00, $00, $01,  $01, $01, $01, $01
        ; sprite x lsb
        .byte $7c, $9a, $df, $fa,  $cd, $b8, $7f, $5e
        ; sprite x msb
        .byte $00, $00, $00, $00,  $00, $00, $00, $00
        ; sprite y
        .byte $4e, $42, $58, $97,  $b8, $be, $ae, $91
        ; sprite ???
        .byte $f6, $00, $17, $1c,  $0d, $06, $f3, $e8

colors:
        .byte $08, $08, $08, $02,  $02, $02, $02, $02
        .byte $02, $02, $02, $01,  $01, $01, $01, $01
        .byte $01, $01, $01, $03,  $03, $03, $03, $03
        .byte $03, $03, $04, $04,  $04, $04, $04, $04
        .byte $04, $04, $04, $05,  $05, $05, $05, $05
        .byte $05, $05, $05, $06,  $06, $06, $06, $06
        .byte $06, $06, $07, $07,  $07, $07, $07, $07
        .byte $07, $07, $07, $08,  $08, $08, $08, $08


sprite_ptrs:
        ; $c0 ->  $c0 * 64 = $3000
        .byte $c5, $c6, $c7, $c0,  $c1, $c2, $c3, $c4


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; segment "SPRITES"
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "SPRITES"
        .incbin "sprites.bin"

