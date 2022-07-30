//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   1
0dbfs   =   1

;drag A minor on the spectrum
instr 1
kEnv = linseg(1,p3*.1,1,p3*.8,100,p3*.1,100)
kFrq1, kFrq2, kFrq3 = 2.2, 2.2*2^(3/12), 2.2*2^(7/12)
aSig1 = mpulse(.1, 1/(kFrq1*kEnv))
aSig2 = mpulse(.1, 1/(kFrq2*kEnv))
aSig3 = mpulse(.1, 1/(kFrq3*kEnv))
aOut  = aSig1+aSig2+aSig3
;aOut  = diode_ladder(aOut, 440*16, 1)
out aOut
endin
schedule(1, 0, 60)


;A major
instr 2
kEnv = 100
kFrq1, kFrq2, kFrq3 = 2.2, 2.2*2^(4/12), 2.2*2^(7/12)
aSig1 = mpulse(.1, 1/(kFrq1*kEnv))
aSig2 = mpulse(.1, 1/(kFrq2*kEnv))
aSig3 = mpulse(.1, 1/(kFrq3*kEnv))
aOut  = aSig1+aSig2+aSig3
out aOut
endin
;schedule(2, 0, 4)

;A minor
instr 3
kEnv = 100
kFrq1, kFrq2, kFrq3 = 2.2, 2.2*2^(3/12), 2.2*2^(7/12)
aSig1 = mpulse(.1, 1/(kFrq1*kEnv))
aSig2 = mpulse(.1, 1/(kFrq2*kEnv))
aSig3 = mpulse(.1, 1/(kFrq3*kEnv))
aOut  = aSig1+aSig2+aSig3
out aOut
endin
;schedule(3, 5, 4)

</CsInstruments>
</CsoundSynthesizer>


