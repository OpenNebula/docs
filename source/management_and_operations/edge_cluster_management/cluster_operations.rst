.. _cluster_operations:

=======================
Edge Cluster Operations
=======================

Edge Cluster Limitations
========================

* Currently it is not possible to connect to VMs running in edge clusters through the normal :ref:`Sunstone mechanisms to access VM console <remote_access_sunstone>`, like for instance VNC. Other mechanisms that implies connection to the VM IP, such as SSH and RDP, work as in other VMs running in local clusters.


Creating a Cluster
================================================================================

Check the steps :ref:`here <first_edge_cluster>`. You can also use the command ``oneprovision create``:

.. prompt:: bash $ auto

    $ oneprovision create /tmp/provision.yml
    ID: 0

Managing the Edge Cluster
================================================================================

Listing
--------------------------------------------------------------------------------

The ``list`` command lists all provisions.

Parameters:

+------------------+-------------------------------+-----------+
| Parameter        | Description                   | Mandatory |
+==================+===============================+===========+
| ``--csv``        | Show output as CSV            | NO        |
+------------------+-------------------------------+-----------+
| ``--json``       | Show output as JSON           | NO        |
+------------------+-------------------------------+-----------+
| ``--done``       | Show provisions in DONE state | NO        |
+------------------+-------------------------------+-----------+

.. prompt:: bash $ auto

    $ oneprovision list
    ID NAME                      CLUSTERS HOSTS VNETS DATASTORES STAT
     0 aws-cluster                      1     1     1          2 RUNNING

Showing
--------------------------------------------------------------------------------

The ``show`` command lists all provisioned objects of the particular provision.

Parameters:

+------------------+---------------------+-----------+
| Parameter        | Description         | Mandatory |
+==================+=====================+===========+
| ``provision ID`` | Valid provision ID  | **YES**   |
+------------------+---------------------+-----------+
| ``--csv``        | Show output as CSV  | NO        |
+------------------+---------------------+-----------+
| ``--json``       | Show output as JSON | NO        |
+------------------+---------------------+-----------+
| ``--xml``        | Show output as XML  | NO        |
+------------------+---------------------+-----------+

Examples:

.. prompt:: bash $ auto

    $ oneprovision show 0
    PROVISION 0 INFORMATION
    ID        : 0
    NAME      : aws-cluster
    STATE     : RUNNING
    PROVIDER  : aws

    Provision Infrastructure Resources

    CLUSTERS
    100: aws-cluster

    DATASTORES
    100: aws-cluster-image
    101: aws-cluster-system

    HOSTS
    0: 54.166.142.123
    1: 34.234.201.245

    NETWORKS
    0: aws-cluster-public

    Provision Resource Resources

    VNTEMPLATES
    0: aws-cluster-private

.. note:: The Terraform state is stored inside the provision information, so the user doesn't need to manage it directly.

Configuring
--------------------------------------------------------------------------------

.. warning::

    It's important to understand that the (re)configuration can happen only on physical Hosts that aren't actively used (e.g., no virtual machines running on the Host) and with the operating system/services configuration untouched since the last (re)configuration. It's not possible to (re)configure the Host with a manually modified OS/services configuration. Also, it's not possible to fix a seriously broken Host. Such a situation needs to be handled manually by an experienced systems administrator.

The ``configure`` command offlines the OpenNebula Hosts (making them unavailable to users) and triggers the deployment configuration phase. If the provision was already successfully configured before, the argument ``--force`` needs to be used. After successful configuration, the OpenNebula Hosts are re-enabled.

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

    $ oneprovision configure 0 -d
    ERROR: Hosts are already configured

    $ oneprovision configure 0 -d --force
    2018-11-27 12:43:31 INFO  : Checking working SSH connection
    2018-11-27 12:43:34 INFO  : Configuring hosts

Deleting
--------------------------------------------------------------------------------

The ``delete`` command releases the physical resources to the remote provider and deletes the provisioned OpenNebula objects.

