<CsoundSynthesizer>
<CsOptions>
-n -Lstdin
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

ia = cpspch(8)
gifn1 ftgen 0,0,-8,-2, ia/4, ia/2, ia, ia*2, ia*4, ia*8, ia*16, ia*32
gifn2 ftgen 0,0,-24,-51,12,2,cpspch(9),0,
2^(0/12),
2^(1/12),
2^(2/12),
2^(3/12),
2^(4/12),
2^(5/12),
2^(6/12),
2^(7/12),
2^(8/12),
2^(9/12),
2^(10/12),
2^(11/12)
gifn3 ftgen 0,0,16,-7, 0,16,16

instr 3
print(tablei(0.8, gifn3))
endin

instr 2
ftprint(gifn2)
print(table3(3.5, gifn2))
endin

instr 1
io=3
ii=0
while ii < 13 do
    print(table3(io+(ii/12), gifn1), table(ii, gifn2))
    ii += 1
od
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
