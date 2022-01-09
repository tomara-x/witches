//trans rights
//Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;c dorian #4 (ukrainian dorian) in 12-tet
iscaledegrees   = 7
itotalsize      = iscaledegrees*7
iinterval       = 2 ;ratio range covered before repeating (2 = 1 octave)
ibasefreq       = cpspch(5) ;cpspch(8) = c4
ibaseindex      = 0 ;index 0 will be ibasefreq
giud7 ftgen 0,0,-itotalsize,-51, iscaledegrees,iinterval,ibasefreq,ibaseindex,
2^(0/12),2^(2/12),2^(3/12),2^(6/12),2^(7/12),2^(9/12),2^(10/12)
; ratios (the numirators are the scale notes in this case 0=c ... 11=b)

;4 octaves
giud4 ftgen 0,0,-7*4,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(6/12),2^(7/12),2^(9/12),2^(10/12)

;c natural minor (6 octaves)
gicm6 ftgen 0,0,-7*6,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)

;4 octaves
gicm4 ftgen 0,0,-7*4,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)

;2 octaves
gicm2 ftgen 0,0,-7*2,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)

;31-tet
iscaledegrees   = 31
itotalsize      = iscaledegrees*4
iinterval       = 2
ibasefreq       = cpspch(6) ;cpspch(8) = c4
ibaseindex      = 0
gi31tet ftgen 0,0,-itotalsize,-51, iscaledegrees,iinterval,ibasefreq,ibaseindex,
2^(00/31),2^(01/31),2^(02/31),2^(03/31),
2^(04/31),2^(05/31),2^(06/31),2^(07/31),
2^(08/31),2^(09/31),2^(10/31),2^(11/31),
2^(12/31),2^(13/31),2^(14/31),2^(15/31),
2^(16/31),2^(17/31),2^(18/31),2^(19/31),
2^(20/31),2^(21/31),2^(22/31),2^(23/31),
2^(24/31),2^(25/31),2^(26/31),2^(27/31),
2^(28/31),2^(29/31),2^(30/31)

;ramp wave (for bit-crushing)
giframp ftgen 0,0,64,7, -1,64,1

;tanh function for distortion
giftanh ftgen 0,0,1024,"tanh", -5, 5, 0

;sawtooth wave
gifsaw ftgen 0,0,2^13,7, 0,2^12,1,0,-1,2^12,0

;square wave
gifsqur ftgen 0,0,2^13,7, 1,2^12,1,0,-1,2^12,-1

