# nextgreater element on right of a element

.section .data

fmt: .string "%d "
fmt_last: .string "%d\n"

.section .text
.global main

main:
   addi sp,sp,-80      # allocating 64 bytes on stack
   sd ra,72(sp)
   sd s0,64(sp)
   sd s1,56(sp)
   sd s2,48(sp)
   sd s3,40(sp)
   sd s4,32(sp)
   sd s5,24(sp)
   sd s6,16(sp)
   sd s7,8(sp)

   mv s0,a0       #  move number of arguments into s0 (it includes ./a.out)
   mv s1,a1       # move address of arguments into s1

   addi s2,s0,-1    # s2=n  

   slli a0,s2,3
   call malloc
   mv s3,a0         # s3=result[]

   li t0,0       # i=0

# initializing result[] to -1

initialize_loop:
   
   bge t0,s2,initialize_done    # if i>=n exit
   li t1,-1                     # t1=-1
   slli t2,t0,3                 # t2=i*8
   add t2,s3,t2                 # t2=result+t2   (address of result)
   sd t1,0(t2)                  # result[i]=-1
   addi t0,t0,1                 # i++
   j initialize_loop     

initialize_done:
  
   slli a0,s2,3   
   call malloc
   mv s4,a0          # s4=array[]

   li t0,0           # i=0

stringtoint_loop:
   
   bge t0,s2,stringtoint_done     # if i>=n exit

   slli t1,t0,3           # t1=i*8
   addi t1,t1,8
   add t1,s1,t1
   ld a0,0(t1)
   call atoi             # int num=atoi(str)

   slli t1,t0,3
   add t1,s4,t1           # arr[i]=num
   sd a0,0(t1)

   addi t0,t0,1     # i++
   j stringtoint_loop 

stringtoint_done:

   slli a0,s2,3    # malloc stack: n*8 bytes
   call malloc
   mv s5,a0       # s5=stack
   li s6,-1       # s6=stack top 

   addi t0,s2,-1    # t0=i

# running loop from n-1 to 0

loop:
   blt t0,x0,done         # if i<0 exit

while_loop:
   
   blt s6,x0,while_done   # if stack empty exit
   slli t1,s6,3
   add t1,s5,t1
   ld t2,0(t1)           # t2=stack.(top) index
   slli t3,t2,3
   add t3,s4,t3
   ld t3,0(t3)           # t3=arr[stack.top()]
   slli t4,t0,3
   add t4,s4,t4
   ld t4,0(t4)         # t4=arr[i]
   bgt t3,t4,while_done

   addi s6,s6,-1   # pop
   j while_loop

while_done:
  
  blt s6,x0,skip       # if(stack.empty()) skip
  slli t1,s6,3
  add t1,s5,t1
  ld t2,0(t1)         # int top=stack.top()
  slli t3,t0,3
  add t3,s3,t3
  sd t2,0(t3)         # result[i]=top

skip:
    
    addi s6,s6,1      # top++
    slli t1,s6,3
    add t1,s5,t1
    sd t0,0(t1)      # stack[top]=i

    addi t0,t0,-1   # i--
    j loop

done:
   
    li s7,0    # i=0

print:
   
   bge s7,s2,print_done    # if  i>n end

   slli t1,s7,3      # t1=i*8
   add t1,s3,t1     # t1=address of result[i]
   ld a1,0(t1)        # a1=result[i]

   addi t2,s2,-1
   beq s7,t2,last_element

    la a0,fmt
    j print_it

last_element:

    la a0,fmt_last

print_it:

   call printf
   addi s7,s7,1 # i++
   j print

print_done:
    
   li a0,0
   ld ra,72(sp)
   ld s0,64(sp)
   ld s1,56(sp)
   ld s2,48(sp)
   ld s3,40(sp)
   ld s4,32(sp)
   ld s5,24(sp)
   ld s6,16(sp)
   ld s7,8(sp)  
   addi sp,sp,80
   ret
