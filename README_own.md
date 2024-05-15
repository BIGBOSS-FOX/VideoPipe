# 调试记录

## 下载代码

1. Github 原repo上点击fork，然后到自己forked repo上复制git clone信息

2. 下载并创建 `own` branch, 上传到自己forked repo上:

   ```bash
   $ git clone git@github.com:BIGBOSS-FOX/video_pipe_c.git
   $ cd video_pipe_c
   $ git remote rename origin github
   $ git checkout -b own
   $ git push github own
   ```

## 依赖和环境

参考： [doc/env.md](doc/env.md)

### desktop-home

os: Ubuntu 20.04

gpu: RTX3090

> - OpenCV >= 4.6

- [x] 如何确定已安装的OpenCV版本？

  ```bash
  $ pkg-config --modversion opencv4
  4.5.5
  ```

- [x] 卸载老的OpenCV

  ```bash
  # Inside ~/Repos/opencv_build/opencv/build
  $ cmake .
  $ sudo make uninstall
  $ cd ..
  $ rm -rf build
  
  $ pkg-config --modversion opencv4
  Package opencv4 was not found in the pkg-config search path.
  Perhaps you should add the directory containing `opencv4.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'opencv4' found
  ```

- [x] 安装gstreamer (按照desktop-work安装剩余gstreamer相关库)

  ```bash
  # 检查gstreamer版本
  $ gst-launch-1.0 --version
  gst-launch-1.0 version 1.16.3
  GStreamer 1.16.3
  https://launchpad.net/distros/ubuntu/+source/gstreamer1.0
  
  $ sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio libgstrtspserver-1.0-dev gstreamer1.0-rtsp
  
  $ gst-launch-1.0 --version
  gst-launch-1.0 version 1.16.3
  GStreamer 1.22.10
  https://launchpad.net/distros/ubuntu/+source/gstreamer1.0
  ```

- [x] 安装OpenCV (注意`-D CUDA_ARCH_BIN=8.6 -D CUDA_ARCH_PTX=8.6`)

  ```bash
  $ cd ~/Repos/opencv_build/opencv/
  $ git checkout 4.x
  $ git pull
  $ git checkout 4.9.0
  $ cd ~/Repos/opencv_build/opencv_contrib/
  $ git checkout 4.x
  $ git pull
  $ git checkout 4.9.0
  
  $ cd ~/Repos/opencv_build/opencv/
  $ mkdir build && cd build
  $ cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_CUDA=ON -D BUILD_opencv_cudacodec=OFF -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=8.6 -D CUDA_ARCH_PTX=8.6 -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_GSTREAMER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_PC_FILE_NAME=opencv.pc -D OPENCV_ENABLE_NONFREE=ON -D OPENCV_EXTRA_MODULES_PATH=~/Repos/opencv_build/opencv_contrib/modules -D INSTALL_PYTHON_EXAMPLES=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_EXAMPLES=ON ..
  $ make -j$(nproc)
  $ sudo make install
  $ sudo ldconfig
  ```
  
- [x] 配置CUDA, CUDNN, TensorRT(~~不要有`CPATH`? 容易造成找不到<cuda.h>~~)

  ```bash
  $ sudo ln -s /home/cdy/TensorRT-8.6.1.6 /usr/local/tensorRT
  ```

  ```bash
  # Inside ~/.bashrc
  
  # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/home/cdy/TensorRT-8.6.1.6/lib
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/tensorRT/lib:/usr/local/lib
  # export PATH=$PATH:/bin:/usr/bin:/usr/local/cuda/bin:/home/cdy/TensorRT-8.6.1.6/bin
  export PATH=$PATH:/bin:/usr/bin:/usr/local/cuda/bin:/usr/local/tensorRT/bin
  export CPATH=$CPATH:/usr/local/cuda/include:/usr/local/tensorRT/include
  export CUDA_PATH=/usr/local/cuda
  export CUDA_HOME=/usr/local/cuda
  export CUDNN_INCLUDE_PATH=/usr/local/cuda/include
  ```

  ```bash
  $ source ~/.bashrc
  ```



### desktop-work

os: Ubuntu 20.04

gpu: RTX3060

- [x] 安装OpenCV, gstreamer（~~方式和desktop-home一样~~, 暂时不安装`libgstreamer-plugins-bad1.0-dev`）

  ```bash
  $ sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio libgstrtspserver-1.0-dev gstreamer1.0-rtsp
  ```

- [x] 配置CUDA, CUDNN, TensorRT

  ```bash
  $ sudo ln -s /home/cdy/Downloads/TensorRT-8.4.3.1.Linux.x86_64-gnu.cuda-11.6.cudnn8.4/TensorRT-8.4.3.1 /usr/local/tensorRT
  ```

  ```bash
  # Inside ~/.bashrc
  
  # export PATH=/usr/local/cuda/bin:$PATH:/home/cdy/Downloads/TensorRT-8.4.3.1.Linux.x86_64-gnu.cuda-11.6.cudnn8.4/TensorRT-8.4.3.1/bin
  # export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda-11.3/lib64:/usr/local/cuda-11.1/lib64:$LD_LIBRARY_PATH:/home/cdy/Downloads/TensorRT-8.4.3.1.Linux.x86_64-gnu.cuda-11.6.cudnn8.4/TensorRT-8.4.3.1/lib
  # export CPATH=$CPATH:/usr/local/cuda/include:/home/cdy/Downloads/TensorRT-8.4.3.1.Linux.x86_64-gnu.cuda-11.6.cudnn8.4/TensorRT-8.4.3.1/include
  # export CUDA_HOME=/usr/local/cuda-11.3
  
  # export PATH=$PATH:/usr/local/cuda/bin:/usr/local/tensorRT/bin
  # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tensorRT/lib:/usr/local/cuda/lib64:/usr/local/lib
  # export CPATH=$CPATH:/usr/local/cuda/include:/usr/local/tensorRT/include
  # export CUDA_HOME=/usr/local/cuda-11.3
  
  export PATH=$PATH:/usr/local/cuda/bin:/usr/local/tensorRT/bin
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tensorRT/lib:/usr/local/cuda/lib64:/usr/local/lib
  export CPATH=$CPATH:/usr/local/cuda/include:/usr/local/tensorRT/include
  # export CUDA_HOME=/usr/local/cuda-11.3
  export CUDA_PATH=/usr/local/cuda
  export CUDA_HOME=/usr/local/cuda
  ```
  
  ```bash
  $ source ~/.bashrc
  ```
  

## 编译

### desktop-work

```bash
$ cd ~/Data_HDD/Projects/video_pipe_c
$ mkdir build && cd build
$ cmake -DVP_WITH_CUDA=ON -DVP_WITH_TRT=ON -DVP_BUILD_COMPLEX_SAMPLES=OFF ..
$ make -j$(nproc)
```

## 运行

### desktop-work

将`vp_data`下载放入`~/Data_HDD/Projects/video_pipe_c`

```bash
$ cd ~/Data_HDD/Projects/video_pipe_c
$ build/bin/1-1-1_sample
[2024-04-15 19:51:53.946][Info ] [file_src_0] [filesrc location=./vp_data/test_video/face.mp4 ! qtdemux ! h264parse ! avdec_h264 ! videoconvert ! appsink]
[2024-04-15 19:51:54.071][Info ] [screen_des_0] [appsrc ! videoconvert ! videoscale ! textoverlay text=screen_des_0 halignment=left valignment=top font-desc='Sans,16' shaded-background=true ! timeoverlay halignment=right valignment=top font-desc='Sans,16' shaded-background=true ! queue ! fpsdisplaysink video-sink=ximagesink sync=false]
[2024-04-15 19:51:54.072][Info ] 
############# pipe check summary ##############
 total layers: 5
 layer index,       node names
 1                    file_src_0,
 2                    yunet_face_detector_0,
 3                    sface_face_encoder_0,
 4                    osd_0,
 5                    screen_des_0,
