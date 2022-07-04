//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr 1
kA1[] init 3, 3
kA1 = 2 ;only 6 elements assigned
printarray kA1
endin
schedule(1, 0, 0.01)

instr 2
kA1[] init 4, 6
kA1 = 2 ;only 10 assigned
printarray kA1
endin
schedule(2, 1, 0.01)

instr 3
kA1[] init 4, 6, 2
kA1 = 2 ;lol 12 get assigned here (dimentions sum)
kx = 0
while kx < 4 do
    ky = 0
    while ky < 6 do
        kz = 0
        while kz < 2 do
            printk 0, kA1[kx][ky][kz]
            kz += 1
        od
        ky += 1
    od
    kx += 1
od
endin
schedule(3, 2, 0.01)
</CsInstruments>
</CsoundSynthesizer>

