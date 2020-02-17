.. _ddc_usage:

========================
OneProvision Basic Usage
========================

Each new provision is described by the :ref:`provision template <ddc_provision_template>`, a YAML document specifying the OpenNebula resources to add (cluster, hosts, datastores, virtual networks), physical resources to provision from the remote infrastructure provider, the connection parameters for SSH and configuration steps (playbook) with tunables. The template is prepared by the experienced Cloud Administrator and passed to the command line tool ``oneprovision``. At the end of the process, there is a new cluster available in OpenNebula.

.. image:: /images/ddc_create.png
    :width: 50%
    :align: center

All operations with the provision and physical resources are performed only with the command line tool ``oneprovision``: create a new provision, manage (reboot, reset, power off, resume) the existing provisions, and delete the provision at the end.

In this chapter, we'll cover the basics of writing the provision templates and available commands to interact with the provision.

.. _ddc_usage_template:

Provision Template
==================

The provision template describes the resources to create in the OpenNebula (cluster, hosts, datastores, virtual networks), parameters for allocation of the new hosts on the remote bare-metal cloud provider, how to connect and configure them from the perspective of operating system and software. It's a YAML document, which needs to be prepared by the Cloud Administrator.

We'll explain the templating basics with a few simple examples. Continue to the :ref:`provision template reference <ddc_provision_template>` for comprehensive documentation.

.. _ddc_usage_example1:

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

Example 2: Cluster with EC2 host
--------------------------------

The following template describes provisioning a cluster with a single host deployed on Amazon EC2:

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
          driver: ec2
          ec2_access: ********************
          ec2_secret: ****************************************
          region_name: "us-east-1"
          cloud_init: true
          ami: ami-66a7871c
          instancetype: "i3.metal"
          securitygroupsids: sg-*****************
          subnetid: subnet-*****************

As with the datastores in :ref:`Example 1 <ddc_usage_example1>` above, the hosts are specified as a list. Each host is described by a hash with template attributes required by OpenNebula. Parameters for provisioning on remote cloud providers must be set in a section ``provision`` for each host. The provision parameters are driver-specific; you have to be aware of the available drivers and their parameters.

Check the :ref:`Provision Drivers <ddc_provision_driver>` reference for the available drivers and parameters.

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
          driver: ec2
          ec2_access: ********************
          ec2_secret: ****************************************
          region_name: "us-east-1"
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

- :ref:`Playbooks <ddc_config_playbooks>` reference for available Ansible playbooks,
- :ref:`Roles <ddc_config_roles>` reference with a detailed description of individual roles and their configuration tunables.

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
        driver: ec2
        ec2_access: ********************
        ec2_secret: ****************************************
        region_name: "us-east-1"
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
        driver: ec2
        ec2_access: ********************
        ec2_secret: ****************************************
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

Similarly, as with **defaults** in :ref:`Example 4 <ddc_usage_example4>`, the reusable parts of the templates can be moved into their own templates. One provision template can include another provision template, extending or overriding the information from the included one. The template can directly extend only from one template, but several templates can be chained (for recursive inheritance). Hosts, datastores, and networks sections are **merged** (appended) in the order they are defined and inherited. Defaults are **deep merged** on the level of individual parameters.

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

The main template extends the datastores and network with one EC2 host:

.. code::

    ---
    name: example6
    extends: example-ds_vnets.yaml

    defaults:
      provision:
        driver: ec2
        ec2_access: ********************
        ec2_secret: ****************************************
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
      name: ex6-cluster

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "ex6-host1"

Check the :ref:`Templates <ddc_provision_templates>` reference for available base templates.

CLI Commands
============

This section covers the available commands of the ``oneprovision`` tool.

.. warning::

    Commands should be run as the ``oneadmin`` user on your frontend.

.. note::

    Additional CLI arguments ``--verbose/-d`` and ``--debug/-D`` (applicable for all commands of the ``oneprovision`` tool) provide additional levels of logging. Check :ref:`Logging Modes <ddc_usage_log>` for the detailed description.

Create
------

All deployment steps (create, provision, configuration) are covered by a single run of the command ``oneprovision create``. It's necessary to provide a :ref:`provision template <ddc_provision_template>` (with information about what to create, provision and how to configure the hosts). The OpenNebula provision ID is returned after successful provision.

Deployment of a new provision is a 4 step process:

