#
# Outputs
#
output "presto_coordinator_ip" {
  value = ["${triton_machine.presto_coordinator.*.primaryip}"]
}

output "presto_worker_ip" {
  value = ["${triton_machine.presto_worker.*.primaryip}"]
}

output "presto_role_tag" {
  value = "${var.role_tag}"
}

output "presto_address" {
  value = "${local.presto_coordinator_address}"
}
