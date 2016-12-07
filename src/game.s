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
; ZP ABSOLUTE ADRESSES
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
zp_time_delay_p1 = $1f
zp_time_0_p1 = $21
zp_time_1_p1 = $22
zp_time_2_p1 = $23

zp_time_delay_p2 = $94
zp_time_0_p2 = $95
zp_time_1_p2 = $96
zp_time_2_p2 = $97

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

        lda #<p1eb0
        sta $0a00
        lda #>p1eb0
        sta $0a01
        lda #$93
        jsr rom_bsouti                                  ; $ffd2 (ind) ibsout output vector, chrout [ef79]

j130a:
        sei
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

        lda #0
        sta sync_irq_0
        sta sync_irq_2

        lda #%11000000                                  ;
        sta $0a04                                       ; init status

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

        cli

game_main_loop:
        lda sync_irq_2
        bne anim_irq_2

test_irq_0:
        lda sync_irq_0
        beq game_main_loop

anim_irq_0:
        dec sync_irq_0
        jsr update_p2
        jsr s15cc
        jmp game_main_loop

anim_irq_2:
        dec sync_irq_2
        jsr update_p1
        jsr s17ce
        jmp game_main_loop

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; init_vars_p1
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
init_vars_p1:
        lda #$30
        sta zp_time_0_p1
        sta zp_time_1_p1
        sta zp_time_2_p1

        lda #$00
        sta player_state_p1
        sta ready_to_start_p1
        sta $0b00
        sta $0b01
        sta $ff
        sta $fe
        sta $6a                                         ; ptr to map: LSB
        sta $6c
        sta $6e
        sta $70
        sta $72
        sta $74
        sta $24
        sta $26

        lda #$60                                        ; ptr to map: MSB
        sta $6b
        lda #$62
        sta $6d
        lda #$64
        sta $6f
        lda #$66
        sta $71
        lda #$68
        sta $73
        lda #$6a
        sta $75
        lda #$6c
        sta $25
        lda #$6e
        sta $27

        lda #$58
        sta $d001                                       ; sprite 0 y pos
        lda #$80
        sta $d000                                       ; sprite 0 x pos

        lda #$04
        sta zp_time_delay_p1

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
        sta $80                                         ; ptr to map: LSB
        sta $82
        sta $84
        sta $86
        sta $88
        sta $8a
        sta $8c
        sta $8e

        lda #$60                                        ; ptr to map: MSB
        sta $81
        lda #$62
        sta $83
        lda #$64
        sta $85
        lda #$66
        sta $87
        lda #$68
        sta $89
        lda #$6a
        sta $8b
        lda #$6c
        sta $8d
        lda #$6e
        sta $8f

        lda #$02
        sta $d029                                       ;sprite 2 color
        sta $d02a                                       ;sprite 3 color
        lda #$70
        sta $d006                                       ;sprite 3 x pos
        lda #$98
        sta $d007                                       ;sprite 3 y pos

        lda #$04
        sta zp_time_delay_p2

        lda #$00
        sta player_state_p2
        sta ready_to_start_p2
        sta $ae

        lda #$30
        sta zp_time_0_p2
        sta zp_time_1_p2
        sta zp_time_2_p2

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
; void scroll_p1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
scroll_p1:
        lda $ff
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
        cmp #$61
        bne @l6

        lda $6a
        cmp #$ff
        beq @l8

@l6:    clc                                             ; p1: map LSB
        inc $6a
        inc $6c
        inc $6e
        inc $70
        inc $72
        inc $74
        inc $24
        inc $26
        bne @l7

        inc $6b                                         ; p1: map MSB
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
; void udpate_p1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_p1:
        lda player_state_p1
        bne @l0
        rts

@l0:    jsr scroll_p1
        jsr read_joy_p1
        jsr s16d0
        jsr update_time_p1
        jsr print_time_p1
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s15cc:  jsr check_start_p1
        jsr check_start_p2
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
; void read_joy_p1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
read_joy_p1:
        lda $dc00                                       ; cia1: data port register a
        and #$0c
        cmp #$0c
        bne @l0

        lda #$00
        sta $1b

@l0:    lda $1b
        bne @l1

        lda $dc00                                       ; cia1: data port register a
        and #$04
        beq b1639

        lda $dc00                                       ; cia1: data port register a
        and #$08
        beq b1660

