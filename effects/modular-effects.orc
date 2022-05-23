//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


instr dist ;distortion
ga_dist_in init 0
itanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
kdist = 0.4
ihp = 10
istor = 0
ga_dist_out distort ga_dist_in, kdist, itanh, ihp, istor
endin

instr dist2
ga_dist2_in init 0
itanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
kdist = 0.4
ihp = 10
istor = 0
ares        distort ga_dist2_in, kdist, itanh, ihp, istor
ares        limit ares, -.01, .01
ga_dist2_out = ares
endin

instr cmpdist ;comparitor distortion
ga_cmpdist_in init 0
ares    cmp ga_cmpdist_in, ">", 0.1
        ares *= 0.02
ga_cmpdist_out = ares
endin

instr verb ;stolen from the floss manual 05E01_freeverb.csd
ga_verb_in   init 0
kroomsize    init      0.85         ; room size (range 0 to 1)
kHFDamp      init      0.5          ; high freq. damping (range 0 to 1)
ga_verb_outl,ga_verb_outr freeverb ga_verb_in,ga_verb_in,kroomsize,kHFDamp
endin

instr verb2 ;bigger reverb
ga_verb2_in  init 0
kroomsize    init      1            ; room size (range 0 to 1)
kHFDamp      init      0.9          ; high freq. damping (range 0 to 1)
ga_verb2_outl,ga_verb2_outr freeverb ga_verb2_in,ga_verb2_in,kroomsize,kHFDamp
endin

;;plate reverb (CPU intensive)
;instr platrev
;ga_platrev_in init 0         ;(freq,rad,phs)
;gitabxcite ftgenonce 0,0,-6,-2, 0.3,0.4,0.4, 0.3,0.8,0.8
;gitabouts  ftgenonce 0,0,-6,-2, 0.2,0.6,0.8, 0.2,0.7,0.7
;kbndry init 1       ; 0=free 1=clamped 2=pivoting
;iaspect = 1         ; aspect ratio (<=1)
;istiff = 1          ; stiffness (1 or less for plate reverb)
;idecay = 5          ; time taken for a 30 dB decay
;iloss = 0.001       ; loss parameter for high-frequency damping (about 0.001)
;ga_platrev_outl,ga_platrev_outr  platerev gitabxcite, gitabouts, kbndry,
;    iaspect, istiff, idecay, iloss, ga_platrev_in,ga_platrev_in
;endin

instr bcrush
ga_bcrush_in init 0
iramp ftgenonce 0,0,64,7, -1,64,1
ga_bcrush_out table (ga_bcrush_in+1)/2, iramp, 1, 0, 1
endin

