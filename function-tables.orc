/*
trans rights
*/

/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/

;gifn1
iscaledegrees   = 7
itotalsize      = iscaledegrees*4
iinterval       = 2 ;ratio range covered before repeating (octave = 2)
ibasefreq       = cpspch(6) ;cpspch(8) = c4
ibaseindex      = 0 ;index 0 will be ibasefreq
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

;natural minor
gifn3 ftgen 0,0,-7*4,-51, 7,2,cpspch(6),0,
2^(0/12),
2^(2/12),
2^(3/12),
2^(5/12),
2^(7/12),
2^(8/12),
2^(10/12)

;same but 2 octaves
gifn4 ftgen 0,0,-7*2,-51, 7,2,cpspch(6),0,
2^(0/12),
2^(2/12),
2^(3/12),
2^(5/12),
2^(7/12),
2^(8/12),
2^(10/12)

;ramp wave
gidfn1 ftgen 0,0,64,7, -1,64,1

