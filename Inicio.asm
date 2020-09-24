; -* SEGMENTO DE MACROS 
include MacrosP3.asm

.model small
.stack 100h 
.data
;================ SEGMENTO DE DATOS ==============================
txtStart db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13, 'FACULTAD DE INGENIERIA', 10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13, 'NOMBRE: STEVEN AARON SIS HERNANDEZ',10,13, 'CARNE: 201706357',10,13, 'SECCION: A', 10,13,  '$'
txtMenuOption db 0ah,0dh, '1) Iniciar Juego', 10,13 , '2) Cargar Juego',10,13, '3) Salir',10,13, '$'
prueba db 0ah,0dh, 'Prueba exito',10,13, '$'
prueba2 db 0ah,0dh, 'La segunda opcion',10,13, '$'
arreglo db 20 dup('$'),'$' ;Asi se define un arreglo de 20 posiciones, el dup rellena de $ todas las posiciones
txtMovida db 20 dup('$'),'$'
;Tablero 101b representa una ficha blanca, 000b representa un espacio en blanco, 100b representa ficha negra, 111b reina blanca, 110b reina negra


row1 db 000b, 110b, 000b, 100b, 000b, 100b, 000b, 100b
row2 db 100b, 000b, 100b, 000b, 100b, 000b, 100b, 000b
row3 db 000b, 100b, 000b, 100b, 000b, 100b, 000b, 100b
row4 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
row5 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
row6 db 101b, 000b, 101b, 000b, 101b, 000b, 101b, 000b
row7 db 000b, 101b, 000b, 101b, 000b, 101b, 000b, 101b
row8 db 101b, 000b, 101b, 000b, 101b, 000b, 101b, 000b

;Variables de turnos
banderaTurno db 30h
banderaAccion db 30h
msgTurnoB db 0ah,0dh, 'Turno blancas: ', '$'
msgTurnoN db 0ah,0dh, 'Turno negras: ', '$'
;Variables de Tablero
fichaB db 'FB|','$'
fichaN db 'FN|','$'
fichaRB db 'RB|','$'
fichaRN db 'RN|','$'
noFicha db '  |', '$'
println db 0ah,0dh, '$'
ocho db '8  |', '$'
siete db '7  |', '$'
seis db '6  |', '$'
cinco db '5  |', '$'
cuatro db '4  |', '$'
tres db '3  |', '$'
dos db '2  |', '$'
uno db '1  |', '$'
separacion db '   -------------------------', 10,13, '$'
letras db 	  '     A  B  C  D  E  F  G  H ',10,13, '$'
;reporte
	;------** Reporte HTML
	msgReportH1 db 0ah,0dh, 'Se creare el archivo estadoTablero.html', '$'
	msgReportH2 db 0ah,0dh, 'Reporte Creado', '$'
	rutaHtml db 'estadoTablero.html',00h
	headHtml db 0ah,0dh, '<head>  <title>201706357</title> </head> <body style="margin: 0x;"> <h1 style="color: rgb(43,91,140);opacity: 0.86;text-align: center;">'
	txtDate db '05/05/2020 09:05:02'
	txtfDate db '&nbsp;</h1>'
	foothtml db 0ah,0dh,'</body> </html>',10,13
;errores
msgErr1 db 0ah,0dh, 'Error al abrir un archivo', '$'
msgErr2 db 0ah,0dh, 'Error al leer un archivo', '$'
msgErr3 db 0ah,0dh, 'Error al crear un archivo', '$'
msgErr4 db 0ah,0dh, 'Error al escribir un archivo', '$'
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 

;Ficheros
handleFichero dw ?
.code ;segmento de código
;================== SEGMENTO DE CODIGO ===========================
	main proc
			MOV dx,@data
			MOV ds,dx 
		StartPrograma:
			imprime txtStart
			jmp Menu
		Menu:
			imprime txtMenuOption
			mov banderaAccion,30h
			getChar ;Obtiene un valor que ingresa del teclado
			cmp al,'1'
			je	IniciarJuego
			cmp al, '2'
			je CargaJ
			cmp al, '3'
			je Salir
			jmp Menu
		Cargaj:
			createHTML
			jmp Menu
		IniciarJuego:
			
			mov dh,10 ;Imprimimos un salto de linea
			imprimirChar dh
			mov dh,13
			imprimirChar dh ;Fin impresion salto de linea
			printTable
			jmp Turno ;salto no condicional a la etiqueta turno

			getChar
			jmp Menu

		Turno:
			cmp banderaTurno, '0'
			je JuegaBlancas
			cmp banderaTurno, '1'
			je JuegaNegras
		JuegaBlancas:
			imprime msgTurnoB
			inPut arreglo
			mov banderaTurno, 31h
			printTable
			createHTML
			jmp Menu
		JuegaNegras:
			imprime msgTurnoN
			inPut arreglo
			mov banderaTurno, 30h
			printTable
			jmp Menu
		;Reportes---------------------------

		;Fin Reportes---------------------------
		
		;Errores archivos
		ErrorAbrir:
	    	imprime msgErr1
	    	getChar
	    	jmp Menu
	    ErrorLeer:
	    	imprime msgErr2
	    	getChar
	    	jmp Menu
	    ErrorCrear:
	    	imprime msgErr3
	    	getChar
	    	jmp Menu
		ErrorEscribir:
	    	imprime msgErr4
	    	getChar
	    	jmp Menu
		;Fin Errores archivos
		Salir: 
			MOV ah,4ch
			int 21h
	main endp

end  