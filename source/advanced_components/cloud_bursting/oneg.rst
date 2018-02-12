.. _oneg:

================================================================================
One-to-One hybrid Driver
================================================================================

Considerations & Limitations
================================================================================

- You need to setup an user account in the remote OpenNebula cloud. All operations will be mapped to this account in the remote OpenNebula cloud, you may need to consider this to when setting up quotas or access rules for this remote account.

- The following operations are supported for VMs in the remote cloud:

    * DEPLOY
    * POWEROFF
    * RESUME
    * REBOOT
    * RESET
    * RESTORE
    * SAVE

- You need to refer the remote VM Templates by their ID, see below for hints to do so.

- Context attribute can be added to the local VM Template, these values will be copied to the remote machine.

.. warning:: The attribute Files is not supported.

- All states of local virtual machines mirror those of the remote virtual machines except for running, that may also include pending or any other active states.

Prerequisites
================================================================================

An user account needs to be setup in remote OpenNebula. This user should have access to the VM Templates that you are going to expose for hybrid access.

.. note:: Can check if the user has access to the remote template with the command ``onetemplate list --endpoint <REMOTE_ENDPOINT> --user <REMOTE_USER> --password <REMOTE_PASS>``.

OpenNebula Configuration
================================================================================

Uncomment the OpenNebula IM and VMM drivers from ``/etc/one/oned.conf`` file in order to use the driver.

.. code::

    IM_MAD = [
        NAME          = "one",
        SUNSTONE_NAME = "OpenNebula",
        EXECUTABLE    = "one_im_sh",
        ARGUMENTS     = "-c -t 1 -r 0 one" ]

     
    VM_MAD = [
        NAME           = "one",
        SUNSTONE_NAME  = "OpenNebula",
        EXECUTABLE     = "one_vmm_sh",
        ARGUMENTS      = "-t 15 -r 0 one",
        TYPE           = "xml",
        KEEP_SNAPSHOTS = "no"
    ]

Driver flags are the same as other drivers:

+--------+---------------------+
| FLAG   | SETs                |
+========+=====================+
| -t     | Number of threads   |
+--------+---------------------+
| -r     | Number of retries   |
+--------+---------------------+

Local Host
--------------------------------------------------------------------------------

First create a new Host with `im` and `vm` drivers set to `opennebula`.

.. code::

    onehost create <name> -i one -v one

Add a new attributes within host template:

.. code::

    onehost update <hostid>

.. code::

    ONE_USER=<remote_username>
    ONE_PASSWORD=<remote_password>
    ONE_ENDPOINT=<remote_endpoint>
    ONE_CAPACITY=[
        CPU=0,
        MEMORY=0
    ]

The following table describes what indicates each attribute that the user needs to add.

.. note:: The attribute ONE_CAPACITY needs to have inside two attributes, CPU and MEMORY, these attributes indicate the quotas for the local host.

+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ATTRIBUTE        | DESCRIPTION                                                                                                                                     |
+==================+=================================================================================================================================================+
| ONE_USER         | Remote username                                                                                                                                 |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ONE_PASSWORD     | Remote password for the username                                                                                                                |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ONE_ENDPOINT     | Remote endpoint url to access                                                                                                                   |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
| ONE_CAPACITY     | 0 indicate that the quotas are taken from the user and group quotas of the remote OpenNebula user. Alternatively, you can set a hard limit here |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+

The user can check if the host has created well with the command:

.. code::

    onehost show <host_id>

Example:

.. prompt:: bash $ auto

    $ onehost create hybrid-test -i one -v one
    $ onehost update hybrid-test
    $ onehost show hybrid-test
    ...
    ONE_CAPACITY=[
        CPU="0",
        MEMORY="0" ]
    ONE_ENDPOINT="http://localhost:2634/RPC2"
    ONE_PASSWORD="fRJ/xgcpXEiokovNnKwoVw=="
    ONE_USER="oneadmin"
    ...


OpenNebula to OpenNebula  Specific Template Attributes
================================================================================

The following section describes how create a new local template and how relate it with the remote template.

Local VM Template
--------------------------------------------------------------------------------

Firstly, the user needs to know if has access to the remote template. The user can execute the following commands:

.. prompt:: bash $ auto

    $ onetemplate list --endpoint http://localhost:2634/RPC2 --user user --password pass
    $ onetemplate show <remote_template_id> --endpoint http://localhost:2634/RPC2 --user user --password pass

The user needs to create a new local template ``onetemplate create <file>``. To match the reported allocated Host resources with the actual usage in the remote OpenNebula, set the same CPU and MEMORY as the remote Template.

Your hybrid VM Template must contain this section. Set TEMPLATE_ID to the target VM Template ID in the **remote OpenNebula**.

.. code::

    PUBLIC_CLOUD=[
    TEMPLATE_ID=<remote_template_id>,
    TYPE="opennebula" ]

Example:

.. prompt:: bash $ auto

    $ cat template.txt
    NAME="hybrid-template"
    CPU=0.1
    MEMORY=128
    PUBLIC_CLOUD=[
        TEMPLATE_ID="0",
        TYPE="opennebula" ]
    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"
    CONTEXT=[
        NETWORK="yes"]

    $ onetemplate create template.txt
    ID: 0

