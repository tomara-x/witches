//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

gaRvbSend init 0
gaDstSend init 0
gaDst2Send init 0
gaRvb2Send init 0
gaCmpDstSend init 0
;gaPltVrbSnd init 0
gaBCrushSend init 0

instr dist ;distortion
kdist = 0.4
ihp = 10
istor = 0
ares        distort gaDstSend, kdist, giftanh, ihp, istor
;ares        compress ares, ares, 0, 20, 60, 2, 0.1, 0.5, 0.02 
outs        ares, ares
clear       gaDstSend
endin

instr dist2 ;we need to address this! pretty soon we gonna have a colony of these!
kdist = 0.4
ihp = 10
istor = 0
ares        distort gaDst2Send, kdist, giftanh, ihp, istor
ares        limit ares, -.01, .01
outs        ares, ares
clear       gaDst2Send
endin

instr cmpdist ;comparitor distortion
ares    cmp gaCmpDstSend, ">", 0.1
        ares *= 0.02
        outs ares, ares
        clear gaCmpDstSend
endin

instr verb ;reverb (stolen from the floss manual 05E01_freeverb.csd)
kroomsize    init      0.85         ; room size (range 0 to 1)
kHFDamp      init      0.5          ; high freq. damping (range 0 to 1)
aRvbL,aRvbR  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aRvbL, aRvbR
             clear     gaRvbSend
endin

instr verb2 ;bigger reverb
kroomsize    init      1            ; room size (range 0 to 1)
kHFDamp      init      0.9          ; high freq. damping (range 0 to 1)
aRvbL,aRvbR  freeverb  gaRvb2Send, gaRvb2Send,kroomsize,kHFDamp
             outs      aRvbL, aRvbR
             clear     gaRvb2Send
endin

;;plate reverb (CPU intensive)         ;(freq,rad,phs)
;gitabxcite ftgen 0,0,-6,-2, 0.3,0.4,0.4, 0.3,0.8,0.8
;gitabouts  ftgen 0,0,-6,-2, 0.2,0.6,0.8, 0.2,0.7,0.7
;instr platrev
;kbndry init 1       ; 0=free 1=clamped 2=pivoting
;iaspect = 1         ; aspect ratio (<=1)
;istiff = 1          ; stiffness (1 or less for plate reverb)
;idecay = 5          ; time taken for a 30 dB decay
;iloss = 0.001       ; loss parameter for high-frequency damping (about 0.001)
;al, ar  platerev gitabxcite, gitabouts, kbndry, iaspect, istiff, idecay, iloss,
;                gaPltVrbSnd, gaPltVrbSnd
;        outs al, ar
;        clear gaPltVrbSnd
;endin

instr bcrush
asig table (gaBCrushSend+1)/2, giframp, 1, 0, 1
outs asig, asig
clear gaBCrushSend
endin

