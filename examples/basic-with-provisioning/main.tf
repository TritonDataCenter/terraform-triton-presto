#
# Data Sources
#
data "triton_image" "ubuntu" {
  name        = "ubuntu-16.04"
  type        = "lx-dataset"
  most_recent = true
}

data "triton_network" "public" {
  name = "Joyent-SDC-Public"
}

data "triton_network" "private" {
  name = "My-Fabric-Network"
}

#
# Modules
#
module "bastion" {
  source = "github.com/joyent/terraform-triton-bastion"

  name    = "presto-basic-with-provisioning"
  image   = "${data.triton_image.ubuntu.id}"
  package = "g4-general-4G"

  # Public and Private
  networks = [
    "${data.triton_network.public.id}",
    "${data.triton_network.private.id}",
  ]
}

module "presto" {
  source = "../../"

  name    = "presto-basic-with-provisioning"
  image   = "${data.triton_image.ubuntu.id}" # note: using the UBUNTU image here
  package = "g4-general-4G"

  # Private only
  networks = [
    "${data.triton_network.private.id}",
  ]

  provision        = "true"                    # note: we ARE provisioning as we are NOT using pre-built images.
  private_key_path = "${var.private_key_path}"

  count_workers = "${var.count_workers}"

  client_access = ["any"]

  manta_url    = "${var.manta_url}"
  manta_user   = "${var.manta_user}"
  manta_key_id = "${var.manta_key_id}"
  manta_key    = "${var.manta_key}"

  bastion_host             = "${module.bastion.bastion_address}"
  bastion_user             = "${module.bastion.bastion_user}"
  bastion_cns_service_name = "${module.bastion.bastion_cns_service_name}"
}
