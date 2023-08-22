# Output
output "external_ip_address_network_load_balancer" {
  value = [ for n in yandex_lb_network_load_balancer.lb-lamp.listener: format("%s - %s", n.name, join(", ", [ for i in n.external_address_spec: i.address ])) ]
}

output "external_ip_address_application_load_balancer" {
  value = [ for n in yandex_alb_load_balancer.alb-lamp.listener: n ]
}