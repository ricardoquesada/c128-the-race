;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Race: https://github.com/ricardoquesada/c128-the-race
;
; Music file
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

.segment "INIT"
.segment "STARTUP"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; main
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.proc music_main
        jsr music_init
        sei
        lda #<irq_vector
        sta $0314
        lda #>irq_vector
        sta $0315
        cli
        rts
.endproc

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; setup
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export music_init
.proc music_init
        lda #<voice_3_data
        sta $c8
        lda #>voice_3_data
        sta $c9

        lda #<voice_2_data
        sta $ca
        lda #>voice_2_data
        sta $cb

        lda #$01
        sta $d40a                               ; voice 2: pulse waveform width - high-nybble
        sta $d411                               ; voice 3: pulse waveform width - high-nybble
        lda #$09
        sta $d405                               ; voice 1: attack / decay cycle control
        lda #$01
        sta $d406                               ; voice 1: sustain / release cycle control
        lda #$14
        sta $d40c                               ; voice 2: attack / decay cycle control
        lda #$41
        sta $d40d                               ; voice 2: sustain / release cycle control
        lda #$0e
        sta $d413                               ; voice 3: attack / decay cycle control
        lda #$10
        sta $d414                               ; voice 3: sustain / release cycle control
        lda #$01
        sta voice_3_duration
        sta voice_2_duration
        rts
.endproc

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; irq vector
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.proc irq_vector
        jsr music_play
        jmp $fa65                               ; $fa65 (irq) normal entry

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; music_play
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export music_play
music_play:

test_voice_3:
        dec voice_3_duration
        beq play_voice_3
test_voice_2:
        dec voice_2_duration
        beq play_voice_2
        rts

play_voice_3:
        lda #$00
        sta $d412                               ; voice 3: control register
        ldy #$03
@l0:    lda ($c8),y
        sta voice_3_shadow,y
        dey
        bpl @l0

        lda voice_3_ctrl_reg
        beq @l2

        ldx #$03
@l1:    lda $c8
        clc
        adc #$01
        sta $c8
        lda $c9
        adc #$00
        sta $c9
        dex
        bpl @l1

        lda voice_3_hi_freq
        sta $d40f                               ; voice 3: frequency control - high-byte
        lda voice_3_lo_freq
        sta $d40e                               ; voice 3: frequency control - low-byte
        lda voice_3_ctrl_reg
        sta $d412                               ; voice 3: control register
        jmp test_voice_2

@l2:    lda #<voice_3_data                      ; restart song voice 3
        sta $c8
        lda #>voice_3_data
        sta $c9
        jmp test_voice_3

play_voice_2:
        lda #$00
        sta $d40b                               ; voice 2: control register
        ldy #$03
@l0:    lda ($ca),y
        sta voice_2_shadow,y
        dey
        bpl @l0
        lda voice_2_ctrl_reg
        beq @l2

        ldx #$03
@l1:    lda $ca
        clc
        adc #$01
        sta $ca
        lda $cb
        adc #$00
        sta $cb
        dex
        bpl @l1

        lda voice_2_hi_freq
        sta $d408                               ; voice 2: frequency control - high-byte
        lda voice_2_lo_freq
        sta $d407                               ; voice 2: frequency control - low-byte
        lda voice_2_ctrl_reg
        sta $d40b                               ; voice 2: control register
        rts

@l2:    lda #<voice_2_data                      ; restart song voice 2
        sta $ca
        lda #>voice_2_data
        sta $cb
        rts
.endproc

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; data
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
voice_2_shadow:
voice_2_hi_freq:        .byte 0                 ; freq hi
voice_2_lo_freq:        .byte 0                 ; freq lo
voice_2_ctrl_reg:       .byte 0                 ; control register
voice_2_duration:       .byte 0                 ; duration

voice_3_shadow:
voice_3_hi_freq:        .byte 0                 ; freq hi
voice_3_lo_freq:        .byte 0                 ; freq lo
voice_3_ctrl_reg:       .byte 0                 ; control register
voice_3_duration:       .byte 0                 ; duration


voice_2_data:
        ; dumped using: hexdump -e '".byte " 4/1 "$%02x," "\n"' voice2.bin
        ; hi, lo, ctrl, duration
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $10,$c3,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$10,$08
        .byte $0e,$4e,$11,$08
        .byte $00,$00,$00,$08

voice_3_data:
        ; dumped using: hexdump -e '".byte " 4/1 "$%02x," "\n"' voice3.bin
        ; hi, lo, ctrl, duration
        .byte $00,$00,$10,$00
        .byte $00,$00,$10,$52
        .byte $00,$00,$10,$01
        .byte $15,$1f,$11,$10
        .byte $19,$1e,$11,$0b
        .byte $15,$1f,$11,$10
        .byte $15,$1f,$11,$0b
        .byte $19,$1e,$11,$10
        .byte $15,$1f,$11,$0b
        .byte $16,$60,$11,$10
        .byte $19,$1e,$11,$10
        .byte $15,$1f,$10,$f0
        .byte $16,$60,$10,$f0
        .byte $21,$87,$11,$10
        .byte $25,$a2,$11,$68
        .byte $21,$87,$11,$10
        .byte $1c,$31,$11,$68
        .byte $21,$87,$11,$10
        .byte $19,$1e,$11,$00
        .byte $00,$00,$10,$20
        .byte $00,$00,$10,$f0
        .byte $21,$87,$11,$d0
        .byte $16,$60,$11,$00
        .byte $00,$00,$10,$40
        .byte $00,$00,$10,$10
        .byte $08,$61,$11,$80
        .byte $06,$47,$11,$00
        .byte $00,$00,$01,$01
        .byte $00,$00,$01,$d0
        .byte $21,$87,$11,$10
        .byte $25,$a2,$11,$68
        .byte $21,$87,$11,$10
        .byte $1c,$31,$11,$68
        .byte $21,$87,$11,$10
        .byte $1f,$a5,$11,$68
        .byte $21,$87,$11,$10
        .byte $19,$1e,$11,$00
        .byte $00,$00,$11,$00
        .byte $00,$00,$10,$10
        .byte $21,$87,$11,$08
        .byte $25,$a2,$11,$08
        .byte $21,$87,$11,$10
        .byte $19,$1e,$11,$30
        .byte $21,$87,$11,$00
        .byte $00,$00,$00,$01
