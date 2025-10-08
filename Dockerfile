FROM node:16 AS build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --save

COPY . .

EXPOSE 8082

CMD ["npm", "start"]
