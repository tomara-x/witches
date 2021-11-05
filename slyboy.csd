trans rights
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
kPitch, kTrigArr[], kPitchArr[] slyboy kTrig, kInitNotes[],
	kIncrements[], iFn [, iInitStep] [, kReset] [, kRandomMode]

initialization:
iFn: Function table containing pitch information (using gen51 for example)
iInitStep: First active step in the sequence (defaults to 0)

performance:
kPitch: Pitch information returned by currently active step.
		This will be the same format as in the input iFn. (cps, pch, ...)
kTrigArr[]: An array of triggers with each index corresponding to
		a step in the sequence. It contains a k-cycle-long trigger
		that equals 1 when that corresponding step is activated (0 otherwise).
kPitchArr[]: An array of the pitch information from all the steps.
kTrig: Trigger signal the runs the sequencer. (metro, metro2, seqtime,...)
		The sequencer advances one step every k-cycle where kTrig != 0
kInitNotes[]: 1D array the length of which is the length of the sequence.
		It contains index values of the iFn for every sequence
		step before the sequencer starts to self-modulate.
		(ie the base index of a gen51)
		If changed mid-performance, changes won't take effect until
		a reset trigger is received.
kIncrements[]: 1D array (same length as kInitNotes.. or not?)
		containing the amount for each step to be transposed
		every time it is active. 2 means every time the step
		is active, it will be 2 scale degrees higher.
		(from c to d ... if iFn contains a chromatic c scale)
		Increments can be negative or fractional values.
kReset: Reset the sequencer to its original state when non zero.
		kInitNotes[] and iInitStep wise. (defaults to 0)
kRandomMode: Advance the sequence in random order when non zero.
		(defaults to 0)
*/
kTrig, kInitNotes[], kIncrements[], iFn, iInitStep, kReset, kRandMode xin

ilen		=		lenarray(kInitNotes)
ktmp[]		init	ilen
kPitchArr[]	init	ilen
kTrigArr[]	init	ilen
kactivestep init	(iInitStep-1)%ilen

kgoto perf
ktmp = kInitNotes

perf:
kTrigArr	=	0

if kTrig != 0 then
	ktmp[kactivestep] = ktmp[kactivestep]+kIncrements[kactivestep]
	if kRandMode == 0 then
		kactivestep = (kactivestep+1)%ilen
	else
		kactivestep = trandom(kTrig, 0, ilen) 
	endif
	
	kTrigArr[kactivestep] = 1

	kj = 0
	while kj < ilen do
		kPitchArr[kj] = table(ktmp[kactivestep], iFn, 0, 0, 1)
		kj += 1
	od
endif

if kReset != 0 then
	ktmp = kInitNotes
	kactivestep = (iInitStep-1)%ilen
endif

xout kPitchArr[kactivestep], kTrigArr, kPitchArr
endop

opcode slyseqtime, kk[], kk[]k[]k[]k[]k[]k[]k[]
/*
Just like slyboy sequencer but modulates step length instead of pitch.
Inspired by the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

Syntax:
kTrigOut, kTrigAtt[] slyseqtime kTimeUnit, kTimes[], kIncrements[],
	kDivs[], kDivIncs[], kMaxDivs[], kMinLen[], kMaxLen[]

Initialization:

Performance:
kTrigOut: Sequencer trigger output.
kTrigArr: Trigger array with each index corresponding to a sequencer step.

kTimeUnit: See seqtime manual entry.
kTimes[]: same as the kfn_times for the seqtime opcode, but an array instead
	of a function table. The length of this array controls the length of the
	sequence, since the kstart and kloop for the seqtime are abstracted.
	(can be modified from calling instrument)
kIncrements[]: 1D array (same length as kTimes) containing the values
	(in TimeUnit) to be added to the length of each step (in kTimes)
	each time that step is activated.
kDivs[]: Array defining how many subdivisions in a corresponding step.
kDivIncs[]: Amounts to increase each step's subdivisions every time
	it's activated. (can be modified from calling instrument)
kMaxDivs[]: Maximum number of subdivisions in a step before wraping back to 1.
kMinLen, kMaxLen: Minimum and maximum length of step (in TimeUnit)
	(From and including kMinLen, up to, but not including, kMaxLen)
	This doesn't apply to the first pass of the sequence.
*/

kTimeUnit, kTimes[], kIncrements[], kDivs[], kDivIncs[], kMaxDivs[], kMinLen[], kMaxLen[] xin

ilen		=		lenarray(kTimes)
kTrigArr[]	init	ilen
ktmp[]		init	ilen
kactivestep	init	ilen-1 ;for the first cycle to be the actual kTimes

ksum[]		=			ktmp+kTimes
;ifntimes	ftgenonce	0,0, -ilen, -2, 0
;			copya2ftab	ksum, ifntimes

;kTrig 		seqtime		kTimeUnit, 0, ilen, 0, ifntimes

kTrig		metro		1/(kTimeUnit*ksum[kactivestep]) ;should be +1?
kTrigArr	=			0

if kTrig != 0 then
	ktmp[kactivestep] = ktmp[kactivestep] + kIncrements[kactivestep]
	ksum[kactivestep] = wrap(ksum[kactivestep], kMinLen[kactivestep], kMaxLen[kactivestep])

	kactivestep = (kactivestep+1)%ilen
	kTrigArr[kactivestep] = 1
endif

xout kTrig, kTrigArr
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
kpitch,kotrig[],kopitch[] slyboy kclkx4,knotes,kincs,gifn1,0,0,0

;patching trig-outs to incs
;if kotrig[5] == 1 then
;	kincs[0] = 1
;	kincs[0] = kincs[0] + 1 ;if you wanna have increasing inrements!
;endif

;using trig-outs to schedule instruments
;if kotrig[4] == 1 then
;	schedkwhen	kclkx1, 0, 0, 3, 0, 0.5, kpitch
;endif

; make some noise
kpres	randi		2, 8, 0.5, 0, 3 ;amp, cps, seed, bit, offset
krat	randi		0.25, 2, 0.5, 0, 0.01
asig	wgbow		0.4, kpitch, 3, 0.13, 5, 0.004
		out			asig
; run another instrument with the same pitch info
		schedkwhen	kclkx4, 0, 0, 2, 0, 0.4, kpitch/2
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

ktimes[]	fillarray	2,    1,    2,    1,    2,    1,    2,    1
kincs[]		fillarray	0,    0,    0,    0,    0,    0,    0,    0

kdivs[]		fillarray	0,    0,    0,    0,    4,    0,    3,    0
kdivincs[]	fillarray	0,    1,    0,    0,    0,   .1,    0,    0
kmaxdivs[]	fillarray	8,    8,    8,    8,    8,    8,    8,    8

kminlen[]	fillarray	1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64
kmaxlen[]	fillarray	4,    4,    4,    4,    4,    4,    4,    4
ktrig, ktrigArr[] slyseqtime ktimeunit, ktimes, kincs, kdivs, kdivincs, kmaxdivs,
		kminlen, kmaxlen

schedkwhen	ktrig, 0, 0, 5, 0, 0.001
endin

instr 5 ;hat
aenv	expsegr	1,p3,1,0.05,0.001
asig	noise	0.1*aenv, 0
out		asig
endin
; ------------------------------

</CsInstruments>
; ==============================================
<CsScore>
t  0 137	;score tempo 137bpm
;i1 0 256	;activate instrument 1 for 256 beats
;i1 0 128
i4 0 64
e 
</CsScore>
</CsoundSynthesizer>


