#
# Outputs
#
output "presto_coordinator_primaryip" {
  value = ["${triton_machine.presto_coordinator.*.primaryip}"]
}

output "presto_worker_primaryip" {
  value = ["${triton_machine.presto_worker.*.primaryip}"]
}

output "presto_coordinator_address" {
  value = "${local.presto_coordinator_address}"
}
