# Base image
FROM nginx:latest

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy HTML files
COPY index.html /usr/share/nginx/html/index.html

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
