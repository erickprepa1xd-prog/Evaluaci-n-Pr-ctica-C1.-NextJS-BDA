# Usamos una imagen ligera de Node.js
FROM node:18-alpine

WORKDIR /app

# Instalamos dependencias primero para aprovechar el caché de Docker
COPY package*.json ./
RUN npm install

# Copiamos el resto del código del dashboard
COPY . .

# Construimos la aplicación para producción [cite: 76]
RUN npm run build

EXPOSE 3000

# Iniciamos la aplicación
CMD ["npm", "run", "start"]