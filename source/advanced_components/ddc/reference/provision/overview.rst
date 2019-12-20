.. _ddc_provision_overview:

=========
Provision
=========

The provision is a process of allocating new physical resources from the remote providers. :ref:`Provision drivers <ddc_provision_driver>` are used for communication with the remote providers. Credentials for the communication and parameters of the required provision (hardware, operating system, IPs, etc.) need to be specified. All these items are stored in the :ref:`provision template <ddc_provision_template>` file and passed to the ``oneprovision create`` command.

In this chapter, we'll describe the format and content of the provision template.

.. _ddc_provision_template:

Template
========

A **provision template** is a YAML-formatted file with parameters specifying the new physical resources to be provisioned. It contains:

* header (name, configuration playbook, parent template)
* global default parameters for

  * remote connection (SSH),
  * host provision driver,
  * host configuration tunables.

* list of provision objects (cluster, hosts, datastores, virtual networks) to deploy with overrides to the global defaults above.

Example:

.. code::

    ---
    name: myprovision
    playbook: default

    # Global defaults:
    defaults:
      provision:
        driver: packet
        packet_token: ********************************
        packet_project: ************************************
        facility: ams1
        plan: baremetal_0
        os: centos7
      connection:
        public_key: '/var/lib/one/.ssh/id_rsa.pub'
        private_key: '/var/lib/one/.ssh/id_rsa'
      configuration:
        opennebula_node_kvm_param_nested: true

    # List of provision objects to deploy with provision/connection/configuration overrides
    cluster:
      name: mycluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "myhost1"
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "myhost2"
          os: ubuntu18_04
        connection:
          remote_user: ubuntu

    datastores:
      - name: "myprovision-images"
        ds_mad: fs
        tm_mad: ssh
      - name: "myprovision-system"
        type: system_ds
        tm_mad: ssh
        safe_dirs: "/var/tmp /tmp"

    networks:
      - name: "myprovision-hostonly_nat"
        vn_mad: dummy
        bridge: br0
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only networking with NAT"
        filter_ip_spoofing: "YES"
        filter_mac_spoofing: "YES"
        ar:
          - ip: 192.168.150.2
            size: 253
            type: IP4

.. _ddc_provision_template_header:

Header
------

+-----------------+--------------------+-----------------------------------------------------------------------------------------------------------------+
| Parameter       | Default            | Description                                                                                                     |
+=================+====================+=================================================================================================================+
| ``name``        | none               | Name of provision.                                                                                              |
+-----------------+--------------------+-----------------------------------------------------------------------------------------------------------------+
| ``playbook``    | ``default``        | Ansible playbook used for hosts configuration.                                                                  |
|                 |                    | Provide the custom **absolute filename**, or one                                                                |
|                 |                    | of predefined:                                                                                                  |
|                 |                    |                                                                                                                 |
|                 |                    | - :ref:`default <ddc_config_playbooks_default>`                                                                 |
|                 |                    | - :ref:`default_lxd <ddc_config_playbooks_default_lxd>`                                                         |
|                 |                    | - :ref:`static_vxlan <ddc_config_playbooks_static_vxlan>`                                                       |
+-----------------+--------------------+-----------------------------------------------------------------------------------------------------------------+
| ``extends``     | none               | Parent template to include and extend. Provide the custom                                                       |
|                 |                    | **absolute filename**, or one of predefined:                                                                    |
|                 |                    |                                                                                                                 |
|                 |                    | - :ref:`/usr/share/one/oneprovision/templates/default.yaml <ddc_provision_templates_default>`                   |
|                 |                    | - :ref:`/usr/share/one/oneprovision/templates/static_vxlan.yaml <ddc_provision_templates_static_vxlan>`         |
+-----------------+--------------------+-----------------------------------------------------------------------------------------------------------------+

Shared sections
---------------

The following shared sections can be specified inside the template ``defaults``, or directly inside each OpenNebula provision object (cluster, datastore, virtual network, and host). Parameters specified on the object side have higher priority and override the parameters from ``defaults``.

.. _ddc_provision_template_connection:

connection
^^^^^^^^^^

This section contains parameters for the remote SSH connection on the privileged user or the user with escalation rights (via ``sudo``) of the newly provisioned host(s).

+-----------------+--------------------------------------+-------------------------------------------+
| Parameter       | Default                              | Description                               |
+=================+======================================+===========================================+
| ``remote_user`` | ``root``                             | Remote user to connect via SSH.           |
+-----------------+--------------------------------------+-------------------------------------------+
| ``remote_port`` | ``22``                               | Remote SSH service port.                  |
+-----------------+--------------------------------------+-------------------------------------------+
| ``public_key``  | ``/var/lib/one/.ssh/ddc/id_rsa.pub`` | Path or content of the SSH public key.    |
+-----------------+--------------------------------------+-------------------------------------------+
| ``private_key`` | ``/var/lib/one/.ssh/ddc/id_rsa``     | Path or content of the SSH private key.   |
+-----------------+--------------------------------------+-------------------------------------------+

.. _ddc_provision_template_provision:

provision
^^^^^^^^^

This section contains parameters for the provisioning driver. Most parameters are specific to each driver. The only valid common parameters are:

+-----------------+--------------------------------------+-----------------------------------------------+
| Parameter       | Default                              | Description                                   |
+=================+======================================+===============================================+
| ``driver``      | none, needs to be specified          | Host provision driver. Options:               |
|                 |                                      |                                               |
|                 |                                      | - :ref:`packet <ddc_driver_packet>`           |
|                 |                                      | - :ref:`ec2 <ddc_driver_ec2>`                 |
+-----------------+--------------------------------------+-----------------------------------------------+

.. _ddc_provision_template_configuration:

configuration
^^^^^^^^^^^^^

This section provides parameters for the host configuration process (e.g. KVM installation, host networking etc.). All parameters are passed to the external configuration tool (Ansible), and all available parameters are covered by the :ref:`configuration <ddc_config_roles>` chapter.

.. _ddc_provision_template_devices:

Provision objects
-----------------

Sections ``cluster``, ``hosts``, ``datastores``, ``networks`` contain list of provision objects to be deployed with all the necessary parameters for deployment and creation in OpenNebula. The object structure is a YAML representation of an OpenNebula template with additional shared sections (``connection``, ``provision``, ``configuration``).

.. note::

    It's possible to deploy only a single cluster. The section ``cluster`` is a dictionary. All other sections are lists.

Example of datastore defined from regular template:

.. prompt:: bash $ auto

    $ cat ds.tpl
    NAME="myprovision-images"
    TM_MAD="ssh"
    DS_MAD="fs"

    $ onedatastore create ds.tpl
    ID: 328

Example of the same datastore defined in provision template:

.. code::

    datastores:
      - name: "myprovision-images"
        ds_mad: fs
        tm_mad: ssh
