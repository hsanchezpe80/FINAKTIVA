FROM node:18-alpine

WORKDIR /apps

# Copiar archivos de dependencias desde src
COPY src/package.json ./

# Instalar dependencias
RUN npm install --production

# Copiar el código fuente
COPY src ./src

# Puerto de la aplicación
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

# Comando para iniciar la aplicación
CMD ["node", "src/server.js"]
