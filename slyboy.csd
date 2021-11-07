trans rights

/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/

<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
; ==============================================
<CsInstruments>

sr		=	44100
ksmps	=	42
;kr		=	1050
nchnls	=	1
0dbfs	=	1


; ------------------------------ 
; function tables

;gifn1 gen51
iscaledegrees	= 7
itotalsize		= iscaledegrees*4
iinterval		= 2 ;ratio range covered before repeating (octave = 2)
ibasefreq		= cpspch(6) ;cpspch(8) = c4
ibaseindex		= 0 ;index 0 will be ibasefreq
gifn1 ftgen 0,0,-itotalsize,-51, iscaledegrees,iinterval,
ibasefreq,ibaseindex,
2^(0/12),
2^(2/12),
2^(3/12),
2^(6/12),
2^(7/12),
2^(9/12),
2^(10/12)
; ratios (the numirators are the scale notes 0=c ... 11=b)
; (this is c dorian #4 (ukrainian dorian) in 12-tet)

gifn2 ftgen 0,0,-8,-2, 2,2,1,2,1,2,3,3 ;delta times (16 steps)
; ------------------------------ 


; ------------------------------
; user defined opcodes

opcode slyboy, kk[]k[], kk[]k[]ioOO
/*
Though the rituals are different, this opcode can summon some of the 
power of the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

syntax:
kPitch, kTrigArr[], kPitchArr[] slyboy kTrig, kNoteIndx[],
	kIncrements[], iFn [, iInitStep] [, kReset] [, kRandomMode]

initialization:
iFn: Function table containing pitch information, or whatever
		(using gen51 for example)
iInitStep: First active step in the sequence (defaults to 0)

performance:
kPitch: Pitch information returned by currently active step.
		This will be the same format as in the input iFn. (cps, pch, ...)
kTrigArr[]: An array of triggers with each index corresponding to
		a step in the sequence. It contains a k-cycle-long trigger
		that equals 1 when that corresponding step is activated (0 otherwise).
kPitchArr[]: An array of the pitch information of all the steps.
kTrig: Trigger signal the runs the sequencer.(metro, metro2, seqtime, slyseqtime...)
		The sequencer advances one step every k-cycle where kTrig != 0
kNoteIndx[]: 1D array the length of which is the length of the sequence.
		It contains index values of the iFn for every sequence
		step before the sequencer starts to self-modulate.
		(ie the base index of a gen51)
kIncrements[]: 1D array (same length as kNoteIndx.. or not?)
		containing the amount for each step to be transposed
		every time it is active. 2 means every time the step
		is active, it will be 2 scale degrees higher.
		(from c to d ... if iFn contains a chromatic c scale)
		Increments can be negative or fractional values.
kReset: Reset the sequencer to its original state when non zero.
		kNoteIndx[] and iInitStep wise. (defaults to 0)
kRandomMode: Advance the sequence in random order when non zero.
		(defaults to 0)
*/
kTrig, kNoteIndx[], kIncrements[], iFn, iInitStep, kReset, kRandMode xin

ilen		=		lenarray(kNoteIndx)
kmem[]		init	ilen ;storing the initial notes state
ktmp[]		init	ilen ;for accumulating the increments
ksum[]		init	ilen ; sum of notes and increments
kPitchArr[]	init	ilen
kTrigArr[]	init	ilen
kAS			init	iInitStep%ilen ;active step

kgoto perf
kmem = kNoteIndx

perf:
kTrigArr	=	0
ksum = kNoteIndx+ktmp

if kTrig != 0 then
	ktmp[kAS] = ktmp[kAS]+kIncrements[kAS]
	kTrigArr[kAS] = 1

	;update pitch output array
	kj = 0
	while kj < ilen do
		kPitchArr[kj] = table(ksum[kAS], iFn, 0, 0, 1)
		kj += 1
	od
	kpitch = kPitchArr[kAS]

	if kRandMode == 0 then
		kAS = (kAS+1)%ilen
	else
		kAS = trandom(kTrig, 0, ilen)
	endif
endif

if kReset != 0 then
	ksum	=	kmem
	kAS		=	iInitStep%ilen
endif

xout kpitch, kTrigArr, kPitchArr
endop

opcode slyseqtime, kkk[], kk[]k[]k[]k[]k[]k[]k[]
/*
Just like slyboy sequencer but modulates time and subdivisions instead of pitch.
Inspired by the seqtime opcode, the Laundry Soup sequencer by computerscare,
and the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

Syntax:
kTrigOut, kSubTrig, kTrigAtt[] slyseqtime kTimeUnit, kTimes[], kIncrements[],
	kDivs[], kDivIncs[], kMaxDivs[], kMinLen[], kMaxLen[]

Performance:
kTrigOut: Step trigger output.
kSubTrig: Dividied step trigger output
kTrigArr: Trigger array with each index corresponding to a sequencer step.
	(will output only the step trigger without the subdivisions)

kTimeUnit: Time unit (in seconds/fractions of second) for all the time arrays.
	Also, see seqtime manual entry.
kTimes[]: An array defining the length of each step (in kTimeUnit).
	The length of this array controls the length of the sequence.
	A value of zero (or negative) will have the length of 1 k-cycle.
	(can be modified from calling instrument for live performance)
kIncrements[]: An array (same length as kTimes) containing the values
	(in TimeUnit) to be added to the length of each step each time
	that step is activated. (can be negative or fractional)
kDivs[]: An array defining how many divisions are in a corresponding step.
	0 or 1 is just natural trigger at the beginning, 2 gives you a trigger
	at the beginning and a trigger in the middle, and so on.
	Like a multiplied clock. (can be modified from calling instrument)
	(0 and 1 will be treated equally, but have different effects with increments)
kDivIncs[]: Amounts to increase each step's divisions every time
	it's activated. (this to kDivs is just like kIncrements is to kTimes)
kMaxDivs[]: Maximum number of subdivisions in a step before wraping around (modulo).
	(up to, but not including)
kMinLen[], kMaxLen[]: Minimum and maximum length of step (in TimeUnit)
	(From and including kMinLen, up to, but not including, kMaxLen)
*/

kTimeUnit, kTimes[], kIncrements[], kDivs[], kDivIncs[], kMaxDivs[], kMinLen[], kMaxLen[] xin

ilen			=			lenarray(kTimes)
kAS				init		0	;active step
kTrigArr[]		init		ilen

ktimetmp[]		init		ilen ;accumulating the increments in this
kdivstmp[]		init		ilen ;accumulating the increments in this

ktimesum[]		=			ktimetmp+kTimes
kdivsum[]		=			kdivstmp+kDivs

kTrigArr		=			0

kdivsum[kAS]	=			wrap(kdivsum[kAS], 0, kMaxDivs[kAS])
kfreq			=			1/kTimeUnit

if ktimesum[kAS] > 0 then
	ktrig		metro	(kfreq/ktimesum[kAS])
	ksubdiv		metro	(kfreq/ktimesum[kAS])*(kdivsum[kAS] > 0 ? kdivsum[kAS] : 1)
else
	ktrig		=			1
endif

if ktrig != 0 then
	ktimetmp[kAS] = ktimetmp[kAS] + kIncrements[kAS]
	ktimesum[kAS] = wrap(ktimesum[kAS], kMinLen[kAS], kMaxLen[kAS])

	kdivstmp[kAS] = kdivstmp[kAS] + kDivIncs[kAS]

	kTrigArr[kAS] = 1
	kAS = (kAS+1)%ilen
endif

xout ktrig, ksubdiv, kTrigArr
endop

;phase modulation oscillator
opcode Pmoscili, a, akaj
aamp, kfreq, aphs, ifn xin
acarrier	phasor kfreq
asig		tablei acarrier+aphs, ifn, 1,0,1
xout		asig*aamp
endop
; ------------------------------


; ------------------------------
; instruments

instr 1
ktmpo		init	137 ;bpm
kclkx1		metro	ktmpo/60 ;whole notes
kclkx4		metro	4*ktmpo/60 ;quarter notes
kclkd4		metro	ktmpo/60/4 ;4 whole notes
kclkd8		metro	ktmpo/60/8 ;8 whole notes
kclkd16		metro	ktmpo/60/16 ;16 whole notes
ktrigseq1	seqtime	1/(4*ktmpo/60), 0, 8, 0, gifn2

knotes[]	fillarray	0,0,0,0,0,0,0,0
kincs[]		fillarray	0,-1,2,0,1,0,-3,1

;kreset = kclkd8  ;reset must be 1-k-cycle-long trigger

;if kclkx1 > 0 then ;randomly increment a random step increment!
;	krandstep	trandom	kclkx1, 0, lenarray(kincs)
;	krandval	=		int(trandom(kclkx1,-5,5))
;	kincs[krandstep] = kincs[krandstep] + krandval
;endif

; run the sequencer
kpitch,kotrig[],kopitch[] slyboy kclkx1,knotes,kincs,gifn1,0,0,0

;self-patching trig-outs to noteIndex or to incs
;if kotrig[5] == 1 then
;	knotes[1] = knotes[1]-5 ;can access values of other steps this way.
;							;totally not because the += form doesn't work on arrays!
;	kincs[0] = kincs[0] + 1 ;if you want increasing inrements!
;endif

; make some noise
kpres	randi		2, 8, 0.5, 0, 3 ;amp, cps, seed, bit, offset
krat	randi		0.25, 2, 0.5, 0, 0.01
asig	wgbow		0.4, kpitch, 3, 0.13, 5, 0.004
		out			asig
; run another instrument with the same pitch info
		schedkwhen	kclkx1, 0, 0, 2, 0, 0.4, kpitch/2
endin

instr 2
iz		init		0.001
aenv1	expseg		2,0.2,iz
aenv2	expseg		2,0.4,iz
aenv3	expsegr		1,0.9,iz,0.6,iz
aenv4	expsegr		1,0.5,iz,0.5,iz
amod1	oscili		aenv1, p4/2
amod2	oscili		aenv2, p4
acar1	Pmoscili	aenv3, p4*2, amod1+amod2
acar2	Pmoscili 	aenv4, p4, amod1+amod2
asig	bqrez		acar1+acar2, p4*4, 1
asig	limit		asig, -0.25, 0.25
		out			asig
endin

instr 3
aenv	linsegr	1, p3, .2, p3/4, 0
alfo	lfo		1, p4/2
asig	oscili 	0.2*alfo, p4*2^5
asig	bqrez	asig*aenv, p4*2^5, abs(alfo)
		out		asig
endin

instr 4
ktempo		=	137 ;bpm
ktimeunit	=	1/(ktempo/60) ;1 whole note at tempo in seconds

ktimes[]	fillarray	4,    4,    4,    4,    4,    4,    4,    4
kincs[]		fillarray	0,    0,    0,    0,    0,    0,    0,    0
kminlen[]	fillarray	1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64
kmaxlen[]	fillarray	4,    4,    4,    4,    4,    4,    4,    4

kdivs[]		fillarray	0,    0,    0,    0,    0,    0,    0,    0
kdivincs[]	fillarray	0,    0,    0,    0,    0,    0,    0,    0
kmaxdivs[]	fillarray	32,   32,   32,   32,   32,   32,   32,   32

ktrig, ksub, ktrigArr[] slyseqtime ktimeunit, ktimes, kincs, kdivs, kdivincs,
		kmaxdivs, kminlen, kmaxlen

schedkwhen	ksub, 0, 0, 5, 0, 0.0001
endin

instr 5 ;hat
aenv	expsegr	1,p3,1,0.04,0.001
asig	noise	0.1*aenv, 0
out		asig
endin
; ------------------------------

</CsInstruments>
; ==============================================
<CsScore>
t		0		137	;score tempo 137bpm
;i1		0		256	;activate instrument 1 for 256 beats
;i1		0		128
i4		0		64
e 
</CsScore>
</CsoundSynthesizer>


