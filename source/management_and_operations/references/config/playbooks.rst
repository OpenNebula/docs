.. _ddc_config_playbooks:

=============
Configuration
=============

Newly provisioned physical resources are mostly running only a base operating system without any additional services. Hosts need to pass the configuration phase to setup the additional software repositories, install packages, and configure and run necessary services to comply with the intended host purpose. This configuration process is fully handled by the ``oneprovision`` tool as part of the initial deployment (``oneprovision create``) or independent run anytime later (``oneprovision configure``).

.. note::

    Tool ``oneprovision`` has a seamless integration with `Ansible <https://www.ansible.com/>`__ (which needs to be already installed on the system). It's not necessary to be familiar with Ansible unless you need to make changes deep inside the configuration process.

As we use Ansible for host configuration, we'll share its terminology in this section.

* **task**: A single configuration step (e.g. package installation, service start)
* **role**: A set of related tasks (e.g. a role to deal with Linux bridges: utilities installation, bridge configure, and activation)
* **playbook**: A set of roles/tasks to configure several components at once (e.g. fully prepare a host as a KVM hypervisor)

The configuration phase can be parameterized to slightly change the configuration process (e.g. enable or disable particular OS features, or force a different repository location or version). These custom parameters are specified in the :ref:`configuration <ddc_provision_template_configuration>` section of the provision template. In most cases, the general defaults should meet requirements.

All code for Ansible (tasks, roles, playbooks) is installed into ``/usr/share/one/oneprovision/ansible/`` with the following high-level structure:

.. code::

    /usr/share/one/oneprovision/ansible
    |-- roles
    |   |-- ddc
    |   |-- ffr
    |   |-- iptables
    |   |-- opennebula-node-firecracker
    |   |-- opennebula-node-kvm
    |   |-- opennebula-node-lxc
    |   |-- opennebula-repository
    |   |-- opennebula-ssh
    |   |-- python
    |   `-- update-replica
    |-- ansible.cfg.erb
    |-- aws.yml
    |-- digitalocean.yml
    |-- google.yml
    `-- packet.yml

Description:

* ``*.yml``: playbooks
* ``roles/``: roles with tasks

The detailed description of all roles and their configuration parameters is in the separate chapter :ref:`Roles <ddc_config_roles>`, which is intended for advanced users.

.. _ddc_config_playbooks_overview:

=========
Playbooks
=========

Playbooks are extensive descriptions of the configuration process (what and how is installed and configured on the physical host). Each configuration description prepares a physical host from the initial to the final ready-to-use state. Each description can configure the host in a completely different way (e.g. KVM host with private networking, KVM host with shared NFS filesystem, or KVM host supporting Packet elastic IPs, etc.). :ref:`Configuration parameters <ddc_provision_template_configuration>` are only small tunables to the configuration process driven by the playbooks.

Before the deployment, a user must choose from the available playbooks to apply on the host(s).

You can use multiple playbooks at once, you just need to add a list in your provision template, e.g:

.. code::

    ---
    playbook:
      - default
      - mycustom

.. note::

    **Description:**
    Host with FRR and configured BGP EVPN extensions for VXLAN networks.

This configuration prepares the host with:

* Hypervisor depending on the value of variable ``oneprovision_hypervisor``.
* FRR on private interface.

Parameters
--------------------------------------------------------------------------------

Main configuration parameters:

=====================================  ========================================== ===========
Parameter                              Value                                      Description
=====================================  ========================================== ===========
``opennebula_node_kvm_use_ev``         **True** or False                          Whether to use the ev package for kvm
``opennebula_node_kvm_param_nested``   True or **False**                          Enable nested KVM virtualization
``opennebula_repository_version``      6.1                                        OpenNebula repository version
``opennebula_repository_base``         ``https://downloads.opennebula.io/repo/``  Repository of the OpenNebula packages
                                       ``{{ opennebula_repository_version }}``
=====================================  ========================================== ===========

All parameters are covered in the :ref:`Configuration Roles <ddc_config_roles>`.

Configuration Steps
--------------------------------------------------------------------------------

The roles and tasks are applied during the configuration in the following order:

1. **python**: check and install Python required for Ansible.
2. **ddc**: general asserts and cleanups,
3. **opennebula-repository**: set up the OpenNebula package repository.
4. **opennebula-node-<X>**: install OpenNebula node KVM, LXC or Firecracker.
5. **opennebula-ssh**: deploy local SSH keys for the remote oneadmin.
6. **iptables**: create basic iptables rules.
7. **update-replica**: prepare replica storage.
8. **frr**: configure FRR.