############# pipe check summary ##############

Gtk-Message: 19:51:54.088: Failed to load module "canberra-gtk-module"
[ WARN:1@0.219] global cap_gstreamer.cpp:1750 open OpenCV | GStreamer warning: frame count is estimated by duration and fps
[2024-04-15 19:51:54.137][Debug] [file_src_0] before dispatching meta, out_queue.size()==>1
[2024-04-15 19:51:54.137][Debug] [file_src_0] after handling meta, out_queue.size()==>1
[2024-04-15 19:51:54.138][Debug] [yunet_face_detector_0] before meta flow, in_queue.size()==>0
[2024-04-15 19:51:54.138][Debug] [yunet_face_detector_0] after meta flow, in_queue.size()==>1
[2024-04-15 19:51:54.138][Debug] [yunet_face_detector_0] before handling meta, in_queue.size()==>1
[2024-04-15 19:51:54.138][Debug] [file_src_0] after dispatching meta, out_queue.size()==>0
[2024-04-15 19:51:54.176][Debug] [file_src_0] after handling meta, out_queue.size()==>1
[2024-04-15 19:51:54.176][Debug] [file_src_0] before dispatching meta, out_queue.size()==>1
[2024-04-15 19:51:54.176][Debug] [yunet_face_detector_0] before meta flow, in_queue.size()==>1
[2024-04-15 19:51:54.176][Debug] [yunet_face_detector_0] after meta flow, in_queue.size()==>2
[2024-04-15 19:51:54.177][Debug] [file_src_0] after dispatching meta, out_queue.size()==>0
[2024-04-15 19:51:54.215][Debug] [file_src_0] after handling meta, out_queue.size()==>1
[2024-04-15 19:51:54.215][Debug] [file_src_0] before dispatching meta, out_queue.size()==>1
[2024-04-15 19:51:54.216][Debug] [yunet_face_detector_0] before meta flow, in_queue.size()==>2
[2024-04-15 19:51:54.216][Debug] [yunet_face_detector_0] after meta flow, in_queue.size()==>3
[2024-04-15 19:51:54.216][Debug] [file_src_0] after dispatching meta, out_queue.size()==>0
terminate called after throwing an instance of 'cv::Exception'
  what():  OpenCV(4.9.0) /home/cdy/Data_HDD/Projects/opencv_build/opencv/modules/dnn/src/op_cuda.cpp:30: error: (-216:No CUDA support) OpenCV was not built to work with the selected device. Please check CUDA_ARCH_PTX or CUDA_ARCH_BIN in your build configuration. in function 'initCUDABackend'

