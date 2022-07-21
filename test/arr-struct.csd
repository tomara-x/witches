//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;this is an effort to try replicating some of the functionality of the
;network sequencer by Mog [https://github.com/JustMog/Mog-VCV]
;thank you so much!


;tree_init(8, 4, 3)
;node_connect(0, 1)
;node_connect(0, 2)
;node_connect(0, 3)
;node_connect(1, 4)
;node_connect(1, 5)
;node_connect(2, 6)
;node_connect(6, 7)

;branches ---------------+-+-+
;root node ------------+ | | |
;values -------+-+-+-+ | | | |
;              | | | | | | | |
;              V + + + R B B B
;N#0-----------0,0,0,0,N,1,2,3           +--0--+
;N#1-----------0,0,0,0,0,4,5,N           |  |  |
;N#2-----------0,0,0,0,0,6,N,N        +--1  2  3
;N#3-----------0,0,0,0,0,N,N,N   ->   |  |  |
;N#4-----------0,0,0,0,1,N,N,N        4  5  6
;N#5-----------0,0,0,0,1,N,N,N              |
;N#6-----------0,0,0,0,2,7,N,N              7
;N#7-----------0,0,0,0,6,N,N,N


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



;when you move those to an orc file:
;-have a list of opcodes and a syntax line for each up top
;-description for the global vars (still not a bad idea)
;-keep the jam responsibly but have it at the end
;-add a moved-to note here
;-link to this file there (for commit history)
;-link to ft-struct.csd too (origin)
;-include the orc and leave the instrs



//TREE_INIT
;create and initialize the tree arrays
;syntax: tree_init iNumberOfNodes, iValusePerNode, iBranchesPerNode
;iNumberOfNodes: how many nodes the tree will have throughout performance
;iValusePerNode: number of variables available in each node for storing
;                note parameters (frequency, intensity, repetitions, etc)
;iBranchesPerNode: how many branches can a node have
opcode tree_init, 0, iii
inodes, ivals, ibranches xin
gi_NumOfNodes = inodes
gi_ValuesPerNode = ivals ;roots index
gi_NodeLength = ivals+ibranches+1 ;the node stores values,root, and branches
gk_Tree[][] init gi_NumOfNodes, gi_NodeLength

;progress of each node in the tree
;-1 = play node itself, 0 = play branch 0, and so on
gk_NodeProgress[] init gi_NumOfNodes

;initialize tree 2d array to -1
ii = 0
while ii < gi_NumOfNodes do
    ij = 0
    while ij < gi_NodeLength do
        gk_Tree[ii][ij] init -1
        ij += 1
    od
    ii += 1
od

;initialize progress array to -1
ii = 0
while ii < gi_NumOfNodes do
    gk_NodeProgress[ii] init -1
    ii += 1
od
endop



//NODE_SET_VALUE
;write input value to node at index (in k-time)
;will write only to node values, never changing connections
;syntax: node_set_value_i/k i/kNode, i/kNdx, i/kInput
;init pass version
opcode node_set_value_i, 0, iii
inode, indx, iin xin
if inode < gi_NumOfNodes && indx < gi_ValuesPerNode then
    gk_Tree[inode][indx] init iin
endif
endop
;k-time
opcode node_set_value_k, 0, kkk
knode, kndx, kin xin
if knode < gi_NumOfNodes && kndx < gi_ValuesPerNode then
    gk_Tree[knode][kndx] = kin
endif
endop
;array of input values
;writes elements of input array or number of value slots in a node (whichever's shorter)
;syntax: node_set_value_i/k i/kNode, i/kValues[]
;init pass version
opcode node_set_value_i, 0, ii[]
inode, iin[] xin
if inode < gi_NumOfNodes then
    icnt = 0
    while icnt < min(lenarray(iin), gi_ValuesPerNode) do
        gk_Tree[inode][icnt] init iin[icnt]
        icnt += 1
    od
endif
endop
;k-time
opcode node_set_value_k, 0, kk[]
knode, kin[] xin
if knode < gi_NumOfNodes then
    kcnt = 0
    while kcnt < min(lenarray(kin), gi_ValuesPerNode) do
        gk_Tree[knode][kcnt] = kin[kcnt]
        kcnt += 1
    od
endif
endop



//NODE_GET_VALUE
;outputs value from index of node (in k-time)
;will output only from a valid node and a value index (0 otherwise)
;syntax: i/kOut node_get_value_i/k i/kNode, i/kNdx
;i-pass
opcode node_get_value_i, i, ii
inode, indx xin
iout = 0
if inode < gi_NumOfNodes && indx < gi_ValuesPerNode then
    iout = i(gk_Tree, inode, indx)
endif
xout iout
endop
;k-time
opcode node_get_value_k, k, kk
knode, kndx xin
kout = 0
if knode < gi_NumOfNodes && kndx < gi_ValuesPerNode then
    kout = gk_Tree[knode][kndx]
endif
xout kout
endop
;array output of all values version
;syntax: kValues[] node_get_value kNode
;i-pass
opcode node_get_value_i, i[], i
inode xin
iout[] init gi_ValuesPerNode
if inode < gi_NumOfNodes then
    icnt = 0
    while icnt < gi_ValuesPerNode do
        iout[icnt] = i(gk_Tree, inode, icnt)
        icnt += 1
    od
endif
xout iout
endop
;k-time
opcode node_get_value_k, k[], k
knode xin
kout[] init gi_ValuesPerNode
if knode < gi_NumOfNodes then
    kout = slicearray(getrow(gk_Tree, knode), 0, gi_ValuesPerNode-1)
endif
xout kout
endop



//NODE_SET_ROOT
;sets root of node to given value
;(it doesn't set branches, but can be useful for root switching)
;(does not error-check if the value is a valid node)
;syntax: node_set_root_i/k i/kNode, i/kRoot
;i-pass version
opcode node_set_root_i, 0, ii
inode, iroot xin
iRootIndex = gi_ValuesPerNode
if inode < gi_NumOfNodes then
    gk_Tree[inode][iRootIndex] init iroot
endif
endop
;k-time
opcode node_set_root_k, 0, kk
knode, kroot xin
iRootIndex = gi_ValuesPerNode
if knode < gi_NumOfNodes then
    gk_Tree[knode][iRootIndex] = kroot
endif
endop
;set an array of nodes to a single root
;syntax node_set_root_i/k i/kNode[], i/kRoot
;i-pass
opcode node_set_root_i, 0, i[]i
inode[], iroot xin
iRootIndex = gi_ValuesPerNode
icnt = 0
while icnt < lenarray(inode) do
    if inode[icnt] < gi_NumOfNodes then
        gk_Tree[inode[icnt]][iRootIndex] init iroot ;set_root(node[cnt], root)
    endif
    icnt += 1
od
endop
;k-time
opcode node_set_root_k, 0, k[]k
knode[], kroot xin
iRootIndex = gi_ValuesPerNode
kcnt = 0
while kcnt < lenarray(knode) do
    if knode[kcnt] < gi_NumOfNodes then
        gk_Tree[knode[kcnt]][iRootIndex] = kroot
    endif
    kcnt += 1
od
endop



//NODE_CLEAR_ROOT
;sets the root of input node to -1 (disconnected/no-root node)
;syntax: node_clear_root_i/k i/kNode
;i-pass
opcode node_clear_root_i, 0, i
inode xin
iRootIndex = gi_ValuesPerNode
if inode < gi_NumOfNodes then
    gk_Tree[inode][iRootIndex] init -1
endif
endop
;k-time
opcode node_clear_root_k, 0, k
knode xin
iRootIndex = gi_ValuesPerNode
if knode < gi_NumOfNodes then
    gk_Tree[knode][iRootIndex] = -1
endif
endop



//NODE_CLEAR_BRANCHES
;sets all branches of input node to -1 (no branches) (k-time)
;syntax: node_clear_branches_i/k i/kNode
;i-pass
opcode node_clear_branches_i, 0, i
inode xin
iBranchZero = gi_ValuesPerNode+1 ;index after root
if inode < gi_NumOfNodes then
    icnt = iBranchZero
    while icnt < gi_NodeLength do
        gk_Tree[inode][icnt] init -1
        icnt += 1
    od
endif
endop
;k-time
opcode node_clear_branches_k, 0, k
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



//NODE_ISOLATE
;sets all connections of node to -1
;syntax: node_isolate_i/k i/kNode
;i-pass
opcode node_isolate_i, 0, i
inode xin
node_clear_root_i(inode)
node_clear_branches_i(inode)
endop
;k-time
opcode node_isolate_k, 0, k
knode xin
node_clear_root_k(knode)
node_clear_branches_k(knode)
endop



//NODE_COPY
;copies node values, root, and branches (k-time)
;a node having the same branch/root nodes as another doean't cause any problems.
;this doesn't cause a connection, only a node with parameters.
;(dst will have src's branches, but those branches still have src as their root)
;if you wanna connect those branches to this new root you'd still have to do connect.
;also this can be used to make different nodes mirror each other.
;syntax: node_copy_i/k i/kSrc, i/kDst
;i-pass
opcode node_copy_i, 0, ii
isrc, idst xin
if isrc < gi_NumOfNodes && idst < gi_NumOfNodes then
    icnt = 0
    while icnt < gi_NodeLength do
        gk_Tree[idst][icnt] init i(gk_Tree, ksrc, kcnt)
        icnt += 1
    od
endif
endop
;k-time
opcode node_copy_k, 0, kk
ksrc, kdst xin
if ksrc < gi_NumOfNodes && kdst < gi_NumOfNodes then
    kcnt = 0
    while kcnt < gi_NodeLength do
        gk_Tree[kdst][kcnt] = gk_Tree[ksrc][kcnt]
        kcnt += 1
    od
endif
endop



//NODE_CONNECT
;connects branch node to root node
;(sets root index of branch, and first empty branch index of root)
;overwrites branch's root. does nothing if all root's branch indices are used (> -1)
;syntax: node_connect_i/k i/kRoot, i/kBranch
;i-pass version
opcode node_connect_i, 0, ii
iroot, ibranch xin
iRootIndex = gi_ValuesPerNode
if iroot < gi_NumOfNodes && ibranch < gi_NumOfNodes then
    icnt = iRootIndex + 1 ;first branch
    while icnt < gi_NodeLength do
        if i(gk_Tree, iroot, icnt) == -1 then ;holy fuck! i() works with multi-arrs! = i(tree[root][cnt])
            gk_Tree[ibranch][iRootIndex] init iroot
            gk_Tree[iroot][icnt] init ibranch
            goto break
        endif
        icnt += 1
    od
    break:
endif
endop
;k-time
opcode node_connect_k, 0, kk
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
;take array of branches to connect to root
;connects as many branches as possible ((empty spaces))
;syntax: node_connect_i/k i/kRoot, i/kBranches[]
;i-pass version
opcode node_connect_i, 0, ii[]
iroot, ibranches[] xin
icnt = 0
while icnt < lenarray(ibranches) do
    node_connect_i(iroot, ibranches[icnt])
    icnt += 1
od
endop
;k-time
opcode node_connect_k, 0, kk[]
kroot, kbranches[] xin
kcnt = 0
while kcnt < lenarray(kbranches) do
    node_connect_k(kroot, kbranches[kcnt])
    kcnt += 1
od
endop



//NODE_CONNECT_AT
;connects branch as Nth branch of root (zero indexed)
;(overwriting exixting root and branch parameters)
;syntax: node_connect_at_i/k i/kRoot, i/kBranch, i/kN
;N must be between 0 and available branch slots
;(gi_NodeLength - (gi_ValuesPerNode + 1)) otherwise nothing is done
;i-pass version
opcode node_connect_at_i, 0, iii
iroot, ibranch, ix xin ;variable called "in" is a no-go
iRootIndex = gi_ValuesPerNode
ix += iRootIndex+1 ;offset
if iroot < gi_NumOfNodes && ibranch < gi_NumOfNodes &&
         ix > iRootIndex && ix < gi_NodeLength then
    gk_Tree[ibranch][iRootIndex] init iroot
    gk_Tree[iroot][ix] init ibranch
endif
endop
;k-time
opcode node_connect_at_k, 0, kkk
kroot, kbranch, kn xin
iRootIndex = gi_ValuesPerNode
kn += iRootIndex+1 ;offset so that kn=0 is first branch index
if kroot < gi_NumOfNodes && kbranch < gi_NumOfNodes &&
         kn > iRootIndex && kn < gi_NodeLength then
    gk_Tree[kbranch][iRootIndex] = kroot
    gk_Tree[kroot][kn] = kbranch
endif
endop



//NODE_GET_BRANCH
;get Nth branch of node (zero indexed)
;syntax: i/kBranch node_get_branch_i/k i/kNode, i/kN
;i-pass
opcode node_get_branch_i, i, ii
inode, ix xin
iRootIndex = gi_ValuesPerNode
iBranchZero = iRootIndex+1
ix += iBranchZero
ibranch init -1
if inode < gi_NumOfNodes && ix > iRootIndex && ix < gi_NodeLength then
    ibranch = i(gk_Tree, inode, ix)
endif
xout ibranch
endop
;k-time
opcode node_get_branch_k, k, kk
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



//NODE_GET_ROOT
;get root of node
;syntax: i/kRoot node_get_root_i/k i/kNode
;i-pass
opcode node_get_root_i, i, i
inode xin
iRootIndex = gi_ValuesPerNode
iroot init -1
if inode < gi_NumOfNodes then
    iroot = i(gk_Tree, inode, iRootIndex)
endif
xout iroot
endop
;k-time
opcode node_get_root_k, k, k
knode xin
iRootIndex = gi_ValuesPerNode
kroot init -1
if knode < gi_NumOfNodes then
    kroot = gk_Tree[knode][iRootIndex]
endif
xout kroot
endop


//BOOLS
;returns 1 when input node has a branch at index, 0 otherwise
;syntax: kFlag node_has_branch kNode, kNdx
opcode node_has_branch, k, kk
knode, kndx xin
kflag = 0
if node_get_branch(knode, kndx) != -1 then
    kflag = 1
endif
xout kflag
endop

;returns 1 when input node has a root, 0 otherwise
;syntax: kFlag node_has_root kNode
opcode node_has_root, k, k
knode xin
kflag = 0
if node_get_root(knode) != -1 then
    kflag = 1
endif
xout kflag
endop



;progress ops-------------------------------------

;reset node's progress to -1
;syntax: progress_reset kNode
opcode progress_reset, 0, k
knode xin
if knode < gi_NumOfNodes then
    gk_NodeProgress[knode] = -1
endif
endop

;reset entire array
;syntax: progress_reset_all
opcode progress_reset_all, 0, 0
gk_NodeProgress = -1
endop

;get progress of node
;syntax: kProgress progress_get kNode
opcode progress_get, k, k
knode xin
kout init -1
if knode < gi_NumOfNodes then
    kout = gk_NodeProgress[knode]
endif
xout kout
endop

;set progress of node to n
;syntax: progress_set kNode, kN
opcode progress_set, 0, kk
knode, kn xin
if knode < gi_NumOfNodes then
    gk_NodeProgress[knode] = kn
endif
endop

;add 1 to progress of node (every k-cycle)
opcode progress_add1, 0, k
knode xin
if knode < gi_NumOfNodes then
    gk_NodeProgress[knode] = gk_NodeProgress[knode] + 1
endif
endop

;----------------------------------------------



;climbs a node, its branches one by one, passing by their branches, and so on
;from the example at the top, with 0 as input, every k-cycle the progress will be:
;0, 1, 4, 5, 2, 6, 7, 3, 0,...
;syntax: kCurrentNode node_climb kNode [, kReset]
opcode node_climb, k, kO
knode, kreset xin
koutnode init i(knode)
kflag = 0
if node_has_branch(koutnode, progress_get(koutnode)) == 1 then
    koutnode = node_get_branch(koutnode, progress_get(koutnode))
elseif progress_get(koutnode) > -1 then
    until node_has_branch(koutnode, progress_get(koutnode)) == 1 do
        koutnode = node_get_root(koutnode)
        if node_has_branch(koutnode, progress_get(koutnode)+1) == 0 &&
            koutnode == knode then ;at last branch of input node
            progress_reset_all
            kflag = 1
        endif
        progress_add1(koutnode)
    od
    if kflag == 0 then
        koutnode = node_get_branch(koutnode, progress_get(koutnode))
    endif
endif
if kflag == 0 then
    progress_add1(koutnode)
endif
xout koutnode
endop

;play root after every branch (no branch-to-branch hopping)
;from same example, progress is: 0,1,4,1,5,1,0,2,6,7,6,2,0,3,0...
;syntax: kCurrentNode node_climb2 kNode [, kRese]
opcode node_climb2, k, kO
knode, kreset xin
koutnode init i(knode)
if node_has_branch(koutnode, progress_get(koutnode)) == 1 then
    koutnode = node_get_branch(koutnode, progress_get(koutnode))
else
    progress_reset(koutnode)
    if koutnode != knode then
        koutnode = node_get_root(koutnode)
    endif
endif
if node_has_branch(koutnode, progress_get(koutnode)+1) == 0 &&
    koutnode == knode then ;at last branch of input node
    progress_reset(koutnode)
endif
progress_add1(koutnode)
xout koutnode
endop



instr 1
tree_init(8, 4, 5) ;init time only
node_connect(0, 1)
node_connect(0, 2)
node_connect(0, 3)
node_connect(1, 4)
node_connect(1, 5)
node_connect(2, 6)
node_connect(6, 7)
endin
instr 2
kn = node_climb(0)
printk 0, kn
;printarray gk_Tree
endin

</CsInstruments>
<CsScore>
i1 0 0.0
i2 1 0.5
e
</CsScore>
</CsoundSynthesizer>



;drunk_climb?
;what kinda drunk do you want here?
;up-down kind of random walk? or probability of brabches?
;this can be a whole box of cookies!



;TRY SWITCHING THE ORDER OF K-RATE AND I-PASS VERSIONS
;motherfucker! it does make it prefer the i-time ones... hmmm...

;i mean it makes sense, the "engine" or whatever is going through definitions and it picks
;the first thing that matches the input and output parameters (the opcode entry)

;nah, i won't waste time, adding triggers is as simple as running the opcode in an
;if conditional in the instr. i want them to run at every cycle (think of the fun mistakes)

;so i-pass ones take priority because most time i think i'll use those with constants
;for initial setting, but for self-patching (the witches live!) it's gonna be k inputs.
;that, and forcing k-time running is simple if it's needed (k() an arg)


;you know what this needs? an additive voice with a bunch of inharmonic
;partials. you know that sound? kinda like a handpan.. ooo mama! have mercy!


;can you make a tree_draw opcode? it'd be nice

;do you wanna k-rate nuke-tree kinda opcode?
;kinda like the progress_reset_all


;storing the repetition value in each node, with some patching to the trigger
;pass the trigger directly, but pass a divided version to the sequencer (on the 0)
;don't need a reset-node to do this.

;a node can have multiple values, you can store chord progressions
;in one tree (bunch of connected nodes) and climb that, and store melodies
;in another tree, and climb that separately


;IMPORTANTE: add a distinguishing i and k to opcode names?
;also for quality's sake let's write i-versions of all those k-only cuties

