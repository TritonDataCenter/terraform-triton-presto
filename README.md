# Triton Presto Terraform Module

A Terraform module to create a [Presto cluster](https://prestodb.io/) for
[Joyent's Triton Compute service](https://www.joyent.com/triton/compute), integrated with
[Triton Object Storage](https://www.joyent.com/triton/object-storage) (aka Manta).

## Usage

```hcl
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

module "bastion" {
  source = "github.com/joyent/terraform-triton-bastion"

  name    = "presto-basic-with-provisioning"
  image   = "${data.triton_image.ubuntu.id}"
  package = "g4-general-4G"

  networks = [
    "${data.triton_network.public.id}",
    "${data.triton_network.private.id}",
  ]
}

module "presto" {
  source = "github.com/joyent/terraform-triton-presto"

  name    = "presto-basic-with-provisioning"
  image   = "${data.triton_image.ubuntu.id}"
  package = "g4-general-4G"

  networks = [
    "${data.triton_network.public.id}",
    "${data.triton_network.private.id}",
  ]

  provision        = "true"
  private_key_path = "${var.private_key_path}"

  count_workers = "${var.count_workers}"

  client_access = ["any"]

  manta_url    = "${var.manta_url}"
  manta_user   = "${var.manta_user}"
  manta_key_id = "${var.manta_key_id}"
  manta_key    = "${var.manta_key}"

  bastion_host     = "${element(module.bastion.bastion_ip,0)}"
  bastion_user     = "${module.bastion.bastion_user}"
  bastion_role_tag = "${module.bastion.bastion_role_tag}"
}
```

## Examples
- [basic-with-provisioning](examples/basic-with-provisioning) - Deploys a Presto coordinator, workers, and relevant 
resources. Presto server will be _provisioned_ by Terraform.
  - _Note: This method with Terraform provisioning is only recommended for prototyping and light testing._

## Resources created

- [`triton_machine.presto_coordinator`](https://www.terraform.io/docs/providers/triton/r/triton_machine.html): The Presto 
coordinator machine.
- [`triton_machine.presto_worker`](https://www.terraform.io/docs/providers/triton/r/triton_machine.html): The Presto 
worker machine(s).
- [`triton_firewall_rule.ssh`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The firewall
rule(s) allowing SSH access FROM the bastion machine(s) TO the Presto machine.
- [`triton_firewall_rule.client_access`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The 
firewall rule(s) allowing access FROM client machines or addresses TO Presto coordinator web ports.
- [`triton_firewall_rule.http_presto_worker_to_coordinator`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The 
firewall rule(s) allowing access FROM Presto worker machines TO Presto coordinator web ports.
- [`triton_firewall_rule.http_presto_coordinator_to_worker`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The 
firewall rule(s) allowing access FROM Presto coordinator machines TO Presto worker web ports.
- [`triton_firewall_rule.http_worker_to_worker`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The 
firewall rule(s) allowing access FROM Presto worker machines TO Presto worker web ports.
