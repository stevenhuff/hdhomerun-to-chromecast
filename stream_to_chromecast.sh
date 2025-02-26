#!/bin/bash

# Variables (replace these with your actual values)
HDHOMERUN_IP="192.168.1.100"  # Replace with your HDHomeRun device's IP
CHANNEL="8"                   # Replace with the channel number you want to stream
CHROMECAST_NAME="Living Room" # Replace with your Chromecast device name

# Discover HDHomeRun stream URL (assuming a simple HTTP stream endpoint)
STREAM_URL="http://${HDHOMERUN_IP}:5004/auto/v${CHANNEL}"

# Use ffmpeg to transcode the stream to a Chromecast-compatible format (e.g., MP4/H.264)
# and serve it via a local HTTP server
ffmpeg -i "$STREAM_URL" -c:v libx264 -preset ultrafast -c:a aac -f mp4 -movflags frag_keyframe+empty_moov -listen 1 http://0.0.0.0:8000/stream.mp4 &

# Wait briefly for ffmpeg to start
sleep 5

# Cast the local stream to Chromecast using go-chromecast
go-chromecast -n "$CHROMECAST_NAME" load "http://localhost:8000/stream.mp4"