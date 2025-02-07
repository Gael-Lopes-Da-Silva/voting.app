FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

COPY . .

EXPOSE 8888

CMD ["npm", "run", "start"]