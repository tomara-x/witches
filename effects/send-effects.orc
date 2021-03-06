//trans rights
//Copyright © 2021 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

gaRvbSend init 0
alwayson "verb"
gaDstSend init 0
alwayson "dist"
gaRvb2Send init 0
alwayson "verb2"

instr dist ;distortion
kdist = 0.4
ihp = 10
istor = 0
ares        distort gaDstSend, kdist, giftanh, ihp, istor
outs        ares, ares
clear       gaDstSend
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

