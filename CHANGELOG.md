
## 1.0.0-rc2 (Unreleased)

BACKWARDS INCOMPATIBILITIES / NOTES:

  * Changes for [terraform-triton-bastion - 1.0.0-rc2](https://github.com/joyent/terraform-triton-bastion/blob/master/CHANGELOG.md#100-rc2-unreleased).
  * Change `presto_coordinator_ip` output to `presto_coordinator_primaryip`. 
  * Change `presto_worker_ip` output to `presto_worker_primaryip`. 
  * Change `presto_address` output to `presto_coordinator_address`. 
  * Remove `role_tag` variable and `presto_role_tag` output.
  * Split `package` variable into `coordinator_package` and `worker_package`.

IMPROVEMENTS:

  * Change firewall rules to rely on CNS service names instead of (now removed) `role` tag.

  
## 1.0.0-rc1 (2018-02-10)

  * Initial working example
