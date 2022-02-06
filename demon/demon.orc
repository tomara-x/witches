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

;umm can't define macros for a running engine or something?
;It gives an error (parser failed due to no input) but it works!
#define TEMPO #128#

#include "../opcodes.orc"
;#include "../function-tables.orc"
;#include "../send-effects2.orc"

; write a send-effects3 with moduar instrs and ftgenonce for thier tables
alwayson "verb"
;alwayson "verb2"
;alwayson "dist"
;alwayson "dist2"
;alwayson "bcrush"

; {} to ensure server gets the whole code
{
instr t1
;kn0p1 inletk "n0+"
ism ftgenonce 0,0,-7*10,-51, 7,2,cpspch(4),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
ktrig   metro $TEMPO*4/60
kn[]    fillarray 00, 05, 11, 11, 00, 00, 05, 05
kg[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn[]   fillarray 21, 21, 21, 21, 21, 21, 21, 21
kmx[]   fillarray 48, 48, 48, 48, 48, 48, 48, 48
kAS, kp[], kt[] Taphath ktrig, kn, kg, kQ, kmn, kmx, ism, p4, 0, p5
kn += ClkDiv(kt[0],4)
outletk "pitch", kp[kAS]
endin
}
{
instr fm
kcps    inletk "pitch"
ke1     linseg p4,p3/($TEMPO/60),p5
ke2     linseg p6,p3/($TEMPO/60),p7
ke3     linseg p8,p3/($TEMPO/60),p9
ke4     linseg p10,p3/($TEMPO/60),p11
aop1    Pmoscili p12, kcps*2^ke1
aop2    Pmoscili p13, kcps*2^ke2,   aop1
aop3    Pmoscili p14, kcps/8,       aop1
aop4    Pmoscili p15, kcps/1,       aop1
aop5    Pmoscili p16, kcps*2^ke3,   aop2+aop3+aop4
aop6    Pmoscili .02, kcps/4,       aop5
aop7    Pmoscili .02, kcps*2^ke4,   aop5
aop8    Pmoscili .02, kcps/2,       aop5
aout =  aop6+aop7+aop8
outs aout, aout
endin
}
connect "t1", "pitch", "fm", "pitch"


; durations are in seconds here, we are in the orc
gitmp nstance "t1",0,8/($TEMPO/60),0,0
gitmp nstance "fm",0,8/($TEMPO/60),-4,02, 8,-4, -4,2, -8,3, .14,.04,.04,.08,.01
turnoff(gitmp)

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

