;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Race: https://github.com/ricardoquesada/c128-the-race
;
; Intro
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Imports
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.import ut_clear_screen, ut_clear_color

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
zp_scroll_mode = $fb
zp_fade_out_idx = $fc
zp_fade_in_idx = $fd
zp_scroll_speed = $fe                                   ; used in vic
zp_fade_out2_idx = $ff

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; PREDEFINED LABELS
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.if .defined(__C128__)
        default_irq_entry = $fa65
        default_irq_exit = $ff33
.elseif .defined(__C64__)
        default_irq_entry = $ea31
        default_irq_exit = $ea81
.endif

.segment "CODE"

.enum INTRO_STATE
        SCROLL
        FADE_OUT
        FADE_IN
        NOTHING
.endenum

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void intro_main()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export intro_main
intro_main:
        sei

.if .defined(__C128__)
        lda #<p29cd
        sta $0a00                                       ; basic restart routine
        lda #>p29cd
        sta $0a01
.endif

        ldx #<intro_irq_0
        ldy #>intro_irq_0
        stx $0314
        sty $0315

        lda #(50 + 25*8)
        sta $d012                                       ; raster position

        lda #1
        sta $d01a                                       ; enable irq interrupt

        lda #$03
        sta zp_scroll_speed

        lda #$1b
        sta $d011                                       ; vic control register 1

        lda #$c8
        sta $d016                                       ; vic control register 2

        lda #$00
        sta $d020                                       ; border color
        sta $d021                                       ; background color 0

        lda #$20
        jsr ut_clear_screen

        lda #$01                                        ; screen color ram
        jsr ut_clear_color

        lda #$ff
        ldx #$00
@l1:    sta $3200,x                                     ; black sprite
        dex
        bne @l1

        lda #%00000000
        sta $d01c                                       ; sprites multi-color mode select

        lda #%01111111
        sta $d01d                                       ; sprites expand 2x horizontal (x)
        sta $d015                                       ; sprite display enable

        lda #$00
        sta $d027                                       ; sprite 0 color
        sta $d028                                       ; sprite 1 color
        sta $d029                                       ; sprite 2 color
        sta $d02a                                       ; sprite 3 color
        sta $d02b                                       ; sprite 4 color
        sta $d02c                                       ; sprite 5 color
        sta $d02d                                       ; sprite 6 color

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

        lda #INTRO_STATE::SCROLL
        sta zp_scroll_mode

        lda #$0f
        sta zp_fade_out_idx
        sta zp_fade_out2_idx
        sta zp_fade_in_idx

        lda #$c8                                        ; points to $3200
        sta $07f8                                       ; sprite pointers
        sta $07f9
        sta $07fa
        sta $07fb
        sta $07fe
        sta $07fc
        sta $07fd

        lda #%00011110                                  ; charset = $3800, screen = $400
        sta $d018


        lda #%01000000
        sta $d010                                       ; sprites 0-7 msb of x coordinate

        cli


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
intro_main_loop:
        jsr check_space

        lda end_intro                                   ; end ?
        beq @l0

        lda #0
        sta $d01a                                       ; disable interrups and return
        rts

@l0:
        lda irq_sync                                    ; should sync with irq?
        beq intro_main_loop

        dec irq_sync

        lda zp_scroll_mode
        and #%01111111                                  ; mask out global fade out

        cmp #INTRO_STATE::SCROLL
        beq @l1                                         ; 0 = normal scroll

        cmp #INTRO_STATE::FADE_OUT
        beq @l2                                         ; 1 = fade out

        cmp #INTRO_STATE::FADE_IN
        beq @l3                                         ; 2 = fade in

        cmp #INTRO_STATE::NOTHING
        beq @next

@error: jmp @error

@next:
        lda zp_scroll_mode
        and #%10000000
        bne @l4
        jmp intro_main_loop


@l1:    jsr do_scroll                                   ; mode = 0
        jmp @next

@l2:    jsr do_fade_out                                 ; mode = 1
        jmp @next

@l3:    jsr do_fade_in                                  ; mode = 2
        jmp @next

@l4:    jsr do_fade_out2                                ; global fade out
        jmp intro_main_loop


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_0()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
intro_irq_0:
        asl $d019

        lda zp_scroll_speed
        ora #%00010000                                  ; disable blank
        sta $d011                                       ; smooth scroll y

        lda #(50 + 8 * 15)
        sta $d012

        ldx #<intro_irq_1
        ldy #>intro_irq_1
        stx $0314
        sty $0315

        jmp default_irq_exit

