.. _oneg:

================================================================================
One-to-One Hybrid Driver
================================================================================

Considerations & Limitations
================================================================================

- You need to setup a user account in the remote OpenNebula cloud. All operations will be mapped to this account in the remote OpenNebula cloud. You may need to consider this when setting up quotas or access rules for this remote account.

- The following operations are not supported for VMs in the remote cloud: disk operations (attach/detach, snapshots or save), NIC operations (attach/detach), migrations or reconfigurations.

- You need to refer to the remote VM Templates by their ID. See below for hints on how to do so.

- Context attributes can be added to the local VM Template. These values will be copied to the remote machine.

.. warning:: The attribute FILES is not supported.

- All states of local virtual machines mirror those of the remote virtual machines except that running may also include pending or any other active states.

Prerequisites
================================================================================

A user account needs to be set up in the remote OpenNebula. This user should have access to the VM Templates that you are going to expose for hybrid access.

.. note:: You can check if the user has access to the remote template with the command

.. code::

    $ onetemplate list --endpoint <REMOTE_ENDPOINT> --user <REMOTE_USER> --password <REMOTE_PASS>

OpenNebula Configuration
================================================================================

In order to enable OpenNebula drivers uncomment the OpenNebula VMM drivers from the ``/etc/one/oned.conf``

.. code::

    VM_MAD = [
        NAME           = "one",
        SUNSTONE_NAME  = "OpenNebula",
        EXECUTABLE     = "one_vmm_sh",
        ARGUMENTS      = "-t 15 -r 0 one",
        TYPE           = "xml",
        KEEP_SNAPSHOTS = "no"
    ]

and IM drivers from the ``/etc/one/monitord.conf``

.. code::

    IM_MAD = [
        NAME          = "one",
        SUNSTONE_NAME = "OpenNebula",
        EXECUTABLE    = "one_im_sh",
        ARGUMENTS     = "-c -t 1 -r 0 one" ]
     
Driver flags are the same as for other drivers:

+------------+---------------------+
| FLAG       | SETs                |
+============+=====================+
| ``-t``     | Number of threads   |
+------------+---------------------+
| ``-r``     | Number of retries   |
+------------+---------------------+

Defining a Hybrid OpenNebula Cloud
--------------------------------------------------------------------------------

First create a new Host with `im` and `vm` drivers set to `one`.

.. code::

    $ onehost create <name> -i one -v one

Now add the user attributes to connect to the hybrid OpenNebula within the host template:

.. code::

    $ onehost update <hostid>

    ONE_USER = <remote_username>

    ONE_PASSWORD = <remote_password>
    ONE_ENDPOINT = <remote_endpoint>
    ONE_CAPACITY = [
        CPU    = 0,
        MEMORY = 0
    ]

The following table describes each supported attribute to configure the hybrid OpenNebula cloud.

.. note:: The attribute ONE_CAPACITY includes two sub-attributes, CPU and MEMORY. These attributes limit the usage of the remote resources.

+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ATTRIBUTE        | DESCRIPTION                                                                                                                                     |
+==================+=================================================================================================================================================+
| ONE_USER         | Remote username                                                                                                                                 |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ONE_PASSWORD     | Remote password for the username                                                                                                                |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ONE_ENDPOINT     | Remote endpoint URL to access                                                                                                                   |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ONE_CAPACITY     | 0 indicates that quotas are taken from the user and group quotas of the remote OpenNebula user. Alternatively, you can set a hard limit here    |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+

OpenNebula-to-OpenNebula-Specific Template Attributes
================================================================================

The following section describes how to create a new local template and map it to the remote template.

Local VM Template
--------------------------------------------------------------------------------

Firstly, find out the remote templates you have access to:

.. prompt:: bash $ auto

    $ onetemplate list --endpoint http://<hybrid_OpenNebula_cloud>:2633/RPC2 --user <username> --password <pass>

Now, create a new local template for each remote template you want to use. It is recommended to set the same CPU and MEMORY as the remote Template. For example:


.. prompt:: bash $ auto

    $ cat template.txt
    NAME = "hybrid-template"

    CPU    = 0.1
    MEMORY = 128

    PUBLIC_CLOUD = [
        TEMPLATE_ID = "0",
        TYPE        = "opennebula"
    ]

    CONTEXT=[
        NETWORK="yes"
    ]

    $ onetemplate create template.txt
    ID: 0

.. note:: Your hybrid VM Template must set TEMPLATE_ID to the target VM Template ID in the **remote OpenNebula**.
