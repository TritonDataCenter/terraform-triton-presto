#
# Outputs
#
output "bastion_ip" {
  value = ["${module.bastion.bastion_ip}"]
}

output "presto_coordinator_ip" {
  value = ["${module.presto.presto_coordinator_ip}"]
}

output "presto_worker_ip" {
  value = ["${module.presto.presto_worker_ip}"]
}

output "presto_address" {
  value = ["${module.presto.presto_address}"]
}
