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
	PUSH CX
	PUSH DX
	PUSH AX
	mov ah, 40h
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorEscribir
	POP AX
	POP DX
	POP CX
endm

getPath macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h
endm
; ---* fin macros para archivos

; ----* Comparar cadenas

compracionTexto macro buffer
local compara,SHOW,EXIT,SAVE,terminar,diferente
xor si,si
xor di,di
	compara:
	 mov cx,10   ;Determinamos la cantidad de datos a leer/comparar
	 mov AX,DS  ;mueve el segmento datos a AX
	 mov ES,AX  ;Mueve los datos al segmento extra
	  lea si,buffer  ;cargamos en si la cadena que contiene vec
	  lea di,txtExit
	  repe cmpsb
	  je EXIT

	  lea si,buffer 
	  lea di,txtShow ;cargamos en di la cadena que contiene vec2
	  repe cmpsb  ;compara las dos cadenas
	  ;Jne diferente ;si no fueron igual
	  je SHOW ;Si fueron iguales
	  
	  lea si,buffer 
	  lea di,txtSave
	  repe cmpsb
	  je SAVE

	  xor si,si
	  PUSH DI
  	  xor di,di	
  	  getLetra buffer
  	  inc si
  	  clearEspacio buffer
  	  inc si
  	  inc si
  	  xor di,di
  	  getLetra buffer
  	  inc si
  	  moverEspacio buffer
  	  POP DI
  	  jmp Turno

	  jmp diferente
  	SHOW:
  		createHTML
  		jmp Turno2
  	EXIT:
  		imprime msgExit
  		jmp Menu
  	SAVE:
  		imprime msgSave
  		saveReport
  		jmp Turno2
  	
	diferente:
		imprime txtNoValido
		jmp Turno2
	terminar:
		
endm



clearEspacio macro buffer
LOCAL UR1,UR2,UR3,UR4,UR5,UR6,UR7,UR8,UFIN
	cmp buffer[si],'1'
	je UR1

	cmp buffer[si],'2'
	je UR2

	cmp buffer[si],'3'
	je UR3

	cmp buffer[si],'4'
	je UR4

	cmp buffer[si],'5'
	je UR5

	cmp buffer[si],'6'
	je UR6

	cmp buffer[si],'7'
	je UR6

	cmp buffer[si],'8'
	je UR7

	UR1:
		mov row1[di],000b
		jmp UFIN
	UR2:
		mov row2[di],000b
		jmp UFIN
	UR3:
		mov row3[di],000b
		jmp UFIN
	UR4:
		mov row4[di],000b
		jmp UFIN
	UR5:
		mov row5[di],000b
		jmp UFIN
	UR6:
		mov row6[di],000b
		jmp UFIN
	UR7:
		mov row7[di],000b
		jmp UFIN
	UR8:
		mov row7[di],000b
		jmp UFIN
	UFIN:

endm

moverEspacio macro buffer
LOCAL MR1,MR2,MR3,MR4,MR5,MR6,MR7,MR8,MFIN
	cmp buffer[si],'1'
	je MR1
	
	cmp buffer[si],'2'
	je MR2

	cmp buffer[si],'3'
	je MR3

	cmp buffer[si],'4'
	je MR4

	cmp buffer[si],'5'
	je MR5

	cmp buffer[si],'6'
	je MR6

	cmp buffer[si],'7'
	je MR7

	cmp buffer[si],'8'
	je MR8


	MR1:
		mov row1[di],101b
		jmp MFIN
	MR2:
		mov row2[di],101b
		jmp MFIN
	MR3:
		mov row3[di],101b
		jmp MFIN
	MR4:
		mov row4[di],101b
		jmp MFIN
	MR5:
		mov row5[di],101b
		jmp MFIN
	MR6:
		mov row6[di],101b
		jmp MFIN
	MR7:
		mov row7[di],101b
		jmp MFIN
	MR8:
		mov row8[di],101b
		jmp MFIN
	MFIN:

endm

