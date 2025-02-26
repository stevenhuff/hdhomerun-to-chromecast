#!/bin/bash

# Check if required environment variables are set, provide defaults or exit if missing
if [ -z "$HDHOMERUN_IP" ]; then
    echo "Error: HDHOMERUN_IP environment variable is not set."
    exit 1
fi

if [ -z "$HDHOMERUN_CHANNEL" ]; then
    echo "Error: HDHOMERUN_CHANNEL environment variable is not set."
    exit 1
fi

if [ -z "$CHROMECAST_IP" ]; then
    echo "Error: CHROMECAST_IP environment variable is not set."
    exit 1
fi

# Construct the HDHomeRun stream URL using environment variables
STREAM_URL="http://${HDHOMERUN_IP}:5004/auto/v${HDHOMERUN_CHANNEL}"

# Use ffmpeg to transcode the stream to a Chromecast-compatible format (e.g., MP4/H.264)
# and serve it via a local HTTP server
ffmpeg -i "$STREAM_URL" -c:v libx264 -preset ultrafast -c:a aac -f mp4 -movflags frag_keyframe+empty_moov -listen 1 http://0.0.0.0:8000/stream.mp4 &

# Wait briefly for ffmpeg to start
sleep 5

# Cast the local stream to Chromecast using go-chromecast
go-chromecast -a "$CHROMECAST_IP" load "http://localhost:8000/stream.mp4"