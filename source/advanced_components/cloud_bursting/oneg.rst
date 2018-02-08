.. _oneg:

================================================================================
One-to-One hybrid Driver
================================================================================

Considerations & Limitations
================================================================================

- The remote OpenNebula must be accessible from local OpenNebula.

- For the moment not all actions are possible to do with the driver, but allow to execute the basic actions:

    * DEPLOY
    * POWEROFF
    * RESUME
    * REBOOT
    * RESET
    * RESTORE
    * SAVE

- When a users creates a new local VM, needs to know which is the ID of the remote template.

- The users can to add the context attribute to local template, these values, will be copied within VM Template section of the remote machine.

.. warning:: The attribute Files doesn't support.

- All states in local virtual machine have your mirror in the remote virtual machine except the state running of the local virtual machine, this state not indicate that the remote machine is `RUNNING`, the remote virtual machine can be in `PENDING` state.


Prerequisites
================================================================================

The user needs to have an account into remote OpenNebula. This user should have access to the VM Templates that you are going to be exposed to the local OpenNebula cloud.

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
        KEEP_SNAPSHOTS = "no",
        IMPORTED_VMS_ACTIONS = "terminate, terminate-hard, hold, release, suspend,
            resume, delete, reboot, reboot-hard, resched, unresched, poweroff,
            poweroff-hard, disk-attach, disk-detach, nic-attach, nic-detach,
            snap-create, snap-delete"
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

First create a new Host with `im` and `vm` drivers set to `opennebula`. ``onehost create <name> -i one -v one``.

Add a new attributes within host template:

.. code::

    ONE_USER=<remote_username>
    ONE_PASSWORD=<remote_password>
    ONE_ENDPOINT=<remote_endpoint>
    ONE_CAPACITY=[
        CPU=0,
        MEMORY=0
    ]

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

The user can check if the host has created well with the command ``onehost show <host_id>``

OpenNebula to OpenNebula  Specific Template Attributes
================================================================================

Local VM Template
--------------------------------------------------------------------------------

Your hybrid VM Template must contain this section. Set TEMPLATE_ID to the target VM Template ID in the **remote OpenNebula**.

.. code::

    PUBLIC_CLOUD=[
    TEMPLATE_ID=<remote_template_id>,
    TYPE="opennebula" ]


If this Template does not define a local disk and must be deployed only in the remote OpenNebula instance, add this requirement:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

To match the reported allocated Host resources with the actual usage in the remote OpenNebula, set the same CPU and MEMORY as the remote Template.
