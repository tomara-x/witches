//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//i understand some of this stuff
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #96#
;#include "../sequencers.orc"
;#include "../oscillators.orc"
;#include "../utils.orc"
#include "../mixer.orc"

gaFileOut init 0
instr File
aSig soundin "../28.11.21.wav", 53
gaFileOut = aSig
endin

gaGrannyOut init 0
instr Granny
iSine       ftgenonce   0, 0, 2^16+1, 10, 1
iRamp       ftgenonce   0, 0, 2^13+1, 7, -1, 2^13, 1
iCosine     ftgenonce   0, 0, 2^13+1, 9, 1, 1, 90

kgrainfreq      = 8000
kdistribution   = .1
idisttab        ftgenonce   0,0,2^13+1, 7, 0, 2^13, 1
async       = 0         ; no sync input
kenv2amt    = 0         ; no secondary enveloping
ienv2tab    = -1        ; default secondary envelope (flat)
ienv_attack = -1        ; default attack envelope (flat)
ienv_decay  = -1        ; default decay envelope (flat)
ksustain_amount = 0.5   ; time (in fraction of grain dur) at sustain level for each grain
ka_d_ratio  = 0.1       ; balance between attack and decay time
kduration   = (0.9/kgrainfreq)*1000 ; set grain duration relative to grain rate
kamp        = 0.1
igainmasks  = -1        ; (default) no gain masking
kwavfreq    = 440       ; fundamental frequency of source waveform
ksweepshape = 0         ; shape of frequency sweep (0=no sweep)
iwavfreqstarttab = -1   ; default frequency sweep start (value in table = 1, which give no frequency modification)
iwavfreqendtab  = -1    ; default frequency sweep end (value in table = 1, which give no frequency modification)
awavfm      = 0
ifmamptab   = -1        ; default FM scaling (=1)
kfmenv      = -1        ; default FM envelope (flat)
icosine     = iCosine   ; cosine ftable
kTrainCps   = kgrainfreq; set trainlet cps equal to grain rate for single-cycle trainlet in each grain
knumpartials= 3     ; number of partials in trainlet
kchroma     = 1         ; balance of partials in trainlet
ichannelmasks   = -1    ; (default) no channel masking, all grains to output 1
krandommask = 0         ; no random grain masking
kwaveform1  = iRamp     ; source waveforms
kwaveform2  = iRamp
kwaveform3  = iRamp
kwaveform4  = iRamp
iwaveamptab = -1        ; (default) equal mix of all 4 sourcve waveforms and no amp for trainlets
asamplepos1 = (gaFileOut+1)/2 ; phase offset for reading source waveform
asamplepos2 = (gaFileOut+1)/2 
asamplepos3 = (gaFileOut+1)/2 
asamplepos4 = (gaFileOut+1)/2 
kwavekey1   = 1         ; original key for source waveform
kwavekey2   = 1
kwavekey3   = 1
kwavekey4   = 1
imax_grains = 100       ; max grains per k period

asig partikkel kgrainfreq, kdistribution, idisttab, async, kenv2amt, ienv2tab,
ienv_attack, ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, igainmasks,
kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, ifmamptab, kfmenv,
icosine, kTrainCps, knumpartials, kchroma, ichannelmasks, krandommask, kwaveform1,
kwaveform2, kwaveform3, kwaveform4, iwaveamptab, asamplepos1, asamplepos2,
asamplepos3, asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, imax_grains

gaGrannyOut = asig
endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
schedule("File", 0, p3)
schedule("Granny", 0, p3)

;verb
;schedule("Verb",0,-1)
;gaVerbIn = gaGrannyOut

;mix
sbus_write 0, gaGrannyOut

;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM
outs aL, aR
endin
</CsInstruments>
<CsScore>
i"Main" 0 120
e
</CsScore>
</CsoundSynthesizer>

