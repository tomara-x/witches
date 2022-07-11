//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;this is an effort to try replicating some of the functionality of the
;network sequencer by Mog [https://github.com/JustMog/Mog-VCV]
;thank you so much!

;branches -----------------------+-+-+
;root node --------------------+ | | |
;values -------+-+-+-+-+-+-+-+ | | | |
;              | | | | | | | | | | | |
;              V + + + + + + + R B B B
;N#0-----------0,0,0,0,0,0,0,0,N,1,2,3               +--0--+
;N#1-----------0,0,0,0,0,0,0,0,0,4,5,N               |  |  |
;N#2-----------0,0,0,0,0,0,0,0,0,6,N,N            +--1  2  3
;N#3-----------0,0,0,0,0,0,0,0,0,N,N,N     ->     |  |  |
;N#4-----------0,0,0,0,0,0,0,0,1,N,N,N            4  5  6
;N#5-----------0,0,0,0,0,0,0,0,1,N,N,N                  |
;N#6-----------0,0,0,0,0,0,0,0,2,7,N,N                  7
;N#7-----------0,0,0,0,0,0,0,0,6,N,N,N
;this example:
;gi_NumOfNodes = 8
;gi_ValuesPerNode = 8
;gi_NodeLength = 12

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
;init pass version (are those needed?) (can be useful for initing nodes)
opcode node_set_value, 0, iii
inode, indx, iin xin
if inode < gi_NumOfNodes && indx < gi_ValuesPerNode then
    gk_Tree[inode][indx] init iin
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
;are i-pass versions needed?
;i(getrow(node), index)? that line looks like it's here to cause mischief



;sets root of node to given value
;(it doesn't set branches, but can be useful for root switching)
;(does not error-check if the value is a valid node)
;syntax: node_set_root kNode, kRoot
opcode node_set_root, 0, kk
knode, kroot xin
iRootIndex = gi_ValuesPerNode
if knode < gi_NumOfNodes then
    gk_Tree[knode][iRootIndex] = kroot
endif
endop
;i-pass version (i feel like those are gonna be a pain in the ass)
opcode node_set_root, 0, ii
inode, iroot xin
iRootIndex = gi_ValuesPerNode
if inode < gi_NumOfNodes then
    gk_Tree[inode][iRootIndex] init iroot
endif
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
iBranchZero = gi_ValuesPerNode+1 ;index after root
if knode < gi_NumOfNodes then
    kcnt = iBranchZero
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



;connects branch node to root node
;(sets root index of branch, and first empty branch index of root)
;overwrites branch's root. does nothing if all root's branch indices are used (> -1)
;syntax: node_connect kRoot, kBranch
opcode node_connect, 0, kk
kroot, kbranch xin
iRootIndex = gi_ValuesPerNode
if kroot < gi_NumOfNodes && kbranch < gi_NumOfNodes then
    kcnt = iRootIndex + 1 ;first branch
    while kcnt < gi_NodeLength do
        if gk_Tree[kroot][kcnt] == -1 then ;empty branch slot in root node
            gk_Tree[kbranch][iRootIndex] = kroot ;set root of branch
            gk_Tree[kroot][kcnt] = kbranch ;set branch of root
            goto break
        endif
        kcnt += 1
    od
    break:
endif
endop
;i-pass version
opcode node_connect, 0, ii
iroot, ibranch xin
iRootIndex = gi_ValuesPerNode
if iroot < gi_NumOfNodes && ibranch < gi_NumOfNodes then
    icnt = iRootIndex + 1 ;first branch
    while icnt < gi_NodeLength do
        if gk_Tree[iroot][icnt] == -1 then
            gk_Tree[ibranch][iRootIndex] init iroot
            gk_Tree[iroot][icnt] init ibranch
            goto break
        endif
        icnt += 1
    od
    break:
endif
endop
;take array of branches to connect to root
;connects as many branches as possible ((empty spaces))
;syntax: node_connect kRoot, kBranches[]
opcode node_connect, 0, kk[]
kroot, kbranches[] xin
kcnt = 0
while kcnt < lenarray(kbranches) do
    node_connect(kroot, kbranches[kcnt])
    kcnt += 1
od
endop
;i-pass version
opcode node_connect, 0, ii[]
iroot, ibranches[] xin
icnt = 0
while icnt < lenarray(ibranches) do
    node_connect(iroot, ibranches[icnt])
    icnt += 1
od
endop



;connects branch as Nth branch of root (zero indexed)
;(overwriting exixting root and branch parameters)
;syntax: node_connect_at kRoot, kBranch, kN
;N must be between 0 and available branch slots (gi_NodeLength - (gi_ValuesPerNode + 1))
opcode node_connect_at, 0, kkk
kroot, kbranch, kn xin
iRootIndex = gi_ValuesPerNode
kn += iRootIndex+1 ;offset so that kn=0 is first branch index
if kroot < gi_NumOfNodes && kbranch < gi_NumOfNodes &&
         kn > iRootIndex && kn < gi_NodeLength then
    gk_Tree[kbranch][iRootIndex] = kroot
    gk_Tree[kroot][kn] = kbranch
endif
endop
;i-pass version
opcode node_connect_at, 0, iii
iroot, ibranch, ix xin ;variable called "in" is a no-go
iRootIndex = gi_ValuesPerNode
ix += iRootIndex+1 ;offset
if iroot < gi_NumOfNodes && ibranch < gi_NumOfNodes &&
         ix > iRootIndex && ix < gi_NodeLength then
    gk_Tree[ibranch][iRootIndex] = iroot
    gk_Tree[iroot][ix] = ibranch
endif
endop



;get Nth branch of node (zero indexed)
;syntax: kBranch node_get_branch kNode, kN
opcode node_get_branch, k, kk
knode, kn xin
iRootIndex = gi_ValuesPerNode
iBranchZero = iRootIndex+1
kn += iBranchZero
kbranch init -1
if knode < gi_NumOfNodes && kn > iRootIndex && kn < gi_NodeLength then
    kbranch = gk_Tree[knode][kn]
endif
xout kbranch
endop



;get root of node
;syntax: kRoot node_get_root kNode
opcode node_get_root, k, k
knode xin
iRootIndex = gi_ValuesPerNode
kroot init -1
if knode < gi_NumOfNodes then
    kroot = gk_Tree[knode][iRootIndex]
endif
xout kroot
endop


/*
climbs up a node, its branches one by one, passing by their branches, and so on

syntax:
kCurrentNode node_climb kTrig, kNode [,KResetNode] [,KResetAll]

kCurrentNode: output of the current node index (values can be accessed with node_get_value)
kTrig: trigger signal, we move to new node every k-cycle where this != 0
kNode: starting node (can be changed in performance for some fun)
kResetNode: when it != 0, resets the progress of the current node back to playing itself
kResetAll: when it != 0, reset all progress of all nodes and return to input node
*/
opcode node_climb, k, kkOO
ktrig, knode, kresetnode, kresetall xin
kprogress[] init gi_NumOfNodes
kprogress = -1
kcurrentnode init 0
iRootIndex = gi_ValuesPerNode
iBranchZero = iRootIndex+1
iNumOfBranches = gi_NodeLength - (gi_ValuesPerNode + 1)
if knode < gi_NumOfNodes && kcurrentnode < gi_NumOfNodes then
    if ktrig != 0 then
        if kprogress[knode] == -1 then ;play this node before branching
            kcurrentnode = knode
            kprogress[kcurrentnode] = (kprogress[kcurrentnode] + 1) % iNumOfBranches
        elseif node_get_branch(kcurrentnode, kprogress[kcurrentnode]) == -1 then ;no more branches
            kprogress[kcurrentnode] = -1 ;reset progress of node
            ktmproot = node_get_root(kcurrentnode)
            ktmpprogress = kprogress[ktmproot]
            ;there is a root, and it has no more branch connections, or we reached the last one
            while ktmproot != -1 &&
                (node_get_branch(ktmproot, ktmpprogress) != -1 ||
                ktmpprogress == iNumOfBranches-1) do
                kcurrentnode = ktmproot ;jump to root
                kprogress[kcurrentnode] = (kprogress[kcurrentnode] + 1) % iNumOfBranches ;increment
                ktmproot = node_get_root(kcurrentnode) ;update loop vars
                ktmpprogress = kprogress[ktmproot]
            od
            if node_get_branch(kcurrentnode, kprogress[kcurrentnode]) != -1 then ;if there's branch ahead
                kcurrentnode = node_get_branch(kcurrentnode, kprogress[kcurrentnode]) ;go to it
                kprogress[kcurrentnode] = (kprogress[kcurrentnode] + 1) % iNumOfBranches ;increment
            endif
        elseif node_get_branch(kcurrentnode, kprogress[kcurrentnode]) != -1 then ;go to branch
            kcurrentnode = node_get_branch(kcurrentnode, kprogress[kcurrentnode])
            kprogress[kcurrentnode] = (kprogress[kcurrentnode] + 1) % iNumOfBranches
        endif
    endif
    if kresetnode != 0 then
        kprogress[kcurrentnode] = -1
    endif
endif
if kresetall != 0 then
    kprogress = -1
    kcurrentnode = knode
endif
xout kcurrentnode
endop



;drunk_climb? climb_playing_root_after_every_branch? (no branch hopping)

;you know what this needs? an additive voice with a bunch of inharmonic
;partials. you know that sound? kinda like a handpan.. ooo mama! have mercy!

instr 1
node_connect(0, 3)
printarray gk_Tree
endin

</CsInstruments>
<CsScore>
i1 0 0.05
e
</CsScore>
</CsoundSynthesizer>