已放弃 (核心已转储)
```

原因可能是：https://github.com/opencv/opencv/issues/20706

原因已确定：OpenCV编译时`CUDA_ARCH_BIN`和`CUDA_ARCH_PTX`需按照GPU算力进行相应设置(3060 3090皆为8.6)

## 生成Doxygen文档

https://zhuanlan.zhihu.com/p/571965687

```bash
$ sudo apt install graphviz    # 用于生成代码关系图 
$ sudo apt install doxygen
# In project root
$ doxygen -g Doxygen.config
```

```bash
# 修改配置文件 Doxygen.config
EXTRACT_ALL            = YES
HAVE_DOT               = YES
UML_LOOK               = YES
RECURSIVE              = YES 
```

```bash
# 根据代码生成文档 (用浏览器打开`./html/index.html`)
$ doxygen Doxygen.config
```

## clion 编译问题

```bash
/usr/local/bin/cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DVP_WITH_CUDA=ON -DVP_WITH_TRT=ON -DVP_BUILD_COMPLEX_SAMPLES=OFF .. -G "CodeBlocks - Unix Makefiles" -S /home/cdy/Data_HDD/Projects/video_pipe_c -B /home/cdy/Data_HDD/Projects/video_pipe_c/cmake-build-debug-system
-- The C compiler identification is GNU 9.4.0
-- The CXX compiler identification is GNU 9.4.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Failed
-- Looking for pthread_create in pthreads
-- Looking for pthread_create in pthreads - not found
-- Looking for pthread_create in pthread
-- Looking for pthread_create in pthread - found
-- Found Threads: TRUE  
-- Found CUDA: /usr/local/cuda (found suitable exact version "11.3") 
-- Found OpenCV: /usr/local (found version "4.9.0") 
-- OpenCV library status:
--     version: 4.9.0
--     libraries: opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_alphamat;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cudaarithm;opencv_cudabgsegm;opencv_cudafeatures2d;opencv_cudafilters;opencv_cudaimgproc;opencv_cudalegacy;opencv_cudaobjdetect;opencv_cudaoptflow;opencv_cudastereo;opencv_cudawarping;opencv_cudev;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_intensity_transform;opencv_line_descriptor;opencv_mcc;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_rapid;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_wechat_qrcode;opencv_xfeatures2d;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto
--     include path: /usr/local/include/opencv4
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.29.1") 
-- Checking for module 'gstreamer-1.0'
--   Found gstreamer-1.0, version 1.22.10
-- Checking for module 'gstreamer-app-1.0'
--   Found gstreamer-app-1.0, version 1.22.10
-- Checking for module 'gstreamer-rtsp-server-1.0'
--   Found gstreamer-rtsp-server-1.0, version 1.16.2
-- GStreamer library status:
--     version: 1.22.10
--     libraries: gstreamer-1.0;gobject-2.0;glib-2.0 gstapp-1.0;gstbase-1.0;gstreamer-1.0;gobject-2.0;glib-2.0 gstrtspserver-1.0;gstbase-1.0;gstreamer-1.0;gobject-2.0;glib-2.0
--     include path: /usr/include/gstreamer-1.0;/usr/include/x86_64-linux-gnu;/usr/include/glib-2.0;/usr/lib/x86_64-linux-gnu/glib-2.0/include
-------------start build trt_vehicle--------------
-- Found CUDA: /usr/local/cuda (found version "11.3") 
-- CUDA library status:
--     version: 11.3
--     libraries: /usr/local/cuda/lib64/libcudart_static.a;Threads::Threads;dl;/usr/lib/x86_64-linux-gnu/librt.so
--     include path: /usr/local/cuda/include
-- OpenCV library status:
--     version: 4.9.0
--     libraries: opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_alphamat;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cudaarithm;opencv_cudabgsegm;opencv_cudafeatures2d;opencv_cudafilters;opencv_cudaimgproc;opencv_cudalegacy;opencv_cudaobjdetect;opencv_cudaoptflow;opencv_cudastereo;opencv_cudawarping;opencv_cudev;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_intensity_transform;opencv_line_descriptor;opencv_mcc;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_rapid;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_wechat_qrcode;opencv_xfeatures2d;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto;opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_alphamat;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cudaarithm;opencv_cudabgsegm;opencv_cudafeatures2d;opencv_cudafilters;opencv_cudaimgproc;opencv_cudalegacy;opencv_cudaobjdetect;opencv_cudaoptflow;opencv_cudastereo;opencv_cudawarping;opencv_cudev;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_intensity_transform;opencv_line_descriptor;opencv_mcc;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_rapid;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_wechat_qrcode;opencv_xfeatures2d;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto
--     include path: /usr/local/include/opencv4
-- TensorRT library status:
--     include path: /usr/local/tensorRT/include
--     library path: /usr/local/tensorRT/lib
--------------end build trt_vehicle---------------
-------------start build tinyexpr--------------
--------------end build tinyexpr---------------
start build for simple samples...
-- Configuring done (0.8s)
-- Generating done (0.2s)
-- Build files have been written to: /home/cdy/Data_HDD/Projects/video_pipe_c/cmake-build-debug-system

