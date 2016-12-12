;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;
; The Uni Games: https://github.com/ricardoquesada/c64-the-uni-games
;
; Collection of utils functions
;
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

.segment "CODE"

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; ut_clear_screen(int char_used_to_clean)
;------------------------------------------------------------------------------;
; Args: A char used to clean the screen.
; Clears the screen
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export ut_clear_screen
.proc ut_clear_screen
        ldx #0
:       sta $0400,x                     ; clears the screen memory
        sta $0500,x                     ; but assumes that VIC is using bank 0
        sta $0600,x                     ; otherwise it won't work
        sta $06e8,x
        inx                             ; 1000 bytes = 40*25
        bne :-

        rts
.endproc


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; ut_clear_color(int foreground_color)
;------------------------------------------------------------------------------;
; Args: A color to be used. Only lower 3 bits are used.
; Changes foreground RAM color
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.export ut_clear_color
.proc ut_clear_color
        ldx #0
:       sta $d800,x                     ; clears the screen color memory
        sta $d900,x                     ; works for any VIC bank
        sta $da00,x
        sta $dae8,x
        inx                             ; 1000 bytes = 40*25
        bne :-

        rts
.endproc

