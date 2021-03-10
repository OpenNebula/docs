.. _ddc_custom:

=============================
Physical Objects Provisioning
=============================

In this chapter, we'll cover the basics of writing the provision templates.

.. _ddc_usage_template:

The provision template describes the resources to create in the OpenNebula (cluster, hosts, datastores, virtual networks), parameters for allocation of the new hosts on the remote bare-metal cloud provider, how to connect and configure them from the perspective of operating system and software. It's a YAML document, which needs to be prepared by the Cloud Administrator.

We'll explain the templating basics with a few simple examples. Continue to the :ref:provision template reference <ddc_provision_template> for comprehensive documentation.

.. _ddc_usage_example1:

.. important::

    Before following any of below examples, you need to create the provider you want to use. Please refer to :ref:this guide <ddc_provider> for more information.

Example 1: Empty cluster with datastores
----------------------------------------

.. code::

  ---
  name: example1

  cluster:
    name: ex1-cluster

  datastores:
    - name: ex1-default
      ds_mad: fs
      tm_mad: ssh
    - name: ex1-system
      type: system_ds
      tm_mad: ssh
      safe_dirs: '/var/tmp /tmp'

Execution of this provision will create a new cluster ``ex1-cluster`` with datastores ``ex1-default`` and ``ex1-system``. The cluster is always just a single one. Datastores, hosts, and virtual networks are specified as a list (collection) of objects. Each object is described by a hash (associative array, map) of attributes, which would be otherwise specified in the OpenNebula INI-like template. I.e., it's an OpenNebula template represented as a YAML hash.

.. note::

    The system datastore ``ex1-system`` from the example matches the datastore which would be created with the CLI as follows, but specified as an OpenNebula INI-like template:

    .. prompt:: text $ auto

        $ cat systemds.txt
        NAME      = ex1-system
        TYPE      = SYSTEM_DS
        TM_MAD    = ssh
        SAFE_DIRS = "/var/tmp /tmp"

        $ onedatastore create systemds.txt
        ID: 100

Check the :ref:`Datastores <ds_op>` section in the Operation Guide for suitable attributes and values.

.. _ddc_usage_example2:

Example 2: Cluster with AWS host
--------------------------------

The following template describes provisioning a cluster with a single host deployed on Amazon AWS:

.. code::

    ---
    name: example2

    cluster:
      name: ex2-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex2-host1"
          provider: aws
          cloud_init: true
          ami: ami-66a7871c
          instancetype: "i3.metal"
          securitygroupsids: sg-*****************
          subnetid: subnet-*****************

As with the datastores in :ref:Example 1 <ddc_usage_example1> above, the hosts are specified as a list. Each host is described by a hash with template attributes required by OpenNebula. Parameters for provisioning on remote cloud providers must be set in a section ``provision`` for each host. The provision parameters are driver-specific; you have to be aware of the available drivers and their parameters.

Check the :ref:Provision Drivers <ddc_provision_driver> reference for the available drivers and parameters.

.. _ddc_usage_example3:

Example 3: Host Configuration
-----------------------------

The newly-provisioned hosts are mostly a fresh installation without anything necessary for running the hypervisor. In this example, we add a few more parameters, telling OpenNebula how to connect and configure the new host:

.. code::

    ---
    name: example3
    playbook: static_vxlan

    cluster:
      name: ex3-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex3-host1"
          provider: aws
          cloud_init: true
          ami: ami-66a7871c
          instancetype: "i3.metal"
          securitygroupsids: sg-*****************
          subnetid: subnet-*****************
        connection:
          remote_user: root
        configuration:
          opennebula_repository_version: '5.8.0'
          opennebula_node_kvm_use_ev: true
          opennebula_node_kvm_param_nested: true

As part of provision creation, the new hosts are connected to over SSH and the required software is installed and configured. Custom SSH connection information can be set for each host in section ``connection``. Installation is handled by Ansible, which runs the template-global installation prescription called  ``playbook``. The playbook run can be slightly modified by optional ``configuration`` tunables.

Check the following subsections:

- :ref:Playbooks <ddc_config_playbooks> reference for available Ansible playbooks,
- :ref:Roles <ddc_config_roles> reference with a detailed description of individual roles and their configuration tunables.

.. _ddc_usage_example4:

Example 4: Defaults
-------------------

When deploying several hosts, repeating the same provision, configuration and connection parameters would be annoying and prone to errors.

In the following example, we explain how to use defaults:

.. code::

    ---
    name: example4
    playbook: static_vxlan

    defaults:
      provision:
        provider: aws
        cloud_init: true
        ami: ami-66a7871c
        instancetype: "i3.metal"
        securitygroupsids: sg-*****************
        subnetid: subnet-*****************
      connection:
        remote_user: root
      configuration:
        opennebula_repository_version: '5.8.0'
        opennebula_node_kvm_use_ev: true
        opennebula_node_kvm_param_nested: true

    cluster:
      name: ex4-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex4-host1"
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex4-host2"
          ami: ami-759bc50a
          cloud_init: false
        connection:
          remote_user: ubuntu
        configuration:
          opennebula_node_kvm_param_nested: false

Section ``defaults`` contains sub-sections for ``provision``, ``connection``, and ``configuration`` familiar from the previous examples. Defaults are applied to all objects. Optionally you can override any of the parameters on the objects level. In the example, the first host ``ex-host1`` inherits all the **defaults** and extends them only with a custom hostname. The second host ``ex-host2`` provides a few more ``provision``, ``connection``, and ``configuration`` overrides (with the rest of the defaults taken).

