output "shared_resources" {
    description = "(Optional) A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
 value = "${var.shared_resources}"
}