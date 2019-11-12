FROM balenalib/raspberrypi4-64-debian-python:3.6-buster-build

# enable access to the USB ports
ENV UDEV=1

# Install dependencies
RUN install_packages \
    build-essential \
    cmake \
    pkg-config \
    libjpeg-dev \
    libtiff5-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libatlas-base-dev \
    gfortran \
    libusb-1.0.0-dev && \
    cd /usr/include/linux && \
    ln -s -f ../libv4l1-videodev.h videodev.h && \
    curl -s https://bootstrap.pypa.io/get-pip.py | python3.6 && \
    python3.6 -m pip install numpy cython

# Download and build OpenCV
RUN curl -s -L https://github.com/opencv/opencv/archive/4.1.2.tar.gz | tar xzf - && \
    mv /opencv-4.1.2 /opencv && \
    curl -s -L https://github.com/opencv/opencv_contrib/archive/4.1.2.tar.gz | tar xzf - && \
    mv /opencv_contrib-4.1.2 /opencv_contrib && \
    mkdir -p /opencv-build && cd /opencv-build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
        -D ENABLE_NEON=ON \
        -D BUILD_TESTS=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D CMAKE_SHARED_LINKER_FLAGS=-latomic \
        -D BUILD_EXAMPLES=OFF \
        -DPYTHON3_EXECUTABLE=/usr/lib/python3.6 \
        –DPYTHON_INCLUDE_DIR=/usr/include/python3.6 \
        –DPYTHON_INCLUDE_DIR2=/usr/include/arm-linux-gnueabihf/python3.6m \
        –DPYTHON_LIBRARY=/usr/lib/arm-linux-gnueabihf/libpython3.6m.so \
        /opencv && \
    make --jobs=$(nproc --all) && \
    make install && \
    cd / && rm -rf /opencv /opencv_contrib /opencv-build

# Build OpenVINO
RUN git clone https://github.com/opencv/dldt.git && \
    cd /dldt/inference-engine/ && \
    git checkout 2019_R3.1 && \
    git submodule init && \
    git submodule update --recursive && \
    mkdir -p /inference-engine-build && cd /inference-engine-build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_FLAGS='-march=armv8-a' \
        -DENABLE_MKL_DNN=OFF \
        -DENABLE_CLDNN=OFF \
        -DENABLE_GNA=OFF \
        -DENABLE_SSE42=OFF \
        -DTHREADING=SEQ \
        /dldt/inference-engine && \
    make --jobs=$(nproc --all)

ENTRYPOINT ["python3"]
