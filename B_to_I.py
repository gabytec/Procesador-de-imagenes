import cv2
from matplotlib import pyplot as plt
import tkinter as tk
from tkinter import *
import numpy as np

print("Ingrese el ancho: ")
ancho = int(input())

print("Ingresa el alto: ")
alto = int(input())

pixeles = ancho * alto * 8

file = open("imagen.bin", "r")
matriz = []
#file.seek(0)
#cur = x = int(file.read(8), 2)
#print(cur)
tamano = 0 
for i in range (alto):
    matriz.append([])
    for j in range (ancho):
        file.seek(tamano)
        imprimir = int(file.read(8), 2)
        matriz[i].append(imprimir)
        tamano = tamano + 8

file.close()
cv2.imwrite("prueba2.jpg", np.asarray(matriz))
plt.imshow(matriz, cmap='gray')
plt.xticks([]),plt.yticks([])
plt.show()
