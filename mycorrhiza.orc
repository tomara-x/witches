//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//this is an effort to try replicating some of the functionality of the
//network sequencer by Mog [https://github.com/JustMog/Mog-VCV]
//thank you so much!

//see test/arr-struct.csd and test/ft-struct.csd for early commit history

/*
                        branches ---------------+-+-+
                        root node ------------+ | | |
                        values -------+-+-+-+ | | | |
                                      | | | | | | | |
                                      V + + + R B B B
tree_init(8, 4, 3)      N#0-----------0,0,0,0,N,1,2,3       +--0--+
node_connect_i(0, 1)    N#1-----------0,0,0,0,0,4,5,N       |  |  |
node_connect_i(0, 2)    N#2-----------0,0,0,0,0,6,N,N    +--1  2  3
node_connect_i(0, 3) -> N#3-----------0,0,0,0,0,N,N,N -> |  |  |
node_connect_i(1, 4)    N#4-----------0,0,0,0,1,N,N,N    4  5  6
node_connect_i(1, 5)    N#5-----------0,0,0,0,1,N,N,N          |
node_connect_i(2, 6)    N#6-----------0,0,0,0,2,7,N,N          7
node_connect_i(6, 7)    N#7-----------0,0,0,0,6,N,N,N



list of opcodes:
(there's an i and k version of most opcodes)

tree_init
tree_reset_i/k
tree_reset_connections_i/k

node_set_value_i/k
node_get_value_i/k
node_set_root_i/k
node_set_branch_i/k
node_isolate_i/k
node_clear_root_i/k
node_clear_branches_i/k
node_copy_i/k
node_connect_i/k
node_connect_at_i/k
node_has_root_i/k
node_has_branch_i/k
node_get_root_i/k
node_get_branch_i/k
node_valid_i/k
node_isolated_i/k
node_climb(2/3/4)

(i-pass versions of the following have an extra "_i" to the name)
progress_set
progress_get
progress_add1
progress_reset
progress_reset_all



globals:
those are all set by the tree_init opcode (you don't need to deal with this)

gi_NumOfNodes      number of nodes (2d array rows) in the current tree
gi_ValuesPerNode   number of variables for storing info in a node (pitch, amp, etc)
gi_NodeLength      length of the entire node (values + 1 root index + branches)
gk_Tree[][]        2d array that is the representation of the tree
gk_NodeProgress[]  1d array where the progress of each node is stored (for node_climb)

the opcodes use those variables (and others derived from them) to work

iBranchesPerNode   = gi_NodeLength - (gi_ValuesPerNode + 1)
iRootIndex         = gi_ValuesPerNode
iBranchZero        = gi_ValuesPerNode + 1
*/



//TREE_INIT
;create and initialize the tree arrays
;syntax: tree_init iNumberOfNodes, iValusePerNode, iBranchesPerNode
;iNumberOfNodes: how many nodes the tree will have throughout performance
;iValusePerNode: number of variables available in each node for storing
;                note parameters (frequency, intensity, repetitions, etc)
;iBranchesPerNode: how many branches can a node have
;note: it's possible to reshape the tree at any point in time through an i-pass
;      instrument (p3=0) for example. keep in mind however that the tree is global,
;      so any change will affect any running instruments
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



