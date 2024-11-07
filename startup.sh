sudo apt update
sudo apt install nginx unzip wget -y

# Check if wget download is successful
wget https://www.tooplate.com/zip-templates/2131_wedding_lite.zip -O /tmp/2131_wedding_lite.zip
if [ $? -ne 0 ]; then
    echo "Download failed" >> /tmp/startup-script.log
    exit 1
fi

# Ensure the right user owns the directory
sudo chown -R ubuntu:ubuntu /var/www/html

# Unzip the file
unzip /tmp/2131_wedding_lite.zip -d /tmp
if [ $? -ne 0 ]; then
    echo "Unzip failed" >> /tmp/startup-script.log
    exit 1
fi

# Move the contents to /var/www/html
sudo mv /tmp/2131_wedding_lite/* /var/www/html/

# Configure Nginx to use the downloaded content
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/default
server {
        listen 80;
        server_name ${google_compute_address.static_ip.address};

        root /var/www/html;
        index index.html;

        location / {
                try_files \$uri \$uri/ =404;
        }
}
EOL'

# Reload Nginx to apply changes
sudo systemctl reload nginx