[Finished]
```

```bash
/usr/local/bin/cmake --build /home/cdy/Data_HDD/Projects/video_pipe_c/cmake-build-debug-system --target 1-1-1_sample -- -j 18
```

```bash
$ /usr/local/bin/cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM=/usr/bin/make -DVP_WITH_CUDA=ON -DVP_WITH_TRT=ON -DVP_BUILD_COMPLEX_SAMPLES=OFF .. -G "CodeBlocks - Unix Makefiles" -S /home/cdy/Data_HDD/Projects/video_pipe_c -B /home/cdy/Data_HDD/Projects/video_pipe_c/build_3rd
-- The C compiler identification is GNU 9.4.0
-- The CXX compiler identification is GNU 9.4.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Failed
-- Looking for pthread_create in pthreads
-- Looking for pthread_create in pthreads - not found
-- Looking for pthread_create in pthread
-- Looking for pthread_create in pthread - found
-- Found Threads: TRUE  
-- Found CUDA: /usr/local/cuda (found suitable exact version "11.3") 
-- Found OpenCV: /usr/local (found version "4.9.0") 
-- OpenCV library status:
--     version: 4.9.0
--     libraries: opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_alphamat;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cudaarithm;opencv_cudabgsegm;opencv_cudafeatures2d;opencv_cudafilters;opencv_cudaimgproc;opencv_cudalegacy;opencv_cudaobjdetect;opencv_cudaoptflow;opencv_cudastereo;opencv_cudawarping;opencv_cudev;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_intensity_transform;opencv_line_descriptor;opencv_mcc;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_rapid;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_wechat_qrcode;opencv_xfeatures2d;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto
--     include path: /usr/local/include/opencv4
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.29.1") 
-- Checking for module 'gstreamer-1.0'
--   Found gstreamer-1.0, version 1.22.10
-- Checking for module 'gstreamer-app-1.0'
--   Found gstreamer-app-1.0, version 1.22.10
-- Checking for module 'gstreamer-rtsp-server-1.0'
--   Found gstreamer-rtsp-server-1.0, version 1.16.2
-- GStreamer library status:
--     version: 1.22.10
--     libraries: gstreamer-1.0;gobject-2.0;glib-2.0 gstapp-1.0;gstbase-1.0;gstreamer-1.0;gobject-2.0;glib-2.0 gstrtspserver-1.0;gstbase-1.0;gstreamer-1.0;gobject-2.0;glib-2.0
--     include path: /usr/include/gstreamer-1.0;/usr/include/x86_64-linux-gnu;/usr/include/glib-2.0;/usr/lib/x86_64-linux-gnu/glib-2.0/include
-------------start build trt_vehicle--------------
-- Found CUDA: /usr/local/cuda (found version "11.3") 
-- CUDA library status:
--     version: 11.3
--     libraries: /usr/local/cuda/lib64/libcudart_static.a;Threads::Threads;dl;/usr/lib/x86_64-linux-gnu/librt.so
--     include path: /usr/local/cuda/include
-- OpenCV library status:
--     version: 4.9.0
--     libraries: opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_alphamat;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cudaarithm;opencv_cudabgsegm;opencv_cudafeatures2d;opencv_cudafilters;opencv_cudaimgproc;opencv_cudalegacy;opencv_cudaobjdetect;opencv_cudaoptflow;opencv_cudastereo;opencv_cudawarping;opencv_cudev;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_intensity_transform;opencv_line_descriptor;opencv_mcc;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_rapid;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_wechat_qrcode;opencv_xfeatures2d;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto;opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_gapi;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_alphamat;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_cudaarithm;opencv_cudabgsegm;opencv_cudafeatures2d;opencv_cudafilters;opencv_cudaimgproc;opencv_cudalegacy;opencv_cudaobjdetect;opencv_cudaoptflow;opencv_cudastereo;opencv_cudawarping;opencv_cudev;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_intensity_transform;opencv_line_descriptor;opencv_mcc;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_rapid;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_wechat_qrcode;opencv_xfeatures2d;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto
--     include path: /usr/local/include/opencv4
-- TensorRT library status:
--     include path: /usr/local/tensorRT/include
--     library path: /usr/local/tensorRT/lib
--------------end build trt_vehicle---------------
-------------start build tinyexpr--------------
--------------end build tinyexpr---------------
start build for simple samples...
-- Configuring done (0.9s)
-- Generating done (0.2s)
-- Build files have been written to: /home/cdy/Data_HDD/Projects/video_pipe_c/build_3rd
```

```bash
/usr/local/bin/cmake --build /home/cdy/Data_HDD/Projects/video_pipe_c/build_3rd --target 1-1-1_sample -- -j 18
```



## samples阅读

### trt_yolov8_sample

#### 首先尝试`./third_party/trt_yolov8/README.md`里的模型转换方式

1. 建`./vp_data/models/cdy/`目录，专门存放自己的weights，将yolov8m相关的`.pt`放入

2. 模型转换`.pt -> .wts -> .engine`:

   2.1 `.pt -> .wts`:

   ```bash
   # in ./third_party/trt_yolov8/samples/
   $ python gen_wts.py -w /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.pt -o /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.wts -t detect
   
   $ python gen_wts.py -w /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.pt -o /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.wts -t seg
   
   $ python gen_wts.py -w /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.pt -o /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.wts
   
   $ python gen_wts.py -w /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.pt -o /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.wts -t cls
   ```

   2.2 单独编译`./third_party/trt_yolov8/CMakeLists.txt`:

   ```bash
   # in ./third_party/trt_yolov8/
   $ mkdir build && cd build
   $ cmake ..
   $ make -j$(nproc)
   ```

   2.3 `.wts -> .engine`:

   ```bash
   # in ./third_party/trt_yolov8/build/samples/
   $ ./trt_yolov8_wts_2_engine -det /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m_w2e.engine m
   
   $ ./trt_yolov8_wts_2_engine -seg /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg_w2e.engine m
   
   $ ./trt_yolov8_wts_2_engine -pose /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose_w2e.engine m
   [05/14/2024-20:33:17] [E] [TRT] 3: (Unnamed Layer* 343) [Convolution]:kernel weights has count 192 but 15360 was expected
   [05/14/2024-20:33:17] [E] [TRT] 4: (Unnamed Layer* 343) [Convolution]: count of 192 weights in kernel, but kernel dimensions (1,1) with 192 input channels, 80 output channels and 1 groups were specified. Expected Weights count is 192 * 1*1 * 80 / 1 = 15360
   [05/14/2024-20:33:17] [E] [TRT] 4: [convolutionNode.cpp::computeOutputExtents::43] Error Code 4: Internal Error ((Unnamed Layer* 343) [Convolution]: number of kernel weights does not match tensor dimensions)
   浮点数例外 (核心已转储)
   
   $ ./trt_yolov8_wts_2_engine -cls /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m_w2e-cls.engine m
   ```


#### 因为pose的engine无法顺利导出，先运行det和seg的sample

1. 将`./samples/trt_yolov8_sample.cpp`改写成`./samples/cdy_trt_yolov8_det_sample.cpp`和`./samples/cdy_trt_yolov8_seg_sample.cpp`

2. `./samples/CMakeLists.txt`中添加相应内容

3. 编译：

   ```bash
   # in ./build/
   $ make
   ```

4. 运行：

   ```bash
   # in ./
   $ ./build/bin/cdy_trt_yolov8_det_sample
   
   $ ./build/bin/cdy_trt_yolov8_seg_sample
   ```

   均成功跑通

#### 尝试ultralytics官方导出`.engine`的方式

1. 编写`./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh`:

   ```python
   # in ./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh
   # engine
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.pt \
   format=engine
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.pt \
   format=engine
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.pt \
   format=engine
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.pt \
   format=engine
   ```

2. 执行`./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh`:

   ```bash
   # in ./third_party/trt_yolov8/samples/
   $ sh cdy_ultralytics_export.sh
   ```

   会在`/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/`下生成相应的`.onnx`和`.engine`文件

3. 修改`./samples/cdy_trt_yolov8_det_sample.cpp`和`./samples/cdy_trt_yolov8_seg_sample.cpp`中的`.engine`路径，重新编译并运行，结果报错：

   ```bash
   $ ./build/bin/cdy_trt_yolov8_det_sample 
   [2024-05-15 10:15:51.155][Info ][7fb608e24000][/home/cdy/Data_HDD/Projects/VideoPipe/nodes/vp_file_src_node.cpp:21] [file_src_0] [filesrc location=./vp_data/test_video/face2.mp4 ! qtdemux ! h264parse ! avdec_h264 ! videoconvert ! appsink]
   [2024-05-15 10:15:51.156][Warn ][7fb608e24000][/home/cdy/Data_HDD/Projects/VideoPipe/nodes/vp_infer_node.cpp:43] [yolo8_detector] cv::dnn::readNet load network failed!
   [05/15/2024-10:15:51] [E] [TRT] 1: [stdArchiveReader.cpp::StdArchiveReader::30] Error Code 1: Serialization (Serialization assertion magicTagRead == kMAGIC_TAG failed.Magic tag does not match)
   [05/15/2024-10:15:51] [E] [TRT] 4: [runtime.cpp::deserializeCudaEngine::50] Error Code 4: Internal Error (Engine deserialization failed.)
   cdy_trt_yolov8_det_sample: /home/cdy/Data_HDD/Projects/VideoPipe/third_party/trt_yolov8/trt_yolov8_detector.cpp:52: void trt_yolov8::trt_yolov8_detector::deserialize_engine(std::string&, nvinfer1::IRuntime**, nvinfer1::ICudaEngine**, nvinfer1::IExecutionContext**): Assertion `*engine' failed.
   已放弃 (核心已转储)
   ```

   原因极大可能是没有指定fp16，因为导出的`.engine`文件都偏大

#### 尝试ultralytics官方导出`.onnx`后，使用trtexec再导出`.engine`

1. 修改`./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh`:

   ```bash
   # in ./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh
   # onnx
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.pt \
   format=onnx
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.pt \
   format=onnx
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.pt \
   format=onnx
   yolo export \
   model=/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.pt \
   format=onnx
   ```

2. 执行`./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh`:

   ```bash
   # in ./third_party/trt_yolov8/samples/
   $ sh cdy_ultralytics_export.sh
   ```

   会在`/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/`下生成相应的`.onnx`文件

3. 编写`./third_party/trt_yolov8/samples/cdy_trtexec.sh`:

   ```bash
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
   ```

4. 执行`./third_party/trt_yolov8/samples/cdy_trtexec.sh`:

   ```bash
   # in ./third_party/trt_yolov8/samples/
   $ sh cdy_trtexec.sh
   ```

   会在`/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/`下生成相应的`.engine`文件

5. 修改`./samples/cdy_trt_yolov8_det_sample.cpp`和`./samples/cdy_trt_yolov8_seg_sample.cpp`中的`.engine`路径，重新编译并运行，结果报错：

   ```bash
   # in ./
   $ ./build/bin/cdy_trt_yolov8_det_sample 
   ...
   [05/15/2024-11:20:34] [E] [TRT] 3: Cannot find binding of given name: output
   cdy_trt_yolov8_det_sample: /home/cdy/Data_HDD/Projects/VideoPipe/third_party/trt_yolov8/trt_yolov8_detector.cpp:67：void trt_yolov8::trt_yolov8_detector::prepare_buffer(nvinfer1::ICudaEngine*, float**, float**, float**, float**, float**, std::string): 假设 ‘outputIndex == 1’ 失败。
   已放弃 (核心已转储)
   
   $ ./build/bin/cdy_trt_yolov8_seg_sample 
   ...
   [05/15/2024-11:20:56] [E] [TRT] 3: Cannot find binding of given name: output
   [05/15/2024-11:20:56] [E] [TRT] 3: Cannot find binding of given name: proto
   cdy_trt_yolov8_seg_sample: /home/cdy/Data_HDD/Projects/VideoPipe/third_party/trt_yolov8/trt_yolov8_seg_detector.cpp:102：void trt_yolov8::trt_yolov8_seg_detector::prepare_buffer(nvinfer1::ICudaEngine*, float**, float**, float**, float**, float**, float**, float**, std::string): 假设 ‘outputIndex == 1’ 失败。
   已放弃 (核心已转储)
   ```

   原因是binding的name不一致

#### 尝试ultralytics官方导出fp16`.engine`

1. 修改并运行`./third_party/trt_yolov8/samples/cdy_ultralytics_export.sh`:

   ```bash
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
   ```

   ```bash
   # in ./third_party/trt_yolov8/samples/
   $ sh cdy_ultralytics_export.sh
   
   # det
   PyTorch: starting from '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.pt' with input shape (1, 3, 640, 640) BCHW and output shape(s) (1, 84, 8400) (49.7 MB)
   
   ONNX: starting export with onnx 1.14.1 opset 15...
   ONNX: simplifying with onnxsim 0.4.36...
   ONNX: export success ✅ 9.1s, saved as '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.onnx' (98.9 MB)
   
   TensorRT: starting export with TensorRT 8.4.3.1...
   [05/15/2024-13:22:49] [TRT] [I] [MemUsageChange] Init CUDA: CPU +319, GPU +0, now: CPU 3525, GPU 2855 (MiB)
   [05/15/2024-13:22:50] [TRT] [I] [MemUsageChange] Init builder kernel library: CPU +327, GPU +104, now: CPU 3871, GPU 2959 (MiB)
   [05/15/2024-13:22:50] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:22:50] [TRT] [I] Input filename:   /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.onnx
   [05/15/2024-13:22:50] [TRT] [I] ONNX IR version:  0.0.8
   [05/15/2024-13:22:50] [TRT] [I] Opset version:    15
   [05/15/2024-13:22:50] [TRT] [I] Producer name:    pytorch
   [05/15/2024-13:22:50] [TRT] [I] Producer version: 1.12.1
   [05/15/2024-13:22:50] [TRT] [I] Domain:           
   [05/15/2024-13:22:50] [TRT] [I] Model version:    0
   [05/15/2024-13:22:50] [TRT] [I] Doc string:       
   [05/15/2024-13:22:50] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:22:50] [TRT] [W] onnx2trt_utils.cpp:369: Your ONNX model has been generated with INT64 weights, while TensorRT does not natively support INT64. Attempting to cast down to INT32.
   TensorRT: input "images" with shape(1, 3, 640, 640) DataType.FLOAT
   TensorRT: output "output0" with shape(1, 84, 8400) DataType.FLOAT
   TensorRT: building FP16 engine as /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.engine
   
   # seg
   PyTorch: starting from '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.pt' with input shape (1, 3, 640, 640) BCHW and output shape(s) ((1, 116, 8400), (1, 32, 160, 160)) (52.4 MB)
   
   ONNX: starting export with onnx 1.14.1 opset 15...
   ONNX: simplifying with onnxsim 0.4.36...
   ONNX: export success ✅ 10.1s, saved as '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.onnx' (104.2 MB)
   
   TensorRT: starting export with TensorRT 8.4.3.1...
   [05/15/2024-13:30:10] [TRT] [I] [MemUsageChange] Init CUDA: CPU +318, GPU +0, now: CPU 3530, GPU 2860 (MiB)
   [05/15/2024-13:30:11] [TRT] [I] [MemUsageChange] Init builder kernel library: CPU +326, GPU +104, now: CPU 3876, GPU 2971 (MiB)
   [05/15/2024-13:30:12] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:30:12] [TRT] [I] Input filename:   /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.onnx
   [05/15/2024-13:30:12] [TRT] [I] ONNX IR version:  0.0.8
   [05/15/2024-13:30:12] [TRT] [I] Opset version:    15
   [05/15/2024-13:30:12] [TRT] [I] Producer name:    pytorch
   [05/15/2024-13:30:12] [TRT] [I] Producer version: 1.12.1
   [05/15/2024-13:30:12] [TRT] [I] Domain:           
   [05/15/2024-13:30:12] [TRT] [I] Model version:    0
   [05/15/2024-13:30:12] [TRT] [I] Doc string:       
   [05/15/2024-13:30:12] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:30:12] [TRT] [W] onnx2trt_utils.cpp:369: Your ONNX model has been generated with INT64 weights, while TensorRT does not natively support INT64. Attempting to cast down to INT32.
   TensorRT: input "images" with shape(1, 3, 640, 640) DataType.FLOAT
   TensorRT: output "output0" with shape(1, 116, 8400) DataType.FLOAT
   TensorRT: output "output1" with shape(1, 32, 160, 160) DataType.FLOAT
   TensorRT: building FP16 engine as /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.engine
   
   # pose
   PyTorch: starting from '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.pt' with input shape (1, 3, 640, 640) BCHW and output shape(s) (1, 56, 8400) (50.8 MB)
   
   ONNX: starting export with onnx 1.14.1 opset 15...
   ONNX: simplifying with onnxsim 0.4.36...
   ONNX: export success ✅ 9.4s, saved as '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.onnx' (101.1 MB)
   
   TensorRT: starting export with TensorRT 8.4.3.1...
   [05/15/2024-13:37:55] [TRT] [I] [MemUsageChange] Init CUDA: CPU +319, GPU +0, now: CPU 3527, GPU 2762 (MiB)
   [05/15/2024-13:37:56] [TRT] [I] [MemUsageChange] Init builder kernel library: CPU +327, GPU +104, now: CPU 3873, GPU 2866 (MiB)
   [05/15/2024-13:37:56] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:37:56] [TRT] [I] Input filename:   /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.onnx
   [05/15/2024-13:37:56] [TRT] [I] ONNX IR version:  0.0.8
   [05/15/2024-13:37:56] [TRT] [I] Opset version:    15
   [05/15/2024-13:37:56] [TRT] [I] Producer name:    pytorch
   [05/15/2024-13:37:56] [TRT] [I] Producer version: 1.12.1
   [05/15/2024-13:37:56] [TRT] [I] Domain:           
   [05/15/2024-13:37:56] [TRT] [I] Model version:    0
   [05/15/2024-13:37:56] [TRT] [I] Doc string:       
   [05/15/2024-13:37:56] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:37:56] [TRT] [W] onnx2trt_utils.cpp:369: Your ONNX model has been generated with INT64 weights, while TensorRT does not natively support INT64. Attempting to cast down to INT32.
   TensorRT: input "images" with shape(1, 3, 640, 640) DataType.FLOAT
   TensorRT: output "output0" with shape(1, 56, 8400) DataType.FLOAT
   TensorRT: building FP16 engine as /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.engine
   
   # cls
   PyTorch: starting from '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.pt' with input shape (1, 3, 224, 224) BCHW and output shape(s) (1, 1000) (32.7 MB)
   
   ONNX: starting export with onnx 1.14.1 opset 15...
   ONNX: simplifying with onnxsim 0.4.36...
   ONNX: export success ✅ 6.5s, saved as '/home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.onnx' (65.1 MB)
   
   TensorRT: starting export with TensorRT 8.4.3.1...
   [05/15/2024-13:46:52] [TRT] [I] [MemUsageChange] Init CUDA: CPU +319, GPU +0, now: CPU 3430, GPU 2651 (MiB)
   [05/15/2024-13:46:54] [TRT] [I] [MemUsageChange] Init builder kernel library: CPU +327, GPU +104, now: CPU 3776, GPU 2755 (MiB)
   [05/15/2024-13:46:54] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:46:54] [TRT] [I] Input filename:   /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.onnx
   [05/15/2024-13:46:54] [TRT] [I] ONNX IR version:  0.0.8
   [05/15/2024-13:46:54] [TRT] [I] Opset version:    15
   [05/15/2024-13:46:54] [TRT] [I] Producer name:    pytorch
   [05/15/2024-13:46:54] [TRT] [I] Producer version: 1.12.1
   [05/15/2024-13:46:54] [TRT] [I] Domain:           
   [05/15/2024-13:46:54] [TRT] [I] Model version:    0
   [05/15/2024-13:46:54] [TRT] [I] Doc string:       
   [05/15/2024-13:46:54] [TRT] [I] ----------------------------------------------------------------
   [05/15/2024-13:46:54] [TRT] [W] onnx2trt_utils.cpp:369: Your ONNX model has been generated with INT64 weights, while TensorRT does not natively support INT64. Attempting to cast down to INT32.
   TensorRT: input "images" with shape(1, 3, 224, 224) DataType.FLOAT
   TensorRT: output "output0" with shape(1, 1000) DataType.FLOAT
   TensorRT: building FP16 engine as /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.engine
   
   ```

2. 修改`./samples/cdy_trt_yolov8_det_sample.cpp`和`./samples/cdy_trt_yolov8_seg_sample.cpp`中的`.engine`路径，重新编译并运行，结果报错：

   ```bash
   # in ./
   $ ./build/bin/cdy_trt_yolov8_det_sample
   ...
   [05/15/2024-13:56:42] [E] [TRT] 1: [stdArchiveReader.cpp::StdArchiveReader::30] Error Code 1: Serialization (Serialization assertion magicTagRead == kMAGIC_TAG failed.Magic tag does not match)
   [05/15/2024-13:56:42] [E] [TRT] 4: [runtime.cpp::deserializeCudaEngine::50] Error Code 4: Internal Error (Engine deserialization failed.)
   cdy_trt_yolov8_det_sample: /home/cdy/Data_HDD/Projects/VideoPipe/third_party/trt_yolov8/trt_yolov8_detector.cpp:52: void trt_yolov8::trt_yolov8_detector::deserialize_engine(std::string&, nvinfer1::IRuntime**, nvinfer1::ICudaEngine**, nvinfer1::IExecutionContext**): Assertion `*engine' failed.
   已放弃 (核心已转储)
   ```

   和fp32的engine报错模式一样，可能是自动转onnx时使用onnxsim造成，但文件大小和其他fp16差不多

#### 尝试修改binding name

试过了，但是出现cuda infer时的错误，不像是名字造成的，目前只能说通过ultralytics转成的engine不能在这个例子中用

```bash
 ./build/bin/cdy_trt_yolov8_det_sample 
