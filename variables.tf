#
# Variables
#
variable "name" {
  description = "The name of the environment."
  type        = "string"
}

variable "image" {
  description = "The image to deploy as the Presto machine(s)."
  type        = "string"
}

variable "coordinator_package" {
  description = "The package to deploy as the Presto coordinator."
  type        = "string"
}

variable "worker_package" {
  description = "The package to deploy as the Presto worker machines."
  type        = "string"
}

variable "networks" {
  description = "The networks to deploy the Presto machine(s) within."
  type        = "list"
}

variable "private_key_path" {
  description = "The path to the private key to use for provisioning machines."
  type        = "string"
}

variable "user" {
  description = "The user to use for provisioning machines."
  type        = "string"
  default     = "root"
}

variable "provision" {
  description = "Boolean 'switch' to indicate if Terraform should do the machine provisioning to install and configure Presto."
  type        = "string"
}

variable "count_workers" {
  default     = "1"
  description = "The number of Presto workers to provision."
  type        = "string"
}

variable "version_presto" {
  default     = "0.193"
  description = "The version of Presto to install. See https://repo1.maven.org/maven2/com/facebook/presto/presto-server/."
  type        = "string"
}

variable "version_presto_manta" {
  default     = "1.0.0-SNAPSHOT"
  description = "The version of the Presto Manta connector to install. See https://github.com/joyent/presto-manta"
  type        = "string"
}

variable "manta_url" {
  default     = "https://us-east.manta.joyent.com/"
  description = "The URL of the Manta service endpoint."
  type        = "string"
}

variable "manta_user" {
  description = "The account name used to access the Manta service."
  type        = "string"
}

variable "manta_key_id" {
  description = "The fingerprint for the public key used to access the Manta service."
  type        = "string"
}

variable "manta_key" {
  description = "The private key data for the Manta service credentials."
  type        = "string"
}

variable "cns_service_name_presto_coordinator" {
  description = "The Presto Coordinator CNS service name. Note: this is the service name only, not the full CNS record."
  type        = "string"
  default     = "presto-coordinator"
}

variable "cns_service_name_presto_worker" {
  description = "The Presto Worker CNS service name. Note: this is the service name only, not the full CNS record."
  type        = "string"
  default     = "presto-worker"
}

variable "client_access" {
  description = <<EOF
'From' targets to allow client access to Presto coordinator' web port - i.e. access from other VMs or public internet.
See https://docs.joyent.com/public-cloud/network/firewall/cloud-firewall-rules-reference#target
for target syntax.
EOF

  type    = "list"
  default = ["all vms"]
}

variable "cns_fqdn_base" {
  description = "The fully qualified domain name base for the CNS address - e.g. 'cns.joyent.com' for Joyent Public Cloud."
  type        = "string"
  default     = "cns.joyent.com"
}

variable "bastion_host" {
  description = "The Bastion host to use for provisioning."
  type        = "string"
}

variable "bastion_user" {
  description = "The Bastion user to use for provisioning."
  type        = "string"
}

variable "bastion_cns_service_name" {
  description = "The CNS service name for the Prometheus machine(s) to allow access FROM the Bastion machine(s)."
  type        = "string"
}
