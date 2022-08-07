//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;p3 (0.5) dur, p4 (230) IFrq, p5 (20) EFrq, p6 (1) amp
;hey alley, this will forever be my kick!
instr Kick
iifrq   =           p4
iefrq   =           p5
aaenv   expseg      p6+1,p3,1
aaenv   -=          1
afenv   expseg      iifrq,p3/10,iefrq
asig    oscili      aaenv*.6, afenv
itanh   ftgenonce   0,0,1024,"tanh", -5, 5, 0
asig    distort     asig*2, 0.2, itanh
asig    limit       asig, -0.5,0.5
asig    +=          moogladder(asig, iifrq*2, .3)
sbus_mix 15, asig
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


;p4 amp, p5 noise beta
instr HatO
aSig noise    p4, p5
aSig butterbp aSig, 8000, 1600
aSig butterbr aSig, 7000, 100
aEnv linseg   1, p3, 0
aSig *= aEnv
sbus_mix 13, aSig
endin


instr HatC
;turn off open hat (only matching fractional instances)
turnoff2 nstrnum("HatO"), 4, 0
aSig noise    p4, p5
aSig butterbp aSig, 8000, 1600
aSig butterbr aSig, 7000, 100
aEnv expseg   2, p3, 1
aSig *=       aEnv - 1
sbus_mix 12, aSig
endin

