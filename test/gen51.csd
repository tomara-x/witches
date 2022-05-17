<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr 1
;the interval (p6) isn't a range covered before repeating the ratios,
;it's rather a ratio multiplier for each iteration of the ratios.
;every cycly (after the first) the ratios are multiplied by that factor
;i'll be back!!!
iFt ftgen 0,0,-12*2,-51,12,.5,cpspch(6),0,
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

;must you specify all optional parameters just to use last one?!
;ftprint(iFt, 1, 0, ftlen(iFt), 1, 1)

iC = 0
while iC < ftlen(iFt) do
    ;print(table(iC, iFt), pchoct(octcps(table(iC, iFt))), octcps(table(iC, iFt)))
    print(pchoct(octcps(table(iC, iFt))))
    iC += 1
od
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