@l1:    lda $dc00                                       ; cia1: data port register a
        and #$10
        beq b15e0

        lda #$01
        sta $1c
j162a:  lda $dc00                                       ; cia1: data port register a
        and #$01
        beq b1697

        lda $dc00                                       ; cia1: data port register a
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

b1687:  lda $d001                                       ; sprite 0 y pos
        cmp #$7a
        bcs b169e

b168e:  ldx $1c
@l0:    inc $d001                                       ; sprite 0 y pos
        dex
        bne @l0
        rts

b1697:  lda $d001                                       ; sprite 0 y pos
        cmp #$3a
        bcc b168e

b169e:  ldx $1c
@l0:    dec $d001                                       ; sprite 0 y pos
        dex
        bne @l0
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void check_collisions()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
check_collisions:
        lda $d019                                       ; vic interrupt request register (irr)
        and #$02
        bne @l2

        lda #$01
        sta $d019                                       ; vic interrupt request register (irr)
        lda $d01f                                       ; sprite to background collision detect
        rts

@l2:
        lda $d01f                                       ; sprite to background collision detect
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

        lda p1_collision                                ; p1 collision ?
        bne b1965

j1958:  lda p2_collision                                ; p2 collision ?
        bne handle_p2_collision

j195d:  lda #$02
        sta $d019                                       ; vic interrupt request register (irr)
        rts

b1965:  jmp handle_p1_collision

handle_p2_collision:
        lda $af
        bne b1b46
        lda #$01
        sta $af

        lda $0652
        and #$0f
        tax
@l0:    jsr inc_score_p2
        dex
        bne @l0

        jsr play_collsion_p2

b1b46:  lda #$00
        sta p2_collision
        jmp j195d


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s16d0:  lda $ff
        bne @l0
@l1:    rts

@l0:    lda $1c
        cmp #$02
        bne @l1
        lda p1_collision
        cmp #$00
        bne @l1
        lda #$00
        sta $ff
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void scroll_p2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
scroll_p2:
        lda $af
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
        cmp #$61
        bne @l6

        lda $80
        cmp #$ff
        beq @l9

@l6:    clc
        inc $80                                         ; map p2: LSB
        inc $82
        inc $84
        inc $86
        inc $88
        inc $8a
        inc $8c
        inc $8e
        bne @l7

        inc $81                                         ; map p2: MSB
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
; void update_p2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_p2:
        lda player_state_p2
        bne @l0
        rts

@l0:
        jsr scroll_p2
        jsr read_joy_p2
        jsr s18d0
        jsr print_time_p2
        jsr update_time_p2
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s17ce:  jsr check_collisions
        jsr music_play
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
b17e0:  lda #$02
        sta $1e
        jmp j182a

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
read_joy_p2:
        lda $dc01                                       ; cia1: data port register b
        and #$0c
        cmp #$0c
        bne b180d
        lda #$00
        sta $1d

b180d:  lda $1d
        bne b181f
        lda $dc01                                       ; cia1: data port register b
        and #$04
        beq b1839

f1818:  lda $dc01                                       ; cia1: data port register b
        and #$08
        beq b1860
b181f:  lda $dc01                                       ; cia1: data port register b
        and #$10
        beq b17e0
        lda #$01
        sta $1e
j182a:  lda $dc01                                       ; cia1: data port register b
        and #$01
        beq b1897
        lda $dc01                                       ; cia1: data port register b
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

b1887:  lda $d003                                       ; sprite 1 y pos
        cmp #$f0
        bcs b189e
b188e:  ldx $1e
b1890:  inc $d003                                       ; sprite 1 y pos
        dex
        bne b1890
        rts

b1897:  lda $d003                                       ; sprite 1 y pos
        cmp #$af
        bcc b188e
b189e:  ldx $1e
b18a0:  dec $d003                                       ; sprite 1 y pos
        dex
        bne b18a0
        rts

s18d0:  lda $af
        bne b18d5
b18d4:  rts

b18d5:  lda $1e
        cmp #$02
        bne b18d4
        lda p2_collision
        bne b18d4
        lda #$00
        sta $af
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void udpate_time_p1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_time_p1:
        dec zp_time_delay_p1
        beq @l0
        rts

