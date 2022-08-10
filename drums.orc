//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;p4=IFrq, p5=EFrq, p6=amp, p7=distortion, p8=VrbSend
;schedulek("Kick", 0, 0.5, 230, 20, 1, 0, 0)
;hey alley, this will forever be my kick!
instr Kick
iIFrq   =           p4
iEFrq   =           p5
aAEnv   expseg      p6+1,abs(p3),1
aAEnv   -=          1
aFEnv   expseg      iIFrq,abs(p3)/10,iEFrq
aSig    oscili      aAEnv*.6, aFEnv
iTanh   ftgenonce   0,0,1024,"tanh", -5, 5, 0
aSig    distort     aSig*2, 0.2, iTanh
aSig    limit       aSig, -0.5,0.5
aSig    +=          moogladder(aSig, iIFrq*2, .3)
aSig    =           pdhalf(aSig, expseg(-(p7+1), abs(p3), -1)+1)
aSig    dcblock     aSig
        vincr       gaVerbL, aSig*(p8)
        vincr       gaVerbR, aSig*(p8)
        sbus_mix    15, aSig
endin



;edited version of a dseq instr [csoundjournal.com/issue8/dseq.html]
;AIM! STUDY THIS! (and make it smoller if possible)
instr Snare
iFt1 ftgenonce 0,0,2^16+1, 10, 1
iFt2 ftgenonce 0,0,2^13, -7, -1,2^12,1,2^12,-1
idur   = p3
ivalue = p4 / 15
iamp   = p5 * 0.5 * ivalue

atri         oscil3 1, 111 + ivalue * 5, iFt2
areal, aimag hilbert atri

ifshift =      175
asin    oscil3 1, ifshift, iFt1
acos    oscil3 1, ifshift, iFt1, .25
amod1   =      areal * acos
amod2   =      aimag * asin
ashift1 =      ( amod1 + amod2 ) * 0.7

ifshift2 =      224
asin     oscil3 1, ifshift2, iFt1
acos     oscil3 1, ifshift2, iFt1, .25
amod1    =      areal * acos
amod2    =      aimag * asin
ashift2  =      ( amod1 + amod2 ) * 0.7

kenv1     line 1, 0.15, 0
ashiftmix =    ( ashift1 + ashift2 ) * kenv1

aosc1   oscil3 1, 180, iFt1
aosc2   oscil3 1, 330, iFt1
kenv2   linseg 1, 0.08, 0, idur - 0.08, 0
aoscmix =      ( aosc1 + aosc2 ) * kenv2

anoise gauss    1
anoise butterhp anoise, 2000
anoise butterlp anoise, 3000 + ivalue * 3000
anoise butterbr anoise, 4000, 200
kenv3  expon    2, 0.15, 1
anoise =        anoise * ( kenv3 - 1 )

amix = aoscmix + ashiftmix + anoise * 4
amix = amix * iamp
sbus_mix 14, amix
endin



;the beta affects the amp cause of the bp
;p4 amp, p5 noise beta, p6 verb send
instr HatO
aSig noise    p4, p5
aSig butterbp aSig, 8000, 1600
aSig butterbr aSig, 7000, 100
aEnv linseg   2, p3, 0
aSig *= aEnv
aSig clip     aSig, 2, p4
     vincr    gaVerbL, aSig*(p6)
     vincr    gaVerbR, aSig*(p6)
     sbus_mix 13, aSig
endin

instr HatC
;turn off open hat (only matching fractional instances)
turnoff2 nstrnum("HatO"), 4, 0
aSig noise    p4, p5
aSig butterbp aSig, 8000, 1600
aSig butterbr aSig, 7000, 100
aEnv expseg   4, p3, 2
aEnv -=       2
aSig *=       aEnv
aSig clip     aSig, 2, p4
     vincr    gaVerbL, aSig*(p6)
     vincr    gaVerbR, aSig*(p6)
     sbus_mix 12, aSig
endin



;p4=amp, p5=noiseBeta, p6=bellFrq, p7=bpFrq, p8=verbSnd
;schedulek("HatO2", 0, .5, .1, -0.9, 9000, 8000, 0.0)
instr HatO2
aNois noise    p4, p5
aSig1 butterbp aNois, p7, 1600
aSig2 fmbell   p4, p6, .8, .5, .1, 2
aEnv1 linseg   2, abs(p3), 0
aEnv2 linseg   2, abs(p3/1.1), 0
aClk  noise    p4, -0.9
aClk  *=       linseg(1, 0.01, 0)
aSig  =        aSig1*aEnv1+aSig2*aEnv2 + aClk
aSig  clip     aSig, 2, p4
      vincr    gaVerbL, aSig*(p8)
      vincr    gaVerbR, aSig*(p8)
      sbus_mix 13, aSig
endin

;schedulek("HatC2", 0, .1, .1, -0.9, 9000, 8000, 0.0)
instr HatC2
;turn off open hat (only matching fractional instances)
turnoff2 nstrnum("HatO2"), 4, 0
aNois noise    p4, p5
aSig1 butterbp aNois, p7, 1600
aSig2 fmbell   p4, p6, .8, .5, .1, 2
aEnv1 expseg   4, abs(p3), 2
aEnv2 expseg   4, abs(p3/1.1), 2
aEnv1 -=       2
aEnv2 -=       2
aClk  noise    p4, -0.9
aClk  *=       linseg(1, 0.01, 0)
aSig  =        aSig1*aEnv1+aSig2*aEnv2 + aClk
aSig  clip     aSig, 2, p4
      vincr    gaVerbL, aSig*(p8)
      vincr    gaVerbR, aSig*(p8)
      sbus_mix 12, aSig
endin

;labels aren't real, a kick is a shitty snare, i am you, you are me

