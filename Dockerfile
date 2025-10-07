
# -----------------------------
# Stage 1: Build Stage
# -----------------------------
FROM node:16 AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (for dependency installation)
COPY package*.json ./

# Install app dependencies
RUN npm install --save

# Copy the rest of the application code
COPY . .

# -----------------------------
# Stage 2: Runtime Stage
# -----------------------------
FROM node:16-alpine

# Set working directory in the final container
WORKDIR /usr/src/app

# Copy only built app and dependencies from the previous stage
COPY --from=build /usr/src/app .

# Expose port 8080 for the Node.js web app
EXPOSE 8082

# Start the application
CMD ["npm", "start"]
