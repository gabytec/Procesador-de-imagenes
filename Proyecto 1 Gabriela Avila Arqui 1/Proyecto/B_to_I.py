import cv2
from matplotlib import pyplot as plt
import tkinter as tk
from tkinter import *
import numpy as np

#Función que obtiene los datos del label
def aceptar():
    global pixeles #variable global para la cantidad total de pixeles
    global alto #variable global de la altura
    global ancho #variable global del ancho
    anchoV = int(ancho.get()) #se obtiene el ancho que ingresó el usuario
    altoV = int(alto.get()) #se obtiene la altura que ingresó el usuario
    pixeles = anchoV * altoV * 8 #total de pixeles 
    alto = altoV #se le asigna el alto del usuario a la variable global
    ancho = anchoV #se le asigna el ancho del usuario a la variable global
    gui.destroy() #se destruye la ventana

#se crea la ventana con las especificaciones dadas
gui = tk.Tk()
gui.title("Datos de la imagen")
gui.geometry('500x400')
gui.configure(background = 'mint cream')
anchoV=tk.StringVar()

#se crea un label para ingresar el ancho de la imagen
label1 = tk.Label(gui, text = "Ingrese el ancho de la imagen", bg = 'mint cream', fg = 'black')
label1.pack(padx=5,pady=4,ipadx=5,ipady=5,fill=tk.X)
ancho = tk.Entry(gui)
ancho.pack(padx=5,pady=5,ipadx=5,ipady=5,fill=tk.X)

#se crea un label para ingresar el alto de la imagen
label2 = tk.Label(gui, text = "Ingrese el alto de la imagen", bg = 'mint cream', fg = 'black')
label2.pack(padx=5,pady=4,ipadx=5,ipady=5,fill=tk.X)
alto = tk.Entry(gui)
alto.pack(padx=5,pady=5,ipadx=5,ipady=5,fill=tk.X)

#acción cuando se apreta en botón de aceptar
Boton = tk.Button(gui, text = "Aceptar", command = aceptar)
Boton.pack(side = tk.TOP)
gui.mainloop()


fileShaperned = open("shaperned.bin", "r") #se abre el archivo de shaperned para leer
file_OverShaperned = open("over_shaperned.bin", "r") #se abre el archivo de overshaperned para leer
matrizShaperned = [] #matriz donde se va a guardar los datos del archivo de shaperned
matriz_OverShaperned = [] #matriz donde se va a guardar los datos del archivo de overshaperned
tamano = 0 #contador del tamaño
print("Aplicando los filtros...") #mesnaje orientativo
for i in range (alto): #ciclo para el anto
    matrizShaperned.append([]) #se agrega una nueva fila
    matriz_OverShaperned.append([]) #se agrega una nueva fila
    for j in range (ancho): #ciclo del ancho
        fileShaperned.seek(tamano) #nos desplazamos en el archivo shaperned
        file_OverShaperned.seek(tamano) #nos desplazamos en el archivo overshaperned
        imprimirS = int(fileShaperned.read(8), 2) #obtenemos el binario de 8 bits y se pasa a entero en el archivo shaperned
        imprimirOS = int(file_OverShaperned.read(8), 2) #obtenemos el binario de 8 bits y se pasa a entero en el archivo overshaperned
        matrizShaperned[i].append(imprimirS) #se agrega a la matriz de shaperned
        matriz_OverShaperned[i].append(imprimirOS) #se agrega a la matriz de overshaperned
        tamano = tamano + 8 #sumamos 8 al contador del tamaño

fileShaperned.close() #se cierra el archivo de shaperned
file_OverShaperned.close() #se cierra el archivo de overshaperned

cv2.imwrite("Shaperned.jpg", np.asarray(matrizShaperned)) #se guarda la imagen de shaperned
cv2.imwrite("OverShaperned.jpg", np.asarray(matriz_OverShaperned)) #se guarda la imagen de overshaperned

print("La imagen ha sido procesada correctamente")#mesnaje orientativo
#ventana donde se va a mostrar las imagenes 
fig = plt.figure()
ax = fig.add_subplot(111)
plt.title("Filtros")
plt.xticks([]),plt.yticks([])
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.spines['bottom'].set_visible(False)
ax.spines['left'].set_visible(False)

#se muestra la imagen de shaperned
ax1 = fig.add_subplot(1,2,1)
ax1.imshow(matrizShaperned, cmap='gray')
plt.title("Shaperned")
plt.xticks([]),plt.yticks([])

#se muestra la imagen de shaperned
ax2 = fig.add_subplot(1,2,2)
ax2.imshow(matriz_OverShaperned, cmap='gray')
plt.title("Overshaperned")
plt.xticks([]),plt.yticks([])

#se muestra en pantalla
plt.show()

