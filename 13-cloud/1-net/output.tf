# Output
# output "external_ip_address_node" {
#   value = [ for n in yandex_compute_instance.node: format("%s - %s", n.hostname, n.network_interface.0.nat_ip_address) ]
# }
