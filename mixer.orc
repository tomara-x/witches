;trans rights

;this beauty is from the csound-live-code library by Steven Yi
;[https://github.com/kunstmusik/csound-live-code]

;; Stereo Audio Bus
ga_sbus[] init 16, 2

/** Write two audio signals into stereo bus at given index */
opcode sbus_write, 0,iaa
  ibus, al, ar xin
  ga_sbus[ibus][0] = al
  ga_sbus[ibus][1] = ar
endop

/** Mix two audio signals into stereo bus at given index */
opcode sbus_mix, 0,iaa
  ibus, al, ar xin
  ga_sbus[ibus][0] = ga_sbus[ibus][0] + al
  ga_sbus[ibus][1] = ga_sbus[ibus][1] + ar
endop

/** Clear audio signals from bus channel */
opcode sbus_clear, 0, i
  ibus xin
  aclear init 0
  ga_sbus[ibus][0] = aclear
  ga_sbus[ibus][1] = aclear
endop

/** Read audio signals from bus channel */
opcode sbus_read, aa, i
  ibus xin
  al = ga_sbus[ibus][0] 
  ar = ga_sbus[ibus][1] 
  xout al, ar
endop


;the following is me overloadig and defining more stuff
;normalled versions of write and mix
opcode sbus_write, 0,ia
  ibus, ain  xin
  ga_sbus[ibus][0] = ain
  ga_sbus[ibus][1] = ain
endop
opcode sbus_mix, 0,ia
  ibus, ain xin
  ga_sbus[ibus][0] = ga_sbus[ibus][0] + ain
  ga_sbus[ibus][1] = ga_sbus[ibus][1] + ain
endop

//don't think i'll use these 2 much anymore
;multiply channel (for setting amplitude)
opcode sbus_mult, 0, ik
  ibus, km xin
  ga_sbus[ibus][0] = ga_sbus[ibus][0] * km
  ga_sbus[ibus][1] = ga_sbus[ibus][1] * km
endop
opcode sbus_mult, 0, ikk ;each stereo channel separately
;must make sure second arg is k, otherwise it's an ambiguous call
;(because of previous definition and optional iksmps) (or use pan2)
  ibus, kml, kmr xin
  ga_sbus[ibus][0] = ga_sbus[ibus][0] * kml
  ga_sbus[ibus][1] = ga_sbus[ibus][1] * kmr
endop

;output a stereo mix of all 16 channels
opcode sbus_out, aa, 0
 al = ga_sbus[0][0]+ga_sbus[1][0]+ga_sbus[2][0]+ga_sbus[3][0]+
      ga_sbus[4][0]+ga_sbus[5][0]+ga_sbus[6][0]+ga_sbus[7][0]+
      ga_sbus[8][0]+ga_sbus[9][0]+ga_sbus[10][0]+ga_sbus[11][0]+
      ga_sbus[12][0]+ga_sbus[13][0]+ga_sbus[14][0]+ga_sbus[15][0]
 ar = ga_sbus[0][1]+ga_sbus[1][1]+ga_sbus[2][1]+ga_sbus[3][1]+
      ga_sbus[4][1]+ga_sbus[5][1]+ga_sbus[6][1]+ga_sbus[7][1]+
      ga_sbus[8][1]+ga_sbus[9][1]+ga_sbus[10][1]+ga_sbus[11][1]+
      ga_sbus[12][1]+ga_sbus[13][1]+ga_sbus[14][1]+ga_sbus[15][1]
  xout al, ar
endop

;clear entire bus
opcode sbus_clear_all, 0, 0
  sbus_clear 0
  sbus_clear 1
  sbus_clear 2
  sbus_clear 3
  sbus_clear 4
  sbus_clear 5
  sbus_clear 6
  sbus_clear 7
  sbus_clear 8
  sbus_clear 9
  sbus_clear 10
  sbus_clear 11
  sbus_clear 12
  sbus_clear 13
  sbus_clear 14
  sbus_clear 15
endop

