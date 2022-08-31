.. _ddc_config_roles:

=====
Roles
=====

.. warning::

    This chapter is only for advanced users who need to modify the host configuration process significantly. Unless the configuration process doesn't meet your requirements, you don't need to be familiar with this part.

The following roles are shipped with the OpenNebula ``provision`` tool and installed into ``/usr/share/one/oneprovision/ansible/roles/``.

Role ceph-opennebula-facts
--------------------------------------------------------------------------------

This role is used to make ``ceph_oneadmin_key`` and ``ceph_oneadmin_keyring``
facts accessible for used on ceph-opennebula-osd

No parameters.


Role ceph-opennebula-mon
--------------------------------------------------------------------------------
Creates OpenNebula Ceph pools

================================= ========================================= ========================================================================================
Parameter                         Default                                   Description
================================= ========================================= ========================================================================================
``ceph_opennebula_mon_pools``     ``{ name: one, pg_num: 128 }}``           Ceph pools definition

``ceph_opennebula_mon_tunables``  default                                   `Crush tunables <https://docs.ceph.com/en/latest/rados/operations/crush-map/#tunables>`_
================================= ========================================= ========================================================================================


Role ceph-opennebula-osd
--------------------------------------------------------------------------------
Creates rbd client directories, configures libvirts secrets, disables
Docker if installed by ceph-ansible.

========================================= ============================== ===========
Parameter                                 Default                        Description
========================================= ============================== ===========
``ceph_opennebula_osd_libvirt_enabled``   true                           Enables libvirt configuraion (not used for LXC)
========================================= ============================== ===========


Role ceph-slice
--------------------------------------------------------------------------------
Creates systemd ceph.slice which encapsulates all Ceph services so they can
be later isolated from machine.slice to manage host resources.

No parameters.

Role ddc
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

This is a set of internal clean-up and check tasks. E.g. check if the target host operating system is supported, or network configuration cleanups.

No parameters.

Role frr
--------------------------------------------------------------------------------
Installs FRR (https://frrouting.org/) and configured BGP EVPN extensions for VXLAN networks

To use this role you need to install netaddr Python library on the frontend, e.g.: pip install netaddr

================================= ======================================== ===========
Parameter                         Default                                  Description
================================= ======================================== ===========
``frr_frrver``                    frr-7                                    frr-stable will be the latest official stable release
``frr_rr_num``                    1                                        Number of route reflectors in the cluster
``frr_iface``                     ``{{ ansible_default_ipv4.interface }}`` Network interface name to route VXLAN traffic
``frr_as``                        65000                                    The AS number used for BGP
``frr_prefix_length``             16                                       Prefix length for the BGP network
``frr_zebra``                     false                                    Configure Zebra
``frr_ipcalc``                    false                                    Install and configure with ipcalc
``frr_net_mask``                  20                                       Default netmask for ipcalc
================================= ======================================== ===========

Role iptables
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

Creates the basic set of IPv4 and IPv6 packet filter rules to ensure only the specified traffic is allowed. Masquerading (NAT) with IP port forwarding can be enabled.

================================= ============================== ===========
Parameter                         Default                        Description
================================= ============================== ===========
``iptables_ip_forward_enabled``   true                           Enable IP forwarding
``iptables_manage_persistent``    true                           Manage persistent configuration
``iptables_base_rules_enabled``   true                           Create a set of base rules
``iptables_base_rules_interface`` NULL                           Particular network interface to limit the base rules
``iptables_base_rules_strict``    true                           Include the rules to drop any other traffic
``iptables_base_rules_services``  ``[{protocol:'tcp',port:22}]`` List of whitelisted services
``iptables_masquerade_enabled``   false                          Enable NAT
``iptables_masquerade_interface`` ansible_default_ipv4.interface NAT output interface
================================= ============================== ===========

Role opennebula-node-firecracker
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

Installs the ``opennebula-node-firecracker`` package, optionally configures the KVM module for the nested virtualization, and ensures libvirt is enabled and running.

================================================== ================ ===========
Parameter                                          Default          Description
================================================== ================ ===========
``opennebula_node_firecracker_network_drivers``    elastic, vxlan   Virtual network drivers to be enabled to work with Firecracker
``opennebula_node_firecracker_network_hook_types`` clean, pre       Required virtual network types
================================================== ================ ===========

Role opennebula-node-kvm
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

Installs the ``opennebula-node-kvm`` package, optionally configures the KVM module for the nested virtualization, and ensures libvirt is enabled and running.

==================================== ================ ===========
Parameter                            Default          Description
==================================== ================ ===========
``opennebula_node_kvm_use_ev``       False            Whether to use the EV package for KVM
``opennebula_node_kvm_param_nested`` False            Enable nested KVM virtualization
``opennebula_node_kvm_manage_kvm``   True             Enable KVM configuration
``opennebula_node_kvm_rhev_repo``    True             Name of Red Hat EV repository
``opennebula_node_selinux_booleans`` ``virt_use_nfs`` SELinux booleans to configure
==================================== ================ ===========

Role opennebula-node-lxc
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

Installs the ``opennebula-node-lxc`` package.

No parameters.

Role opennebula-repository
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

Configures the OpenNebula package repository for the particular version.

======================================= ========================================== ===========
Parameter                               Default                                    Description
======================================= ========================================== ===========
``opennebula_repository_version``       6.4                                        OpenNebula repository version
``opennebula_repository_base``          ``https://downloads.opennebula.io/repo/``  Repository of the OpenNebula packages
                                        ``{{ opennebula_repository_version }}``
``opennebula_repository_gpgcheck``      yes                                        Enable GPG check for the packages
``opennebula_repository_repo_gpgcheck`` yes                                        Enable GPG check for the repos (RHEL/AlmaLinux only)
======================================= ========================================== ===========

Role opennebula-ssh
--------------------------------------------------------------------------------

.. !!! Description and parameters needs to be IN SYNC WITH THE ROLE CONTENT !!!

Handles the SSH configuration and SSH keys distribution on the OpenNebula front-end/hosts.

============================================== ==================== ===========
Parameter                                      Default              Description
============================================== ==================== ===========
``opennebula_ssh_manage_sshd``                 True                 Manage SSH server configuration
``opennebula_ssh_sshd_passwordauthentication`` no                   SSH server option for Password Authentication
``opennebula_ssh_sshd_permitrootlogin``        ``without-password`` SSH server option for PermitRootLogin
``opennebula_ssh_deploy_local``                True                 Deploy local oneadmin's SSH key to remote host
============================================== ==================== ===========
