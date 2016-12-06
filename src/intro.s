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

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; ZP ABSOLUTE ADRESSES
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
zp_scroll_addr_lo = $6a
zp_scroll_addr_hi = $6b
zp_scroll_mode = $6c
zp_fade_out_idx = $6d
zp_fade_in_idx = $6e
zp_scroll_speed = $fa                                   ; used in vic
zp_screen_row0_lo = $fb
zp_screen_row0_hi = $fc
zp_screen_row1_lo = $fd
zp_screen_row1_hi = $fe
zp_delay = $ff

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; PREDEFINED LABELS
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
rom_cint = $ff81
rom_ioinit = $ff84
rom_restor = $ff8a
rom_key = $ff9f
rom_closei = $ffc3
rom_bsouti = $ffd2
rom_clalli = $ffe7

.segment "INIT"
.segment "STARTUP"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void intro_main()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export intro_main
intro_main:
        sei
        lda #<irq_0
        sta $0314
        lda #>irq_0
        sta $0315
        cli

        lda #$07
        sta zp_scroll_speed
        lda #$00
        sta zp_delay
        sta zp_screen_row0_lo
        lda #$04
        sta zp_screen_row0_hi
        sta zp_screen_row1_hi
        lda #$28
        sta zp_screen_row1_lo
        lda #$1b
        sta $d011                                       ; vic control register 1
        lda #$32
        sta $d012                                       ; raster position
        lda #$c8
        sta $d016                                       ; vic control register 2

        lda #<scroll_txt
        sta zp_scroll_addr_lo
        lda #>scroll_txt
        sta zp_scroll_addr_hi

        lda #$93
        jsr rom_bsouti                                  ; $ffd2 (ind) ibsout output vector, chrout [ef79]

        lda #$00
        sta $d020                                       ; border color
        sta $d021                                       ; background color 0

        lda #$01                                        ; screen color ram
        ldx #$00
@l0:    sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        dex
        bne @l0

        lda #$c0                                        ; no vcd charset, no editor
        sta $0a04                                       ; init status

        lda #$ff
        ldx #$00
@l1:    sta $0f80,x                                     ; black sprite
        nop
        nop
        nop
        dex
        bne @l1

        lda #%00000000
        sta $d01c                                       ; sprites multi-color mode select

        lda #%01111111
        sta $d01d                                       ; sprites expand 2x horizontal (x)

        lda #$00
        sta $d027                                       ; sprite 0 color
        sta $d028                                       ; sprite 1 color
        sta $d029                                       ; sprite 2 color
        sta $d02a                                       ; sprite 3 color
        sta $d02b                                       ; sprite 4 color
        sta $d02c                                       ; sprite 5 color
        sta $d02d                                       ; sprite 6 color

        lda #%01111111
        sta $d015                                       ; sprite display enable

        lda #$7a
        sta $d001                                       ; sprite 0 y pos
        sta $d003                                       ; sprite 1 y pos
        sta $d005                                       ; sprite 2 y pos
        sta $d007                                       ; sprite 3 y pos
        sta $d009                                       ; sprite 4 y pos
        sta $d00b                                       ; sprite 5 y pos
        sta $d00d                                       ; sprite 6 y pos

        lda #$40
        sta $d000                                       ; sprite 0 x pos
        lda #$70
        sta $d002                                       ; sprite 1 x pos
        lda #$a0
        sta $d004                                       ; sprite 2 x pos
        lda #$cf
        sta $d006                                       ; sprite 3 x pos
        lda #$ff
        sta $d008                                       ; sprite 4 x pos
        lda #$20
        sta $d00a                                       ; sprite 5 x pos
        lda #$20
        sta $d00c                                       ; sprite 6 x pos

        lda #00
        sta zp_scroll_mode
        lda #$0f
        sta zp_fade_out_idx
        lda #$08
        sta zp_fade_in_idx                              ; color for scroll row

        lda #%00011110                                  ; charset = $3800, screen = $400
        sta $0a2c                                       ; shadow for $d018

        lda #$3e                                        ; points to $f80
        sta $07f8                                       ; sprite pointers
        sta $07f9
        sta $07fa
        sta $07fb
        sta $07fe
        sta $07fc
        sta $07fd

        lda #<p29cd
        sta $0a00                                       ; basic restart routine
        lda #>p29cd
        sta $0a01

        lda #%01000000
        sta $d010                                       ; sprites 0-7 msb of x coordinate

        lda #$0b
        jsr rom_bsouti                                  ; $ffd2 (ind) ibsout output vector, chrout [ef79]

j29bd:  jmp j29bd

b28cd:  jmp check_space                                 ; mode = 4

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_0()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_0:
        lda zp_scroll_mode
        beq b28e7                                       ; 0 = normal scroll
        cmp #$01
        beq b28ed                                       ; 1 = fade out
        cmp #$02
        beq b28f3                                       ; 2 = fade in
        cmp #$03
        beq b28f9                                       ; 3 = unused
        cmp #$04
        beq b28cd                                       ; 4 = check space
        jmp $fa65                                       ;$fa65 (irq) normal entry

