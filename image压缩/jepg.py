from PIL import Image # pip install pillow
import os

# 读取图片
img = Image.open("../image/1.jpg") #pillow.image.*
print("********************")
print("图片信息:")
print("格式:", img.format) #JPEG
print("宽高:", img.size) #(1920, 1080)
print("模式:", img.mode) #RGB
print("大小:", os.path.getsize("../image/1.jpg")/1024,"KB")



# 压缩并保存为 JPG，quality 越低压缩率越高（1-100）
img.save("compressed.jpg", "JPEG", quality=30)  # 30 是低质量，文件更小
print("********************")
print("压缩后图片信息:")
print("格式:", img.format) #JPEG
print("宽高:", img.size) #(1920, 1080)
print("模式:", img.mode) #RGB
print("大小:", os.path.getsize("compressed.jpg")/1024,"KB") 


# 删除压缩后的图片
os.remove("compressed.jpg")

# python jepg.py