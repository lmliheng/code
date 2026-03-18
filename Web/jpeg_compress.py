from PIL import Image # pip install pillow
import os


def compress_image(img, compress_quality):
    # 读取图片
     #pillow.image.*
    print("********************")
    print("图片信息:")
    print("格式:", img.format) #JPEG
    print("宽高:", img.size) #(1920, 1080)
    print("模式:", img.mode) #RGB
     
# 压缩并保存为 JPG，quality 越低压缩率越高（1-100）
    img.save("compressed.jpg", "JPEG", quality=compress_quality)  # 30 是低质量，文件更小
    print("********************")
    print("压缩后图片信息:")
    print("格式:", img.format) #JPEG
    print("宽高:", img.size) #(1920, 1080)
    print("模式:", img.mode) #RGB
    print("大小:", os.path.getsize("compressed.jpg")/1024,"KB") 

    return img # error: `return` return的是压缩后的图片吗，在哪里
# 删除压缩后的图片
# os.remove("compressed.jpg")



if __name__ == "__main__": 

    from PIL import Image
    image_path = "../image/1.jpg"
    compress_quality = 30
    img = Image.open(image_path)

    image_compressed = compress_image(img, compress_quality) # 在内存里面保存了压缩后的图片
    os.remove("compressed.jpg")

    # 保存压缩后的图片
    image_compressed.save("./image/image_compressed.jpg")
    

# python jepg.py
