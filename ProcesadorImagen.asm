.data 
	ancho: .asciiz "\nIngrese el ancho de la imagen: " #variable para obtener el valor de teclado del ancho de la imagen 
	alto: .asciiz "\nIngese el alto de la imagen: " #variable para obtener el valor de teclado del largo de la imagen 
	open_file: .asciiz "C:/Users/Gaby/Desktop/Proyecto Arqui/imagen.bin" #variable donde est� la ubicaci�n del archivo .bin
	shapernedFile: .asciiz "C:/Users/Gaby/Desktop/Proyecto Arqui/shaperned.bin" #variable donde se alacena del archivo shaperned 
	over_shapernedFile: .asciiz "C:/Users/Gaby/Desktop/Proyecto Arqui/over_shaperned.bin" #variable donde se alacena del archivo over_shaperned
	buffer: .space 1024 #tama�o del buffer
	 
.text 
	#etiqueta principal
	main: 
		#se imprime el mensaje solicitando el ancho
		li $v0, 4 #llamado al sistema para imprimir un string 
		la $a0, ancho #direcci�n del ancho
		syscall #imprime el mensaje
		
		#se obtiene el valor de ancho ingresado con el teclado y se guarda en el registro $s0
		jal getNumber #salta a la etiqueta getNumber y guarda la siguiente direcci�n en $ra 
		
		#se almacena el ancho en memoria
		move $s0, $v0 #se mueve el n�mero de $v0 a $s0
		li $s1, 0x10000000 #se guarda la direcci�n en memoria 0x10000000 en el registro $s1
		sw $s0, ($s1) #se almacena el ancho en la memoria
		
		#se imprime el mensaje solicitando el alto 
		li $v0, 4 #llamado al sistema para imprimir un string 
		la $a0, alto #direcci�n del alto 
		syscall #imprime el mensaje 
		
		#se obtiene el valor de largo ingresado con el teclado y se guarda en el registro $s0
		jal getNumber #salta a la etiqueta getNumber y guarda la siguiente direcci�n en $ra 	
		
		#se almacena el ancho en memoria
		move $s0, $v0 #se mueve el n�mero de $v0 a $s0
		add $s1, $s1, 4 #se aumenta en 4 la direcci�n en memoria (0x10000008)
		sw $s0, ($s1) #se almacena el ancho en la memoria
			
		#se almacena el contador del ancho 
		add $s1, $s1, 4 #se aumenta en 4 la direcci�n en memoria (0x1000000c)
		li $s0, 1 #se inicia en 1 el contador del ancho
		sw $s0, ($s1) #se almacena el contador del ancho en la memoria
		
		#se almacena el contador de la altura 
		add $s1, $s1, 4 #se aumenta en 4 la direcci�n en memoria (0x100000010)
		li $s0, 1 #se inicia en 1 el contador de la altura
		sw $s0, ($s1) #se almacena el contador de la altura en la memoria
		
		#se almacena el contador de la cantidad total de pixeles 
		add $s1, $s1, 4 #se aumenta en 4 la direcci�n en memoria (0x100000014)
		li $s0, 0 #se inicia en 1 el contador total de pixeles
		sw $s0, ($s1) #se almacena el contador de los pixeles en la memoria
		
		#se guarda el kernel de shaperned en memoria
		jal Shaperned_kernel #salto a la etiqueta de shaperned
		
		#se guarda el kernel de overhaperned en memoria
		jal OverShaperned_kernel #salto a la etiqueta de over shaperned
		
		jal openRead_File
		jal closeFile
		
		
		#j topLeftCorner LISTO 0
		#j topRightCorner LISTO 3192
		#j leftCornerDown 851200
		#j rightCornerDown 854392
		#j top 8
		#j down 851208
		#j left 3200
		#j right 6392
		#j inMiddle 3208
		#jal addWidth
		#jal addHigh
		
		#li $s0, 0x10000010
		#li $s1, 3192
		#sw $s1, ($s0)
		#j topRightCorner
		#j topLeftCorner
		#j topLeftCorner
					
		j imageProcessor
	
	#etiqueta donde se escoge cual es el procesamiento de la imagen segun el contador del ancho y el alto 
	imageProcessor:
		li $s1, 0x10000120
		lw $s2, ($s1)
		add $s2, $s2, 1
		sw $s2, ($s1)
		
		li $s0, 0x10000000 #direcci�n de memoria donde est� el valor del ancho
		lw $s1, ($s0) #se obtiene el valor del ancho
		
		#cuando el contado del alto sea mayor q el alto
		move $s2, $s0
		add $s2, $s2, 4
		lw $s3, ($s2)
		add $s3, $s3, 1
		add $s2, $s2, 8
		lw $s4, ($s2)
		beq $s3, $s4, end
				
		#cuando el contador del ancho es igual a 1
		add $s0, $s0, 8 #direccion de memoria donde est� el valor del contador del ancho
		lw $s3, ($s0) #obtengo el valor del contador del ancho
		li $s0, 1 #se le asigna un 1 al registro $s0
		beq $s3, $s0, widthOne #salta si el contador del ancho es igual a 1 
		
		#cuando el contador del ancho es igual al ancho
		beq $s3, $s1, widthWidth
		
		j differentWidth #salta si el contador del ancho es diferente de 1 o al ancho

	
	#etiqueta para el procesamiento cuando el contador del ancho es igual a 1
	widthOne:
		li $s0, 0x10000004 #direcci�n de memoria donde est� el valor de la altura
		lw $s1, ($s0) #obtengo el valor de la altura
		
		#cuando el contador de la altura es igual a 1
		add $s0, $s0, 8 #direcci�n en memoria (0x10000008) donde est� el contador del altura
		lw $s2, ($s0) #obtengo el valor del ancho
		li $s3, 1 #al registro $t0 se le asigna un 1
		beq $s2, $s3, topLeftCorner #salta si el contador de la altura es igual a 1
		
		#cuando el contador de la altura es igual a la altura
		beq $s1, $s2, leftCornerDown #salta si el contador de la altura es igual a la altura

		j left #salta si el contador de la altura es diferente a 1 o a la altura

	
	#etiqueta para el procesamiento del pixel de la esquina arriba a la derecha
	topLeftCorner:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000064
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000068
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000006c
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia el contador de pixeles a $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
    		
    		add $s2, $s2, 8 #al contador de pixeles se le suma 8 para conseguir el seguiente n�mero 
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000074
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $t0, 0 #al registro $t0 se le asigna un 0
    		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000078
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c  
    		
    		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		add $s2, $s2, 8 #al ancho multiplicado por 8 se suma 8
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000080		
    		 
    		li $s1, 0x100000e0
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)
    		jal addWidth #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
    		    			
	#etiqueta para el procesamiento del pixel de la esquina abajo a la derecha
	leftCornerDown:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060
						
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000064
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de los pixeles
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
		add $s2, $s2, 8 #se suma 8 al resultado anterior
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000068
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia el contador de los pixeles
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia el contador de los pixeles
		add $s2, $s2, 8 #se suma 8 al contador
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000074
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000006c
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000078
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000007c
			
		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000080
		
		li $s1, 0x100000e4
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)								
    		jal addWidth #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
		
	#etiqueta para el procesamiento de los pixeles de la izquierda
	left:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060
				
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000064 
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		add $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000068 
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
		add $s2, $s2, 8 #se le suma 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000074
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000078
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		add $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x100000 7c
    		
    		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		add $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		add $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000080 
    		
    		li $s1, 0x100000e8
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)
    		jal addWidth #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n	
    		 			
	#etiqueta para el procesamiento cuando el contador del ancho es igual al ancho
	widthWidth:
		li $s0, 0x10000004 #direcci�n de memoria donde est� el valor de la altura
		lw $s1, ($s0) #obtengo la antura
		
		#cuando el contador de la altura es igual a 1
		add $s0, $s0, 8 #direcci�n en memoria (0x1000000c) donde est� el contador del altura
		lw $s2, ($s0) #obtengo el valor del ancho
		li $s3, 1 #al registro $t0 se le asigna un 1
		beq $s2, $s3, topRightCorner #salta si el contador de la altura es igual a 1
		
		#cuando el contador de la altura es igual a la altura
		beq $s1, $s2, rightCornerDown #salta si el contador de la altura es igual a la altura
		
		#cuando el contador de altura es diferente de 1 o a la altura
		j right #salta si el contador de la altura es diferente a 1 o a la altura
	
	#etiqueta para el procesamiento del pixel de la esquina arriba a la izquierda	
	topRightCorner:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000064
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000068
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
		sub $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000074
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s2, $s1 #se suma el contador de pixeles con el ancho
		sub $s2, $s2, 8 #se le resta 8 
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000078
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s2, $s1 #se suma el contador de pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
				
		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060				
		
		li $s1, 0x100000ec
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)						
    		jal addHigh #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
	
	#etiqueta para el procesamiento del pixel de la esquina abajo a la izquierda
	rightCornerDown:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
		sub $s2, $s2, 8 #al resultado anterior se le resta 8
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000060
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000064
		    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000068
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia el contador de los pixeles
		sub $s2, $s2, 8 #se le resta 8 al resultado anterior
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000068
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia el contador de los pixeles
		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
    		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000074
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000078
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000007c
			
		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000080
		
		li $s1, 0x100000f0
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)																																				
    		jal addHigh #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
		
	#etiqueta para el procesamiento de los pixeles de la derecha
	right:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		sub $s2, $s2, 8
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000064 
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		sub $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000068 
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x1000006c
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
		sub $s2, $s2, 8 #se le suma 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000074
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
    		  		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000078
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		add $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		sub $s2, $s2, 8
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x100000 7c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		lw $s2, ($s4) #se carga el ancho en el registro $s2
    		mul $s2, $s2, 8 #se multiplica por 8 el ancho
    		add $s2, $s1, $s2 #se resta el contador de los pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000080 
    		
    		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
    		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000078	
    		
    		li $s1, 0x100000f4
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)		
    		jal addHigh #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
	
	#etiqueta para el procesamiento cuando el contador del ancho es diferente a 1 o al ancho
	differentWidth:
		li $s0, 0x10000004 #direcci�n de memoria donde est� el valor de la altura
		lw $s1, ($s0) #obtengo el valor de la altura
		
		#cuando el contador de la altura es igual a 1
		add $s0, $s0, 8 #direcci�n en memoria (0x10000008) donde est� el contador del altura
		lw $s2, ($s0) #obtengo el valor del ancho
		li $s3, 1 #al registro $t0 se le asigna un 1
		beq $s2, $s3, top #salta si el contador de la altura es igual a 1
		
		#cuando el contador de la altura es igual a la altura
		beq $s1, $s2, down #salta si el contador de la altura es igual a la altura

		j inMiddle #salta si el contador de la altura es diferente a 1 o a la altura
	
	#etiqueta para el procesamiento de los pixeles de arriba
	top:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000064
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000068
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
		sub $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000070
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
		add $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x10000074
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s2, $s1 #se suma el contador de pixeles con el ancho
		sub $s2, $s2, 8 #se le resta 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
				
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s2, $s1 #se suma el contador de pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
    						
		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s2, $s1 #se suma el contador de pixeles con el ancho
		add $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
		
		li $s1, 0x100000f8
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)																																				
    		jal addWidth #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
		
	#etiqueta para el procesamiento de los pixeles de abajo
	down:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
		sub $s2, $s2, 8 #se le resta 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
				
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
    						
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
		add $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		move $s2, $s1 #se copia le contador de pixeles en $s2
		sub $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
		add $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		li $t0, 0 #al registro $t0 se le asigna un 0
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000060
		
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000064
		
		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
		sw $t0, ($s3) #se guarda un 0 en la direcci�n 0x10000068
		
		li $s1, 0x100000fc
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)
		jal addWidth #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
	
	#etiqueta para el procesamiento de los pixeles del medio
	inMiddle:
		li $s3, 0x10000060 #direcci�n en memoria para almacenar los n�meros de de la imagen
		li $s4, 0x10000000 #direcci�n en memoria donde est� el ancho
		add $s1, $s4, 16 #direcci�n en memoria (0x10000010) donde est� el contador de los pixeles
		lw $s1, ($s1) #se cargar el contador de pixeles
		
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
		sub $s2, $s2, 8 #se le resta 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
				
		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		sub $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
		add $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
    						   		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		move $s2, $s1 #se copia le contador de pixeles en $s2
		sub $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		move $s2, $s1 #se copia le contador de pixeles en $s2
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
    		move $s2, $s1 #se copia le contador de pixeles en $s2
		add $s2, $s2, 8 #se resta 8 al contador de pixeles
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000006c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
		sub $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
    		
    		add $s3, $s3, 4 #se suma 4 bits a la direcci�n en memoria
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c
		
		li $s3, 0x10000080 #se carga en el registro la direcci�n 0x10000080
		lw $s2, ($s4) #se carga el ancho de la imagen
		mul $s2, $s2, 8 #se multiplica el ancho por 8
		add $s2, $s1, $s2 #se resta el contador de pixeles con el ancho
		add $s2, $s2, 8 #se le suma 8 al resultado anterior
    		li $s0, 8 #se le asigna a $s0 el contador de bits
    		jal getBinary #salto para obtener el n�mero en la direcci�n de $s2
    		sw $t0, ($s3) #se guarda el n�mero obtenido en la direcci�n 0x1000007c

		li $s1, 0x10000100
    		lw $s2, ($s1)
    		add $s2, $s2, 1
    		sw $s2, ($s1)
		jal addWidth #salto para cambiar los contadores	
    		j convolutionShaperned #salto para realizar la convoluci�n
		
	
	#etiqueta para realizar la convoluci�n entre la imagen y el kernel Shaperned
	convolutionShaperned:
		li $s0, 0x10000060 #direcci�n en memoria donde esta los n�meros
		li $s1, 0x10000020 #direcci�n en memoria donde esta el kernel
		lw $s2, ($s0) #se carga el primer n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el primer n�mero de la matriz del kernel
		mul $s4, $s2, $s3 #se multiplica los dos n�meros
				
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		add $s1, $s1, 4 #se suma 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el segundo n�mero de la matriz de la imagen
		lw $s3, ($s1)  #se carga el segundo n�mero de la matriz del kernel
		mul $s2, $s2, $s3  #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		sub $s1, $s1, 4 #se suma 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el tercer n�mero de la matriz de la imagen
		lw $s3, ($s1)  #se carga el tercer n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		add $s1, $s1, 4 #se suma 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el cuarto n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el cuarto n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		add $s1, $s1, 4 #se suma 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el quinto n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el quinto n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		sub $s1, $s1, 4 #se resta 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el sexto n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el sexto n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		sub $s1, $s1, 4 #se resta 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el septimo n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el septimo n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		add $s0, $s0, 4 #se suma 4 a la direcci�n de los n�meros
		add $s1, $s1, 4 #se suma 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el octavo n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el octavo n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		li $s0, 0x10000080 #direcci�n en memoria donde esta el nuveno n�mero de la imagen
		sub $s1, $s1, 4 #se resta 4 a la direcci�n del kernel
		lw $s2, ($s0) #se carga el noveno n�mero de la matriz de la imagen
		lw $s3, ($s1) #se carga el noveno n�mero de la matriz del kernel
		mul $s2, $s2, $s3 #se multiplica los dos n�meros
		add $s4, $s4, $s2 #se suma al resultado anterior
		
		jal verifyNumber #salto a la etiquera que verifica si en n�mero es menor que 0 o mayor que 255
		jal begin_allocateMemory #salto a la etiqueta que guarda el n�mero en el archivo

	addWidth:
		li $s0, 0x10000000 #direcci�n en memoria donde esta el ancho
		add $s0, $s0, 8
    		lw $s1, ($s0)
    		add $s1, $s1, 1
    		sw $s1, ($s0)
    		
    		add $s0, $s0, 8
    		lw $s1, ($s0)
    		add $s1, $s1, 8
    		sw $s1, ($s0)
    		
    		jr $ra #salto a la siguiente direcci�n donde salto

	addHigh:
		li $s0, 0x10000000 #direcci�n en memoria donde esta el ancho
		add $s0, $s0, 8
    		li $s1, 1
    		sw $s1, ($s0)
    		
    		add $s0, $s0, 4
    		lw $s1, ($s0)
    		add $s1, $s1, 1
    		sw $s1, ($s0)
    		    		
    		add $s0, $s0, 4
    		lw $s1, ($s0)
    		add $s1, $s1, 8
    		sw $s1, ($s0)
    		
    		jr $ra #salto a la siguiente direcci�n donde salto
	
	#etiqueta que verifica si el n�mero es mayor que 255 o menor q 0	
	verifyNumber:
		slti $s2, $s4, 0 #verifica si el n�mero es menor que 0 ($s2=-1 si es menor, $s2=0 si es mayor)
		beq $s2, 1, saveZero #si el n�mero de la convoluci�n es menor que 0
		slti $s2, $s4, 255 #verifica si el n�mero es mayor que 255 ($s2=-1 si es menor, $s2=0 si es mayor)
		beq $s2, 0, saveTop #si el n�mero de la convoluci�n es mayor que 255
		li $s0, 0x10000014 #direcci�n en memoria que se guarda el n�mero
		sw $zero, ($s0)
		sw $s4, ($s0) #si el n�mero no es mayor, ni menor se guarda el n�mero
		jr $ra #salto a la siguiente direcci�n donde salto
	
	#etiqueta para guardar un 0 como n�mero resultado de la convoluci�n
	saveZero:
		li $s0, 0x10000014 #direcci�n en memoria que se guarda el n�mero
		li $s4, 0 #al registro $s4 se le asiga un 0
		sw $zero, ($s0)
		sw $s4, ($s0) #se guarda el n�mero
		jr $ra #salto a la siguiente direcci�n donde salto
	
	#etiqueta para guardar un 255 como n�mero resultado de la convoluci�n
	saveTop:
		li $s0, 0x10000014 #direcci�n en memoria que se guarda el n�mero
		li $s4, 255 #al registro $s4 se le asiga un 255
		sw $zero, ($s0)
		sw $s4, ($s0) #se guarda el n�mero
		jr $ra #salto a la siguiente direcci�n donde salto
	
	#etiquta para obtener el n�mero de 8 bits
	getBinary:
		beq $s0, 0, return #salto a la siguiente direcci�n donde salto
    		lb $t1, buffer($s2) #se obtiene 1 bit del file
    		beq $s0, 8, beginBinary #salto para iniciar la uni�n del n�mero
    		beq $t1, 48, zero #salto para agregar un 0 al n�mero
    		beq $t1, 49, one #salto para agregar un 1 al n�mero  		
	
	#etiqueta que devuelve el PC a la direcci�n donde estaba antes de saltar
	return:
		jr $ra #salto a la siguiente direcci�n donde salto
		
	#etiquta para agregar el primer bit
	beginBinary:
		beq $t1, 48, beginZero #salto para agregar un 0 como primer bit
    		beq $t1,49, beginOne #salto para agregar un 1 como primer bit
    	
    	#etiqueta para agregar un 0 bit al inicio
	beginZero:
		li $t0, 0 #se agrega un 0 a la cadena
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente n�mero
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para agregar un 0
	zero:
		sll $t0, $t0, 1 #se mueve un espacio a la izquierda la cadena del n�mero
		add $t0, $t0, 0 #se suma un 0 a la cadena 
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente n�mero
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para agregar un 1 bit al inicio
	beginOne:
		li $t0, 1 #se agrega un 1 a la cadena
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente n�mero
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para agregar un 1
	one:	
		sll $t0, $t0, 1 #se mueve un espacio a la izquierda la cadena del n�mero
		add $t0, $t0, 1 #se suma un 1 a la cadena
		add $s2, $s2, 1 #se suma un 1 para que avance al siguiente n�mero
		sub $s0, $s0, 1 #se resta un 1 al contador 
		j getBinary #salto al loop donde se obtiene el siguente bit
	
	#etiqueta para obtener el n�mero	
	getNumber:
		li $v0, 5 #llamado al sistema para leer el entero 
		syscall #leer el entero en $v0 desde consola
		jr $ra	#salto a la siguiente direcci�n donde salto
	
	#etiqueta donde se almacena el kernel sharperned en memoria 
	Shaperned_kernel:
		li $s0, 0 #guardamos el n�mero cero en el registro $s0
		li $s1, 0x10000020 #se guarda la direcci�n en memoria 0x10000020 en el registro $s1 
		sw $s0, ($s1) #se guarda en memoria el n�mero 0
		li $s0, -1 #guardamos el n�mero -1 en el registro $s0
		add $s1, $s1, 4 #se aumenta en 4 la direcci�n en memoria 0x100100e0
		sw $s0, ($s1) #se guarda en memoria el n�mero -1
		li $s0, 5 #guardamos el n�mero 5 en el registro $s0
		add $s1, $s1, 4 #se aumenta en 4 la direcci�n en memoria 0x100100e0
		sw $s0, ($s1) #se guarda en memoria el n�mero 5
		jr $ra	#salto a la siguiente direcci�n donde salto
	
	#etiqueta donde se almacena el kernel OverShaperned en memoria	
	OverShaperned_kernel:
		li $s0, 0
		li $s1, 0x10000040
		sw $s0, ($s1)
		li $s0, -1
		add $s1, $s1, 4
		sw $s0, ($s1)
		li $s0, 5
		add $s1, $s1, 4
		sw $s0, ($s1)
		jr $ra	#salto a la siguiente direcci�n donde salto
	
	#etiqueta para asignar memoria en el heap
	begin_allocateMemory:
		li $s0, 0x100000a0 #direcci�n de memoria donde est� en n�mero de la convoluci�n
		li $v0, 9 #llamado al sistema para asignar memoria 
		li $a0, 8 #n�mero de bytes asignar
		syscall #llamado al sistema
		addi $s0, $s0, 8 #guardamos la cantidad de bits del n�mero
		li $s1, 31 #cantidad de espacios que se van a mover a la izquierda
		li $s2, 31 #cantidad de espacios que se van a mover a la derecha
		j allocateMemory #salto para empezar a seleccionar cada uno de los bits de n�meros
	
	#etiqueta para guardar bit por bit de los n�meros
	allocateMemory:
		beq $s1, 23, saveFile #salto para guardar en el archivo
		li $t4, 0x10000014 #direcci�n de memoria donde est� en n�mero de la convoluci�n
		lw $s3, ($t4) #se saca el n�mero de memoria
		sllv $s3, $s3, $s1 #se corre $s1 veces a la izquerda
		srlv $s3, $s3, $s2 #se corre $s2 veces a la derecha
		j checkBit #salto para verificar el primer car�cter del heap
	
	#etiqueta donde se selecciona en cual archivo guardar
	saveFile:
		j openShaperned_file
		#li $t1, 0x100100e0 #direcci�n en memoria donde se selecciona en cual archivo guardar SE TIENE Q CAMBIAR
		#lw $t1, ($t1) #se obtiene el n�mero
		#li $t1, 1
		#beq $t1, 1, openShaperned_file #salto para guardar en el archivo Shaperned
		#beq $t1, 2, openOver_shapernedFile # salto para guardar en el archivo Over shaperned
			
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
		sb $t3, 0($s0) #almacena un byte en la posici�n $s0 del heap
		sub $s0, $s0, 1 #se le quita un 1 a $s0
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria

	#etiqueta para agregar un 1 al inicio del heap
	allocateOne_begin:
 		li $t3, 49 #se guarda un 1 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posici�n $s0 del heap
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria
	
	#etiqueta para agregar un 0 al heap
	allocateZero:
 		li $t3, 48 #se guarda un 0 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posici�n $s0 del heap
		sub $s0, $s0, 1 #se le quita un 1 a $s0
		sub $s1, $s1, 1 #se le quita un 1 al la cantidad de espacios para moverse a la izquierda
		j allocateMemory #salto al loop de guardar en memoria

	#etiqueta para agregar un 0 al inicio del heap 
	allocateZero_begin:
 		li $t3, 48 #se guarda un 8 en formaro de ascii
		sb $t3, 0($s0) #almacena un byte en la posici�n $s0 del heap
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
		la $a1, buffer #tama�o del buffer del archivo
		#se obtiene el ancho y el alto
		li $t0, 0x10000000 #direcci�n de memoria donde est� el ancho
		lw $t1, ($t0) #se obtiene el ancho
		add $t0, $t0, 4 #direcci�n en memoria donde est� el alto
		lw $t2, ($t0) #se obtiene el alto
		mul $t1, $t1, $t2 #se obtiene la cantidad de pixeles de la imagen
		mul $t1, $t1, 8 #se obtiene la cantidad de pixeles en 8 bits 
		la $a2, 0($t1) #tama�o de la cantidad de datos del documentos
		syscall #llamado al sistema 
    		jr $ra	#salto a la siguiente direcci�n donde salto
    	
    	#etiqueta donde escribe el archivo .bin de Shaperned
    	openShaperned_file:
		li   $v0, 13       # system call for open file
		la   $a0, shapernedFile     # output file name
		li   $a1, 9      # Open for writing (flags are 0: read, 1: write)
		#li   $a2, 0        # mode is ignored
		syscall            # open a file (file descriptor returned in $v0)
		move $s6, $v0      # save the file descriptor 

		# Write to file just opened
		li   $v0, 15       # system call for write to file
		move $a0, $s6      # file descriptor 
		move $a1, $s0      # address of buffer from which to write
		li   $a2, 8        # hardcoded buffer length
		syscall            # write to file

		# Close the file 
		li   $v0, 16       # system call for close file
		move $a0, $s6      # file descriptor to close
		syscall 
    		   		
    		j imageProcessor
    	
    	#etiqueta donde escribe el archivo .bin de overshaperned
    	openOver_shapernedFile:
    		#se abre el archivo a leer
		li $v0, 13 #llamado al sistema para abrir el archivo
    		la $a0, over_shapernedFile #se obtiene el nombre del archivo
    		li $a1, 9 #bandera para escribir al final del archivo
    		syscall #llamado al sistema
    		move $s6, $v0 #se guarda el file descriptor en $s6
    		#se escribe en el archivo
    		li $v0, 15 #llamado al sistema para escribir en un archivo
    		move $a0, $s6 #el file descriptor se copia en $a0
    		move $a1, $s0 #direcci�n del buffer desde donde se escribe
    		la $a2, 8 #tama�o de caracteres a escribir
    		syscall #llamado al sistema
    		


	#etiqueta para cerrar los archivos
	closeFile_shaperned:
		li $v0, 16 #llamado al sistema para cerrar el archivo
    		move $a0, $s0 #se cierra el file descriptor
    		syscall #llamado al sistema
    		j imageProcessor
    		
    	#etiqueta para cerrar los archivos
	closeFile:
		li $v0, 16 #llamado al sistema para cerrar el archivo
    		move $a0, $s0 #se cierra el file descriptor
    		syscall #llamado al sistema
    		jr $ra	#salto a la siguiente direcci�n donde salto
    		
	#etiqueta para finalizar el programa		
	end:
		#fin del programa  
		li $v0, 10 #llamado al sistema para terminar el programa
	
