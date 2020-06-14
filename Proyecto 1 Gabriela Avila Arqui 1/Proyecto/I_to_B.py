import cv2
from matplotlib import pyplot as plt
import tkinter as tk
from tkinter import *
import numpy as np

#Función para crear los archivos binarios de la imagen
def pixel(img):
    tamanoImg = img.shape #se obtiene las dimensiones de la imagen
    alto = tamanoImg[0] #se obtiene el alto de la imagen
    altoArchivos = alto // 6 #se divide el alto en 6 para obetener el alto de los rectángulos 
    contadorAlto = 1 #contador del alto de la imagen
    file1 = open("imagen1.bin", "w") #se crear el archivo 1
    file2 = open("imagen2.bin", "w") #se crear el archivo 2
    file3 = open("imagen3.bin", "w") #se crear el archivo 2
    file4 = open("imagen4.bin", "w") #se crear el archivo 4
    file5 = open("imagen5.bin", "w") #se crear el archivo 5
    file6 = open("imagen6.bin", "w") #se crear el archivo 6
    for i in img: #ciclo para el alto
        for j in i: #ciclo para el ancho
            if contadorAlto < altoArchivos: #si el contador del alto es menor que el alto del rectángulo
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file1.write(valor) #se escribe el binario obtenido en el archivo
            #si el contador es igual al alto del rectángulo o si el contador es igual al alto del rectángulo + 1 
            elif (contadorAlto == altoArchivos) or (contadorAlto == (altoArchivos + 1)): 
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file1.write(valor) #se escribe el binario obtenido en el archivo
                file2.write(valor) #se escribe el binario obtenido en el archivo
            elif contadorAlto < (altoArchivos * 2): #si el contador del alto es menor que el alto del rectángulo * 2
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file2.write(valor) #se escribe el binario obtenido en el archivo
            #si el contador es igual al alto del rectángulo o si el contador es igual al alto del rectángulo * 2 + 1
            elif (contadorAlto == (altoArchivos * 2)) or (contadorAlto == ((altoArchivos * 2) + 1)):
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file2.write(valor) #se escribe el binario obtenido en el archivo
                file3.write(valor) #se escribe el binario obtenido en el archivo
            elif contadorAlto < (altoArchivos * 3): #si el contador del alto es menor que el alto del rectángulo * 3
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file3.write(valor) #se escribe el binario obtenido en el archivo
            #si el contador es igual al alto del rectángulo o si el contador es igual al alto del rectángulo * 3 + 1
            elif (contadorAlto == (altoArchivos * 3)) or (contadorAlto == ((altoArchivos * 3) + 1)):
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file3.write(valor) #se escribe el binario obtenido en el archivo
                file4.write(valor) #se escribe el binario obtenido en el archivo
            elif contadorAlto < (altoArchivos * 4): #si el contador del alto es menor que el alto del rectángulo * 4
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file4.write(valor) #se escribe el binario obtenido en el archivo
            #si el contador es igual al alto del rectángulo o si el contador es igual al alto del rectángulo * 4 + 1
            elif (contadorAlto == (altoArchivos * 4)) or (contadorAlto == ((altoArchivos * 4) + 1)):
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file4.write(valor) #se escribe el binario obtenido en el archivo
                file5.write(valor) #se escribe el binario obtenido en el archivo
            elif contadorAlto < (altoArchivos * 5): #si el contador del alto es menor que el alto del rectángulo * 5
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file5.write(valor) #se escribe el binario obtenido en el archivo
            #si el contador es igual al alto del rectángulo o si el contador es igual al alto del rectángulo * 5 + 1
            elif (contadorAlto == (altoArchivos * 5)) or (contadorAlto == ((altoArchivos * 5) + 1)):
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file5.write(valor) #se escribe el binario obtenido en el archivo
                file6.write(valor) #se escribe el binario obtenido en el archivo
            else:
                valor = binario(j) #se obtiene el pixel y se cambia a binario
                file6.write(valor) #se escribe el binario obtenido en el archivo
        contadorAlto = contadorAlto + 1 #al contador se le suma un 1
    file1.close() #se cierra el archivo
    file2.close() #se cierra el archivo
    file3.close() #se cierra el archivo
    file4.close() #se cierra el archivo
    file5.close() #se cierra el archivo
    file6.close() #se cierra el archivo
    print("Analizando la imagen...") #se imprime un mensaje en consola

#Función para cambiar un número a binario
def binario(numero):
    Num_binario = '{0:b}'.format(numero) #se cambia el número decimal a binario
    if (len(Num_binario) < 8): #si el tamaño del binario es menor que 8
        complemento = 8 - len(Num_binario) #se obtiene la diferencia 
        i = 0 #se inicia el contador 0
        while i < complemento: #ciclo
            Num_binario = '0' + Num_binario #se le suena un 0 a la izquierda del número binario
            i = i + 1#se suma un 1 al contador
        return Num_binario #se devuelve en binario de 8 bits
    else: #si el binario si tiene 8 bits
        return Num_binario  #se devuelve en binario de 8 bits
    
########################################### MAIN ################################
root = tk.Tk() #pantalla para seleccionar la imagen
root.withdraw() #se muestra la pantalla
#se arma el path de la imagen
file_path = filedialog.askopenfilename(initialdir="/", title="Seleccione una imagen", filetypes=(("Image file", ("*.png","*.jpg","*.bmp","*.jpeg"))
                                                                                                 ,("all files", "*.*")))
#se abre la imagen
img=cv2.imread(file_path,0)

#se llama a la función donde se guarda el archivo 
pixel(img)



