;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Race: https://github.com/ricardoquesada/c128-the-race
;
; Cracktro
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Imports
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.import intro_main

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Macros
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.macpack cbm                            ; adds support for scrcode

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Constants
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.include "c64.inc"                      ; c64 constants

.segment "CODE"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; ZP ABSOLUTE ADRESSES
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
zp_scroll_addr_lo = $6a
zp_scroll_addr_hi = $6b
zp_color_speed  = $fb
zp_raster_pos_bottom = $fd
zp_raster_pos_top = $fe
zp_scroll_speed = $ff


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Predefined labels
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
rom_bsouti = $ffd2
rom_jsetmsg = $ff90

.if .defined(__C128__)
        default_irq_entry = $fa65
        default_irq_exit = $ff33
.elseif .defined(__C64__)
        default_irq_entry = $ea31
        default_irq_exit = $ea81
.endif

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; cracktro_main
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export cracktro_main
cracktro_main:
        lda #$00                                        ; no kernal messages displayed
        jsr rom_jsetmsg                                 ; Control OS Messages

        sei

        ldx #<irq_0
        ldy #>irq_0
        stx $0314
        sty $0315

        lda #$00
        sta zp_color_speed                              ; color_scroll_speed
        sta zp_scroll_speed                             ; scroll speed

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

        cli

main_loop:
        lda $dc01                                       ; cia1: data port register b
        cmp #$ef
        bne main_loop

        lda #$ea                                        ; $ea = nop
        sta a14b0

        lda #0
        sta counter_delay

@l0:    lda counter_delay
        cmp #128                                        ; wait two seconds
        bne @l0

        lda #0
        sta $d01a                                       ; disable irq interrupt

        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void init_screen()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
init_screen:
        sei
        lda $d011                               ; vic control register 1
        and #$7f
        sta $d011                               ; vic control register 1

        lda #$32
        sta $d012                               ; raster position

        lda #$01
        sta $d01a                               ; enable raster interrup
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
        sta zp_raster_pos_top
        lda #$b0
        sta zp_raster_pos_bottom

        lda #$e6                                ; $e6 = inc
        sta a17ed
        lda #$c6                                ; $c6 = dec
        sta a16bd                               ; inc/dec raster position

        ldx #<scroll_txt
        ldy #>scroll_txt
        stx zp_scroll_addr_lo
        sty zp_scroll_addr_hi
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_0
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_0:
        nop
        nop
        nop
        nop

        lda zp_raster_pos_top
        sta $d012                               ; raster position

        lda #$c8
        sta $d016                               ; vic control register 2

        nop

        ldx #$00
@l0:    lda #$01
        sta $d021                               ; background color 0
        sta $d020                               ; border color
        inx
        cpx #$04
        bne @l0

        lda #$00
        sta $d020                               ; border color
        sta $d021                               ; background color 0

        ldx #<irq_1
        ldy #>irq_1
        stx $0314
        sty $0315

        jsr animate

        asl $d019

        inc counter_delay
        jmp default_irq_exit                    ; irq exit

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_1
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_1:
        nop
        nop
        nop
        nop

        lda zp_raster_pos_bottom
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

        ldx #<irq_2
        ldy #>irq_2
        stx $0314
        sty $0315

        asl $d019

        jmp default_irq_exit

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_2
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_2:
        lda #$d6
        sta $d012                               ; raster position

        nop
        nop
        nop
        nop
        nop

        ldx #$10
@l0:    lda colors,x
        sta $d021                               ; background color 0
        sta $d020                               ; border color
        dex
        bpl @l0

        lda #$00
        sta $d020                               ; border color
        sta $d021                               ; background color 0

        ldx #<irq_3
        ldy #>irq_3
        stx $0314
        sty $0315

        asl $d019

        jmp default_irq_exit                    ; return from interrupt

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq_3
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_3:
        lda #$e4
        sta $d012                               ; raster position

        ldx #$04
@l0:    lda #$01
        sta $d020                               ; border color
        sta $d021                               ; background color 0
        dex
        bpl @l0

        lda #$02
        sta $d020                               ; border color
        sta $d021                               ; background color 0

        lda zp_scroll_speed
        sta $d016                               ; vic control register 2

        ldx #<irq_0
        ldy #>irq_0
        stx $0314
        sty $0315

        asl $d019

        jmp default_irq_exit                    ; return from interrupt


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void animate()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
animate:
        jsr update_sprites
        nop
        nop
        nop
        jsr scroll_top_colors
        jsr update_bottom_raster_position
        jsr update_top_raster_position
        jsr do_the_scroll
        jmp update_top_colors


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void scroll_top_colors()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
scroll_top_colors:
        lda zp_color_speed
        beq @l1
        dec zp_color_speed
        rts

@l1:    lda #$01
        sta zp_color_speed
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
a16bd:  dec zp_raster_pos_bottom                        ; self modifying: inc/dec
        lda zp_raster_pos_bottom
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
a17ed:  inc zp_raster_pos_top                           ; self modifying: inc/dec
        lda zp_raster_pos_top
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
        jsr scroll_it
        pla
        tax
        dex
        bpl @l0
        rts

