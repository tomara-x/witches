//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;~~
;we learn from this that you shpuldn't include the fm.orc, rather copy the
;instrument(s) you'd like to use into your csd file and init its global arrays
;I might split them into seperate files
;~~

// that was when they used the old convention,
// none of that global array stuff is needed anymore
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
;-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

gkFM0Amp[][] init 4,4
gkFM0Cps[][] init 4,4
gkFM0Rat[][] init 4,4
gkFM1Amp[][] init 4,4
gkFM1Cps[][] init 4,4
gkFM1Rat[][] init 4,4
gkFM2Amp[][] init 4,4
gkFM2Cps[][] init 4,4
gkFM2Rat[][] init 4,4
gkFM3Amp[][] init 4,4
gkFM3Cps[][] init 4,4
gkFM3Rat[][] init 4,4
gkFM4Amp[][] init 4,4
gkFM4Cps[][] init 4,4
gkFM4Rat[][] init 4,4
gkFM5Amp[][] init 4,4
gkFM5Cps[][] init 4,4
gkFM5Rat[][] init 4,4
gkFM6Amp[][] init 4,4
gkFM6Cps[][] init 4,4
gkFM6Rat[][] init 4,4
gkFM7Amp[][] init 4,4
gkFM7Cps[][] init 4,4
gkFM7Rat[][] init 4,4
gkFM8Amp[][] init 4,4
gkFM8Cps[][] init 4,4
gkFM8Rat[][] init 4,4
gkFM9Amp[][] init 4,4
gkFM9Cps[][] init 4,4
gkFM9Rat[][] init 4,4
gkFM10Amp[][] init 4,4
gkFM10Cps[][] init 4,4
gkFM10Rat[][] init 4,4
gkFM11Amp[][] init 4,4
gkFM11Cps[][] init 4,4
gkFM11Rat[][] init 4,4
gkFM12Amp[][] init 4,4
gkFM12Cps[][] init 4,4
gkFM12Rat[][] init 4,4
gkFM13Amp[][] init 4,4
gkFM13Cps[][] init 4,4
gkFM13Rat[][] init 4,4
gkFM14Amp[][] init 4,4
gkFM14Cps[][] init 4,4
gkFM14Rat[][] init 4,4
gkFM15Amp[][] init 4,4
gkFM15Cps[][] init 4,4
gkFM15Rat[][] init 4,4

#include "../oscillators.orc"
#include "../fm/fm.orc"

</CsInstruments>
</CsoundSynthesizer>


