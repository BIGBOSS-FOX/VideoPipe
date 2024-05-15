# # onnx
# yolo export \
# model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.pt \
# format=onnx
# yolo export \
# model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.pt \
# format=onnx
# yolo export \
# model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.pt \
# format=onnx
# yolo export \
# model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.pt \
# format=onnx

# engine
yolo export \
model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.pt \
format=engine \
half=True
yolo export \
model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.pt \
format=engine \
half=True
yolo export \
model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.pt \
format=engine \
half=True
yolo export \
model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.pt \
format=engine \
half=True