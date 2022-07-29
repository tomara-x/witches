//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441

/*
opcode MyMetro, k, k
kcps xin
kphs init 1
kflag = 0
kphs += kcps/kr
if kphs >= 1 then
    kflag = 1
    kphs = 0
endif
xout kflag
endop
*/

;this is accurate as far as i've tested
;thank you eduardo
opcode MyMetro, k, k
kcps xin
kcnt init kr
kflag = 0
kcnt += kcps
if kcnt >= kr then
    kflag = 1
    kcnt -= kr
endif
xout kflag
endop

instr mymetro
kt1 = MyMetro(4)
kt2 = MyMetro(4)
if kt1+kt2 == 2 then
    printks("in sync at: %f\n", 0, timeinsts())
elseif kt1 == 1 then
    printks("out of sync at: %f\n", 0, timeinsts())
endif
endin
;schedule("mymetro", 0, 120)

;timeinsts does return time offset by the init-pass
instr 1
printk 0,timeinsts()
endin
schedule(1,0,.1)


/*
;stays in sync
sr = 65536
ksmps = 64
instr 1
kt1 = metro(4)
kt2 = metro(8)
if kt1+kt2 == 2 then
    printks("in sync at: %f\n", 0, timeinsts())
elseif kt1 == 1 then
    printks("out of sync at: %f\n", 0, timeinsts())
endif
endin
schedule(1, 0, 60)
*/

/*
;goes out of sync
sr = 48000
ksmps = 16
instr 2
kt1 = metro(4)
kt2 = metro(8)
if kt1+kt2 == 2 then
    printks("in sync at: %f\n", 0, timeinsts())
elseif kt1 == 1 then
    printks("out of sync at: %f\n", 0, timeinsts())
endif
endin
schedule(2, 0, 60)
*/

</CsInstruments>
</CsoundSynthesizer>


