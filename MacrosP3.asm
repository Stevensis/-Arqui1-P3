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
	mov ah, 40h
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorEscribir
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
 mov cx,10   ;Determinamos la cantidad de datos a leer/comparar
 mov AX,DS  ;mueve el segmento datos a AX
 mov ES,AX  ;Mueve los datos al segmento extra
	compara:
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

	  jmp diferente
  	SHOW:
  		createHTML
  		jmp terminar
  	EXIT:
  		imprime msgExit
  		jmp terminar
  	SAVE:
  		imprime msgSave
  		saveReport
  		jmp terminar
	diferente:
		imprime txtNoValido
		jmp terminar
	terminar:

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
	rowHtml row8
	rowHtml row7
	rowHtml row6
	rowHtml row5
	rowHtml row4
	rowHtml row3
	rowHtml row2
	rowHtml row1
endm

rowHtml macro row
LOCAL HACER,FICHABE2,FICHANE2,FICHARBE2,FICHARNE2,VACIO2,INCREMENTAR,FINALIZAR
	PUSH SI
	PUSH AX

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
	POP AX
	POP SI
endm

saveReport macro
	getPath pathFile
	createF pathFile,handleFichero
	openFile pathFile,handleFichero

	writeFile SIZEOF foothtml, foothtml, handleFichero
	closeFile handleFichero
endm

saveReport2 macro array
LOCAL MIENTRAS,FICHABE,FICHANE,VACIO,INCREMENTO,FINAL,FICHARBE,FICHARNE
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
		imprime fichaB
		jmp INCREMENTO3	
	FICHANE3:
		imprime fichaN
		jmp INCREMENTO3
	VACIO3:
		imprime noFicha
		jmp INCREMENTO3
	INCREMENTO3:
		inc si
		inc cx
		jmp MIENTRAS3
	FICHARBE3:
		imprime fichaRB
		jmp INCREMENTO3
	FICHARNE3:
		imprime fichaRN
		jmp INCREMENTO3
	FINAL3:
		imprime println
POP AX
POP SI
endm
; ---------------------* Fin reportes
getDate macro
	MOV AH,2AH
	INT 21H
	MOV AH,2CH
	INT 21H
endm