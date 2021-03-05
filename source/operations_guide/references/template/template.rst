.. _ddc_template:

==================
Template Reference
==================

The provision is a process of allocating new physical resources from the remote providers. :ref:Provision drivers <ddc_provision_driver> are used for communication with the remote providers. Credentials for the communication and parameters of the required provision (hardware, operating system, IPs, etc.) need to be specified. All these items are stored in the :ref:provision template <ddc_provision_template> file and passed to the ``oneprovision create`` command.

In this chapter, we'll describe the format and content of the provision template.

.. _ddc_provision_template:

A **provision template** is a YAML-formatted file with parameters specifying the new physical resources to be provisioned. It contains:

* header (name, configuration playbook, parent template)
* global default parameters for

  * remote connection (SSH),
  * host provision driver,
  * host configuration tunales.

* list of OpenNebula infrastructure objects (cluster, hosts, datastores, virtual networks) to deploy with overrides to the global defaults above.

* list of OpenNebula virtual objects (images, templates, vnet templates, marketplace apps, service templates). Refer to :ref:this<ddc_virtual> for more information.

Example:

.. code::

    ---
    name: myprovision
    playbook: default

    # Global defaults:
    defaults:
      provision:
        provider: packet
        plan: baremetal_0
        os: centos_7
      connection:
        public_key: '/var/lib/one/.ssh/id_rsa.pub'
        private_key: '/var/lib/one/.ssh/id_rsa'
      configuration:
        opennebula_node_kvm_param_nested: true

    # List of OpenNebula infrastructure objects to deploy with provision/connection/configuration overrides
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

    # List of OpenNebula vitual objects to be created
    images:
      - name: "test_image"
        ds_id: 1
        size: 2048
        meta:
          uname: 'serveradmin'
          gname: 'users'
          mode: 777
          wait: false

     marketplaceapps:
       - appname: "Ttylinux - KVM"
         name: "test_image2"
         dsid: 1
         meta:
           wait: true
           wait_timeout: 30

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
|                 |                    | - :ref:default <ddc_config_playbooks_default>                                                                   |
|                 |                    | - :ref:default_lxd <ddc_config_playbooks_default_lxd>                                                           |
|                 |                    | - :ref:static_vxlan <ddc_config_playbooks_static_vxlan>                                                         |
+-----------------+--------------------+-----------------------------------------------------------------------------------------------------------------+
| ``extends``     | none               | Parent template to include and extend. Provide the custom                                                       |
|                 |                    | **absolute filename**, or one of predefined:                                                                    |
|                 |                    |                                                                                                                 |
|                 |                    | - :ref:/usr/share/one/oneprovision/templates/default.yaml <ddc_provision_templates_default>                     |
|                 |                    | - :ref:/usr/share/one/oneprovision/templates/static_vxlan.yaml <ddc_provision_templates_static_vxlan>           |
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

This section contains parameters for the provisioning provider. Most parameters are specific to each driver. The only valid common parameters are:

+-----------------+--------------------------------------+-----------------------------------------------+
| Parameter       | Default                              | Description                                   |
+=================+======================================+===============================================+
| ``provider``    | none, needs to be specified          | Host provision driver. Options:               |
|                 |                                      |                                               |
|                 |                                      | - :ref:packet <ddc_driver_packet>             |
|                 |                                      | - :ref:aws <ddc_driver_aws>                   |
+-----------------+--------------------------------------+-----------------------------------------------+

.. _ddc_provision_template_configuration:

configuration
^^^^^^^^^^^^^

This section provides parameters for the host configuration process (e.g. KVM installation, host networking etc.). All parameters are passed to the external configuration tool (Ansible), and all available parameters are covered by the :ref:`configuration <ddc_config_roles>` chapter.

.. _ddc_provision_template_devices:

OpenNebula infrastructure objects
---------------------------------

