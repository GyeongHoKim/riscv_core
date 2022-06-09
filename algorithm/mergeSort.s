#initialization
# init sp
addi x31, x0, 2000
slli x31, x31, 2
# init return addr
addi x1, x0, 0
# init array start
addi x2, x0, 0
# init array end, x29
addi x29, x0, 999
slli x29, x29, 2
mv x3, x29
# init array mid
add x4, x2, x3
srli x4, x4, 1
#init sorted start, x30
addi x30, x0, 1000
slli x30, x30, 2

addi x28, x0, 1024
slli x28, x28, 3

#Divide
mergeSort:
sw x1, 0(x31)
sw x2, 4(x31) # we will use x2 as start addr
sw x3, 8(x31) # we will use x3 as end addr
sw x4, 12(x31) # we will use x4 as mid addr
addi x31, x31, 16

bge x2, x3, return # return when element remains only one
add x4, x2, x3 # calculate middle addr
srli x4, x4, 1
mv x3, x4
jal x1, mergeSort

lw x3, 8(x31)
lw x4, 12(x31)
addi x31, x31, -16

addi x2, x4, 4
jal x1, mergeSort

jal x0, merge

return:
bne x31, x28, return1 # x28 is the end of the ram + 16.
addi x31, x31, -16
return1:
lw x1, 0(x31)
addi x31, x31, -16
jalr x0, x1, 0

#Conquer
merge:
lw x2, 4(x31)
lw x3, 8(x31)
lw x4, 12(x31)

mv x6, x2 # i
mv x7, x4 # j
addi x7, x7, 4
mv x8, x2 # k
mv x9, x2 # t

loop:
lw x10, 0(x6)
lw x11, 0(x7)

bgt x6, x4, over
bgt x7, x3, over

blt x10, x11, smalli

add x12, x30, x8
sw x11, 0(x12)
addi x8, x8, 4
addi x7, x7, 4

smalli:
add x12, x30, x8
sw x10, 0(x12)
addi x8, x8, 4
addi x6, x6, 4
jal x0, loop

over:
bgt x6, x4, over2 # first while loop
add x12, x30, x8
sw x10, 0(x12)
addi x8, x8, 4
addi x6, x6, 4
jal x0, over

over2:
bgt x7, x3, over3
add x12, x30, x8
sw x11, 0(x12)
addi x8, x8, 4
addi x7, x7, 4
jal x0, over2

over3:
bgt x9, x3, end
add x12, x30, x9
lw x13, 0(x12)
sw x13 0(x9)
addi x9, x9, 4
jal x0, over3

end:
bne x2, x0, return2
bne x4, x29, return2
addi x1, x0 400

return2:
lw x1, 0(x31)
addi x31, x31, -16
jalr x0, x1, 0