//TREE_RESET
;reset connections and node values (doesn't reset progress)
;syntax: tree_reset_i/k
;i-pass
opcode tree_reset_i, 0, 0
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
;k-time
opcode tree_reset_k, 0, 0
ki = 0
while ki < gi_NumOfNodes do
    kj = 0
    while kj < gi_NodeLength do
        gk_Tree[ki][kj] = -1
        kj += 1
    od
    ki += 1
od
endop



//TREE_RESET_CONNECTIONS
;reset connections only, without changing node values or progress
;syntax: tree_reset_connections_i/k
;i-pass
opcode tree_reset_connections_i, 0, 0
ii = 0
while ii < gi_NumOfNodes do
    ij = gi_ValuesPerNode
    while ij < gi_NodeLength do
        gk_Tree[ii][ij] init -1
        ij += 1
    od
    ii += 1
od
endop
;k-time
opcode tree_reset_connections_k, 0, 0
ki = 0
while ki < gi_NumOfNodes do
    kj = gi_ValuesPerNode
    while kj < gi_NodeLength do
        gk_Tree[ki][kj] = -1
        kj += 1
    od
    ki += 1
od
endop



//NODE_VALID
;returns 1 if input number is a node in the allocated tree, 0 otherwise
;syntax: i/kFlag node_valid_i/k i/kNode
;i-pass
opcode node_valid_i, i, i
inode xin
iflag = 0
if inode > -1 && inode < gi_NumOfNodes then
    iflag = 1
endif
xout iflag
endop
;k-time
opcode node_valid_k, k, k
knode xin
kflag = 0
if knode > -1 && knode < gi_NumOfNodes then
    kflag = 1
endif
xout kflag
endop



//NODE_SET_VALUE
;write input value to node at index (in k-time)
;will write only to node values, never changing connections
;syntax: node_set_value_i/k i/kNode, i/kNdx, i/kInput
;init pass version
opcode node_set_value_i, 0, iii
inode, indx, iin xin
if node_valid_i(inode) == 1 && indx < gi_ValuesPerNode then
    gk_Tree[inode][indx] init iin
endif
endop
;k-time
opcode node_set_value_k, 0, kkk
knode, kndx, kin xin
if node_valid_k(knode) == 1 && kndx < gi_ValuesPerNode then
    gk_Tree[knode][kndx] = kin
endif
endop
;array of input values
;writes elements of input array or number of value slots in a node (whichever's shorter)
;syntax: node_set_value_i/k i/kNode, i/kValues[]
;init pass version
opcode node_set_value_i, 0, ii[]
inode, iin[] xin
if node_valid_i(inode) == 1 then
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
if node_valid_k(knode) == 1 then
    kcnt = 0
    while kcnt < min(lenarray(kin), gi_ValuesPerNode) do
        gk_Tree[knode][kcnt] = kin[kcnt]
        kcnt += 1
    od
endif
endop



//NODE_GET_VALUE
;outputs value from index of node
;will output only from a valid node and a value index (0 otherwise)
;syntax: i/kOut node_get_value_i/k i/kNode, i/kNdx
;i-pass
opcode node_get_value_i, i, ii
inode, indx xin
iout = 0
if node_valid_i(inode) == 1 && indx < gi_ValuesPerNode then
    iout = i(gk_Tree, inode, indx)
endif
xout iout
endop
;k-time
opcode node_get_value_k, k, kk
knode, kndx xin
kout = 0
if node_valid_k(knode) == 1 && kndx < gi_ValuesPerNode then
    kout = gk_Tree[knode][kndx]
endif
xout kout
endop
;array output of all values version
;syntax: i/kValues[] node_get_value_i/k i/kNode
;i-pass
opcode node_get_value_i, i[], i
inode xin
iout[] init gi_ValuesPerNode
if node_valid_i(inode) == 1 then
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
if node_valid_k(knode) == 1 then
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
if node_valid_i(inode) == 1 then
    gk_Tree[inode][iRootIndex] init iroot
endif
endop
;k-time
opcode node_set_root_k, 0, kk
knode, kroot xin
iRootIndex = gi_ValuesPerNode
if node_valid_k(knode) == 1 then
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
    if node_valid_i(inode[icnt]) == 1 then
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
    if node_valid_k(knode[kcnt]) == 1 then
        gk_Tree[knode[kcnt]][iRootIndex] = kroot
    endif
    kcnt += 1
od
endop



//NODE_SET_BRANCH
;sets nth branch of node to given value (doesn't check if branch is valid node)
;syntax: node_set_branch_i/k i/kNode, i/kBranch, i/kN
;i-pass
opcode node_set_branch_i, 0, iii
inode, ibranch, ix xin
iRootIndex = gi_ValuesPerNode
ix += iRootIndex+1
if node_valid_i(inode) == 1 && ix > iRootIndex && ix < gi_NodeLength then
    gk_Tree[inode][ix] init ibranch
endif
endop
;k-time
opcode node_set_branch_k, 0, kkk
knode, kbranch, kn xin
iRootIndex = gi_ValuesPerNode
kn += iRootIndex+1
if node_valid_k(knode) == 1 && kn > iRootIndex && kn < gi_NodeLength then
    gk_Tree[knode][kn] = kbranch
endif
endop
;array of input branches
;writes elements of input array or number of branches in a node (whichever's shorter)
;(doesn't check if branches are valid nodes)
;syntax: node_set_branch_i/k i/kNode, i/kBranches[]
;i-pass
opcode node_set_branch_i, 0, ii[]
inode, iin[] xin
iBranchesPerNode = gi_NodeLength - (gi_ValuesPerNode + 1)
ioffset = gi_ValuesPerNode+1
if node_valid_i(inode) == 1 then
    icnt = 0
    while icnt < min(lenarray(iin), iBranchesPerNode) do
        gk_Tree[inode][icnt+ioffset] init iin[icnt]
        icnt += 1
    od
endif
endop
;k-time
opcode node_set_branch_k, 0, kk[]
knode, kin[] xin
iBranchesPerNode = gi_NodeLength - (gi_ValuesPerNode + 1)
ioffset = gi_ValuesPerNode+1
if node_valid_k(knode) == 1 then
    kcnt = 0
    while kcnt < min(lenarray(kin), iBranchesPerNode) do
        gk_Tree[knode][kcnt+ioffset] = kin[kcnt]
        kcnt += 1
    od
endif
endop



//NODE_CLEAR_ROOT
;sets the root of input node to -1 (no root node)
;syntax: node_clear_root_i/k i/kNode
;i-pass
opcode node_clear_root_i, 0, i
inode xin
iRootIndex = gi_ValuesPerNode
if node_valid_i(inode) == 1 then
    gk_Tree[inode][iRootIndex] init -1
endif
endop
;k-time
opcode node_clear_root_k, 0, k
knode xin
iRootIndex = gi_ValuesPerNode
if node_valid_k(knode) == 1 then
    gk_Tree[knode][iRootIndex] = -1
endif
endop



//NODE_CLEAR_BRANCHES
;sets all branches of input node to -1 (no branches)
;syntax: node_clear_branches_i/k i/kNode
;i-pass
opcode node_clear_branches_i, 0, i
inode xin
iBranchZero = gi_ValuesPerNode+1 ;index after root
if node_valid_i(inode) == 1 then
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
if node_valid_k(knode) == 1 then
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
;copies node values, root, and branches
;a node having the same branch/root nodes as another doean't cause any problems.
;this doesn't cause a connection, only a node with parameters.
;(dst will have src's branches, but those branches still have src as their root)
;if you wanna connect those branches to this new root you'd still have to do connect.
;also this can be used to make different nodes mirror each other.
;syntax: node_copy_i/k i/kSrc, i/kDst
;i-pass
opcode node_copy_i, 0, ii
isrc, idst xin
if node_valid_i(isrc) == 1 && node_valid_i(idst) == 1 then
    icnt = 0
    while icnt < gi_NodeLength do
        gk_Tree[idst][icnt] init i(gk_Tree, isrc, icnt)
        icnt += 1
    od
endif
endop
;k-time
opcode node_copy_k, 0, kk
ksrc, kdst xin
if node_valid_k(ksrc) == 1 && node_valid_k(kdst) == 1 then
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
if node_valid_i(iroot) == 1 && node_valid_i(ibranch) == 1 then
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
if node_valid_k(kroot) == 1 && node_valid_k(kbranch) == 1 then
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
;connects as many branches as there are  empty  spaces
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
if node_valid_i(iroot) == 1 && node_valid_i(ibranch) == 1 &&
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
if node_valid_k(kroot) == 1 && node_valid_k(kbranch) == 1 &&
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
if node_valid_i(inode) == 1 && ix > iRootIndex && ix < gi_NodeLength then
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
if node_valid_k(knode) == 1 && kn > iRootIndex && kn < gi_NodeLength then
    kbranch = gk_Tree[knode][kn]
endif
xout kbranch
endop
;array output of all branches of a node
;syntax: i/kBranches[] node_get_branch_i/k i/kNode
;i-pass
opcode node_get_branch_i, i[], i
inode xin
iRootIndex = gi_ValuesPerNode
iBranchesPerNode = gi_NodeLength - (gi_ValuesPerNode + 1)
iBranchZero = iRootIndex+1
iout[] init iBranchesPerNode
if node_valid_i(inode) == 1 then
    icnt = 0
    while icnt < iBranchesPerNode do
        iout[icnt] = i(gk_Tree, inode, icnt+iBranchZero)
        icnt += 1
    od
endif
xout iout
endop
;k-time
opcode node_get_branch_k, k[], k
knode xin
iRootIndex = gi_ValuesPerNode
iBranchesPerNode = gi_NodeLength - (gi_ValuesPerNode + 1)
iBranchZero = iRootIndex+1
kout[] init iBranchesPerNode
if node_valid_k(knode) == 1 then
    kout = slicearray(getrow(gk_Tree, knode), iBranchZero, gi_NodeLength-1)
endif
xout kout
endop



//NODE_GET_ROOT
;get root of node
;syntax: i/kRoot node_get_root_i/k i/kNode
;i-pass
opcode node_get_root_i, i, i
inode xin
iRootIndex = gi_ValuesPerNode
iroot init -1
if node_valid_i(inode) == 1 then
    iroot = i(gk_Tree, inode, iRootIndex)
endif
xout iroot
endop
;k-time
opcode node_get_root_k, k, k
knode xin
iRootIndex = gi_ValuesPerNode
kroot init -1
if node_valid_k(knode) == 1 then
    kroot = gk_Tree[knode][iRootIndex]
endif
xout kroot
endop



//NODE_HAS_BRANCH
;returns 1 when input node has a branch at index, 0 otherwise
;syntax: i/kFlag node_has_branch_i/k i/kNode, i/kNdx
;i-pass
opcode node_has_branch_i, i, ii
inode, indx xin
iflag = 0
if node_get_branch_i(inode, indx) != -1 then
    iflag = 1
endif
xout iflag
endop
;k-time
opcode node_has_branch_k, k, kk
knode, kndx xin
kflag = 0
if node_get_branch_k(knode, kndx) != -1 then
    kflag = 1
endif
xout kflag
endop



//NODE_HAS_ROOT
;returns 1 when input node has a root, 0 otherwise
;syntax: i/kFlag node_has_root_i/k i/kNode
;i-pass
opcode node_has_root_i, i, i
inode xin
iflag = 0
if node_get_root_i(inode) != -1 then
    iflag = 1
endif
xout iflag
endop
;k-time
opcode node_has_root_k, k, k
knode xin
kflag = 0
if node_get_root_k(knode) != -1 then
    kflag = 1
endif
xout kflag
endop



//NODE_ISOLATED
;returns 1 when input node has no connections (branches or root), 0 otherwise
;syntax: i/kFlag node_isolated_i/k i/kNode
;i-pass
opcode node_isolated_i, i, i
inode xin
iflag = 1
if node_valid_i(inode) == 1 then
    icnt = gi_ValuesPerNode
    while icnt < gi_NodeLength do
        if i(gk_Tree, inode, icnt) != -1 then
            iflag = 0
            goto break
        endif
        icnt += 1
    od
    break:
endif
xout iflag
endop
;k-time
opcode node_isolated_k, k, k
knode xin
kflag = 1
if node_valid_k(knode) == 1 then
    kcnt = gi_ValuesPerNode
    while kcnt < gi_NodeLength do
        if gk_Tree[knode][kcnt] != -1 then
            kflag = 0
            goto break
        endif
        kcnt += 1
    od
    break:
endif
xout kflag
endop



;progress ops-------------------------------------

;i-pass
;reset node's progress to -1
;syntax: progress_reset_i iNode
opcode progress_reset_i, 0, i
inode xin
if node_valid_i(inode) == 1 then
    gk_NodeProgress[inode] init -1
endif
endop

;reset entire array
;syntax: progress_reset_all_i
opcode progress_reset_all_i, 0, 0
icnt = 0
while icnt < lenarray(gk_NodeProgress) do
    gk_NodeProgress[icnt] init -1
od
endop

;get progress of node
;syntax: iProgress progress_get_i kNode
opcode progress_get_i, i, i
inode xin
iout init -1
if node_valid_i(inode) == 1 then
    iout = i(gk_NodeProgress, inode)
endif
xout iout
endop

;set progress of node to n
;syntax: progress_set_i iNode, iN
opcode progress_set_i, 0, ii
inode, ix xin
if node_valid_i(inode) == 1 then
    gk_NodeProgress[inode] init ix
endif
endop

;add 1 to progress of node
;syntax: progress_add1_i iNode
opcode progress_add1_i, 0, i
inode xin
if node_valid_i(inode) == 1 then
    gk_NodeProgress[inode] init i(gk_NodeProgress, inode) + 1
endif
endop


;k-time
;reset node's progress to -1
;syntax: progress_reset kNode
opcode progress_reset, 0, k
knode xin
if node_valid_k(knode) == 1 then
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
if node_valid_k(knode) == 1 then
    kout = gk_NodeProgress[knode]
endif
xout kout
endop

;set progress of node to n
;syntax: progress_set kNode, kN
opcode progress_set, 0, kk
knode, kn xin
if node_valid_k(knode) == 1 then
    gk_NodeProgress[knode] = kn
endif
endop

;add 1 to progress of node (every k-cycle)
;syntax: progress_add1 kNode
opcode progress_add1, 0, k
knode xin
if node_valid_k(knode) == 1 then
    gk_NodeProgress[knode] = gk_NodeProgress[knode] + 1
endif
endop

;----------------------------------------------



//CLIMB OPS

;climbs a node, its branches one by one, passing by their branches, and so on
;from the example at the top, with 0 as input, every k-cycle the progress will be:
;0, 1, 4, 5, 2, 6, 7, 3, 0,...
;syntax: kCurrentNode node_climb kNode [, kReset]
;reset only reassigns the current node to input node when non-zero
opcode node_climb, k, kO
knode, kreset xin
koutnode init i(knode)
if kreset != 0 then
    koutnode = knode
endif
if node_valid_k(koutnode) == 1 && node_isolated_k(koutnode) == 0 then
    if node_has_branch_k(koutnode, progress_get(koutnode)) == 1 then
        koutnode = node_get_branch_k(koutnode, progress_get(koutnode))
    elseif progress_get(koutnode) > -1 then
        until node_has_branch_k(koutnode, progress_get(koutnode)) == 1 do
            progress_reset(koutnode)
            if node_has_root_k(koutnode) == 1 && koutnode != knode then
                koutnode = node_get_root_k(koutnode)
            endif
            progress_add1(koutnode)
        od
        if !(koutnode == knode && progress_get(knode) == 0) then
            koutnode = node_get_branch_k(koutnode, progress_get(koutnode))
        endif
    endif
    if !(koutnode == knode && progress_get(knode) == 0) then
        progress_add1(koutnode)
    endif
endif
xout koutnode
endop



;play root after every branch (no branch-to-branch hopping)
;from same example, progress is: 0,1,4,1,5,1,0,2,6,7,6,2,0,3,0...
;syntax: kCurrentNode node_climb2 kNode [, kReset]
;reset only reassigns the current node to input node when non-zero
opcode node_climb2, k, kO
knode, kreset xin
koutnode init i(knode)
if kreset != 0 then
    koutnode = knode
endif
if node_valid_k(koutnode) == 1 && node_isolated_k(koutnode) == 0 then
    if node_has_branch_k(koutnode, progress_get(koutnode)) == 1 then
        koutnode = node_get_branch_k(koutnode, progress_get(koutnode))
    else
        progress_reset(koutnode)
        if koutnode != knode then
            koutnode = node_get_root_k(koutnode)
        endif
    endif
    if node_has_branch_k(koutnode, progress_get(koutnode)+1) == 0 &&
        koutnode == knode then ;at last branch of input node
        progress_reset(koutnode)
    endif
    progress_add1(koutnode)
endif
xout koutnode
endop



;same as node_climb but uses local progress, so every call is independent
;syntax: kCurrentNode node_climb3 kNode [, kReset] [, kResetNodeProgress] [, kResetAllProgress]

;(all three resets default to 0)
;kReset: when non-zero, sets the current node to input node, since this
;        is assigned only at i-pass (changing input node needs this to take effect)
;kResetNodeProgress: reset internal progress counter for the current node only
;kResetAllProgress: reset entire progress array

;Note: i think there are cases where mixing and matching resets can
;cause weird (bad) things like getting stuck in a loop (crashing csound),
;i havent's tested this stuff, maybe i should have just one reset?
opcode node_climb3, k, kOOO
knode, kreset, kresetnode, kresetall xin
koutnode init i(knode)

;alloc progress array and init to -1
kp[] init gi_NumOfNodes
icnt = 0
while icnt < gi_NumOfNodes do
    kp[icnt] = -1
    icnt += 1
od

;resets
if kreset != 0 then
    koutnode = knode
endif
if kresetnode != 0 then
    kp[koutnode] = -1
endif
if kresetall != 0 then
    kp = -1
endif

if node_valid_k(koutnode) == 1 && node_isolated_k(koutnode) == 0 then
    if node_has_branch_k(koutnode, kp[koutnode]) == 1 then
        koutnode = node_get_branch_k(koutnode, kp[koutnode])
    elseif kp[koutnode] > -1 then
        until node_has_branch_k(koutnode, kp[koutnode]) == 1 do
            kp[koutnode] = -1 ;reset node progress
            if node_has_root_k(koutnode) == 1 && koutnode != knode then
                koutnode = node_get_root_k(koutnode)
            endif
            kp[koutnode] = kp[koutnode] + 1
        od
        if !(koutnode == knode && kp[knode] == 0) then
            koutnode = node_get_branch_k(koutnode, kp[koutnode])
        endif
    endif
    if !(koutnode == knode && kp[knode] == 0) then
        kp[koutnode] = kp[koutnode] + 1
    endif
endif
xout koutnode
endop



;same as node_climb2 but uses local progress
;syntax: kCurrentNode node_climb4 kNode [, kReset] [, kResetNodeProgress] [, kResetAllProgress]

;(all three resets default to 0)
;kReset: when non-zero, sets the current node to input node, since this
;        is assigned only at i-pass (changing input node needs this to take effect)
;kResetNodeProgress: reset internal progress counter for the current node only
;kResetAllProgress: reset entire progress array

;note above doean't apply here i think? (you know by now how much you can trust me)
opcode node_climb4, k, kOOO
knode, kreset, kresetnode, kresetall xin
koutnode init i(knode)

;alloc progress array and init to -1
kp[] init gi_NumOfNodes
icnt = 0
while icnt < gi_NumOfNodes do
    kp[icnt] = -1
    icnt += 1
od

;resets
if kreset != 0 then
    koutnode = knode
endif
if kresetnode != 0 then
    kp[koutnode] = -1
endif
if kresetall != 0 then
    kp = -1
endif

if node_valid_k(koutnode) == 1 && node_isolated_k(koutnode) == 0 then
    if node_has_branch_k(koutnode, kp[koutnode]) == 1 then
        koutnode = node_get_branch_k(koutnode, kp[koutnode])
    else
        kp[koutnode] = -1
        if koutnode != knode then
            koutnode = node_get_root_k(koutnode)
        endif
    endif
    if node_has_branch_k(koutnode, kp[koutnode]+1) == 0 &&
        koutnode == knode then ;at last branch of input node
        kp[koutnode] = -1
    endif
    kp[koutnode] = kp[koutnode] + 1
endif
xout koutnode
endop



;testing
opcode node_climb5, k, kO
knode, kreset xin
if node_has_branch_k(knode, progress_get(knode)) == 1 then
                ;lmao v (interesting!)
    knode = node_climb3(node_get_branch_k(knode, progress_get(knode)))
elseif progress_get(knode) != -1 then
    progress_reset(knode)
endif
progress_add1(knode)
xout knode
endop



;maybe i should change all those chacks against -1? some evil soul (me) might use
;smaller negative numbers for branch/root values for whatever twisted reason
;and then shit gonna blow up in her face!
;it's like, to do or not to do! like i feel if i use custom weird shit, i'll be
;checking manually for those values?
;but still, branch -2 isn't a branch and has-branch shouldn't say it is...


;drunk_climb?
;what kinda drunk do you want here?
;up-down kind of random walk? or probability of brabches?
;this can be a whole box of cookies!

;can you make a tree draw opcode? it'd be nice

;storing the repetition value in each node, with some patching to the trigger
;pass the trigger directly, but pass a divided version to the sequencer (on the 0)
;don't need a reset-node to do this.

;a node can have multiple values, you can store chord progressions
;in one tree (bunch of connected nodes) and climb that, and store melodies
;in another tree, and climb that separately

;values can be instr numbers and p-fields


;jam as irresponsibly as you possibly can

