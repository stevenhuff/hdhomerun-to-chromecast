# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: ffmpeg for streaming, python for scripting, and build tools for go-chromecast
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
    wget \
    curl \
    git \
    golang \
    && rm -rf /var/lib/apt/lists/*

# Install go-chromecast CLI tool
RUN go get github.com/vishen/go-chromecast@latest && \
    mv /root/go/bin/go-chromecast /usr/local/bin/

# Set working directory
WORKDIR /app

# Copy a simple script to handle the streaming (will be created below)
COPY stream_to_chromecast.sh /app/
RUN chmod +x /app/stream_to_chromecast.sh

# Expose port for HTTP server (if needed for streaming)
EXPOSE 8000

# Command to run the streaming script
CMD ["/app/stream_to_chromecast.sh"]