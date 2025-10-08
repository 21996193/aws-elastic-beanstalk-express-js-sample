
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

# Expose port 8082 for the Node.js web app
EXPOSE 8082

# Start the application
CMD ["npm", "start"]
