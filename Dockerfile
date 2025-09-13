# Stage 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy application code
COPY . .

# Optional: run tests
RUN npm test

# Stage 2: Production Image
FROM node:20-alpine

WORKDIR /app

# Copy files from build stage
COPY --from=build /app .

# Expose the app port (change if your app uses different port)
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
