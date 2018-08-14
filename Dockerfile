FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         wget \
         vim \
         ca-certificates \
         libjpeg-dev \
         libreadline-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*

RUN cd / && git clone https://github.com/torch/distro.git /torch --recursive
ENV TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__"
RUN cd /torch && ./install.sh

RUN cd / && git clone https://github.com/anchen1011/toflow.git
RUN sed -i 's/sm_20/sm_30/g'  /toflow/src/stnbhwd/CMakeLists.txt
RUN cd /toflow/src/stnbhwd && /torch/install/bin/luarocks make
RUN cd /toflow && ./download_models.sh
RUN cd / && wget https://www.dropbox.com/s/br1xdwog0787vys/cudnn-9.0-linux-x64-v7.2.1.38.tgz
RUN tar -xzvf cudnn-9.0-linux-x64-v7.2.1.38.tgz
RUN cp /cuda/include/cudnn.h /usr/local/cuda/include
RUN cp /cuda/lib64/libcudnn* /usr/local/cuda/lib64
ENV CUDNN_PATH="/cuda/lib64/libcudnn.so.7.2.1"
RUN chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
RUN git clone https://github.com/soumith/cudnn.torch.git -b R7 && cd cudnn.torch && /torch/install/bin/luarocks make cudnn-scm-1.rockspec

WORKDIR /toflow/src

ENTRYPOINT ["/bin/bash"]
