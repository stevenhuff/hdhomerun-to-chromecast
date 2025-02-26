# Use a Go-specific base image with a recent version
FROM golang:1.23

# Install ffmpeg (no python or other extras needed for this use case)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Install go-chromecast
RUN go install github.com/vishen/go-chromecast@latest

# Set working directory
WORKDIR /app

# Copy the streaming script
COPY stream_to_chromecast.sh /app/
RUN chmod +x /app/stream_to_chromecast.sh

# Expose port for HTTP server
EXPOSE 8000

# Command to run the streaming script
CMD ["/app/stream_to_chromecast.sh"]
