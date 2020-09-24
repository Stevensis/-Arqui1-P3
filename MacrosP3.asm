; -* SEGMENTO DE MACROS 
; -----* Macros para archivos
openFile macro ruta,handle
mov ah,3dh
mov al,10b
lea dx,ruta
int 21h
mov handle,ax
jc ErrorAbrir
endm

closeFile macro handle
mov ah,3eh
mov handle,bx
int 21h
endm

readFile macro numbytes,buffer,handle
mov ah,3fh
mov bx,handle
mov cx,numbytes
lea dx,buffer
int 21h
jc ErrorLeer
endm

createF macro buffer,handle
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
mov handle,ax
jc ErrorCrear
endm

writeFile macro numbytes,buffer,handle
	mov ah, 40h
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorEscribir
endm
; ---* fin macros para archivos

imprime macro texto ; Macro para imprimir textos
LOCAL ETI
ETI:
	MOV ah,09h
	MOV dx, offset texto
	int 21h
endm



getChar macro ;Macro para pedir un caraceter 
	MOV ah,01h
	int 21h
endm

imprimirChar macro caracter ;Macro para imprimir Caracteres
	MOV ah,02h
	MOV dl,caracter
	int 21h
endm

inPut macro buffer ;Macro para pedir un texto
LOCAL CONTINUE,FIN
PUSH SI ;añada al stack lo que contiene si para no perderlo
PUSH AX ; añade al stack lo que contiene ax

xor si,si ; Limpia el indice de origen
CONTINUE:
getChar
cmp al,0dh
je FIN
mov buffer[si],al
inc si
jmp CONTINUE

FIN:
mov al,'$'
mov buffer[si],al

POP AX
POP SI
endm

printRow macro array 
LOCAL MIENTRAS,FICHABE,FICHANE,VACIO,INCREMENTO,FINAL,FICHARBE,FICHARNE
PUSH SI
PUSH AX
	xor si,si
	xor cx,cx
	mov cx, '0'
	MIENTRAS:

	cmp cx,'8'
	je Final
	mov dh, array[si]
	cmp dh,101b
	je FICHABE
	cmp dh,100b
	je FICHANE
	cmp dh,111b
	je FICHARBE
	cmp dh,110b
	je FICHARNE
	cmp dh,000b
	je VACIO

	jmp Final
	FICHABE:
		imprime fichaB
		jmp INCREMENTO	
	FICHANE:
		imprime fichaN
		jmp INCREMENTO
	VACIO:
		imprime noFicha
		jmp INCREMENTO
	INCREMENTO:
		inc si
		inc cx
		jmp MIENTRAS
	FICHARBE:
		imprime fichaRB
		jmp INCREMENTO
	FICHARNE:
		imprime fichaRN
		jmp INCREMENTO
	FINAL:
		imprime println
POP AX
POP SI
endm

printTable macro
			imprime separacion
			imprime ocho ; fila 
			printRow row8
			imprime separacion ;division
			imprime siete ;fila
			printRow row7
			imprime separacion ;division
			imprime seis ;fila
			printRow row6
			imprime separacion ;division
			imprime cinco ;fila
			printRow row5
			imprime separacion ;division
			imprime cuatro ;fila
			printRow row4
			imprime separacion ;division
			imprime tres ;fila
			printRow row3
			imprime separacion ;division
			imprime dos ;fila
			printRow row2
			imprime separacion ;division
			imprime uno ;fila
			printRow row1
			imprime separacion ;division
			imprime letras
endm

createHTML macro
	imprime msgReportH1
	createF rutaHtml,handleFichero
	openFile rutaHtml,handleFichero
	writeFile SIZEOF headHtml, headHtml, handleFichero
	writeFile SIZEOF txtDate, txtDate, handleFichero
	writeFile SIZEOF txtfDate, txtfDate, handleFichero
	writeFile SIZEOF foothtml, foothtml, handleFichero
	closeFile handleFichero
	getChar
endm

getDate macro
	MOV AH,2AH
	INT 21H
	MOV AH,2CH
	INT 21H
endm