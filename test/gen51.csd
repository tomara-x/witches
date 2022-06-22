//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//oh boy! i need to get back here sometime? it's fun!
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

;gen51
instr 1
;the interval (p6) isn't a range covered before repeating the ratios,
;it's rather a ratio multiplier for each iteration of the ratios.
;every cycly (after the first) the ratios are multiplied by that factor (.5)

;nope this seems wrong? the POWER function? aaaa i don't know what's what anymore!
;never work when you're out of it, kids

;it IS the ratio of interval covered before repeating, and that's why it's a mult!
;holup i think the opposite is more accurate?
;CLOSEST!
;it IS a ratio multiplier after each cycle through the ratios, and that's why
;it is the interval covered by the ratios as they are given?

;static int gen51(FGDATA *ff, FUNC *ftp)    /* Gab 1/3/2005 */
;{
;    int     j, notenum, grade, numgrades, basekeymidi, nvals;
;    MYFLT   basefreq, factor, interval;
;    MYFLT   *fp = ftp->ftable, *pp;
;    CSOUND  *csound = ff->csound;
;
;    if (UNLIKELY(ff->e.pcnt>=PMAX)) {
;      csound->Warning(csound, Str("using extended arguments\n"));
;    }
;    nvals       = ff->flen;
;    pp          = &(ff->e.p[5]);
;    numgrades   = (int) *pp++;
;    interval    = *pp++;
;    basefreq    = *pp++;
;    basekeymidi = (int) *pp++;
;    if (UNLIKELY((ff->e.pcnt - 8) < numgrades)) { /* gab fixed */
;      return fterror(ff,
;                     Str("GEN51: invalid number of p-fields (too few grades)"));
;    }
;
;    for (j = 0; j < nvals; j++) {
;      MYFLT x;
;      notenum = j;
;      if (notenum < basekeymidi) {
;        notenum = basekeymidi - notenum;
;        grade  = (numgrades - (notenum % numgrades)) % numgrades;
;        factor = -((MYFLT) ((int) ((notenum + numgrades - 1) / numgrades)));
;      }
;      else {
;        notenum = notenum - basekeymidi;
;        grade  = notenum % numgrades;
;        factor = (MYFLT) ((int) (notenum / numgrades));
;      }
;      factor = POWER(interval, factor);
;      if (LIKELY(grade<PMAX-10)) x = pp[grade];
;      else x = ff->e.c.extra[grade-PMAX+11];
;      fp[j] = x * factor * basefreq;
;    }
;    return OK;
;}

;tab[x] = inputRatio[x%NumGrades] * interval^(x/NumGrades) * baseFrq
;doesn't that mean it's multiplying by the step ratio twice? in theory that is?
;in practice that is not what's happening! ugh! there's something i'm missing

;yeah, i'm not wrong!
;print(pchoct(octcps(440*2^(0/12)*2^(0/12))))
;the realization is gonna be epic!
iv0 = pchoct(octcps(440)) 
iv1 = pchoct(octcps(440*2^(1/12)))
iv2 = pchoct(octcps(440*2^(1/12)*2^(1/12)))
print(iv0, iv1, iv2)

;it's weird because at interval 0 the first cycle through the ratios is accurate,
;and then we get -inf... i'm getting more questions! (present amy: prolly POWER)
;iFt ftgen 0,0,-(12*3+1),-51,12,0,cpspch(6),0, (with the 12 ratios)

;at interval 1 it's just repeating the ratios for the length

;okay don't even wanna think about negative intervals lol

;there is no truth

;it's funny because i understand how it will behave, but i don't understand how
;this code does it!


iFt ftgen 0,0,-(12*3+1),-51,12,-2,cpspch(6),0,
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

;this will be fun for octave switching sequences
;2^(0/12), 2*2^(0/12),
;2^(1/12), 2*2^(1/12),
;2^(2/12), 2*2^(2/12),
;2^(3/12), 2*2^(3/12),
;2^(4/12), 2*2^(4/12),
;2^(5/12), 2*2^(5/12)

;one semi-tone interval and a scale of only one grade
;iFt ftgen 0,0,-12*3,-51,1,2^(1/12),cpspch(6),0,1

;must you specify all optional parameters just to use last one?!
;ftprint(iFt, 1, 0, ftlen(iFt), 1, 1)

;maybe a test print is always a good idea to check what's actually happening
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

