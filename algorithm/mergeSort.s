addi a0, x0, 0
addi t0, x0, 1024
slli t0, t0, 2
add a1, a0, t0
addi sp, x0, 1100
slli sp, sp, 2
jal ra, mergesort
jal x0, over

mergesort:

   # Stack management
   addi sp, sp, -16              # Adjust stack pointer
   sw ra, 0(sp)                  # Load return address
   sw a0, 4(sp)                  # Load first element address
   sw a1, 8(sp)                 # Load last element address

   
   # Base case
   li t1, 4                      # Size of one element
   sub t0, a1, a0                # Calculate number of elements
   ble t0, t1, mergesort_end     # If only one element remains in the array, return

   srli  t0, t0, 1               # Divide array size to get half of the element
   add a1, a0, t0                # Calculate array midpoint address
   sw a1, 12(sp)                 # Store it on the stack

   jal mergesort                 # Recursive call on first half of the array

   lw a0, 12(sp)                 # Load midpoint back from the stack
   lw a1, 8(sp)                 # Load last element address back from the stack

   jal mergesort                 # Recursive call on second half of the array

   lw a0, 4(sp)                  # Load first element address back from the stack
   lw a1, 12(sp)                 # Load midpoint address back form the stack
   lw a2, 8(sp)                 # Load last element address back from the stack

   jal merge                     # Merge two sorted sub-arrays

mergesort_end:
   lw ra, 0(sp)
   addi sp, sp, 16
   ret

##
# Merge(*testArray, first, midpoint, last)
# param a0 -> first address of first array   
# param a1 -> first address of second array
# param a2 -> last address of second array
##
merge:

   # Stack management
   addi sp, sp, -16              # Adjust stack pointer
   sw ra, 0(sp)                  # Load return address
   sw a0, 4(sp)                  # Load first element of first array address
   sw a1, 8(sp)                 # Load first element of second array address
   sw a2, 12(sp)                 # Load last element of second array address

   mv s0, a0                     # First half address copy 
   mv s1, a1                     # Second half address copy

   merge_loop:

      mv t0, s0                  # copy first half position address
      mv t1, s1                  # copy second half position address
      lw t0, 0(t0)               # Load first half position value
      lw t1, 0(t1)               # Load second half position value   

      bgt t1, t0, shift_skip     # If lower value is first, no need to perform operations

      mv a0, s1                  # a0 -> element to move
      mv a1, s0                  # a1 -> address to move it to
      jal shift                  # jump to shift 
      
      addi s1, s1, 4

      shift_skip: 

            addi s0, s0, 4          # Increment first half index and point to the next element
            lw a2, 12(sp)           # Load back last element address

            bge s0, a2, merge_loop_end
            bge s1, a2, merge_loop_end
            beq x0, x0, merge_loop

      ##
      # Shift array element to a lower address
      # param a0 -> address of element to shift
      # param a1 -> address of where to move a0
      ##
      shift:

         ble a0, a1, shift_end      # Location reached, stop shifting
         addi t3, a0, -4            # Go to the previous element in the array
         lw t4, 0(a0)               # Get current element pointer
         lw t5, 0(t3)               # Get previous element pointer
         sb t4, 0(t3)               # Copy current element pointer to previous element address
         sb t5, 0(a0)               # Copy previous element pointer to current element address
         mv a0, t3                  # Shift current position back
         beq x0, x0, shift          # Loop again

      shift_end:

         ret

   merge_loop_end:

      lw ra, 0(sp)
      addi sp, sp, 16
      ret
over: