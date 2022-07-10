//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;jam responsibly
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

gi_NumOfNodes = 8
gi_ValuesPerNode = 4 ;roots index
gi_NodeLength = 8
gk_Tree[][] init gi_NumOfNodes, gi_NodeLength


;branches -----------------------+-+-+
;root node --------------------+ | | |
;values -------+-+-+-+-+-+-+-+ | | | |
;              | | | | | | | | | | | |
;              V + + + + + + + R B B ...
;N#0-----------0,0,0,0,0,0,0,0,N,1,2,3               +--0--+
;N#1-----------0,0,0,0,0,0,0,0,0,4,5,N               |  |  |
;N#2-----------0,0,0,0,0,0,0,0,0,6,N,N            +--1  2  3
;N#3-----------0,0,0,0,0,0,0,0,0,N,N,N     ->     |  |  |
;N#4-----------0,0,0,0,0,0,0,0,1,N,N,N            4  5  6
;N#5-----------0,0,0,0,0,0,0,0,1,N,N,N                  |
;N#6-----------0,0,0,0,0,0,0,0,2,7,N,N                  7
;N#7-----------0,0,0,0,0,0,0,0,6,N,N,N   



;initialize entire array to -1
opcode tree_init, 0, 0
ii = 0
while ii < gi_NumOfNodes do
    ij = 0
    while ij < gi_NodeLength do
        gk_Tree[ii][ij] init -1
        ij += 1
    od
    ii += 1
od
endop

tree_init ;init time only, so can be called from instr 0



;write input value to node at index (in k-time)
;will write only to node values, never changing connections
;syntax: node_set_value kNode, kNdx, kInput
opcode node_set_value, 0, kkk
knode, kndx, kin xin
if knode < gi_NumOfNodes && kndx < gi_ValuesPerNode then
    gk_Tree[knode][kndx] = kin
endif
endop
;init pass version (are those needed?)
opcode node_set_value, 0, iii
inode, indx, iin xin
if inode < gi_NumOfNodes && indx < gi_ValuesPerNode then
    gk_Tree[knode][kndx] init iin
endif
endop
;array of input values
;writes elements of input array or number of value slots in a node (whichever's shorter)
;syntax: node_set_value kNode, kValues[]
opcode node_set_value, 0, kk[]
knode, kin[] xin
if knode < gi_NumOfNodes then
    kcnt = 0
    while kcnt < min(lenarray(kin), gi_ValuesPerNode) do
        gk_Tree[knode][kcnt] = kin[kcnt]
        kcnt += 1
    od
endif
endop
;init pass version
opcode node_set_value, 0, ii[]
inode, iin[] xin
if inode < gi_NumOfNodes then
    icnt = 0
    while icnt < min(lenarray(iin), gi_ValuesPerNode) do
        gk_Tree[inode][icnt] init iin[icnt]
        icnt += 1
    od
endif
endop



;outputs value from index of node (in k-time)
;will output only from a valid node and a value index (0 otherwise)
;syntax: kOut node_get_value kNode, kNdx
opcode node_get_value, k, kk
knode, kndx xin
kout = 0
if knode < gi_NumOfNodes && kndx < gi_ValuesPerNode then
    kout = gk_Tree[knode][kndx]
endif
xout kout
endop

;i don't think an i-pass version is possible here?
;is it even needed?
;i(getrow(node), index)? that line looks like it's here to cause mischief

;array output of all values version
;syntax: kValues[] node_get_value kNode
opcode node_get_value, k[], k
knode xin
kout[] init gi_ValuesPerNode
if knode < gi_NumOfNodes then
    kout = slicearray(getrow(gk_Tree, knode), 0, gi_ValuesPerNode-1)
endif
xout kout
endop



;sets the root of input node to -1 (disconnected/no root node)
;syntax: node_clear_root kNode
opcode node_clear_root, 0, k
knode xin
iRootIndex = gi_ValuesPerNode
if knode < gi_NumOfNodes then
    gk_Tree[knode][iRootIndex] = -1
endif
endop



;sets all branches of input node to -1 (no branches) (k-time)
;syntax: node_clear_branches kNode
opcode node_clear_branches, 0, k
knode xin
iBranchOne = gi_ValuesPerNode+1 ;index after root
if knode < gi_NumOfNodes then
    kcnt = iBranchOne
    while kcnt < gi_NodeLength do
        gk_Tree[knode][kcnt] = -1
        kcnt += 1
    od
endif
endop



;sets all connections of node to -1
;syntax: node_isolate kNode
opcode node_isolate, 0, k
knode xin
node_clear_root(knode)
node_clear_branches(knode)
endop




;copies node values and root (but not branches lol)
;syntax: node_copy kSrc, kDst
opcode node_copy, 0, kk
ksrc, kdst xin
if ksrc < gi_NumOfNodes && kdst < gi_NumOfNodes then
    kcnt = 0
    while kcnt <= gi_ValuesPerNode do ;copy vals and root
        gk_Tree[kdst][kcnt] = gk_Tree[ksrc][kcnt]
        kcnt += 1
    od
endif
endop

;node_connect (take root and 1 branch) (array of branches overload?)
;node_copy
;node_walk (recursive?) (tracks progress) (reset-node/all trig inputs)
;drunk_walk? walk_playing_root_after_every_branch?

instr 1
printarray gk_Tree
endin

</CsInstruments>
<CsScore>
i1 0 0.05
e
</CsScore>
</CsoundSynthesizer>

