# Use official Node.js image as the build environment
FROM node:18-alpine AS build

# Set working directory inside the container
WORKDIR /app

# Copy package.json and yarn.lock files first to install dependencies
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy all source files
COPY . .

# Build the app (assuming Vite build script is "build" in package.json)
RUN yarn build

# Production image, serve the build output with a lightweight web server
FROM nginx:alpine

# Copy the built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
