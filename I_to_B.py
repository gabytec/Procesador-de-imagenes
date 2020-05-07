import cv2
from matplotlib import pyplot as plt
import tkinter as tk
from tkinter import *
import numpy as np

#Función para crear el archivo binario de la imagen
def pixel(img):
    file = open("imagen.bin", "w") #se crear el archivo
    for i in img: #ciclo para el alto
        for j in i: #ciclo para el ancho
            valor = binario(j) #se obtiene el pixel y se cambia a binario
            file.write(valor) #se escribe el binario obtenido en el archivo
    file.close() #se cierra el archivo

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
file_path = filedialog.askopenfilename(initialdir="/", title="Seleccione una imagen", filetypes=(("Image file", ("*.png","*.jpg","*.gif","*.bmp","*.jpeg"))
                                                                                                 ,("all files", "*.*")))
#se abre la imagen
img=cv2.imread(file_path,0)

#se llama a la función donde se guarda el archivo 
pixel(img)



