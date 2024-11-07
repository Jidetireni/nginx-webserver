resource "google_compute_address" "static_ip" {
  name   = var.static_ip_name
  region = var.region
}

resource "google_compute_instance" "nginx_web" {
  name               = var.instance_name
  machine_type       = var.machine_type
  zone               = var.zone
  labels             = var.labels
  allow_stopping_for_update = true
  tags               = [ "http-server", "https-server" ]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = var.boot_disk_size
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = <<-EOT
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
EOT

}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-server"]
  description = "Allow HTTP traffic"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["https-server"]
  description = "Allow HTTPS traffic"
  source_ranges = ["0.0.0.0/0"]
}