.. _ddc_usage_example5:

Example 5: Full Cluster
-----------------------

The following example shows the provisioning of a complete cluster with host, datastores, and networks.

.. code::

    ---
    name: example5
    playbook: default

    defaults:
      provision:
        region_name: "us-east-1"
        cloud_init: true
        ami: ami-66a7871c
        instancetype: "i3.metal"
        securitygroupsids: sg-*****************
        subnetid: subnet-*****************
      connection:
        remote_user: root
      configuration:
        opennebula_node_kvm_manage_kvm: False
        opennebula_repository_version: '5.8.0'
        opennebula_node_kvm_use_ev: true
        opennebula_node_kvm_param_nested: true

    cluster:
      name: ex5-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex5-host1"

    datastores:
      - name: ex5-default
        ds_mad: fs
        tm_mad: ssh
      - name: ex5-system
        type: system_ds
        tm_mad: ssh
        safe_dirs: '/var/tmp /tmp'

    networks:
      - name: ex5-nat
        vn_mad: dummy
        bridge: br0
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only networking with NAT"
        ar:
          - ip: "192.168.150.2"
            size: 253
            type: IP4

.. _ddc_usage_example6:

Example 6: Template Inheritance
-------------------------------

Similarly, as with **defaults** in :ref:`Example 4 <ddc_usage_example4>`, the reusable parts of the templates can be moved into their own templates. One provision template can include anothers provision templates, extending or overriding the information from the included ones. The template can directly extend from multiple templates. Hosts, datastores, and networks sections are **merged** (appended) in the order they are defined and inherited. Defaults are **deep merged** on the level of individual parameters.

In the following example, we separate datastore and network definitions into their own template, ``example-ds_vnets.yaml``:

.. code::

    ---
    datastores:
      - name: example-default
        ds_mad: fs
        tm_mad: ssh
      - name: example-system
        type: system_ds
        tm_mad: ssh
        safe_dirs: '/var/tmp /tmp'

    networks:
      - name: example-nat
        vn_mad: dummy
        bridge: br0
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only networking with NAT"
        ar:
          - ip: "192.168.150.2"
            size: 253
            type: IP4

The main template extends the datastores and network with one AWS host:

.. code::

    ---
    name: example6
    extends: example-ds_vnets.yaml

    defaults:
      provision:
        provider: aws
        cloud_init: true
        ami: ami-66a7871c
        instancetype: "i3.metal"
        securitygroupsids: sg-*****************
        subnetid: subnet-*****************
      connection:
        remote_user: root
      configuration:
        opennebula_node_kvm_manage_kvm: False
        opennebula_repository_version: '5.8.0'
        opennebula_node_kvm_use_ev: true
        opennebula_node_kvm_param_nested: true

    cluster:
      name: ex6-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex6-host1"

In the following example, we separate datastore and network definitions into their own templates, ``example-ds.yaml`` and ``example-vnet.yaml``:

.. code::

    ---
    datastores:
      - name: example-default
        ds_mad: fs
        tm_mad: ssh
      - name: example-system
        type: system_ds
        tm_mad: ssh
        safe_dirs: '/var/tmp /tmp'

.. code::

    ---
    networks:
      - name: example-nat
        vn_mad: dummy
        bridge: br0
        dns: "8.8.8.8 8.8.4.4"
        gateway: "192.168.150.1"
        description: "Host-only networking with NAT"
        ar:
          - ip: "192.168.150.2"
            size: 253
            type: IP4

The main template extends the datastores and network with one AWS host:

.. code::

    ---
    name: example6
    extends:
      - example-ds.yaml
      - example-vnet.yaml

    defaults:
      provision:
        provider: aws
        cloud_init: true
        ami: ami-66a7871c
        instancetype: "i3.metal"
        securitygroupsids: sg-*****************
        subnetid: subnet-*****************
      connection:
        remote_user: root
      configuration:
        opennebula_node_kvm_manage_kvm: False
        opennebula_repository_version: '5.8.0'
        opennebula_node_kvm_use_ev: true
        opennebula_node_kvm_param_nested: true

    cluster:
      name: ex6-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex6-host1"

Check the :ref:Templates <ddc_provision_templates> reference for available base templates.

.. _ddc_usage_example7:

Example 7: Using more than one playbook
---------------------------------------

In order to configure the provision, you can specify playbooks, these are Ansible playbooks that are going to be triggered. You can specify more than one playbook, they are going to be executed one by one by ``oneprovision``.

In the following example we use the ``default`` and a custom ``mycustom`` playbooks:

.. code::

    ---
    name: example6
    playbook:
      - default
      - mycustom

    defaults:
      provision:
        provider: aws
        cloud_init: true
        ami: ami-66a7871c
        instancetype: "i3.metal"
        securitygroupsids: sg-*****************
        subnetid: subnet-*****************
      connection:
        remote_user: root
      configuration:
        opennebula_node_kvm_manage_kvm: False
        opennebula_repository_version: '5.8.0'
        opennebula_node_kvm_use_ev: true
        opennebula_node_kvm_param_nested: true

    cluster:
      name: ex6-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex6-host1"

.. note:: If you are using :ref:`template inheritance <ddc_usage_example6>`, you can also specify there playbooks.

