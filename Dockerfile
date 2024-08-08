# Base CUDA image
FROM cnstark/pytorch:2.0.1-py3.9.17-cuda11.8.0-ubuntu20.04

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
RUN pip install --no-cache-dir -r  requirements.txt
# Define a build-time argument for image type
ARG IMAGE_TYPE=full

# Conditional logic based on the IMAGE_TYPE argument
# Always copy the Docker directory, but only use it if IMAGE_TYPE is not "elite"
COPY ./Docker /workspace/Docker 
RUN chmod +x /workspace/Docker/download.sh && \
    bash /workspace/Docker/download.sh

# Copy the rest of the application
COPY . /workspace

EXPOSE 9871 9872 9873 9874 9880
CMD ["python", "api.py", "-dr", "dingzhen_10.wav", "-dt", "有可能以后再也听不到这些声音了，他们是我们的朋友。", "-dl", "zh"]
