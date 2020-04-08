.data 
	ancho: .asciiz "\nIngrese el ancho de la imagen: " #variable para obtener el valor de teclado del ancho de la imagen 
	largo: .asciiz "\nIngese el largo de la imagen: " #variable para obtener el valor de teclado del largo de la imagen 
	open_file: .asciiz "C:/Users/Gaby/Desktop/file.txt" #variable donde está la ubicación del archivo .bin
	shapernedFile: .asciiz "C:/Users/Gaby/Desktop/shaperned.bin" #variable donde se alacena del archivo shaperned 
	over_shapernedFile: .asciiz "C:/Users/Gaby/Desktop/over_shaperned.bin" #variable donde se alacena del archivo over_shaperned
	buffer: .space 1024 #tamaño del buffer
	 
.text 
	#etiqueta principal
	main: 
		#se imprime el mensaje solicitando el ancho
		li $v0, 4 #llamado al sistema para imprimir un string 
		la $a0, ancho #dirección del ancho
		syscall #imprime el mensaje
		
		#se obtiene el valor de ancho ingresado con el teclado y se guarda en el registro $s0
		jal getNumber #salta a la etiqueta getNumber y guarda la siguiente dirección en $ra 
		
		#se almacena el ancho en memoria
		move $s0, $v0 #se mueve el número de $v0 a $s0
		li $s1, 0x100101c0 #se guarda la dirección en memoria 0x100100c0 en el registro $s1
		sw $s0, ($s1) #se almacena el ancho en la memoria
		
		#se imprime el mensaje solicitando el largo 
		li $v0, 4 #llamado al sistema para imprimir un string 
		la $a0, largo #dirección del largo 
		syscall #imprime el mensaje 
		
		#se obtiene el valor de largo ingresado con el teclado y se guarda en el registro $s0
		jal getNumber #salta a la etiqueta getNumber y guarda la siguiente dirección en $ra 	
		
		#se almacena el largo en memoria
		move $s0, $v0 #se mueve el número de $v0 a $s0
		add $s1, $s1, 4 #se aumenta en 4 la dirección en memoria
		sw $s0, ($s1) #se almacena el largo en la memoria
		
		#se guarda el kernel de shaperned en memoria
		jal Shaperned_kernel
		
		#se guarda el kernel de overhaperned en memoria
		jal OverShaperned_kernel
		
		
		
		#get number
		#li $s2, 16 #número donde se empieza la cadena
    		#li $s0, 8 #contador de bits
		
		b end
	
	
	
	
	#etiquta para obtener el número de 8 bits
	getBinary:
		beq $s0, 0, end #salto parntinur SE TIENE Q CAMBIAR
    		lb $t1, open_file($s2) #se obtiene 1 bit del file
    		beq $s0, 8, beginBinary #salto para iniciar la unión del número
    		beq $t1, 48, zero #salto para agregar un 0 al número
    		beq $t1, 49, one #salto para agregar un 1 al número
	
	#etiquta para agregar el primer bit
	beginBinary:
		beq $t1, 48, beginZero #salto para agregar un 0 como primer bit
    		beq $t1,49, beginOne #salto para agregar un 1 como primer bit
    	
    	#etiqueta para agregar un 0 bit al inicio
	beginZero:
		li $t0, 0 #se agrega un 0 a la cadena
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente número
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para agregar un 0
	zero:
		sll $t0, $t0, 1 #se mueve un espacio a la izquierda la cadena del número
		add $t0, $t0, 0 #se suma un 0 a la cadena 
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente número
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para agregar un 1 bit al inicio
	beginOne:
		li $t0, 1 #se agrega un 1 a la cadena
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente número
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para agregar un 1
	one:	
		sll $t0, $t0, 1 #se mueve un espacio a la izquierda la cadena del número
		add $t0, $t0, 1 #se suma un 1 a la cadena
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente número
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para obtener el número	
	getNumber:
		li $v0, 5 #llamado al sistema para leer el entero 
		syscall #leer el entero en $v0 desde consola
		jr $ra	#salto a la siguiente dirección donde salto
	
	#etiqueta donde se almacena el kernel sharperned en memoria 
	Shaperned_kernel:
		li $s0, 0 #guardamos el número cero en el registro $s0
		li $s1, 0x100100e0 #se guarda la dirección en memoria 0x100100c0 en el registro $s1 
		sw $s0, ($s1) #se guarda en memoria el número 0
		li $s0, -1 #guardamos el número -1 en el registro $s0
		add $s1, $s1, 4 #se aumenta en 4 la dirección en memoria 0x100100e0
		sw $s0, ($s1) #se guarda en memoria el número -1
		li $s0, 5 #guardamos el número 5 en el registro $s0
		add $s1, $s1, 4 #se aumenta en 4 la dirección en memoria 0x100100e0
		sw $s0, ($s1) #se guarda en memoria el número 5
		jr $ra	#salto a la siguiente dirección donde salto
	
	#etiqueta donde se almacena el kernel OverShaperned en memoria	
	OverShaperned_kernel:
		li $s0, 0
		li $s1, 0x100100e0
		sw $s0, ($s1)
		li $s0, -1
		add $s1, $s1, 4
		sw $s0, ($s1)
		li $s0, 5
		add $s1, $s1, 4
		sw $s0, ($s1)
		jr $ra	#salto a la siguiente dirección donde salto
	
	#etiqueta para asignar memoria en el heap
	begin_allocateMemory:
		li $v0, 9 #llamado al sistema para asignar memoria 
		li $a0, 8 #número de bytes asignar
		syscall #llamado al sistema

		li $s0, 8 #guardamos la cantidad de bits del número
		li $s1, 31 #cantidad de espacios que se van a mover a la izquierda
		li $s2, 31 #cantidad de espacios que se van a mover a la derecha
		j allocateMemory #salto para empezar a seleccionar cada uno de los bits de números
	
	#etiqueta para guardar bit por bit de los números
	allocateMemory:
		beq $s1, 23, saveFile #salto para guardar en el archivo
		li $t4, 0x100101c0 #dirección de memoria donde está en número SE TIENE Q CAMBIAR
		lw $s3, ($t4) #se saca el número de memoria
		sllv $s3, $s3, $s1 #se corre $s1 veces a la izquerda
		srlv $s3, $s3, $s2 #se corre $s2 veces a la derecha
		j checkBit
	
	#etiqueta donde se selecciona en cual archivo guardar
	saveFile:
		li $t1, 0x100100e0 #dirección en memoria donde se selecciona en cual archivo guardar SE TIENE Q CAMBIAR
		lw $t1, ($t1) #se obtiene el número
		beq $t1, 1, openShaperned_file #salto para guardar en el archivo Shaperned
		beq $t1, 0, openOver_shapernedFile # salto para guardar en el archivo Over shaperned
			
	#etiqueta para verificar si el bit es un 0, un 1, o el inicio de la cadena
	checkBit:
		beq $s1, 24, checkBegin #salto para verificar si el inicio es 0 o 1
		beq $s3, 1, allocateOne #salto para guardar un 1
		beq $s3, 0, allocateZero #salto para guardar un 0
	
	#etiqueta para verificar si el primer bit es un 0 o un 1
	checkBegin:
 		beq $s3, 1, allocateOne_begin #salto para guardar un 1
		beq $s3, 0, allocateZero_begin #salto para guardar un 0
	
	#etiqueta para agregar un 1 al heap
	allocateOne:
 		li $t3, 49 #se guarda un 1 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posición $s0 del heap
		sub $s0, $s0, 1 #se le quita un 1 a $s0
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria

	#etiqueta para agregar un 1 al inicio del heap
	allocateOne_begin:
 		li $t3, 49 #se guarda un 1 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posición $s0 del heap
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria
	
	#etiqueta para agregar un 0 al heap
	allocateZero:
 		li $t3, 48 #se guarda un 0 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posición $s0 del heap
		sub $s0, $s0, 1 #se le quita un 1 a $s0
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria

	#etiqueta para agregar un 0 al inicio del heap 
	allocateZero_begin:
 		li $t3, 48 #se guarda un 8 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posición $s0 del heap
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria
	
	#etiqueta donde se abre y leer el archivo .bin inicial
	openRead_File:
		#se abre el archivo a leer
		li $v0, 13 #llamado al sistema para abrir el archivo
    		la $a0, open_file #se obtiene el nombre del archivo
    		li $a1, 0 #bandera para leer el archivo
    		syscall #llamado al sistema
    		move $s0, $v0 #se guarda el file descriptor en $s0
    		#se lee el archivo 
    		li $v0, 14 #llamado al sistema para leer el archivo
		move $a0, $s0 #se se hace un copia del file descriptor en $a0
		la $a1, buffer #tamaño del buffer del archivo
		#se obtiene el ancho y el alto
		li $t0, 0x100101c0 #dirección de memoria donde está el ancho
		lw $t1, ($t0) #se obtiene el ancho
		add $t0, $t0, 4 #dirección en memoria donde está el alto
		lw $t2, ($t0) #se obtiene el alto
		mul $t1, $t1, $t2 #se obtiene la cantidad de pixeles de la imagen
		mul $t1, $t1, 8 #se obtiene la cantidad de pixeles en 8 bits 
		la $a2, 0($t1) #tamaño de la cantidad de datos del documentos
		syscall #llamado al sistema 
    		jr $ra	#salto a la siguiente dirección donde salto
    	
    	#etiqueta donde escribe el archivo .bin de Shaperned
    	openShaperned_file:
    		#se abre el archivo a leer
		li $v0, 13 #llamado al sistema para abrir el archivo
    		la $a0, open_file #se obtiene el nombre del archivo
    		li $a1, 9 #bandera para escribir al final del archivo
    		syscall #llamado al sistema
    		move $s0, $v0 #se guarda el file descriptor en $s0
    		#se escribe en el archivo
    		li $v0, 15 #llamado al sistema para escribir en un archivo
    		move $a0, $s0 #el file descriptor se copia en $a0
    		la $a1, shapernedFile #se obtiene el nombre del archivo
    		la $a2, 8 #tamaño de caracteres a escribir
    		syscall #llamado al sistema
    	
    	#etiqueta donde escribe el archivo .bin de overshaperned
    	openOver_shapernedFile:
    		#se abre el archivo a leer
		li $v0, 13 #llamado al sistema para abrir el archivo
    		la $a0, over_shapernedFile #se obtiene el nombre del archivo
    		li $a1, 9 #bandera para escribir al final del archivo
    		syscall #llamado al sistema
    		move $s0, $v0 #se guarda el file descriptor en $s0
    		#se escribe en el archivo
    		li $v0, 15 #llamado al sistema para escribir en un archivo
    		move $a0, $s0 #el file descriptor se copia en $a0
    		move $a1, $s3 #dirección del buffer desde donde se escribe
    		la $a2, 8 #tamaño de caracteres a escribir
    		syscall #llamado al sistema

	#etiqueta para cerrar los archivos
	closeFile:
		li $v0, 16 #llamado al sistema para cerrar el archivo
    		move $a0, $s0 #se cierra el file descriptor
    		syscall #llamado al sistema
    		
	#etiqueta para finalizar el programa		
	end:
		#fin del programa  
		li $v0, 10 #llamado al sistema para terminar el programa
	
