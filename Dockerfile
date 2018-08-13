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

WORKDIR /toflow/src

ENTRYPOINT ["/bin/bash"]