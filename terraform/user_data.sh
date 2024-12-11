#!/bin/bash
# Actualizar el sistema
sudo yum update -y

# Instalar Apache y PHP
sudo yum install -y httpd php

# Habilitar y arrancar Apache
sudo systemctl enable httpd
sudo systemctl start httpd

# Limpiar el directorio web
sudo rm -rf /var/www/html/*

# Clonar y configurar la aplicación web
cd /var/www/html
sudo dnf install -y git
sudo git clone https://github.com/ferminromero00/Ejercicio1-Fermin.git
sudo mv Ejercicio1-Fermin/* /var/www/html/sitio1

# Configurar permisos
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

#Sitios virtuales
sudo mkdir -p /var/www/html/sitio1
sudo chown -R apache:apache /var/www/html/sitio1
sudo chmod -R 755 /var/www/html/sitio1

# Crear un archivo de configuración para el VirtualHost de Apache
echo -e "<VirtualHost *:81>\n\
    ServerName sitio1\n\
    ServerAlias sitio1\n\
    DocumentRoot /var/www/html/sitio1\n\
    <Directory /var/www/html/sitio1>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
    ErrorLog /var/log/httpd/prueba321321-error.log\n\
    CustomLog /var/log/httpd/prueba321321-access.log combined\n\
</VirtualHost>" | sudo tee /etc/httpd/conf.d/mi-sitio.conf

#Se tendria que cambiar automaticamente pero no encuentro como
# Agregar la IP del servidor al archivo hosts para resolver el dominio localmente
echo "3.83.232.45  sitio1 www.sitio1.com" | sudo tee -a /etc/hosts
# Hacer que sitio virtual escuche por el puerto 80
echo -e "Listen 81" | sudo tee -a /etc/httpd/conf/httpd.conf > /dev/null









# Reiniciar Apache
sudo systemctl restart httpd