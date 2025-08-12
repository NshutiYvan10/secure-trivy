FROM node:14

# Set working directory
WORKDIR /usr/src/app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application
COPY . .

# Create a non-root user and switch to it
RUN useradd --user-group --create-home --shell /bin/false appuser \
    && chown -R appuser:appuser /usr/src/app
USER appuser

# Expose port
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:3000/health || exit 1

# Start app
CMD ["node", "server.js"]
