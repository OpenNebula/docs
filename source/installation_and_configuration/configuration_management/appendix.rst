.. _cfg_files:

======================================
Appendix - List of Configuration Files
======================================

The following table describes all configuration files and their type from directories

- ``/etc/one/``
- ``/var/lib/one/remotes/``

managed by the ``onecfg`` tool:

================================================================== ======================
Name                                                               Type
================================================================== ======================
``/etc/one/auth/ldap_auth.conf``                                   YAML w/ ordered arrays
``/etc/one/auth/server_x509_auth.conf``                            YAML
``/etc/one/auth/x509_auth.conf``                                   YAML
``/etc/one/az_driver.conf``                                        YAML
``/etc/one/az_driver.default``                                     Plain file (or XML)
``/etc/one/cli/*.yaml``                                            YAML w/ ordered arrays
``/etc/one/defaultrc``                                             Shell
``/etc/one/ec2_driver.conf``                                       YAML
``/etc/one/ec2_driver.default``                                    Plain file (or XML)
``/etc/one/ec2query_templates/*.erb``                              Plain file (or XML)
``/etc/one/econe.conf``                                            YAML
``/etc/one/fireedge-server.conf``                                  YAML
``/etc/one/hm/hmrc``                                               Shell
``/etc/one/monitord.conf``                                         oned.conf-like
``/etc/one/oned.conf``                                             oned.conf-like
``/etc/one/oneflow-server.conf``                                   YAML
``/etc/one/onegate-server.conf``                                   YAML
``/etc/one/onehem-server.conf``                                    YAML
``/etc/one/packet_driver.default``                                 Plain file (or XML)
``/etc/one/sched.conf``                                            oned.conf-like
``/etc/one/sunstone-logos.yaml``                                   YAML w/ ordered arrays
``/etc/one/sunstone-server.conf``                                  YAML
``/etc/one/sunstone-views.yaml``                                   YAML
``/etc/one/sunstone-views/**/*.yaml``                              YAML
``/etc/one/tmrc``                                                  Shell
``/etc/one/vcenter_driver.conf``                                   YAML
``/etc/one/vcenter_driver.default``                                Plain file (or XML)
``/etc/one/vmm_exec/vmm_exec_kvm.conf``                            oned.conf-like
``/etc/one/vmm_exec/vmm_exec_vcenter.conf``                        oned.conf-like
``/etc/one/vmm_exec/vmm_execrc``                                   Shell
``/var/lib/one/remotes/datastore/ceph/ceph.conf``                  Shell
``/var/lib/one/remotes/etc/datastore/ceph/ceph.conf``              Shell
``/var/lib/one/remotes/etc/datastore/datastore.conf``              Shell
``/var/lib/one/remotes/etc/datastore/fs/fs.conf``                  Shell
``/var/lib/one/remotes/etc/im/firecracker-probes.d/probe_db.conf`` YAML
``/var/lib/one/remotes/etc/im/kvm-probes.d/pci.conf``              YAML
``/var/lib/one/remotes/etc/im/kvm-probes.d/probe_db.conf``         YAML
``/var/lib/one/remotes/etc/im/lxc-probes.d/probe_db.conf``         YAML
``/var/lib/one/remotes/etc/im/lxd-probes.d/pci.conf``              YAML
``/var/lib/one/remotes/etc/im/lxd-probes.d/probe_db.conf``         YAML
``/var/lib/one/remotes/etc/im/qemu-probes.d/pci.conf``             YAML
``/var/lib/one/remotes/etc/im/qemu-probes.d/probe_db.conf``        YAML
``/var/lib/one/remotes/etc/market/http/http.conf``                 Shell
``/var/lib/one/remotes/etc/tm/fs_lvm/fs_lvm.conf``                 Shell
``/var/lib/one/remotes/etc/tm/ssh/sshrc``                          Shell
``/var/lib/one/remotes/etc/vmm/firecracker/firecrackerrc``         YAML
``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``                         Shell
``/var/lib/one/remotes/etc/vmm/lxc/lxcrc``                         YAML
``/var/lib/one/remotes/etc/vmm/lxd/lxdrc``                         YAML
``/var/lib/one/remotes/etc/vmm/vcenter/vcenterrc``                 YAML
``/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf``            YAML
``/var/lib/one/remotes/vmm/kvm/kvmrc``                             Shell
``/var/lib/one/remotes/vnm/OpenNebulaNetwork.conf``                YAML
================================================================== ======================
