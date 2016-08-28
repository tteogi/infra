resource "google_compute_firewall" "consul" {
    description = "consul"
    name = "consul"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["8600", "8500", "8400", "8300", "8301", "8302"]
    }
    allow {
        protocol = "udp"
        ports = ["8600", "8500", "8400", "8300", "8301", "8302"]
    }
    source_ranges = ["0.0.0.0/0"]
}
