# Nginx Web Server with Static Content Deployment

This project provisions a Google Cloud Compute Engine instance with an Nginx web server. It automatically downloads and deploys a static website from a public URL using a startup script and assigns a static IP to the instance.

## Features

- **Nginx Web Server**: The VM instance runs a pre-configured Nginx web server.
- **Static Website Deployment**: Downloads and serves a wedding-themed static website template.
- **Static IP**: The VM instance is assigned a static external IP.
- **Firewall Rules**: Opens ports 80 (HTTP) and 443 (HTTPS) for web traffic.

## Architecture

- **Google Cloud Compute Engine**: The web server is deployed on a VM instance in Google Cloud.
- **Static IP**: A static IP is provisioned for the instance to ensure it has a persistent external address.
- **Firewall**: Custom firewall rules are created to allow HTTP and HTTPS traffic.
- **Startup Script**: A custom startup script is executed to install Nginx, download the static website, and configure the server.

## How to Use

### Prerequisites

- **Terraform**: Ensure Terraform is installed. You can follow the instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- **Google Cloud Account**: Make sure you have a Google Cloud account with the necessary permissions to create resources.

### Steps to Deploy

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/nginx-web-server.git
   cd nginx-web-server
   ```

2. Create a `terraform.tfvars` file to provide your Google Cloud project and region information:

   ```hcl
   static_ip_name = "my-static-ip"
   region          = "us-central1"
   zone            = "us-central1-a"
   instance_name   = "nginx-web-server"
   machine_type    = "e2-medium"
   labels          = {"environment" = "production"}
   boot_disk_size  = 10
   ```

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Apply the Terraform plan to create the resources:

   ```bash
   terraform apply
   ```

5. Once the deployment is complete, the static IP assigned to the VM will be available in the output. Access your Nginx server by visiting the static IP in your web browser.

   ```
   http://<your-static-ip>
   ```

### Destroy Resources

To clean up the resources created by Terraform, run:

```bash
terraform destroy
```

## Files and Directories

- **main.tf**: Main Terraform configuration file that defines resources like Compute Engine instance, static IP, and firewall rules.
- **variables.tf**: Input variables for the Terraform configuration.
- **outputs.tf**: Outputs such as the static IP address of the deployed VM.
- **startup-script.sh**: The shell script executed when the VM instance is created. It installs Nginx, downloads the static website, and configures the server.

## Customization

You can modify the following variables in the `terraform.tfvars` file to customize the deployment:

- `static_ip_name`: Name of the static IP address.
- `instance_name`: Name of the Google Cloud VM instance.
- `machine_type`: Type of the VM instance (e.g., `e2-medium`, `n1-standard-1`).
- `zone`: The Google Cloud zone for the instance.
- `labels`: Labels for the VM instance.
- `boot_disk_size`: Size of the boot disk in GB.

## Acknowledgements

- [Tooplate](https://www.tooplate.com/) for providing the free static website template.
- [Terraform](https://www.terraform.io/) for automating the infrastructure deployment.

```