scroll_it:
        dec zp_scroll_speed                             ; scroll speed
        lda zp_scroll_speed
        cmp #$ff
        beq @l1
        rts

@l1:    lda #$07                                        ; reset speed counter
        sta zp_scroll_speed

        ldx #$00
@l2:    lda $0400 + 40 * 21 + 1,x                       ; scroll
        sta $0400 + 40 * 21,x
        inx
        cpx #$28
        bne @l2

        ldy #$00
        lda (zp_scroll_addr_lo),y
        beq restart_scroll
        sta $0400 + 40 * 21 + 39

        lda zp_scroll_addr_lo                           ; increment scroll ptr by 1
        clc
        adc #$01
        sta zp_scroll_addr_lo
        lda zp_scroll_addr_hi
        adc #$00
        sta zp_scroll_addr_hi

        rts

restart_scroll:
        lda #<scroll_txt
        sta zp_scroll_addr_lo
        lda #>scroll_txt
        sta zp_scroll_addr_hi
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void update_sprites()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_sprites:
        ldx #7

sprites_loop:
        lda sprite_x_dir,x                              ; left or right ?
        bne do_left

                                                        ; do right
        lda sprite_y,x                                  ; above or below midpoint ?
        cmp #$80
        bcc @l0                                         ; above midpoint

        lda #$01                                        ; below midpoint
        sta sprite_x_dir,x                              ; change direction. go left
        lda #%00100000                                  ; ($20) and start deccel
        sta sprite_y_vel,x

@l0:    jsr set_sprite_in_vic
        jmp sprite_go_right

sprite_go_right:
        clc
        lda sprite_x_lsb,x                              ; x++
        adc #$01                                        ; sprite go right
        sta sprite_x_lsb,x
        bcc @l2
        lda sprite_x_msb,x                              ; update x MSB if needed
        eor #$01
        sta sprite_x_msb,x

@l2:    nop
        nop
        nop
        nop
        nop
        lda sprite_y_vel,x                              ; positive or negative vel?
        bmi @l0

        lsr                                             ; sprite go down (positive speed)
        lsr                                             ; y += speed / 8
        lsr
        clc
        adc sprite_y,x
        sta sprite_y,x
        jmp @l1

@l0:    eor #$ff                                        ; sprite go up (negative speed)
        lsr                                             ; y -= speed / 8
        lsr
        lsr
        eor #$ff
        clc
        adc sprite_y,x
        sta sprite_y,x

@l1:    lda sprite_y_vel,x                              ; vel_y++
        clc
        adc #$01
        sta sprite_y_vel,x

        dex
        bpl sprites_loop
        rts


do_left:
        lda sprite_y,x
        cmp #$80                                        ; midpoint: above or below ?
        bcs @l0                                         ; below midpoint

        lda #$00                                        ; above midpoint
        sta sprite_x_dir,x                              ; so change direction. go right
        lda #%11100111                                  ; ($e7) and start deccel
        sta sprite_y_vel,x

        nop
@l0:    jsr set_sprite_in_vic

        nop
        nop
        nop

        clc
        lda sprite_x_lsb,x                              ; sprite go left
        adc #$ff                                        ; x--
        sta sprite_x_lsb,x
        bcs @l1
        lda sprite_x_msb,x                              ; update MSB if needed
        eor #$01
        sta sprite_x_msb,x

@l1:    lda sprite_y_vel,x
        bmi b14bd

a14b0 = *
        lsr                                             ; self modifying: nop/lsr
        lsr                                             ; sprite go down (positive speed)
        lsr                                             ; y += speed / 8

        clc
        adc sprite_y,x
        sta sprite_y,x
        jmp j14cb

b14bd:  eor #$ff                                        ; sprite go up (negative speed)
        lsr                                             ; y -= speed / 8
        lsr
        lsr
        eor #$ff
        clc
        adc sprite_y,x
        sta sprite_y,x

j14cb:  lda sprite_y_vel,x                              ; vel_y--
        clc
        adc #$ff
        sta sprite_y_vel,x

        dex
        bpl @l0
        rts

@l0:    jmp sprites_loop

set_sprite_in_vic:
        txa
        asl
        tay
        lda sprite_x_lsb,x
        sta $d000,y                                     ; sprite 0 x pos
        lda sprite_y,x
        sta $d001,y                                     ; sprite 0 y pos

        lda sprite_x_msb + 7
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
sprite_x_dir:
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
        ; sprite x direction
        .byte $00, $00, $00, $01,  $01, $01, $01, $01
        ; sprite x lsb
        .byte $7c, $9a, $df, $fa,  $cd, $b8, $7f, $5e
        ; sprite x msb
        .byte $00, $00, $00, $00,  $00, $00, $00, $00
        ; sprite y
        .byte $4e, $42, $58, $97,  $b8, $be, $ae, $91
        ; sprite y vel
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

counter_delay:
        .byte 0


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; segment "SPRITES_CRACKTRO"
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "SPRITES_CRACKTRO"
        .incbin "sprites.bin"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; segment "CHARSET"
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "CHARSET"
        .incbin "therace-level1-charset.bin"

