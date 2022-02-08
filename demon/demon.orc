//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

/*
I execute chunks of this in vim using:
:w !nc -u 127.0.0.1 10000 -c
with visual mode range selected, or:
:.w !nc -u 127.0.0.1 10000 -c
for executing the current line
*/

alwayson "t1"
alwayson "sine"
alwayson "patch"

instr 99
gkcps = gkp[gkAS]
gkg[2] = gkg[2] + gkt[0]
endin

instr patch
ktrg metro 1/4
if ktrg == 1 then
    turnoff2(99, 0, 0)
    schedulek(99,0,-1)
endif
endin


{
#define TEMPO #128# ;"parser failed due to no input" when executed alone
#include "../opcodes.orc"
instr t1
ism ftgenonce 0,0,-7*4,-51, 7,2,cpspch(6),0,
1,2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
ktrig   metro $TEMPO/60
gkn[]   fillarray 00, 05, 11, 11
gkg[]   fillarray 00, 00, 00, 03
gkQ[]   fillarray 00, 00, 00, 00
gkAS, gkp[], gkt[] Taphath ktrig, gkn, gkg, gkQ, ism
endin
instr sine
gkcps   init 440
asig oscil 0.1, gkcps
outs asig, asig
endin
}


;----------------------------------------

print(active("t1"))

; durations are in seconds here, we are in the orc
git1 nstance "t1",0,64/($TEMPO/60),0,0
gifm nstance "fm",0,4/($TEMPO/60),-4,3, -4,-8, -2,2, 3,3, .14,.04,.04,.08,.01
turnoff(git1)
turnoff(gifm)

; $ to send score lines
$
{ 8 CNT
i"kick" [$CNT*4] 0.0001
}

event "i","t2",0,8, 0,0, -4,02, 8,-4, -4,2, -8,3, .14,.04,.04,.08,.01
event_i "i","t2",0,8, 0,0, -4,02, 8,-4, -4,2, -8,3, .14,.04,.04,.08,.01

;why is duration still in seconds though even with a t statement in the csd?
;             SM LM  1i 1f 2i 2f 3i 3f 4i 4f op1             op5
$i"t2" 0  08  0  0   -4 02 08 -4 -4 02 -8 03 .14 .04 .04 .08 .01
$i"t2" 0  08  0  0   -4 02 08 -4 -4 02 -8 03 .14 .04 .04 .08 .05


{
instr kick
iifrq   = 230
iefrq   = 20
aaenv   expsegr 1,0.5,0.001
afenv   expsegr iifrq,p3,iifrq,0.05,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig*2, k(aaenv)*0.4, giftanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
asig *= 0.5
outs    asig, asig
gaRvbSend += asig*0.15
endin
}

;to close the server
##close##