@l0:    lda #$10
        sta zp_time_delay_p1

        inc zp_time_2_p1
        lda zp_time_2_p1
        cmp #$3a
        beq @l1
        rts

@l1:    lda #$30
        sta zp_time_2_p1
        inc zp_time_1_p1
        lda zp_time_1_p1
        cmp #$3a
        beq @l2
        rts

@l2:    lda #$30
        sta zp_time_1_p1
        inc zp_time_0_p1
        lda zp_time_0_p1
        cmp #$3a
        beq @l3
        rts

@l3:    lda #$39
        sta zp_time_0_p1
        sta zp_time_1_p1
        sta zp_time_2_p1
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
print_time_p1:
        lda $fe
        beq @l0
        lda #$00
        sta player_state_p1
        sta ready_to_start_p1
        rts

@l0:    ldx #$02
@l1:    lda zp_time_0_p1,x
        sta $059a,x
        dex
        bpl @l1
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
print_time_p2:
        lda $ae
        beq @l0
        lda #$00
        sta player_state_p2
        sta ready_to_start_p2
        rts

@l0:    ldx #$02
@l1:    lda zp_time_0_p2,x
        sta $063a,x
        dex
        bpl @l1
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
handle_p1_collision:
        lda $ff
        bne b1b27
        lda #$01
        sta $ff

        lda $05b2
        and #$0f
        tax
@l0:    jsr inc_score_p1
        dex
        bne @l0

        jsr play_collsion_p1

b1b27:  lda #$00
        sta p1_collision
        jmp j1958


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
inc_score_p1:
        inc $05a9
        lda $05a9
        cmp #$3a
@l0:    bne @end

        lda #$30
        sta $05a9
        inc $05a8
        lda $05a8
        cmp #$3a
        bne @l0

        lda #$30
        sta $05a8
        inc $05a7
        lda $05a7
        cmp #$3a
        bne @l0

        lda #$30
        sta $05a7
        inc $05a6
        lda $05a6
        cmp #$3a
        bne @l0

        lda #$30
        sta $05a6
        inc $05a5
        lda $05a5
        cmp #$3a
        bne @l0

        lda #$39
        sta $05a5
        sta $05a6
@end:   rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
inc_score_p2:
        inc $0649
        lda $0649
        cmp #$3a
@l0:    bne @end

        lda #$30
        sta $0649
        inc $0648
        lda $0648
        cmp #$3a
        bne @l0

        lda #$30
        sta $0648
        inc $0647
        lda $0647
        cmp #$3a
        bne @l0

        lda #$30
        sta $0647
        inc $0646
        lda $0646
        cmp #$3a
        bne @l0

        lda #$30
        sta $0646
        inc $0645
        lda $0645
        cmp #$3a
        bne @l0

        lda #$39
        sta $0645
        sta $0646
@end:   rts


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

b1c57:  jsr play_collsion_or_wait_p1
        jsr inc_score_p1
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

b1ca4:  jsr play_collsion_or_wait_p2
        jsr inc_score_p2
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
play_collsion_p1:
        lda #$81
        sta $b0
        jmp j1cb6

play_collsion_or_wait_p1:
        lda #$21
        sta $b0
        dec sound_collsion_delay_p1
        beq j1cb6
        rts

j1cb6:
        lda #$00
        sta $d404                                       ; voice 1: control register
        lda #$08
        sta sound_collsion_delay_p1
        lda #$00
        sta $d400                                       ; voice 1: frequency control - low-byte
        lda #$0f
        sta $d401                                       ; voice 1: frequency control - high-byte
        lda #$00
        lda $d402                                       ; voice 1: pulse waveform width - low-byte
        lda #$01
        lda $d403                                       ; voice 1: pulse waveform width - high-nybble
        lda #$09
        lda $d405                                       ; voice 1: attack / decay cycle control
        lda #$01
        lda $d406                                       ; voice 1: sustain / release cycle control
        lda $b0
        sta $d404                                       ; voice 1: control register
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
play_collsion_p2:
        lda #$81
        sta $b1
        jmp s1cfa

play_collsion_or_wait_p2:
        lda #$21
        sta $b1
        dec sound_collsion_delay_p2
        beq s1cfa
        rts

