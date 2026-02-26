FROM oven/bun:1-debian AS deps
WORKDIR /app
COPY package.json ./
RUN bun install

FROM node:18-slim

# Install FFmpeg and Puppeteer dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
ffmpeg \
libnss3 \
libatk1.0-0 \
libatk-bridge2.0-0 \
libcups2 \
libdrm2 \
libxkbcommon0 \
libxcomposite1 \
libxdamage1 \
libxrandr2 \
libgbm1 \
libasound2 \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN mkdir -p /app/music /app/logo

EXPOSE $STREAM_PORT
CMD ["node", "index.js"]
