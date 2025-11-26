# Build Stage: React App bauen
FROM node:20-alpine AS build

# Arbeitsordner im Container
WORKDIR /app

# Nur package Dateien zuerst kopieren (Cache fuer Abhaengigkeiten)
COPY package*.json ./

# Dependencies installieren
RUN npm ci

# Restlichen Code kopieren
COPY . .

# React App fuer Produktion bauen
RUN npm run build

# Runtime Stage: Nginx als Webserver
FROM nginx:1.27-alpine

# Gebaute Dateien in das Standard Web Verzeichnis von Nginx kopieren
COPY --from=build /app/build /usr/share/nginx/html

# Port 80 im Container freigeben
EXPOSE 80

# Nginx im Vordergrund starten
CMD ["nginx", "-g", "daemon off;"]