getLetra macro buffer
LOCAL ISA,ISB,ISC,ISD,ISE,ISF,ISG,ISH,IFIN

	  cmp buffer[si],'A'
	  je ISA 

	  cmp buffer[si],'B'
	  je ISB

	  cmp buffer[si],'C'
	  je ISC 

	  cmp buffer[si],'D'
	  je ISD 

	  cmp buffer[si],'E'
	  je ISE 

	  cmp buffer[si],'F'
	  je ISF 

	  cmp buffer[si],'G'
	  je ISG 

	  cmp buffer[si],'H'
	  je ISH 
	ISA:
  		imprime prueba
		jmp IFIN
  	ISB:
  		imprime prueba
  		inc di
  		jmp IFIN
  	ISC:
  		imprime prueba
  		inc di
  		inc di
  		jmp IFIN
  	ISD:
  		imprime prueba
  		inc di
  		inc di
  		inc di
  		jmp IFIN
  	ISE:
  		imprime prueba
  		inc di
  		inc di
  		inc di
  		inc di
  		jmp IFIN
  	ISF:
  		imprime prueba
  		inc di
  		inc di
  		inc di
  		inc di
  		inc di
  		jmp IFIN
  	ISG:
  		imprime prueba
  		inc di
  		inc di
  		inc di
  		inc di
  		inc di
  		inc di
  		jmp IFIN
  	ISH:
  		imprime prueba
  		inc di
  		inc di
  		inc di
  		inc di
  		inc di
  		inc di
  		inc di
  		jmp IFIN
  	IFIN:
endm

; ----* Fin de comparacion

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

	;jmp Final
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
; ----------------------- Reportes
createHTML macro 
	imprime msgReportH1
	createF rutaHtml,handleFichero
	openFile rutaHtml,handleFichero
	writeFile SIZEOF headHtml, headHtml, handleFichero
	writeFile SIZEOF txtDate, txtDate, handleFichero
	writeFile SIZEOF txtfDate, txtfDate, handleFichero
	writeFile SIZEOF txtfDate, txtfDate, handleFichero
	writeFile SIZEOF txtTableS, txtTableS, handleFichero
	tableHtml
	writeFile SIZEOF txtTableF, txtTableF, handleFichero
	writeFile SIZEOF foothtml, foothtml, handleFichero
	closeFile handleFichero
	getChar
endm

tableHtml macro
	PUSH Ax
	xor ax,ax
	mov ax,'0'
	rowHtml row8
	inc ax
	rowHtml row7
	inc ax
	rowHtml row6
	inc ax
	rowHtml row5
	inc ax
	rowHtml row4
	inc ax
	rowHtml row3
	inc ax
	rowHtml row2
	inc ax
	rowHtml row1
	POP AX
endm

rowHtml macro row
LOCAL HACER,FICHABE2,FICHANE2,FICHARBE2,FICHARNE2,VACIO2,INCREMENTAR,FINALIZAR
	PUSH SI
	
	xor si,si
	xor cx,cx
	mov cx, '0'
	writeFile SIZEOF txtRowS, txtRowS, handleFichero
		HACER:
		cmp cx,'8'
		je FINALIZAR
		mov dh, row[si]
		cmp dh,101b
		je FICHABE2
		cmp dh,100b
		je FICHANE2
		cmp dh,111b
		je FICHARBE2
		cmp dh,110b
		je FICHARNE2
		cmp dh,000b
		je VACIO2

		
		FICHABE2:
		writeFile SIZEOF rFichaB, rFichaB, handleFichero
		jmp INCREMENTAR
		FICHANE2:
		writeFile SIZEOF rFichaN, rFichaN, handleFichero
		jmp INCREMENTAR
		FICHARBE2:
		writeFile SIZEOF rFichaRB, rFichaRB, handleFichero
		jmp INCREMENTAR
		FICHARNE2:
		writeFile SIZEOF rFichaRN, rFichaRN, handleFichero
		jmp INCREMENTAR
		VACIO2:
		writeFile SIZEOF rVacio, rVacio, handleFichero
		jmp INCREMENTAR
		INCREMENTAR:
		inc si
		inc cx
		jmp HACER
		FINALIZAR:
		writeFile SIZEOF txtRowF, txtRowF, handleFichero
	POP SI
