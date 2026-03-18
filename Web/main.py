# pip install "fastapi[standard]"
# fastapi dev main.py
import jpeg_compress as jpeg_compress
from fastapi import FastAPI # pip install fastapi
from fastapi.middleware.cors import CORSMiddleware

from fastapi import FastAPI, UploadFile, File
from PIL import Image # pip install pillow
import os


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 允许所有来源
    allow_credentials=True,
    allow_methods=["*"],  # 允许所有方法
    allow_headers=["*"],  # 允许所有头
)

@app.get("/test")
async def root():
    return {"message": "Hello World"}

# 图库
@app.get("/gallerys")
async def gallery():
    return {"message": "Hello Gallery"}

@app.post("/api/gallery_compress")
async def gallery_compress(    
    image: UploadFile = File(..., description="上传的图片文件")):  # UploadFile (FastAPI) ≠ Image (PIL)
    # 读取图片
    img = Image.open(image.file)
    image_compressed = jpeg_compress.compress_image(img, 30)
    return image_compressed

# error



    
