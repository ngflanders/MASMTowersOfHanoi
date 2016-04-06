; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
; Program Exercise 6
; Nick Flanders based on code from K. R. Johnson & Tom Fuller
; 	Algorithm based on Tanenbaum
; March 30, 2016
; Program executes the Towers of Hanoi algorithm demonstrating recursion.
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
    include \masm32\include\masm32rt.inc
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

.data
	str0	db	'Enter the number of disks: ',0
	str1	db 	'Move a disk from peg ', 0
	str2	db	' to peg ',0
	str3	db  'Repeat Program? Reply Y or N: ',0 
	str4	db	'Invalid response', 0
	; Storage for variables

	letter	dd	0
	cInp	db	3	dup(?)
	
	
.code
	include helper.inc

start:   
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

	cls
    call maine
    inkey
    exit

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
	towerProc proc
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
;	The following numbers assume that the stack pointer (esp) pointed to 
;	7000 before the first push was executed in the "maine" function.
;
;   Memory address      item stored     size
;   6998-6999					  3		2b j
;   6996-6997                	  1     2b i
;   6994-6995                 	  n     2b n
;   6990-6993        return address     4b
;
;   6958-6989           8 4b registers  32b
;
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
		pushad				; push *all* 8 general purpose registers onto the stack!
		mov 	ebp,esp		; we will use ebp as our base pointer to stack contents
		
		mov 	bx,[ebp+36] ; n

		cmp		bx, 1		; check n != 1
		jne recurse			
		
		print OFFSET str1	; print "Move a disk from peg "
		mov bx, [ebp+38]	; get i
		movsx ebx, bx
		print str$(ebx)
		
		print OFFSET str2	; print " to peg "
		mov bx, [ebp+40]	; get j
		movsx ebx, bx
		print str$(ebx), 13,10
		
		popad				; pop *all* 8 general purpose registers off the stack!
		ret	6				; clear the 6 bytes of parameters passed to this function
		
		
		recurse:
			
			mov cx, 6			; 6-i-j
			sub cx, [ebp+38]	; subtract i
			
			sub cx, [ebp+40]	; subtract j
			
			mov [ebp+42], cx	; set k
			push cx				; push k onto stack
			
			mov bx, [ebp+38]	; get i
			push bx				; push i
			
			mov bx, [ebp+36]	; get n
			dec bx				; n-1
			push bx				; push n
			
			call towerProc		; towers(n-1, i, 6-i-j)
			
					
			mov bx, [ebp+40]	; get j
			push bx				; push j
			
			mov bx, [ebp+38]	; get i
			push bx				; push i
			
			mov bx, 1			; store 1 for pushing
			push bx				; push 1
			
			call towerProc		; towers(1, i, j)
			
						
			mov bx, [ebp+40]	; get j
			push bx				; push j
			
			mov bx, [ebp+42]	; get k
			push bx				; push k
			
			mov bx, [ebp+36]	; get n
			dec bx				; n-1
			push bx				; push n
			
			call towerProc		; towers(n-1, k, j)
			
			
			popad
			ret 6
			
			
			
	towerProc endp
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

	;call prtfReg;
	maine proc
	
	
	
	L0:
		cls
		
		; push j, i (destination and source)
		mov 	ax,2
		push	ax				; store the 16-bit integer on the stack
		mov 	bx,1
		push	bx				; store the 16-bit integer on the stack		
		
		; print "Enter the number of disks: "
		print 	OFFSET  str0
		
		
		; get and push n
		mov eax,sval(input())	; get user input as an integer
		push	ax				; store the 16-bit integer on the stack
		
		call 	towerProc		; call the function
		
		repeatloop:	
		
			print 	OFFSET  str3		; 'Repeat Program? Reply Y or N: ',0
			
			invoke StdIn, ADDR cInp, 3	; gets user input
			mov al, [BYTE PTR cInp]
			movzx EAX, al				; resizes the data into a full register
			
			mov letter, EAX
			
			; compares user input against 'Y', 'y', 'N', 'n'
			
			mov EDI, letter				
			mov ESI, 59h				; 'Y'
			sub EDI, ESI
			jz L0
			
			mov EDI, letter
			mov ESI, 79h				; 'y'
			sub EDI, ESI
			jz L0
			
			mov EDI, letter
			mov ESI, 4Eh				; 'N'
			sub EDI, ESI
			jz stop
			
			mov EDI, letter
			mov ESI, 6Eh				; 'n'
			sub EDI, ESI
			jz stop
			
			; default case
			print OFFSET str4,13,10,0	; 'Invalid response'
			jmp repeatloop
		
		
		stop:	; end of program, clear screen and return
			cls
			inkey
			invoke ExitProcess,0
		
	maine endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

end start
