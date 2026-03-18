from PIL import Image
import os

# 打开一张图片（可以是任意格式：jpg, png, bmp...）
input_image_path = "../image/1.jpg"  # 原图，比如是 JPEG
output_image_path = "converted.png"  # 转换为 PNG

# 打开图像
img = Image.open(input_image_path)
print("********************")
print("图片信息:")
print("格式:", img.format) #JPEG
print("宽高:", img.size) #(1920, 1080)
print("模式:", img.mode) #RGB
print("大小:", os.path.getsize("../image/1.jpg")/1024,"KB")
print("********************")

# 转换并保存为新的格式
img.save(output_image_path)  # 根据文件后缀名自动判断格式

print(f"已将 {input_image_path} 转换为 {output_image_path}")
print("********************")
print("转换后图片信息:")
print("格式:", img.format) #PNG 的格式也是jpeg？
print("宽高:", img.size) #(1920, 1080)
print("模式:", img.mode) #RGB
print("大小:", os.path.getsize("converted.png")/1024,"KB")

os.remove(output_image_path)


# python jTp.py
