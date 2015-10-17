# ERIK KAASILA
# WRITTEN ON 10/08/2014

.globl main
.data
   .align 5
   #  char * data[] = {"Joe", "Jenny", "Jill", "John", "Jeff", "Joyce",
   #		"Jerry", "Janice", "Jake", "Jonna", "Jack", "Jocelyn",
   #		"Jessie", "Jess", "Janet", "Jane"};
   array:
      .asciiz "Joe"
      .align 5
      .asciiz "Jenny"
      .align 5
      .asciiz "Jill"
      .align 5
      .asciiz "John"
      .align 5
      .asciiz "Jeff"
      .align 5
      .asciiz "Joyce"
      .align 5
      .asciiz "Jerry"
      .align 5
      .asciiz "Janice"
      .align 5
      .asciiz "Jake"
      .align 5
      .asciiz "Jonna"
      .align 5
      .asciiz "Jack"
      .align 5
      .asciiz "Jocelyn"
      .align 5
      .asciiz "Jessie"
      .align 5
      .asciiz "Jess"
      .align 5
      .asciiz "Janet"
      .align 5
      .asciiz "Jane"
      .align 5


   init_message:
      .asciiz "Initial array is:\n"
   term_message:
      .asciiz "\nInsertion sort is finished!\n"
   lbracket:
      .asciiz "["
   rbracket:
      .asciiz "]"
   space:
      .asciiz " "

   .align 2

   # int size = 16;
   size: .word 16

   .align 2
   data: .space 64

.text
# int main(void) {
   main:
      # printf("Initial array is:\n");
      li $v0, 4
      la $a0, init_message
      syscall
      li $s6, 1
      lw $a1, size
      jal create_pointer_array
      lw $a1, size

      # print_array(data, size);
      jal print_array

      # insertSort(data, size);
      jal insertion_sort

      #  printf("Insertion sort is finished!\n");
      li $v0, 4
      la $a0, term_message
      syscall
      lw $a1, size
      jal print_array
      li $v0, 10
      syscall
   # }

   # create the pointer array for sorting
   #   char * data[] = {"Joe", "Jenny", "Jill", "John", "Jeff", "Joyce",
   #		"Jerry", "Janice", "Jake", "Jonna", "Jack", "Jocelyn",
   #		"Jessie", "Jess", "Janet", "Jane"};
   create_pointer_array:
      # Local variable for size of array
      lw $t2, size
      # Get the current element
      sub $t0, $t2, $a1
      # Used for data position
      addi $t3, $t0, 0
      mul $t3, $t3, 4
      # Load the multiplier
      li $t2, 32
      # Calculate the memory address
      mul $t0, $t0, $t2
      # Load the address
      la $t1, array($t0)
      # Store the address in the data array
      sw $t1, data($t3)
      # Decrement for loop
      addi $a1, $a1, -1
      # If still have more to go, keep looping
      bgt $a1, 0, create_pointer_array
      # Else, exit back to main
      jr $ra

   # void print_array(char * a[], const int size)
   print_array:
      # printf("[");
      li $v0, 4
      la $a0, lbracket
      syscall

      # printf(" ");
      la $a0, space
      syscall

      # while(i < size)
      loop:
      lw $t2, size

      # Get the current element
      sub $t0, $t2, $a1
      mul $t0, $t0, 4
      lw $t4, data($t0)

      # a[i]
      li $a0, 0
      add $a0, $a0, $t4
      syscall

      # printf("  %s");
      la $a0, space
      syscall

      # i--;     Decrement for loop
      addi $a1, $a1, -1
      bgt $a1, 0, loop

      # printf(" ]\n");     Else, exit back to main
      li $v0, 4
      la $a0, rbracket
      syscall
      jr $ra
    # }

   # int str_lt (char *x, char *y) {
   str_lt:
      move $t0, $a0
      move $t1, $a1

      # for (; *x!='\0' && *y!='\0';) {
      for_loop:
         lb $t2 0($t0)
         lb $t3 0($t1)

         # if ( *y < *x ) return 0;
         beq $t2, $zero return0

         # if ( *x < *y ) return 1;
         beq $t3, $zero return1

         # if ( *y == '\0' ) return 0;
         blt $t2, $t3, return0

         # else return 1;
         bgt $t2, $t3, return1

         # x++, y++;
         addi $t0, $t0, 1
         addi $t1, $t1,  1

         # Continue the for loop if we didn't meet any of our break conditions
         b for_loop

         # Return back to where we were
         jr $ra
       # }


   # return 0;
   return0:
      li $v0, 0
      jr $ra

   # return 1;
   return1:
      li $v0, 1
      jr $ra

   # void insertSort(char *a[], size_t length) {
   insertion_sort:
      # int i = 1;
      li $s0, 1

      # Store $ra for later
      la $s7, ($ra)

      # READ: outer_loop is a combination of the two for loops provided in the C code;
      #       the comments do not align exactly, but the outcome is the same.
      # for(i = 1; i < length;) {
      outer_loop:
         # int j = i-1;
         sub $s1, $s0, 1
         addi $s2, $s0, 0
         mul $s1, $s1 4
         mul $s2, $s2, 4

         # a[j]
         lw $a0, data($s1)

         # char *value = a[i];
         lw $a1, data ($s2)

         # char *value = a[i];
         jal str_lt

         # a[j+1] = a[j];
         # a[j+1] = value;
         beq $v0, 1, swap_items

         lw $s4, size

         # j++;     INNER loop counter
         addi $s0, $s0, 1

         # This is the end condition checker for the INNER LOOP
         blt $s0, $s4, outer_loop
         li $s0 1

         # i++;     This is a OUTER loop counter (represetative of i in the provided C code)
         addi $s6, $s6, 1

         # This is the end condition checker for the OUTER LOOP
         blt $s6, 16, outer_loop
     jr $s7

     # a[j+1] = a[j];
     # a[j+1] = value;
     swap_items:
        sw $a1, data($s1)
        sw $a0, data($s2)
        li $v0, 0
        jr $ra
