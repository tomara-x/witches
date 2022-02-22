//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


instr Dist ;distortion
gaDistIn init 0
iTanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
kDist = 0.4
iHP = 10
iStor = 0
gaDistOut distort gaDistIn, kDist, iTanh, iHP, iStor
endin

instr CmpDist ;comparitor distortion ;attenuate this! it's brutal!
gaCmpDistIn     init 0
gaCmpDistOut    cmp gaCmpDistIn, ">", 0.1
endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.85     ; room size (range 0 to 1)
kHFDamp     init      0.5      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Verb2 ;bigger reverb
gaVerb2In   init    0
kRoomSize   init    1       ; room size (range 0 to 1)
kHFDamp     init    0.9     ; high freq. damping (range 0 to 1)
gaVerb2OutL,gaVerb2OutR freeverb gaVerb2In,gaVerb2In,kRoomSize,kHFDamp
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

instr BitCrush
gaBitCrushIn    init 0
iRamp           ftgenonce 0,0,64,7, -1,64,1
gaBitCrushOut   table (gaBitCrushIn+1)/2, iRamp, 1, 0, 1
endin