s1cfa:
        lda #$00
        sta $d404                                       ; voice 1: control register
        lda #$08
        sta sound_collsion_delay_p2
        lda #$00
        sta $d400                                       ; voice 1: frequency control - low-byte
        lda #$15
        sta $d401                                       ; voice 1: frequency control - high-byte
        lda #$00
        lda $d409                                       ; voice 2: pulse waveform width - low-byte
        lda #$00
        lda $d40a                                       ; voice 2: pulse waveform width - high-nybble
        lda #$09
        lda $d40c                                       ; voice 2: attack / decay cycle control
        lda #$01
        lda $d40d                                       ; voice 2: sustain / release cycle control
        lda $b1
        sta $d404                                       ; voice 1: control register
        rts


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
check_start_p1:
        lda $fe
        beq @l0
        rts

@l0:    lda $dc00                                       ; cia1: data port register a
        and #$10
        bne update_countdown

        lda #$01
        sta ready_to_start_p1

update_countdown:
        jsr start_delay_p1
        jsr start_delay_p2
        rts

check_start_p2:
        lda $ae
        beq @l0
        rts

@l0:    lda $dc01                                       ; cia1: data port register b
        and #$10
        bne update_countdown
        lda #$01
        sta ready_to_start_p2
        jmp update_countdown


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void start_delay_p1()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
start_delay_p1:
        lda player_state_p1
        beq @l0
        rts

@l0:    lda ready_to_start_p1
        bne @l1
        rts

@l1:    lda ready_to_start_p2
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
        sta player_state_p1
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
        sta player_state_p1
        sta player_state_p2
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void start_delay_p2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
start_delay_p2:
        lda player_state_p2
        beq @l0
        rts

@l0:    lda ready_to_start_p2
        bne @l1
        rts

@l1:    lda ready_to_start_p1
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
        sta player_state_p2
        rts

b1df1:  lda #$39
        sta $0631
        lda #$30
        sta a1e06
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void update_time_p2()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
update_time_p2:
        dec zp_time_delay_p2
        beq b1e15
        rts

b1e15:  lda #$10
        sta zp_time_delay_p2
        nop
        inc zp_time_2_p2
        lda zp_time_2_p2
        cmp #$3a
        beq b1e23
        rts

b1e23:  lda #$30
        sta zp_time_2_p2
        inc zp_time_1_p2
        lda zp_time_1_p2
        cmp #$3a
        beq b1e30
        rts

b1e30:  lda #$30
        sta zp_time_1_p2
        inc zp_time_0_p2
        lda zp_time_0_p2
        cmp #$3a
        beq b1e3d
        rts

b1e3d:  lda #$39
        sta zp_time_0_p2
        sta zp_time_1_p2
        sta zp_time_2_p2
        rts

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
s1e50:  lda $28
        bne b1e55
b1e54:  rts

b1e55:  lda $dc00                                       ; cia1: data port register a
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

b1e7a:  lda $dc01                                       ; cia1: data port register b
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

p1eb0:
        lda #$93
        jsr rom_bsouti                                  ; $ffd2 (ind) ibsout output vector, chrout [ef79]
        jmp j130a

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; variables
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
f193d:                          .byte 0
p1_collision:                   .byte 0
p2_collision:                   .byte 0

sound_collsion_delay_p1:        .byte $08
sound_collsion_delay_p2:        .byte $08

player_state_p1:                .byte $00
ready_to_start_p1:              .byte $00
a1e02:                          .byte $2a

player_state_p2:                .byte $00
ready_to_start_p2:              .byte $00
a1e06:                          .byte $12


label_txt_p1:
        .incbin "therace-game-central-map.bin"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; .segment "LOWCODE"
; IRQ must be in LOWCODE
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "LOWCODE"
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; void irq_0()
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
irq_0:
        lda #$81
        sta $d012                                       ; raster position
        nop
        nop
        lda #%00011110                                  ; charset = $3800, screen = $400
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
        inc sync_irq_0
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
        lda #%00011110                                  ; charset = $3800, screen = $400
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
        inc sync_irq_2
        jmp $ff33                                       ; $ff33 return from interrupt

sync_irq_0: .byte  0
sync_irq_2: .byte  0

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; .segment "LEVEL1"
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.segment "LEVEL1"
        .incbin "therace-level1-map.bin"