.. prompt:: bash $ auto

    $ oneprovision delete 0 -d
    2018-11-27 12:45:21 INFO  : Deleting provision 0
    2018-11-27 12:45:21 INFO  : Undeploying hosts
    2018-11-27 12:45:23 INFO  : Deleting provision objects

Only provisions with no running VMs or images in the datastores can be easily deleted. You can force ``oneprovision`` to terminate VMs running on provisioned Hosts and delete all images in the datastores by using the ``--cleanup`` parameter.

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

    $ oneprovision delete 0 -d
    2018-11-27 13:44:40 INFO  : Deleting provision 0
    ERROR: Provision with running VMs can't be deleted

.. prompt:: bash $ auto

    $ oneprovision delete 0 -d --cleanup
    2018-11-27 13:56:39 INFO  : Deleting provision 0
    2018-11-27 13:56:44 INFO  : Undeploying hosts
    2018-11-27 13:56:51 INFO  : Deleting provision objects

 - states

Customization of the Edge Cluster
================================================================================

Ansible
--------------------------------------------------------------------------------

Ansible is used to configure the Hosts. All the playbooks and roles are located in ``/usr/share/one/oneprovision/ansible``. OpenNebula comes with a set of roles ready to configure the provision, but in case you want to add new roles or modify the existing ones, please check :ref:`this guide <ddc_config>`.

Provision Elements
--------------------------------------------------------------------------------

You can create multiple elements with a single provision; check :ref:`this guide <ddc_virtual>` for more information.

Adding/Removing Public IPs
--------------------------------------------------------------------------------

Check :ref:`this <edge_public>` to know how you can add more public IPs to an existing Edge Cluster.

Adding Virtual Netwok
--------------------------------------------------------------------------------

Check :ref:`this <edge_private>` to know how you can add more private networks to an existing Edge Cluster.

CLI Commands
================================================================================

Validate
--------------------------------------------------------------------------------

The ``validate`` command checks the provided :ref:`provision template <ddc_provision_template>` is correct. It returns exit code 0 if the template is valid.

Host Management
--------------------------------------------------------------------------------

Individual Hosts from the provision can be managed by the ``oneprovision host`` subcommands.

Cluster Management
--------------------------------------------------------------------------------

Individual clusters from the provision can be managed by the ``oneprovision cluster`` subcommands.

Datastore Management
--------------------------------------------------------------------------------

Individual datastores from the provision can be managed by the ``oneprovision datastore`` subcommands.

Virtual Networks Management
--------------------------------------------------------------------------------

Individual virtual networks from the provision can be managed by the ``oneprovision network`` subcommands.

Images
--------------------------------------------------------------------------------

Individual images from the provision can be managed by the ``oneprovision image`` subcommands.

Templates
--------------------------------------------------------------------------------

Individual VM templates from the provision can be managed by the ``oneprovision template`` subcommands.

VNet Templates
--------------------------------------------------------------------------------

Individual VNet templates from the provision can be managed by the ``oneprovision vntemplate`` subcommands.

Flow Templates
--------------------------------------------------------------------------------

Individual Flow templates from the provision can be managed by the ``oneprovision flowtemplate`` subcommands.

Logging Modes
================================================================================

The ``oneprovision`` tool in the default mode returns only minimal requested output (e.g., provision IDs after create), or errors. Operations on the remote providers or the Host configuration are complicated and time-consuming tasks. For better insight and for debugging purposes there are two logging modes available, providing more information on the standard error output.

* **verbose** (``--verbose/-d``). Only the main steps are logged.
* **debug** (``--debug/-D``). All internal actions, including generated configurations with **sensitive data**, are logged.

Running Modes
================================================================================

The ``oneprovision`` tool is ready to deal with common problems during execution. It's able to retry some actions or clean up an incomplete provision. Depending on where and how the tool is used, it offers two running modes:

* **interactive** (default). If an unexpected condition appears, the user is asked how to continue.
* **batch** (``--batch``). It's expected to be run from scripts. No questions are asked and the tool tries to deal automatically with the problem according to the failover method specified as a command line parameter:
