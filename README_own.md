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

#### 1. 首先尝试`./third_party/trt_yolov8/README.md`里的模型转换方式

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
   $ ./trt_yolov8_wts_2_engine -det /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m.engine m
   
   $ ./trt_yolov8_wts_2_engine -seg /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-seg.engine m
   
   $ ./trt_yolov8_wts_2_engine -pose /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-pose.engine m
   [05/14/2024-20:33:17] [E] [TRT] 3: (Unnamed Layer* 343) [Convolution]:kernel weights has count 192 but 15360 was expected
   [05/14/2024-20:33:17] [E] [TRT] 4: (Unnamed Layer* 343) [Convolution]: count of 192 weights in kernel, but kernel dimensions (1,1) with 192 input channels, 80 output channels and 1 groups were specified. Expected Weights count is 192 * 1*1 * 80 / 1 = 15360
   [05/14/2024-20:33:17] [E] [TRT] 4: [convolutionNode.cpp::computeOutputExtents::43] Error Code 4: Internal Error ((Unnamed Layer* 343) [Convolution]: number of kernel weights does not match tensor dimensions)
   浮点数例外 (核心已转储)
   
   $ ./trt_yolov8_wts_2_engine -cls /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.wts /home/cdy/Data_HDD/Projects/VideoPipe/vp_data/models/cdy/yolov8m-cls.engine m
   ```

   

