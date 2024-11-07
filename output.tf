output "static_ip" {
  description = "static ip value"
  value = google_compute_address.static_ip.address
}