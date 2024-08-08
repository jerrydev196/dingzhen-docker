# Base CUDA image
FROM cnstark/pytorch:2.0.1-py3.9.17-cuda11.8.0-ubuntu20.04

LABEL maintainer="lulaide85@gmail.com"
LABEL version="dingzhen_gen1"
LABEL description="Docker image for GPT-SoVITS Dingzhen"


# Install 3rd party apps
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata ffmpeg libsox-dev parallel aria2 git git-lfs && \
    git lfs install && \
    rm -rf /var/lib/apt/lists/*

# Copy only requirements.txt initially to leverage Docker cache
WORKDIR /workspace
COPY requirements.txt /workspace/
