# Simple Docker image for this awesome-copilot repository
# Uses Node.js 20 on Alpine Linux as a small base image
FROM node:20-alpine

# Set working directory inside the container
WORKDIR /app

# Install dependencies first (better build caching)
COPY package*.json ./
RUN npm ci

# Copy the rest of the repository
COPY . .

# Optional: run the README build once during image build
# This validates that everything works and generates README.md
RUN npm run build

# Default command when the container starts
# You can change this to whatever you need, for example:
#   - "npm run build" to regenerate README
#   - "npm run collection:validate" to validate collections
CMD ["npm", "run", "collection:validate"]
