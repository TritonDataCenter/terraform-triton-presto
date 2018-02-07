resource "null_resource" "presto_install_coordinator" {
  count = "${var.provision == "true" ? "1" : 0}"

  triggers {
    machine_ids = "${triton_machine.presto_coordinator.*.id[count.index]}"
  }

  connection {
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${file(var.private_key_path)}"

    host        = "${triton_machine.presto_coordinator.*.primaryip[count.index]}"
    user        = "${var.user}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/presto_installer/",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/packer/scripts/install_presto.sh"
    destination = "/tmp/presto_installer/install_presto.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0755 /tmp/presto_installer/install_presto.sh",
      "sudo /tmp/presto_installer/install_presto.sh",
    ]
  }

  # clean up
  provisioner "remote-exec" {
    inline = [
      "rm -rf /tmp/presto_installer/",
    ]
  }
}

resource "null_resource" "presto_install_worker" {
  count = "${var.provision == "true" ? var.count_workers : 0}"

  triggers {
    machine_ids = "${triton_machine.presto_worker.*.id[count.index]}"
  }

  connection {
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${file(var.private_key_path)}"

    host        = "${triton_machine.presto_worker.*.primaryip[count.index]}"
    user        = "${var.user}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/presto_installer/",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/packer/scripts/install_presto.sh"
    destination = "/tmp/presto_installer/install_presto.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0755 /tmp/presto_installer/install_presto.sh",
      "sudo /tmp/presto_installer/install_presto.sh",
    ]
  }

  # clean up
  provisioner "remote-exec" {
    inline = [
      "rm -rf /tmp/presto_installer/",
    ]
  }
}