b28e7:  jsr do_scroll                                   ; mode = 0
        jmp $fa65

b28ed:  jsr do_fade_out                                 ; mode = 1
        jmp $fa65

b28f3:  jsr do_fade_in                                  ; mode = 2
        jmp $fa65

b28f9:  jsr $2a50                                       ; mode = 3
        jmp $fa65                                       ; XXX: $2a50 is garbage


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_scroll()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_scroll:
        lda zp_delay
        beq b2907
        dec zp_delay
        rts

b2907:  lda #$08
        sta zp_delay
        lda zp_scroll_speed
        and #$17
        ora #$10
        sta $d011                                       ;vic control register 1
        lda zp_scroll_speed
        cmp #$ff
        beq b291d
        dec zp_scroll_speed
        rts

b291d:  lda #$07
        sta zp_scroll_speed

        ldx #$08
@l1:    ldy #$27
@l0:    lda (zp_screen_row1_lo),y
        sta (zp_screen_row0_lo),y
        dey
        bpl @l0

        clc
        lda zp_screen_row1_lo
        adc #$28
        sta zp_screen_row1_lo
        lda zp_screen_row1_hi
        adc #$00
        sta zp_screen_row1_hi

        clc
        lda zp_screen_row0_lo
        adc #$28
        sta zp_screen_row0_lo
        lda zp_screen_row0_hi
        adc #$00
        sta zp_screen_row0_hi

        dex
        bpl @l1

        ldy #$27
@l2:    lda (zp_scroll_addr_lo),y
        beq b2970
        sta (zp_screen_row0_lo),y
        dey
        bpl @l2

s2954:  lda #<$0400
        sta zp_screen_row0_lo
        lda #>$0400
        sta zp_screen_row0_hi
        sta zp_screen_row1_hi
        lda #$28
        sta zp_screen_row1_lo

        clc
        lda zp_scroll_addr_lo
        adc #$28
        sta zp_scroll_addr_lo
        lda zp_scroll_addr_hi
        adc #$00
        sta zp_scroll_addr_hi
        rts

b2970:  jsr s2954
        lda #<$1600                                     ; XXX: should be <scroll_txt
        sta zp_scroll_addr_lo
        lda #>$1600                                     ; XXX: should be >scroll_txt
        sta zp_scroll_addr_hi
        lda #$01
        sta zp_scroll_mode
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void check_space()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
check_space:
        lda $dc01
        and #$10
        beq @l0
        jmp $fa65                                       ;$fa65 (irq) normal entry

@l0:
p29cd:
        sei

        lda #<$fa65
        sta $0315
        lda #>$fa65
        sta $0314

        jsr rom_restor                                  ;$ff8a (jmp) restor restore vectors
        jsr rom_ioinit                                  ;$ff84 (jmp) ioinit init i/o devices, ports & timers
        jsr rom_cint                                    ;$ff81 (jmp) cint init editor & video chips

        cli

        ;jmp game_init
        jmp intro_main


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_fade_out()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_fade_out:
        lda zp_delay
        beq @l3
        dec zp_delay
        rts

@l3:    lda #$10
        sta zp_delay
        ldx zp_fade_out_idx
        lda colors_fade_out,x
        ldy #$00
@l2:    sta $d800,y
        sta $d900,y
        dey
        bne @l2
        dex
        stx zp_fade_out_idx
        beq @l1
        rts

@l1:    lda #$00
        sta $f1
        lda #$93
        jsr rom_bsouti                                  ;$ffd2 (ind) ibsout output vector, chrout [ef79]

        ldx #$27
@l0:    lda label_0,x
        sta $0450,x
        dex
        bpl @l0

        lda #$02
        sta zp_scroll_mode
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_fade_in()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_fade_in:
        lda zp_delay
        beq @l0
        dec zp_delay
        rts
@l0:
        lda #$10
        sta zp_delay
        ldx zp_fade_in_idx
        lda colors_fade_in,x
        ldy #$00
@l1:    sta $d800,y
        sta $d900,y
        dey
        bne @l1

        dex
        stx zp_fade_in_idx
        cpx #$00
        beq @l2
        rts

@l2:    lda #$04
        sta zp_scroll_mode
        rts

colors_fade_out:
        .byte $00, $00, $00, $00,  $0f, $01, $01, $01
        .byte $01, $01, $01, $01,  $01, $01, $01, $01

colors_fade_in:
        .byte $00, $01, $0f, $00,  $00, $00, $00, $00
        .byte $00, $00, $00, $00,  $02, $03, $04, $01

label_0:
                ;0123456789012345678901234567890123456789
        ; says  "   erasoft tambien crackea sus juegos   "
        .incbin "therace-legend-map.bin"

scroll_txt:
        .incbin "therace-scroll-map.bin"
        .byte $20
        .byte 0