- **Add**. OpenNebula provision objects (cluster, hosts, datastores, networks) are created, but disabled for general use.
- :ref:`Provision <ddc_provision>`. Resources are allocated on the remote provider (e.g. use the provider's API to get clean new hosts).
- :ref:`Configure <ddc_config>`. Resources are reconfigured for a particular use (e.g. install virtualization tools on new hosts).
- **Enable**. Ready-to-use resources are enabled in OpenNebula.

Parameters:

+---------------------------+----------------------------------------------------+-----------+
| Parameter                 | Description                                        | Mandatory |
+===========================+====================================================+===========+
| ``FILENAME``              | File with                                          | **YES**   |
|                           | :ref:`provision template <ddc_provision_template>` |           |
+---------------------------+----------------------------------------------------+-----------+
| ``--ping-retries`` number | Number of SSH connection retries (default: 10)     | NO        |
+---------------------------+----------------------------------------------------+-----------+
| ``--ping-timeout`` number | Seconds between each SSH retry (default: 20)       | NO        |
+---------------------------+----------------------------------------------------+-----------+

Example:

.. prompt:: bash $ auto

    $ oneprovision create myprovision.yaml -d
    2018-11-27 11:32:03 INFO  : Creating provision objects
    WARNING: This operation can take tens of minutes. Please be patient.
    2018-11-27 11:32:05 INFO  : Deploying
    2018-11-27 11:34:42 INFO  : Monitoring hosts
    2018-11-27 11:34:46 INFO  : Checking working SSH connection
    2018-11-27 11:34:49 INFO  : Configuring hosts
    ID: 8fc831e6-9066-4c57-9ee4-4b11fea98f00

Validate
--------

The ``validate`` command checks the provided :ref:`provision template <ddc_provision_template>` is correct. Returns exit code 0 if the template is valid.

Parameters:

+--------------+----------------------------------------------------+-----------+
| Parameter    | Description                                        | Mandatory |
+==============+====================================================+===========+
| ``FILENAME`` | File with                                          | **YES**   |
|              | :ref:`provision template <ddc_provision_template>` |           |
+--------------+----------------------------------------------------+-----------+
| ``--dump``   | Show complete provision template on standard output| NO        |
+--------------+----------------------------------------------------+-----------+

Examples:

.. prompt:: bash $ auto

    $ oneprovision validate simple.yaml
    $ oneprovision validate simple.yaml --dump | head -4
    ---
    name: myprovision
    playbook: default

List
----

The ``list`` command lists all provisions.

.. prompt:: bash $ auto

    $ oneprovision list
                                      ID NAME                      CLUSTERS HOSTS VNETS DATASTORES STAT
    8fc831e6-9066-4c57-9ee4-4b11fea98f00 myprovision                      1     1     1          2 configured

Show
----

The ``show`` command lists all provisioned objects of the particular provision.

Parameters:

+------------------+---------------------+-----------+
| Parameter        | Description         | Mandatory |
+==================+=====================+===========+
| ``provision ID`` | Valid provision ID  | **YES**   |
+------------------+---------------------+-----------+
| ``--csv``        | Show output as CSV  | NO        |
+------------------+---------------------+-----------+

Examples:

.. prompt:: bash $ auto

    $ oneprovision show 8fc831e6-9066-4c57-9ee4-4b11fea98f00
    PROVISION  INFORMATION
    ID                : 8fc831e6-9066-4c57-9ee4-4b11fea98f00
    NAME              : myprovision
    STATUS            : configured

    CLUSTERS
    184

    HOSTS
    766

    VNETS
    135

    DATASTORES
    318
    319

Configure
---------

.. warning::

    It's important to understand that the (re)configuration can happen only on physical hosts that aren't actively used (e.g., no virtual machines running on the host) and with the operating system/services configuration untouched since the last (re)configuration. It's not possible to (re)configure the host with a manually modified OS/services configuration. Also it's not possible to fix a seriously broken host. Such a situation needs to be handled manually by an experienced systems administrator.

The ``configure`` command offlines the OpenNebula hosts (making them unavailable to users) and triggers the deployment configuration phase. If the provision was already successfully configured before, the argument ``--force`` needs to be used. After successful configuration, the OpenNebula hosts are re-enabled.

Parameters:

+------------------+-----------------------+-----------+
| Parameter        | Description           | Mandatory |
+==================+=======================+===========+
| ``provision ID`` | Valid provision ID    | **YES**   |
+------------------+-----------------------+-----------+
| ``--force``      | Force reconfiguration | NO        |
+------------------+-----------------------+-----------+

Examples:

.. prompt:: bash $ auto

    $ oneprovision configure 8fc831e6-9066-4c57-9ee4-4b11fea98f00 -d
    ERROR: Hosts are already configured

    $ oneprovision configure 8fc831e6-9066-4c57-9ee4-4b11fea98f00 -d --force
    2018-11-27 12:43:31 INFO  : Checking working SSH connection
    2018-11-27 12:43:34 INFO  : Configuring hosts

Delete
------

The ``delete`` command releases the physical resources to the remote provider and deletes the provisioned OpenNebula objects.

.. prompt:: bash $ auto

    $ oneprovision delete 8fc831e6-9066-4c57-9ee4-4b11fea98f00 -d
    2018-11-27 12:45:21 INFO  : Deleting provision 8fc831e6-9066-4c57-9ee4-4b11fea98f00
    2018-11-27 12:45:21 INFO  : Undeploying hosts
    2018-11-27 12:45:23 INFO  : Deleting provision objects

Only provisions with no running VMs or images in the datastores can be easily deleted. You can force ``oneprovision`` to terminate VMs running on provisioned hosts and delete all images in the datastores with the ``--cleanup`` parameter.

Parameters:

+------------------+---------------------------------------------+-----------+
| Parameter        | Description                                 | Mandatory |
+==================+=============================================+===========+
| ``provision ID`` | Valid provision ID                          | **YES**   |
+------------------+---------------------------------------------+-----------+
| ``--delete-all`` | Delete all contained objects (VMs, images)  | NO        |
+------------------+---------------------------------------------+-----------+

Examples:

.. prompt:: bash $ auto

    $ oneprovision delete 8fc831e6-9066-4c57-9ee4-4b11fea98f00 -d
    2018-11-27 13:44:40 INFO  : Deleting provision 8fc831e6-9066-4c57-9ee4-4b11fea98f00
    ERROR: Provision with running VMs can't be deleted

.. prompt:: bash $ auto

    $ oneprovision delete 8fc831e6-9066-4c57-9ee4-4b11fea98f00 -d --cleanup
    2018-11-27 13:56:39 INFO  : Deleting provision 8fc831e6-9066-4c57-9ee4-4b11fea98f00
    2018-11-27 13:56:44 INFO  : Undeploying hosts
    2018-11-27 13:56:51 INFO  : Deleting provision objects

Host Management
---------------

Individual hosts from the provision can be managed by the ``oneprovision host`` subcommands.

List
^^^^

The ``host list`` command lists all provisioned hosts, and ``host top`` command periodically refreshes the list until it's terminated.

.. prompt:: bash $ auto

    $ oneprovision host list
      ID NAME            CLUSTER   RVM PROVIDER VM_MAD   STAT
     766 147.75.33.113   conf-prov   0 packet   kvm      on

    $ oneprovision host top

Host Power Off
^^^^^^^^^^^^^^

The ``host poweroff`` command offlines the host in OpenNebula (making it unavailable to users) and powers off the physical resource.

.. prompt:: bash $ auto

    $ oneprovision host poweroff 766 -d
    2018-11-27 12:21:40 INFO  : Powering off host: 766
    HOST 766: disabled

Host Resume
^^^^^^^^^^^

The ``host resume`` command powers on the physical resource, and re-enables the OpenNebula host (making it available again to users).

.. prompt:: bash $ auto

    $ oneprovision host resume 766 -d
    2018-11-27 12:22:57 INFO  : Resuming host: 766
    HOST 766: enabled

Host Reboot
^^^^^^^^^^^

The ``host reboot`` command offlines the OpenNebula host (making it unavailable for users), cleanly reboots the physical resource and re-enables the OpenNebula host (making it available again for users after successful OpenNebula host monitoring).

.. prompt:: bash $ auto

    $ oneprovision host reboot 766 -d
    2018-11-27 12:25:10 INFO  : Rebooting host: 766
    HOST 766: enabled

Host Reset
^^^^^^^^^^

The ``host reboot --hard`` command offlines the OpenNebula host (making it unavailable for users), resets the physical resource and re-enables the OpenNebula host.

.. prompt:: bash $ auto

    $ oneprovision host reboot --hard 766 -d
    2018-11-27 12:27:55 INFO  : Resetting host: 766
    HOST 766: enabled

Host SSH
^^^^^^^^

The ``host ssh`` command opens an interactive SSH connection on the physical resource to the (privileged) remote user used for configuration.

.. prompt:: bash $ auto

    $ oneprovision host ssh 766
    Welcome to Ubuntu 18.04 LTS (GNU/Linux 4.15.0-20-generic x86_64)

     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage

    Last login: Tue Nov 27 10:37:42 2018 from 213.175.39.66
    root@myprovision-host1:~#

An additional argument may specify a command to run on the remote side.

.. prompt:: bash $ auto

    $ oneprovision host ssh 766 hostname
    ip-172-30-4-47.ec2.internal

Host Configure
^^^^^^^^^^^^^^

The physical host :ref:`configuration <ddc_config>` is part of the initial deployment, but it's possible to trigger the reconfiguration on provisioned hosts anytime later (e.g. when a configured service stopped running, or the host needs to be reconfigured differently). Based on the initially-provided connection and configuration parameters in the :ref:`provision template <ddc_provision_template_configuration>`, the configuration steps are applied again.

The ``host configure`` command offlines the OpenNebula host (making it unavailable for users) and re-triggers the deployment configuration phase. If the provisioned the host was already successfully configured, the argument ``--force`` needs to be used. After successful configuration, the OpenNebula host is re-enabled.

.. prompt:: bash $ auto

    $ oneprovision host configure 766 -d
    ERROR: Hosts are already configured

    $ oneprovision host configure 766 -d --force
    2018-11-27 12:36:18 INFO  : Checking working SSH connection
    2018-11-27 12:36:21 INFO  : Configuring hosts
    HOST 766:

Cluster Management
------------------

Individual clusters from the provision can be managed by the ``oneprovision cluster`` subcommands.

Cluster List
^^^^^^^^^^^^

The ``oneprovision cluster list`` command lists all provisioned clusters.

.. prompt:: bash $ auto

    $ oneprovision cluster list
       ID NAME                      HOSTS VNETS DATASTORES
      184 myprovision                   1     1          2

Cluster Delete
^^^^^^^^^^^^^^

The ``oneprovision cluster delete`` command deletes the cluster.

.. prompt:: bash $ auto

    $ oneprovision cluster delete 184 -d
    CLUSTER 184: deleted

The cluster needs to have no datastores, virtual networks, or hosts. Please see the ``oneprovision delete`` command to remove all the related objects.

.. prompt:: bash $ auto

    $ oneprovision cluster delete 184 -d
    ERROR: [one.cluster.delete] Cannot delete cluster. Cluster 185 is not empty, it contains 1 datastores.


Datastore Management
--------------------

Individual datastores from the provision can be managed by the ``oneprovision datastore`` subcommands.

Datastore List
^^^^^^^^^^^^^^

The ``oneprovision datastore list`` command lists all provisioned datastores.

.. prompt:: bash $ auto

    $ oneprovision datastore list
      ID NAME                SIZE AVAIL CLUSTERS     IMAGES TYPE DS      PROVIDER TM      STA
     318 conf-provisio     271.1G 7%    184               0 img  fs      packet   ssh     on
     319 conf-provisio         0M -     184               0 sys  -       packet   ssh     on

Datastore Delete
^^^^^^^^^^^^^^^^

The ``oneprovision datastore delete`` command deletes the datastore.

.. prompt:: bash $ auto

    $ oneprovision datastore delete 318 -d
    2018-11-27 13:01:08 INFO  : Deleting datastore 318
    DATASTORE 318: deleted

Virtual Networks Management
---------------------------

Individual virtual networks from the provision can be managed by the ``oneprovision vnet`` subcommands.

Vnet List
^^^^^^^^^

The ``oneprovision vnet list`` command lists all virtual networks.

.. prompt:: bash $ auto

    $ oneprovision vnet list
      ID USER            GROUP        NAME                CLUSTERS   BRIDGE   PROVIDER LEASES
     136 oneadmin        oneadmin     myprovision-hostonl 184        br0      packet        0

Vnet Delete
^^^^^^^^^^^

The ``oneprovision vnet delete`` command deletes the virtual network.

.. prompt:: bash $ auto

    $ oneprovision vnet delete 136 -d
    2018-11-27 13:02:08 INFO  : Deleting vnet 136
    VNET 136: deleted

.. _ddc_usage_log:

Logging Modes
=============

The ``oneprovision`` tool in the default mode returns only minimal requested output (e.g., provision IDs after create), or errors. Operations on the remote providers or the host configuration are complicated and time-consuming tasks. For better insight and for debugging purposes there are 2 logging modes available, providing more information on the standard error output.

* **verbose** (``--verbose/-d``). Only the main steps are logged.

Example:

.. prompt:: bash $ auto

    $ oneprovision host reboot 766 -d
    2018-11-27 12:58:32 INFO  : Rebooting host: 766
    HOST 766: disabled

* **debug** (``--debug/-D``). All internal actions, including generated configurations with **sensitive data**, are logged.

Example:

.. prompt:: bash $ auto

    $ oneprovision host reboot 766 -D
    2018-11-27 12:59:02 DEBUG : Offlining OpenNebula host: 766
    2018-11-27 12:59:02 INFO  : Rebooting host: 766
    2018-11-27 12:59:02 DEBUG : Command run: /var/lib/one/remotes/pm/packet/reboot fa65c328-57c3-4890-831e-172c9d730b04 147.75.33.113 767 147.75.33.113
    2018-11-27 12:59:09 DEBUG : Command succeeded
    2018-11-27 12:59:09 DEBUG : Enabling OpenNebula host: 766

Running Modes
=============

The ``oneprovision`` tool is ready to deal with common problems during execution. It's able to retry some actions or clean up an incomplete provision. Depending on where and how the tool is used, it offers 2 running modes:

* **interactive** (default). If the unexpected condition appears, the user is asked how to continue.

Example:

.. prompt:: bash $ auto

    $ oneprovision host poweroff 0
    ERROR: Driver action '/var/lib/one/remotes/pm/packet/shutdown' failed
    Shutdown of Packet host 147.75.33.123 failed due to "{"errors"=>["Device must be powered on"]}"
    1. quit
    2. retry
    3. skip
    Choose failover method: 2
    ERROR: Driver action '/var/lib/one/remotes/pm/packet/shutdown' failed
    Shutdown of Packet host 147.75.33.123 failed due to "{"errors"=>["Device must be powered on"]}"
    1. quit
    2. retry
    3. skip
    Choose failover method: 1
    $

* **batch** (``--batch``). It's expected to be run from scripts. No questions are asked, and the tool tries to deal automatically with the problem according to the failover method specified as a command line parameter:

+-------------------------+------------------------------------------------+
| Parameter               | Description                                    |
+=========================+================================================+
| ``--fail-quit``         | Set batch failover mode to quit (default)      |
+-------------------------+------------------------------------------------+
| ``--fail-retry`` number | Set batch failover mode to number of retries   |
+-------------------------+------------------------------------------------+
| ``--fail-cleanup``      | Set batch failover mode to clean up and quit   |
+-------------------------+------------------------------------------------+
| ``--fail-skip``         | Set batch failover mode to skip failing part   |
+-------------------------+------------------------------------------------+

Example of automatic retry:

.. prompt:: bash $ auto

    $ oneprovision host poweroff 0 --batch --fail-retry 2
    ERROR: Driver action '/var/lib/one/remotes/pm/packet/shutdown' failed
    Shutdown of Packet host 147.75.33.123 failed due to "{"errors"=>["Device must be powered on"]}"
    ERROR: Driver action '/var/lib/one/remotes/pm/packet/shutdown' failed
    Shutdown of Packet host 147.75.33.123 failed due to "{"errors"=>["Device must be powered on"]}"
    ERROR: Driver action '/var/lib/one/remotes/pm/packet/shutdown' failed
    Shutdown of Packet host 147.75.33.123 failed due to "{"errors"=>["Device must be powered on"]}"

Example of non-interactive provision with automatic clean up in case of failure:

.. prompt:: bash $ auto

    $ oneprovision create simple.yaml -d --batch --fail-cleanup
    2018-11-27 13:48:53 INFO  : Creating provision objects
    WARNING: This operation can take tens of minutes. Please be patient.
    2018-11-27 13:48:54 INFO  : Deploying
    2018-11-27 13:51:32 INFO  : Monitoring hosts
    2018-11-27 13:51:36 INFO  : Checking working SSH connection
    2018-11-27 13:51:38 INFO  : Configuring hosts
    2018-11-27 13:52:02 WARN  : Command FAILED (code=2): ANSIBLE_CONFIG=/tmp/d20181127-11335-ktlqrb/ansible.cfg ansible-playbook --ssh-common-args='-o UserKnownHostsFile=/dev/null' -i /tmp/d20181127-11335-ktlqrb/inventory -i /usr/share/one/oneprovision/ansible/inventories/default/ /usr/share/one/oneprovision/ansible/default.yml
    ERROR: Configuration failed
    - 147.75.33.125   : TASK[opennebula-repository : Add OpenNebula repository (Ubuntu)] - MODULE FAILURE
    2018-11-27 13:52:02 INFO  : Deleting provision 18e85ef4-b29f-4391-8d89-c72702ede54e
    2018-11-27 13:52:02 INFO  : Undeploying hosts
    2018-11-27 13:52:05 INFO  : Deleting provision objects
