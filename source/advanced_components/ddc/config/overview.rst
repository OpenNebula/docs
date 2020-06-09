.. _ddc_config_overview:

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
    |-- inventories
    |   |-- default
    |   |-- default_firecracker
    |   |-- default_lxd
    |   `-- static_vxlan
    |-- roles
    |   |-- bridged-networking
    |   |-- ddc
    |   |-- iptables
    |   |-- opennebula-node-firecracker
    |   |-- opennebula-node-kvm
    |   |-- opennebula-node-lxd
    |   |-- opennebula-p2p-vxlan
    |   |-- opennebula-repository
    |   |-- opennebula-ssh
    |   |-- python
    |   `-- tuntap
    |-- ansible.cfg.erb
    |-- default_firecracker.yml
    |-- default_lxd.yml
    |-- default.yml
    |-- dummy.yml
    `-- static_vxlan.yml

Description:

* ``*.yml``: playbooks
* ``inventories/``: parameters for each playbook
* ``roles/``: roles with tasks

The detailed description of all roles and their configuration parameters is in the separate chapter :ref:`Roles <ddc_config_roles>`, which is intended for advanced users.
