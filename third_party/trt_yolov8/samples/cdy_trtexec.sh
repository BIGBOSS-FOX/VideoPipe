trtexec \
--onnx=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.onnx \
--saveEngine=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m_trtexec_fp16.engine \
--fp16
trtexec \
--onnx=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.onnx \
--saveEngine=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg_trtexec_fp16.engine \
--fp16
trtexec \
--onnx=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.onnx \
--saveEngine=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose_trtexec_fp16.engine \
--fp16
trtexec \
--onnx=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.onnx \
--saveEngine=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls_trtexec_fp16.engine \
--fp16