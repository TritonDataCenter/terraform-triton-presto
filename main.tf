#
# Terraform/Providers
#
terraform {
  required_version = ">= 0.11.0"
}

provider "triton" {
  version = ">= 0.4.1"
}

#
# Data sources
#
data "triton_datacenter" "current" {}

data "triton_account" "current" {}

#
# Locals
#
locals {
  presto_coordinator_address = "${var.cns_service_name_presto_coordinator}.svc.${data.triton_account.current.id}.${data.triton_datacenter.current.name}.${var.cns_fqdn_base}"
}

#
# Machines
#
resource "triton_machine" "presto_coordinator" {
  name    = "${var.name}-presto"
  package = "${var.package}"
  image   = "${var.image}"

  firewall_enabled = true

  networks = ["${var.networks}"]

  tags {
    role = "${var.role_tag}"
  }

  cns {
    services = ["${var.cns_service_name_presto_coordinator}"]
  }

  metadata {
    version_presto             = "${var.version_presto}"
    version_presto_manta       = "${var.version_presto_manta}"
    mode_presto                = "coordinator"
    address_presto_coordinator = "localhost"

    manta_url    = "${var.manta_url}"
    manta_user   = "${var.manta_user}"
    manta_key_id = "${var.manta_key_id}"
    manta_key    = "${var.manta_key}"
  }
}

resource "triton_machine" "presto_worker" {
  count = "${var.count_workers}"

  name    = "${var.name}-presto-worker-${count.index}"
  package = "${var.package}"
  image   = "${var.image}"

  firewall_enabled = true

  networks = ["${var.networks}"]

  tags {
    role = "${var.role_tag}"
  }

  cns {
    services = ["${var.cns_service_name_presto_worker}"]
  }

  metadata {
    version_presto             = "${var.version_presto}"
    version_presto_manta       = "${var.version_presto_manta}"
    mode_presto                = "worker"
    address_presto_coordinator = "${local.presto_coordinator_address}"

    manta_url    = "${var.manta_url}"
    manta_user   = "${var.manta_user}"
    manta_key_id = "${var.manta_key_id}"
    manta_key    = "${var.manta_key}"
  }
}

#
# Firewall Rules
#
resource "triton_firewall_rule" "ssh" {
  rule        = "FROM tag \"role\" = \"${var.bastion_role_tag}\" TO tag \"role\" = \"${var.role_tag}\" ALLOW tcp PORT 22"
  enabled     = true
  description = "${var.name} - Allow access from bastion hosts to Presto servers."
}

resource "triton_firewall_rule" "client_access" {
  count = "${length(var.client_access)}"

  rule        = "FROM ${var.client_access[count.index]} TO tag \"role\" = \"${var.role_tag}\" ALLOW tcp PORT 8080"
  enabled     = true
  description = "${var.name} - Allow access from clients to Presto servers."
}

resource "triton_firewall_rule" "http_presto_worker_to_coordinator" {
  rule        = "FROM tag \"triton.cns.services\" = \"${var.cns_service_name_presto_worker}\" TO tag \"triton.cns.services\" = \"${var.cns_service_name_presto_coordinator}\" ALLOW tcp PORT 8080"
  enabled     = true
  description = "HTTP connection between Presto worker instances and coordinator"
}

resource "triton_firewall_rule" "http_presto_coordinator_to_worker" {
  rule        = "FROM tag \"triton.cns.services\" = \"${var.cns_service_name_presto_coordinator}\" TO tag \"triton.cns.services\" = \"${var.cns_service_name_presto_worker}\" ALLOW tcp PORT 8080"
  enabled     = true
  description = "HTTP connection between Presto worker instances and coordinator"
}

resource "triton_firewall_rule" "http_worker_to_worker" {
  rule        = "FROM tag \"triton.cns.services\" = \"${var.cns_service_name_presto_worker}\" TO tag \"triton.cns.services\" = \"${var.cns_service_name_presto_worker}\" ALLOW tcp PORT 8080"
  enabled     = true
  description = "HTTP connection between Presto worker instances"
}
