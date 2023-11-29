.data
.text
.globl echo

echo:

    pushl %ebp                
    movl %esp, %ebp          # set up the stack 
    push %ebx                # push ebx register on the stack 

    movl  8(%ebp), %edx      # put the port address in the edx register 
    movb  12(%ebp), %bl      # put the escape character into the bl register


   

    # read data ready 
    # if ready, read a byte from received data

        loop2:

        movl  8(%ebp), %edx     #saves the comport adress in edx
        addl $5, %edx           # line status
        
        inb (%dx), %al          # get data ready
        andb $0x01, %al         # look at dr
        jz loop2                # if zero, jump to loop 2: wait till u get input.


        movl  8(%ebp), %edx     # reset edx to the base address 
        inb (%dx), %al          # move rx to %al

        movb %al, %cl           # save it in cl

        cmpb %bl, %cl           # compare with escape character
        je return               # if equal, jump to return 

        movl  8(%ebp), %edx     # reset edx to comport address 
        addl $5, %edx           # line status
       

    # read THRE, if empty, write a byte to transmit data

        transmit:
        inb (%dx), %al      # get thre
        andb $0x20, %al     # look at thre
        jz loop2            # if tx hr empty 
        movb %cl, %al       # get data

        movl  8(%ebp), %edx      # reset edx to i/o data addr

        outb %al, (%dx)     # send it
        jmp loop2           # loop2
  

                                   
    return:
    popl %ebx         # pop ebx register
    movl %ebp, %esp   # close the stack
    popl %ebp
    ret
    .end
