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
  aclear init 0 ;this aint used, is it needed?
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

;multiply channel (for setting amplitude)
opcode sbus_mult, 0,ik
  ibus, kml, kmr xin
  ga_sbus[ibus][0] = ga_sbus[ibus][0] * kml
  ga_sbus[ibus][1] = ga_sbus[ibus][1] * kmr
endop
;normalled (DO THIS WITH OPTIONAL ARGS?)
opcode sbus_mult, 0,ik
  ibus, km xin
  ga_sbus[ibus][0] = ga_sbus[ibus][0] * km
  ga_sbus[ibus][1] = ga_sbus[ibus][1] * km
endop

;output a mix of all 16 channels
opcode sbus_out, aa, 0
  al, ar init 0
  clear al, ar
  kbus = 0
  while kbus < 16 do
    al = al + ga_sbus[kbus][0] 
    ar = ar + ga_sbus[kbus][1] 
    kbus += 1
  od
  xout al, ar
endop

