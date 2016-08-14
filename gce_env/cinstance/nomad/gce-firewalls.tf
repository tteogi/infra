resource "google_compute_firewall" "nomad" {
    description = "nomad"
    name = "nomad"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["4647", "4646", "4648"]
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "template_file" "env" {
    template = "${file("./templates/server.env")}"
}
