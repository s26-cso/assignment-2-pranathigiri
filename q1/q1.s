# sturct node layout:
#    offset 0 ->val
#    offset 8 ->left
#    offset 16->right

.section .text

.global make_node
.global insert
.global get
.global getAtMost

make_node:
   
   addi sp,sp,-16
   sd ra,8(sp)
   sd s0,0(sp)

   mv s0,a0 # saving the val

   li a0,24       # used malloc(24)
   call malloc    

   sw s0,0(a0)  # node->val=valeq sd x0,inser_null
   
   sd x0,8(a0) # node->left=NULLeq sd x0,inser_null
   
   sd x0,16(a0) # node->right=NULL

   ld ra,8(sp)
   ld s0,0(sp)
   addi sp,sp,16
   ret

insert:
     addi sp,sp,-32
     sd ra,24(sp)
     sd s0,16(sp)
     sd s1,8(sp)

     mv s0,a0   # s0=root
     mv s1,a1   # s1=val

     beq s0,x0,insert_null

     lw t0,0(s0) # t0=root->val
     beq s1,t0,insert_return
     blt s1,t0,insert_left
     
     # val>root->val (root=root->right)
     ld a0,16(s0)  
     mv a1,s1
     call insert
     sd a0,16(s0)  # root->right=result
     j insert_return

insert_null:
   
   # root==NULL (call makenode(val) and return )
   mv a0,s1
   call make_node
   j insert_done

insert_left:
   
   ld a0,8(s0)
   mv a1,s1
   call insert
   sd a0,8(s0)  # root->left=result

insert_return:
   
   mv a0,s0

insert_done:
   
   ld ra,24(sp)
   ld s0,16(sp)
   ld s1,8(sp)
   addi sp,sp,32
   ret

get:
  
  beq a0,x0,get_done   # if NULL return

  lw t0,0(a0)
  beq a1,t0,get_done   # if node found return

  blt a1,t0,get_left   # if val < root->val go left

  ld a0,16(a0)          # else go right

  j get    

get_left:

    ld a0,8(a0)    # go left
    j get

get_done:
   ret

getAtMost:
   
   addi sp,sp,-32
   sd ra,24(sp)
   sd s0,16(sp)
   sd s1,8(sp)
   sd s2,0(sp)

   mv s0,a0   # s0=val

   mv s1,a1   # s1=current node
   li s2,-1   # s2=best possible answer

loop:
    
    beq s1,x0,getAtMost_done

    lw t0,0(s1)  # t0=node->val

    bgt t0,s0,getAtMost_left    # node->val > val go left

    mv s2,t0
    ld s1,16(s1)       # node->val< val so go right
    j loop

getAtMost_left:
   
   ld s1,8(s1)
   j loop

getAtMost_done:
  
  mv a0,s2

  ld ra,24(sp)
  ld s0,16(sp)
  ld s1,8(sp)
  ld s2,0(sp)
  addi sp,sp,32
  ret
