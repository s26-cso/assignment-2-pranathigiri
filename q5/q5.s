.section .data
file: .string "input.txt"
mode: .string "r"
true: .string "Yes\n"
false: .string "No\n"

.section .text
.global main

main:
   addi sp,sp,-48
   sd ra,40(sp)     # saves return address
   sd s0,32(sp)     # s0=forward file pointer
   sd s1,24(sp)     # s1=backward file pointer 
   sd s2,16(sp)     # s2=left index
   sd s3,8(sp)      # s3=right index
  
   # forward pointer

   la a0,file      # load filename
   la a1,mode      # load mode
   call fopen      # open file
   mv s0,a0        # store file in s0

   # backward pointer

   la a0,file
   la a1,mode
   call fopen
   mv s1,a0        # store file in s1 

   mv a0,s1     # file pointer 
   li a1,0      # offset=0
   li a2,2      # end
   call fseek   # fseek(s1,0,end)

   mv a0,s1
   call ftell    # current position of file
   mv s3,a0

   addi s3,s3,-1   # right=size-1

   li s2,0        # left=0

loop:
    
    bge s2,s3,TRUE    # if left>=right true

    # reading character from left

    mv a0,s0   
    mv a1,s2
    li a2,0
    call fseek      # move to left

    mv a0,s0
    call fgetc     # read single character
    mv t0,a0       # store in t0

    # reading character from right

    mv a0,s1
    mv a1,s3
    li a2,0
    call fseek     # move to right

    mv a0,s1
    call fgetc    # read single character
    mv t1,a0

    bne t0,t1,FALSE   # if left!=right end

    addi s2,s2,1      # left++
    addi s3,s3,-1     # right--
    j loop  

TRUE:

    mv a0,s0
    call fclose     # close forward file
    mv a0,s1
    call fclose     # close backward file
    la a0,true
    call printf
    j done


FALSE:

    mv a0,s0
    call fclose
    mv a0,s1
    call fclose
    la a0,false
    call printf
    j done

done: 
    
    li a0,0
    ld ra,40(sp)
    ld s0,32(sp)
    ld s1,24(sp)
    ld s2,16(sp)
    ld s3,8(sp) 
    addi sp,sp,48
    ret
