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

schedule("clock", 0, -1)
schedule("t1", 0, -1)
schedule("sine", 0, -1)
schedule("patch", 0, -1)

{
instr cables ;connections instrument
gk_t1_trig = gk_clock_out ;patching a clock to the sequencer taphy
gk_sine_cps = gk_t1_p[gk_t1_AS] ;patching taphy's pitch output to the sine instr
;gk_t1_g[2] = gk_t1_g[2] + gk_t1_t[0] ;patching taphy to herself
;gk_t1_g = 0
gk_t1_n[0] = gk_t1_n[0] + gk_t1_t[0]*5
gk_t1_n[3] = gk_t1_n[3] + gk_t1_t[2]*2
gk_t1_n[2] = gk_t1_n[2] + gk_t1_t[3]*1
gk_t1_n[1] = gk_t1_n[1] + gk_t1_t[3]*-2
endin
}


{
#define TEMPO #128# ;"parser failed due to no input" when executed alone (but works)
#include "../opcodes.orc"
#include "../modular-effects.orc"
instr clock
gk_clock_out metro $TEMPO/60
endin
instr t1
ism ftgenonce 0,0,-7*4,-51, 7,2,cpspch(6),0,
1,2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
gk_t1_trig   init 0
gk_t1_n[]    fillarray 00, 05, 11, 11
gk_t1_g[]    fillarray 00, 00, 00, 00
gk_t1_Q[]    fillarray 00, 00, 00, 00
gk_t1_AS, gk_t1_p[], gk_t1_t[] Taphath gk_t1_trig, gk_t1_n, gk_t1_g, gk_t1_Q, ism
endin
instr sine
gk_sine_cps init 220
asig oscil 0.1, gk_sine_cps
outs asig, asig
endin
instr patch ;invokes the connections instr
ktrg metro 1/4 ;every 4 seconds
if ktrg == 1 then
    turnoff2(nstrnum("cables"), 0, 0) ;same as: schedulek(-nstrnum("cables"), 0, 1)
    schedulek("cables", 0, -1)
endif
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

