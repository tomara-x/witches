//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

</CsInstruments>
<CsScore>
f1 0 16384 10 1 ; Sine
f2 0 16384 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111 ; Sawtooth
f3 0 16384 18 1 -1 0 16383 2 1 0 16383 ;gen18 mix of 2 ft's
</CsScore>
</CsoundSynthesizer>