intro_irq_1:
        asl $d019

        lda #50
        sta $d012

        lda #%00010000
        sta $d011

        ldx #<intro_irq_0
        ldy #>intro_irq_0
        stx $0314
        sty $0315

        inc irq_sync
        jmp default_irq_exit


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_scroll()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_scroll:
        dec delay_scroll
        bmi @l0
        rts

@l0:    lda #$02
        sta delay_scroll

        ldx zp_scroll_speed
        dex
        txa
        and #%00000111
        sta zp_scroll_speed

        cmp #07
        beq do_the_scroll
        rts

do_the_scroll:

        ldx #39

@l0:
        .repeat 8, YY
                lda $0400+ 40 * (1 + YY),x
                sta $0400 + 40 * (0 + YY),x
        .endrepeat

@source_addr = *+1
        lda scroll_txt,x
        sta $0400 + 40 * 8,x

        dex
        bpl @l0

        inc scroll_row                          ; last row for scroll ?
        lda scroll_row
        cmp #25                                 ; end? loop the scroll
        beq @end_scroll

        clc                                     ; else, increment source addr
        lda @source_addr                         ; and return
        adc #40
        sta @source_addr
        bcc @l1
        inc @source_addr+1
@l1:    rts

@end_scroll:
        lda #INTRO_STATE::FADE_OUT
        sta zp_scroll_mode
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void check_space()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
check_space:
        lda $dc01
        and #$10
        beq @l0
        rts

@l0:
p29cd:
        lda zp_scroll_mode
        ora #%10000000
        sta zp_scroll_mode
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_fade_out()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_fade_out:
        dec delay_fadeout
        bmi @l3
        rts

@l3:    lda #$01
        sta delay_fadeout

        ldx zp_fade_out_idx
        lda colors_fade_out,x
        ldy #$00
@l2:    sta $d800,y
        sta $d900,y
        dey
        bne @l2

        dec zp_fade_out_idx
        bmi @l1
        rts

@l1:    lda #$20
        jsr ut_clear_screen

        ldx #$27
@l0:    lda label_0,x
        sta $0450,x
        dex
        bpl @l0

        lda #INTRO_STATE::FADE_IN
        sta zp_scroll_mode
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_fade_in()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_fade_in:
        dec delay_fadein
        bmi @l0
        rts
@l0:
        lda #$00
        sta delay_fadein

        ldx zp_fade_in_idx
        lda colors_fade_in,x
        ldy #$00
@l1:    sta $d800,y
        sta $d900,y
        dey
        bne @l1

        dec zp_fade_in_idx
        bmi @l2
        rts
@l2:
        lda zp_scroll_mode                                      ; enable global fade out
        ora #INTRO_STATE::NOTHING
        ora #%10000000
        sta zp_scroll_mode
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void do_fade_out2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
do_fade_out2:
        dec delay_fadeout2
        bmi @l3
        rts

@l3:    lda #$02
        sta delay_fadeout2

        ldx zp_fade_out2_idx
        lda colors_fade_out2,x
        ldy #$00
@l2:    sta $d800,y
        sta $d900,y
        dey
        bne @l2

        dec zp_fade_out2_idx
        bmi @l1
        rts

@l1:    inc end_intro
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; variables
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
end_intro:      .byte 0                 ; boolean: 1 if intro should end
irq_sync:       .byte 0                 ; boolean
scroll_row:     .byte 0                 ; rows scrolled
delay_scroll:   .byte 0
delay_fadeout:  .byte 0
delay_fadeout2: .byte 0
delay_fadein:   .byte 0

colors_fade_out:
        .byte $00, $00, $0b, $0b,  $0c, $0c, $0f, $0f
        .byte $01, $01, $01, $01,  $01, $01, $01, $01

colors_fade_out2:
        .byte $00, $00, $00, $00, $0b, $0b, $0b, $0b
        .byte $0c, $0c, $0c, $0c, $0f, $0f, $0f, $0f

colors_fade_in:
        .byte $01, $01, $01, $01,  $0f, $0f, $0f, $0f
        .byte $0c, $0c, $0c, $0c,  $0b, $0b, $0b, $0b

label_0:
                ;0123456789012345678901234567890123456789
        ; says  "   erasoft tambien crackea sus juegos   "
        .incbin "therace-legend-map.bin"

scroll_txt:
        .incbin "therace-scroll-map.bin"
        .byte 0

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; segment "SPRITES_INTRO" (@ $3200)
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "SPRITES_INTRO"
        .res 512, $ff
