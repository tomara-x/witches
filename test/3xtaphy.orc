instr taphy
ktrig   metro $TEMPO/60
kn1[]   fillarray 05, 00, 00, 00, 00, 00, 00, 00
kn2[]   fillarray 00, 00, 10, 20, 00, 30, 00, 13
kn3[]   fillarray 17, 10, 08, 13, 09, 00, 16, 23
kg1[]   fillarray 21, 07, 11, 03, 15, 14, 00, 06
kg2[]   fillarray 21, 07, -8, 03, 15, 14, 00, 06
kg3[]   fillarray 21, 07, 02, 03, 15, 14, 00, 06
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ, gicm2
kAS2, kp2[], kt2[] Taphath ktrig, kn2, kg2, kQ, gicm2
kAS3, kp3[], kt3[] Taphath ktrig, kn3, kg3, kQ, gicm2
gkcps[] init 3
gkcps[0] = tlineto(kp1[2], 0.4, kt1[2])
gkcps[1] = tlineto(kp2[2], 0.2, ClkDiv(kt2[2],4))
gkcps[2] = tlineto(kp3[2], 0.6, kt3[2])
; Q mode (0=reset, 1=keep)
kQ[kAS1] = kQ[kAS1] * 0
; sigil
;knote[4] = knote[4]+kt[2]
;kgain[2] = kgain[2]+kt[4]
;kgain[5] = kgain[5]+kt[4]*2
;kQ[2]    = kQ[2]+ClkDiv(kt1[4], 2)
;kQ[5]    = kQ[5]+ClkDiv(kt1[3], 3)
;kQ[0]    = kQ[0]+ClkDiv(kt1[4], 6)
;kQ[7]    = kQ[7]+ClkDiv(kt1[4], 3)
;kQ[6]    = kQ[6]+ClkDiv(kt1[4], 5)
endin


