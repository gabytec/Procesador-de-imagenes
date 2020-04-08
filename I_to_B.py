import cv2
from matplotlib import pyplot as plt
import tkinter as tk
from tkinter import *
import numpy as np


def pixel(img):
    file = open("imagen.bin", "w")
    for i in img:
        for j in i:
            valor = binario(j)
            file.write(valor)
            j = j + 1
        j = 0
        i = i + 1
    file.close()

def binario(numero):
    Num_binario = "{0:b}".format(numero)
    if (len(Num_binario) < 8):
        complemento = 8 - len(Num_binario)
        i = 0
        while i < complemento:
            Num_binario = '0' + Num_binario
            i = i + 1
        return Num_binario
    else:
        return Num_binario
    
#Main    
root = tk.Tk()
root.withdraw()
file_path = filedialog.askopenfilename(initialdir="/", title="Seleccione una imagen", filetypes=(("Image file", ("*.png","*.jpg","*.gif","*.bmp","*.jpeg"))                                                                                                ,("all files", "*.*")))
#img=cv2.imread(file_path,0)
img=cv2.imread(file_path)
print(img)
pixel(img)
plt.imshow(img, cmap='gray')
plt.xticks([]),plt.yticks([])
plt.show()

#cv2.imwrite("test.jpg", img)