[2024-05-15 15:55:55.430][Info ][7f185622d000][/home/cdy/Data_HDD/Projects/VideoPipe/nodes/vp_file_src_node.cpp:21] [file_src_0] [filesrc location=./vp_data/test_video/face2.mp4 ! qtdemux ! h264parse ! avdec_h264 ! videoconvert ! appsink]
[2024-05-15 15:55:55.430][Warn ][7f185622d000][/home/cdy/Data_HDD/Projects/VideoPipe/nodes/vp_infer_node.cpp:43] [yolo8_detector] cv::dnn::readNet load network failed!
[2024-05-15 15:55:55.982][Info ][7f185622d000][/home/cdy/Data_HDD/Projects/VideoPipe/nodes/vp_screen_des_node.cpp:14] [screen_des_0] [appsrc ! videoconvert ! videoscale ! textoverlay text=screen_des_0 halignment=left valignment=top font-desc='Sans,16' shaded-background=true ! timeoverlay halignment=right valignment=top font-desc='Sans,16' shaded-background=true ! queue ! fpsdisplaysink video-sink=ximagesink sync=false]
[2024-05-15 15:55:55.983][Info ][7f185622d000][/home/cdy/Data_HDD/Projects/VideoPipe/utils/analysis_board/../vp_pipe_checker.h:167] 
############# pipe check summary ##############
 total layers: 4
 layer index,       node names
 1                    file_src_0,
 2                    yolo8_detector,
 3                    osd_0,
 4                    screen_des_0,
############# pipe check summary ##############

Gtk-Message: 15:55:56.262: Failed to load module "canberra-gtk-module"
[ WARN:1@0.879] global cap_gstreamer.cpp:1750 open OpenCV | GStreamer warning: frame count is estimated by duration and fps
[05/15/2024-15:55:56] [W] [TRT] The enqueue() method has been deprecated when used with engines built from a network created with NetworkDefinitionCreationFlag::kEXPLICIT_BATCH flag. Please use enqueueV2() instead.
[05/15/2024-15:55:56] [W] [TRT] Also, the batchSize argument passed into this function has no effect on changing the input shapes. Please use setBindingDimensions() function to change input shapes instead.
CUDA error 700 at /home/cdy/Data_HDD/Projects/VideoPipe/third_party/trt_yolov8/trt_yolov8_detector.cpp:90cdy_trt_yolov8_det_sample: /home/cdy/Data_HDD/Projects/VideoPipe/third_party/trt_yolov8/trt_yolov8_detector.cpp:90：void trt_yolov8::trt_yolov8_detector::infer(nvinfer1::IExecutionContext&, CUstream_st*&, void**, float*, int, float*, float*, int, std::string): 假设 ‘0’ 失败。
已放弃 (核心已转储)
```

一些修改的内容如下，源码加了点注释，并没真正改

```bash
修改：     README_own.md
修改：     samples/CMakeLists.txt
修改：     samples/cdy_trt_yolov8_det_sample.cpp
修改：     samples/cdy_trt_yolov8_seg_sample.cpp
修改：     third_party/trt_yolov8/include/config.h
修改：     third_party/trt_yolov8/src/model.cpp
修改：     third_party/trt_yolov8/trt_yolov8_seg_detector.cpp

未跟踪的文件:
  （使用 "git add <文件>..." 以包含要提交的内容）
	nodes/infers/cdy_vp_trt_yolov8_classifier.cpp.bak
	nodes/infers/cdy_vp_trt_yolov8_classifier.h.bak
	nodes/infers/cdy_vp_trt_yolov8_detector.cpp.bak
	nodes/infers/cdy_vp_trt_yolov8_detector.h.bak
	nodes/infers/cdy_vp_trt_yolov8_pose_detector.cpp.bak
	nodes/infers/cdy_vp_trt_yolov8_pose_detector.h.bak
	nodes/infers/cdy_vp_trt_yolov8_seg_detector.cpp.bak
	nodes/infers/cdy_vp_trt_yolov8_seg_detector.h.bak
	samples/cdy_trt_yolov8_det_sample_v2.cpp.bak
	samples/cdy_trt_yolov8_seg_sample_v2.cpp.bak
	third_party/trt_yolov8/cdy_trt_yolov8_classifier.cpp.bak
	third_party/trt_yolov8/cdy_trt_yolov8_classifier.h.bak
	third_party/trt_yolov8/cdy_trt_yolov8_detector.cpp.bak
	third_party/trt_yolov8/cdy_trt_yolov8_detector.h.bak
	third_party/trt_yolov8/cdy_trt_yolov8_pose_detector.cpp.bak
	third_party/trt_yolov8/cdy_trt_yolov8_pose_detector.h.bak
	third_party/trt_yolov8/cdy_trt_yolov8_seg_detector.cpp.bak
	third_party/trt_yolov8/cdy_trt_yolov8_seg_detector.h.bak
	third_party/trt_yolov8/include/cdy_config.h.bak
	third_party/trt_yolov8/include/cdy_model.h.bak
	third_party/trt_yolov8/samples/cdy_trtexec.sh
	third_party/trt_yolov8/samples/cdy_ultralytics_export.sh
	third_party/trt_yolov8/src/cdy_model.cpp.bak

```