endm

rowVacioHtml macro 
LOCAL IMPAR, PAR,BLACKS, WHITES, VFIN
	cmp ax,'0'
	je PAR
	cmp ax,'1'
	je IMPAR
	cmp ax,'2'
	je PAR
	cmp ax,'3'
	je IMPAR
	cmp ax,'4'
	je PAR
	cmp ax,'5'
	je IMPAR
	cmp ax,'6'
	je PAR
	cmp ax,'7'
	je IMPAR

 	jmp VFIN
	IMPAR:
	cmp cx,'0'
	je BLACKS
	cmp cx,'1'
	je WHITES
	cmp cx,'2'
	je BLACKS
	cmp cx,'3'
	je WHITES
	cmp cx,'4'
	je BLACKS
	cmp cx,'5'
	je WHITES
	cmp cx,'6'
	je BLACKS
	cmp cx,'7'
	je WHITES

 	jmp VFIN
	PAR:
	imprime prueba2
	cmp cx,'0'
	je WHITES
	cmp cx,'1'
	je BLACKS
	cmp cx,'2'
	je WHITES
	cmp cx,'3'
	je BLACKS
	cmp cx,'4'
	je WHITES
	cmp cx,'5'
	je BLACKS
	cmp cx,'6'
	je WHITES
	cmp cx,'7'
	je BLACKS
	jmp VFIN
	BLACKS:
	writeFile SIZEOF rVacioN, rVacioN, handleFichero
	jmp VFIN
	WHITES:
	writeFile SIZEOF rVacio, rVacio, handleFichero
	jmp VFIN
	VFIN:
endm

saveReport macro
	getPath pathFile
	createF pathFile,handleFichero
	openFile pathFile,handleFichero
	saveReport2 row8
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row7
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row6
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row5
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row4
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row3
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row2
	writeFile SIZEOF sprintln, sprintln, handleFichero
	saveReport2 row1
	closeFile handleFichero
endm

saveReport2 macro array
LOCAL MIENTRAS3,FICHABE3,FICHANE3,VACIO3,INCREMENTO3,FINAL3,FICHARBE3,FICHARNE3
PUSH SI
PUSH AX
	xor si,si
	xor cx,cx
	mov cx, '0'
	MIENTRAS3:
	cmp cx,'8'
	je Final3
	mov dh, array[si]
	cmp dh,101b
	je FICHABE3
	cmp dh,100b
	je FICHANE3
	cmp dh,111b
	je FICHARBE3
	cmp dh,110b
	je FICHARNE3
	cmp dh,000b
	je VACIO3

	;jmp Final
	FICHABE3:
		writeFile SIZEOF sfichaB, sfichaB, handleFichero
		jmp INCREMENTO3	
	FICHANE3:
		writeFile SIZEOF sfichaN, sfichaN, handleFichero
		jmp INCREMENTO3
	VACIO3:
		writeFile SIZEOF snoFicha, snoFicha, handleFichero
		jmp INCREMENTO3
	INCREMENTO3:
		inc si
		inc cx
		jmp MIENTRAS3
	FICHARBE3:
		writeFile SIZEOF sfichaRB, sfichaRB, handleFichero
		jmp INCREMENTO3
	FICHARNE3:
		writeFile SIZEOF sfichaRN, sfichaRN, handleFichero
		jmp INCREMENTO3
	FINAL3:
POP AX
POP SI
endm


; -------------------*
clearInput macro buffer
	mov buffer[0],'$'
	mov buffer[1],'$'
	mov buffer[2],'$'
	mov buffer[3],'$'
	mov buffer[4],'$'
	mov buffer[5],'$'
	mov buffer[6],'$'
	mov buffer[7],'$'
	mov buffer[8],'$'
	mov buffer[9],'$'
endm
; ---------------------* Fin reportes
getDate macro
	MOV AH,2AH
	INT 21H
	MOV AH,2CH
	INT 21H
endm