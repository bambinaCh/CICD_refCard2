# Build stage: React App bauen
FROM node:16-alpine AS build

WORKDIR /app

# Nur package Dateien kopieren und Dependencies installieren
COPY package*.json ./
RUN npm ci

# Restlichen Code kopieren und bauen
COPY . .
RUN npm run build

# Runtime stage: Nginx, um das Build zu serven
FROM nginx:alpine

# Build in den Standard Nginx Ordner legen
COPY --from=build /app/build /usr/share/nginx/html

# Port 80 nach aussen oeffnen
EXPOSE 80

# Nginx im Vordergrund starten
CMD ["nginx", "-g", "daemon off;"]