Sections ``cluster``, ``hosts``, ``datastores``, ``networks`` contain list of OpenNebula infrastructure objects to be deployed with all the necessary parameters for deployment and creation in OpenNebula. The object structure is a YAML representation of an OpenNebula template with additional shared sections (``connection``, ``provision``, ``configuration``).

.. note::

    It's possible to deploy only a single cluster. The section ``cluster`` is a dictionary. All other sections are lists.

.. note::

    Hosts have an special attribute ``count``, this attribute allow you to deploy the same host multiple times, without having to specify all of them.

    The following example, deploy two hosts with the same configuration:

    .. prompt:: bash $ auto

        hosts:
        - reserved_cpu: 100
          im_mad: kvm
          vm_mad: kvm
          provision:
            hostname: "myhost1"
          count: 2

    The resulting hostanmes would be ``myhost1_0`` and ``myhost1_1``.

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

OpenNebula virtual objects
--------------------------

Sections ``images``, ``marketplaceapps``, ``templates``, ``vnetemplates``, ``flowtemplates`` contain list of OpenNebula virtual objects to be created with all the necessary parameters for the creation in OpenNebula. The object strcture is a YAML representation of and OpenNebula template.

Example of VM template defined from regular template:

.. prompt:: bash $ auto

    $ cat template.tpl
    NAME="test_template"
    MEMORY=128
    CPU=1

    $ onetemplate create template.tpl
    ID: 0

Example of the same VM template defined in provision template:

.. code::

    templates:
      - name: "test_template"
        memory: 1
        cpu: 1

.. _ddc_provision_templates:

Several templates are shipped in the distribution package. Those are not the final templates, but only provide a partial definition of infrastructure and should be used as a base (extended) in your custom templates. Check the brief description of each template, and continue with reading the content of the template files in your installation.

.. _ddc_provision_templates_default:

Template 'default'
------------------

.. note::

    Installed into
    ``/usr/share/one/oneprovision/templates/default.yaml``.

Template with private OpenNebula virtual network configured by :ref:default <ddc_config_playbooks_default> on physical hosts.

The following virtual network(s) are configured:

* nat

.. _ddc_provision_templates_static_vxlan:

Template 'static_vxlan'
-----------------------

.. note::

    Installed into
    ``/usr/share/one/oneprovision/templates/static_vxlan.yaml``.

Template with private OpenNebula virtual networks configured by :ref:`static_vxlan <ddc_config_playbooks_static_vxlan>` on physical hosts.

The following virtual network(s) are configured:

* nat
* private

.. _ddc_provision_cluster_templates:

Few examples of complete cluster templates are shipped in the distribution package. These are for the two providers OpenNebula supports - the Packet and Amazon EC2. The examples should be used following way:

- Copy the file with example template.
- Replace values with ``****`` by valid credentials, depending on the template you are using.
- Uncomment (and create more) hosts you want to deploy.
- On your frontend under oneadmin user, trigger provision based on your template. E.g.,

.. prompt:: bash $ auto

   $ oneprovision create custom_packet.yaml -d

.. _ddc_provision_template_packet:

Packet Cluster
--------------

.. note::

    Installed into ``/usr/share/one/oneprovision/examples/example_packet.yaml``.

Template with the following resources:

- disabled hosts with CentOS 7 and Ubuntu 18.04 to be deployed on Packet
- image and system datastores (driver SSH)
- networks:

 - ``public`` (IPs allocated via :ref:IPAM <ddc_ipam_packet> from Packet; should be attached as NIC alias to NIC from ``private-host-only``)
 - ``private-host-only`` (to be used with ``public`` network)
 - ``private``

.. _ddc_provision_template_aws:

Amazon AWS Cluster
------------------

.. note::

    Installed into ``/usr/share/one/oneprovision/examples/example_aws.yaml``.

Template with the following resources:

- disabled hosts with CentOS 7 and Ubuntu 16.04 to be deployed on AWS
- image and system datastores (driver SSH)
- networks:

 - ``private-host-only-nat`` (with NAT enabled)
 - ``private``
