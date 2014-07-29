.. _appflow_use_cli:

=================================
Managing Multi-tier Applications
=================================

OneFlow allows users and administrators to define, execute and manage multi-tiered applications, or services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced :ref:`OpenNebula user and group management <auth_overview>`.

What Is a Service
=================

The following diagram represents a multi-tier application. Each node represents a Role, and its cardinality (the number of VMs that will be deployed). The arrows indicate the deployment dependencies: each Role's VMs are deployed only when all its parent's VMs are running.

|image0|

This Service can be represented with the following JSON template:

.. code::

    {
      "name": "my_service",
      "deployment": "straight",
      "ready_status_gate": true|false,
      "roles": [
        {
          "name": "frontend",
          "vm_template": 0
        },
        {
          "name": "db_master",
          "parents": [
            "frontend"
          ],
          "vm_template": 1
        },
        {
          "name": "db_slave",
          "parents": [
            "frontend"
          ],
          "cardinality": 3,
          "vm_template": 2
        },
        {
          "name": "worker",
          "parents": [
            "db_master",
            "db_slave"
          ],
          "cardinality": 10,
          "vm_template": 3
        }
      ]
    }

Managing Service Templates
==========================

OneFlow allows OpenNebula administrators and users to register Service Templates in OpenNebula, to be instantiated later as Services. These Templates can be instantiated several times, and also shared with other users.

Users can manage the Service Templates using the command ``oneflow-template``, or the graphical interface. For each user, the actual list of Service Templates available is determined by the ownership and permissions of the Templates.

Create and List Existing Service Templates
------------------------------------------

The command ``oneflow-template create`` registers a JSON template file. For example, if the previous example template is saved in /tmp/my\_service.json, you can execute:

.. code::

    $ oneflow-template create /tmp/my_service.json
    ID: 0

You can also create service template from Sunstone:

|image1|

To list the available Service Templates, use ``oneflow-template list/show/top``:

.. code::

    $ oneflow-template list
            ID USER            GROUP           NAME
             0 oneadmin        oneadmin        my_service

    $ oneflow-template show 0
    SERVICE TEMPLATE 0 INFORMATION
    ID                  : 0
    NAME                : my_service
    USER                : oneadmin
    GROUP               : oneadmin

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    TEMPLATE CONTENTS
    {
      "name": "my_service",
      "roles": [
        {

    ....

Templates can be deleted with ``oneflow-template delete``.

|image2|

.. _appflow_use_cli_running_state:

Determining when a VM is REAADY
-------------------------------

Depending on the deployment strategy, OneFlow will wait until all the VMs in a specific role are all in running state before deploying VMs that belong to a child role. How OneFlow determines the running state of the VMs can be specified with the checkbox ``Wait for VMs to report that the are READY`` available in the service creation dialog in Sunstone, or the attribute in ``ready_status_gate`` in the top-level of the service JSON.

If ``ready_status_gate`` is set to ``true``, a VM will only be considered to be in running state the following points are true:

* VM is in running state for OpenNebula. Which specifically means that ``LCM_STATE==3`` and ``STATE>=3``
* The VM has ``READY=YES`` in the user template.

The idea is report via :ref:`OneGate <onegate_usage>` from inside the VM that it's running during the boot sequence:

.. code::

  curl -X "PUT" http://<onegate>/vm \
    --header "X-ONEGATE-TOKEN: ..." \
    --header "X-ONEGATE-VMID: ..." \
    -d "READY = YES"

This can also be done directly using OpenNebula's interfaces: CLI, Sunstone or API.

If ``ready_status_gate`` is set to ``false``, a VM will be considered to be in running state when it's in running state for OpenNebula (``LCM_STATE==3`` and ``STATE>=3``). Take into account that the VM will be considered RUNNING the very same moment the hypervisor boots the VM (before it loads the OS).

Managing Services
=================

A Service Template can be instantiated as a Service. Each newly created Service will be deployed by OneFlow following its deployment strategy.

Each Service Role creates :ref:`Virtual Machines <vm_guide_2>` in OpenNebula from :ref:`VM Templates <vm_guide>`, that must be created beforehand.

Create and List Existing Services
---------------------------------

New Services are created from Service Templates, using the ``oneflow-template instantiate`` command:

.. code::

    $ oneflow-template instantiate 0
    ID: 1

To list the available Services, use ``oneflow list/top``:

.. code::

    $ oneflow list
            ID USER            GROUP           NAME                      STATE
             1 oneadmin        oneadmin        my_service                PENDING

|image3|

The Service will eventually change to ``DEPLOYING``. You can see information for each Role and individual Virtual Machine using ``oneflow show``

.. code::

    $ oneflow show 1
    SERVICE 1 INFORMATION
    ID                  : 1
    NAME                : my_service
    USER                : oneadmin
    GROUP               : oneadmin
    STRATEGY            : straight
    SERVICE STATE       : DEPLOYING

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---

    ROLE frontend
    ROLE STATE          : RUNNING
    CARNIDALITY         : 1
    VM TEMPLATE         : 0
    NODES INFORMATION
     VM_ID NAME                    STAT UCPU    UMEM HOST                       TIME
         0 frontend_0_(service_1)  runn   67  120.3M localhost              0d 00h01

    ROLE db_master
    ROLE STATE          : DEPLOYING
    PARENTS             : frontend
    CARNIDALITY         : 1
    VM TEMPLATE         : 1
    NODES INFORMATION
     VM_ID NAME                    STAT UCPU    UMEM HOST                       TIME
         1                         init           0K                        0d 00h00

    ROLE db_slave
    ROLE STATE          : DEPLOYING
    PARENTS             : frontend
    CARNIDALITY         : 3
    VM TEMPLATE         : 2
    NODES INFORMATION
     VM_ID NAME                    STAT UCPU    UMEM HOST                       TIME
         2                         init           0K                        0d 00h00
         3                         init           0K                        0d 00h00
         4                         init           0K                        0d 00h00

    ROLE worker
    ROLE STATE          : PENDING
    PARENTS             : db_master, db_slave
    CARNIDALITY         : 10
    VM TEMPLATE         : 3
    NODES INFORMATION
     VM_ID NAME                    STAT UCPU    UMEM HOST                       TIME



    LOG MESSAGES
    09/19/12 14:44 [I] New state: DEPLOYING

Life-cycle
----------

The ``deployment`` attribute defines the deployment strategy that the Life Cycle Manager (part of the :ref:`oneflow-server <appflow_configure>`) will use. These two values can be used:

-  **none**: All roles are deployed at the same time.
-  **straight**: Each Role is deployed when all its parent Roles are ``RUNNING``.

Regardless of the strategy used, the Service will be ``RUNNING`` when all of the Roles are also ``RUNNING``. Likewise, a Role will enter this state only when all the VMs are ``running``.

|image4|

This table describes the Service states:

+--------------------------+--------------------------------------------------------------------------------------------+
| Service State            | Meaning                                                                                    |
+==========================+============================================================================================+
| ``PENDING``              | The Service starts in this state, and will stay in it until the LCM decides to deploy it   |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``DEPLOYING``            | Some Roles are being deployed                                                              |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``RUNNING``              | All Roles are deployed successfully                                                        |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``WARNING``              | A VM was found in a failure state                                                          |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``SCALING``              | A Role is scaling up or down                                                               |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``COOLDOWN``             | A Role is in the cooldown period after a scaling operation                                 |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``UNDEPLOYING``          | Some Roles are being undeployed                                                            |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``DONE``                 | The Service will stay in this state after a successful undeployment. It can be deleted     |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``FAILED_DEPLOYING``     | An error occurred while deploying the Service                                              |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``FAILED_UNDEPLOYING``   | An error occurred while undeploying the Service                                            |
+--------------------------+--------------------------------------------------------------------------------------------+
| ``FAILED_SCALING``       | An error occurred while scaling the Service                                                |
+--------------------------+--------------------------------------------------------------------------------------------+

Each Role has an individual state, described in the following table:

+--------------------------+-------------------------------------------------------------------------------------------+
| Role State               | Meaning                                                                                   |
+==========================+===========================================================================================+
| ``PENDING``              | The Role is waiting to be deployed                                                        |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``DEPLOYING``            | The VMs are being created, and will be monitored until all of them are ``running``        |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``RUNNING``              | All the VMs are ``running``                                                               |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``WARNING``              | A VM was found in a failure state                                                         |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``SCALING``              | The Role is waiting for VMs to be deployed or to be shutdown                              |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``COOLDOWN``             | The Role is in the cooldown period after a scaling operation                              |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``UNDEPLOYING``          | The VMs are being shutdown. The role will stay in this state until all VMs are ``done``   |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``DONE``                 | All the VMs are ``done``                                                                  |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``FAILED_DEPLOYING``     | An error occurred while deploying the VMs                                                 |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``FAILED_UNDEPLOYING``   | An error occurred while undeploying the VMs                                               |
+--------------------------+-------------------------------------------------------------------------------------------+
| ``FAILED_SCALING``       | An error occurred while scaling the Role                                                  |
+--------------------------+-------------------------------------------------------------------------------------------+

Life-Cycle Operations
---------------------

Services are deployed automatically by the Life Cycle Manager. To undeploy a running Service, users have the commands ``oneflow shutdown`` and ``oneflow delete``.

The command ``oneflow shutdown`` will perform a graceful shutdown of all the running VMs, and will delete any VM in a failed state (see :ref:`onevm shutdown and delete <vm_guide_2>`). If the ``straight`` deployment strategy is used, the Roles will be shutdown in the reverse order of the deployment.

After a successful shutdown, the Service will remain in the ``DONE`` state. If any of the VM shutdown operations cannot be performed, the Service state will show ``FAILED``, to indicate that manual intervention is required to complete the cleanup. In any case, the Service can be completely removed using the command ``oneflow delete``.

If a Service and its VMs must be immediately undeployed, the command ``oneflow delete`` can be used from any Service state. This will execute a delete operation for each VM and delete the Service. Please be aware that **this is not recommended**, because VMs using persistent Images can leave them in an inconsistent state.

When a Service fails during a deployment, undeployment or scaling operation, the command ``oneflow recover`` can be used to retry the previous action once the problem has been solved.

Elasticity
----------

A role's cardinality can be adjusted manually, based on metrics, or based on a schedule. To start the scalability immediately, use the command ``oneflow scale``:

.. code::

    $ oneflow scale <serviceid> <role_name> <cardinality>

To define automatic elasticity policies, proceed to the :ref:`elasticity documentation guide <appflow_elasticity>`.

Managing Permissions
====================

Both Services and Template resources are completely integrated with the :ref:`OpenNebula user and group management <auth_overview>`. This means that each resource has an owner and group, and permissions. The VMs created by a Service are owned by the Service owner, so he can list and manage them.

For example, to change the owner and group of the Service 1, we can use ``oneflow chown/chgrp``:

.. code::

    $ oneflow list
            ID USER            GROUP           NAME                      STATE
             1 oneadmin        oneadmin        my_service                RUNNING

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
         0 oneadmin oneadmin frontend_0_(ser runn   17   43.5M localhost    0d 01h06
         1 oneadmin oneadmin db_master_0_(se runn   59  106.2M localhost    0d 01h06
    ...

    $ oneflow chown my_service johndoe apptools

    $ oneflow list
            ID USER            GROUP           NAME                      STATE
             1 johndoe         apptools        my_service                RUNNING

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
         0 johndoe  apptools frontend_0_(ser runn   62   83.2M localhost    0d 01h16
         1 johndoe  apptools db_master_0_(se runn   74  115.2M localhost    0d 01h16
    ...

Note that the Service's VM ownership is also changed.

All Services and Templates have associated permissions for the **owner**, the users in its **group**, and **others**. For each one of these groups, there are three rights that can be set: **USE**, **MANAGE** and **ADMIN**. These permissions are very similar to those of UNIX file system, and can be modified with the command ``chmod``.

For example, to allow all users in the ``apptools`` group to USE (list, show) and MANAGE (shutdown, delete) the Service 1:

.. code::

    $ oneflow show 1
    SERVICE 1 INFORMATION
    ..

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---
    ...

    $ oneflow chmod my_service 660

    $ oneflow show 1
    SERVICE 1 INFORMATION
    ..

    PERMISSIONS
    OWNER               : um-
    GROUP               : um-
    OTHER               : ---
    ...

Another common scenario is having Service Templates created by oneadmin that can be instantiated by any user. To implement this scenario, execute:

.. code::

    $ oneflow-template show 0
    SERVICE TEMPLATE 0 INFORMATION
    ID                  : 0
    NAME                : my_service
    USER                : oneadmin
    GROUP               : oneadmin

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : ---
    ...

    $ oneflow-template chmod 0 604

    $ oneflow-template show 0
    SERVICE TEMPLATE 0 INFORMATION
    ID                  : 0
    NAME                : my_service
    USER                : oneadmin
    GROUP               : oneadmin

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : u--
    ...

Please refer to the OpenNebula documentation for more information about :ref:`users & groups <auth_overview>`, and :ref:`resource permissions <chmod>`.

Scheduling Actions on the Virtual Machines of a Role
====================================================

You can use the ``action`` command to perform a VM action on all the Virtual Machines belonging to a role. For example, if you want to suspend the Virtual Machines of the worker Role:

.. code::

    $ oneflow action <service_id> <role_name> <vm_action>

These are the commands that can be performed:

-  ``shutdown``
-  ``shutdown-hard``
-  ``undeploy``
-  ``undeploy-hard``
-  ``hold``
-  ``release``
-  ``stop``
-  ``suspend``
-  ``resume``
-  ``boot``
-  ``delete``
-  ``delete-recreate``
-  ``reboot``
-  ``reboot-hard``
-  ``poweroff``
-  ``poweroff-hard``
-  ``snapshot-create``

Instead of performing the action immediately on all the VMs, you can perform it on small groups of VMs with these options:

-  ``-p, –period x``: Seconds between each group of actions
-  ``-n, –number x``: Number of VMs to apply the action to each period

Let's say you need to reboot all the VMs of a Role, but you also need to avoid downtime. This command will reboot 2 VMs each 5 minutes:

.. code::

    $ oneflow action my-service my-role reboot --period 300 --number 2

The ``oneflow-server.conf`` file contains default values for ``period`` and ``number`` that are used if you omit one of them.

Recovering from Failures
========================

Some common failures can be resolved without manual intervention, calling the ``oneflow recover`` command. This command has different effects depending on the Service state:

+--------------------------+-------------------+----------------------------------------------------------------------------+
| State                    | New State         | Recover action                                                             |
+==========================+===================+============================================================================+
| ``FAILED_DEPLOYING``     | ``DEPLOYING``     | VMs in ``DONE`` or ``FAILED`` are deleted.                                 |
|                          |                   |  VMs in ``UNKNOWN`` are booted.                                            |
+--------------------------+-------------------+----------------------------------------------------------------------------+
| ``FAILED_UNDEPLOYING``   | ``UNDEPLOYING``   | The undeployment is resumed.                                               |
+--------------------------+-------------------+----------------------------------------------------------------------------+
| ``FAILED_SCALING``       | ``SCALING``       | VMs in ``DONE`` or ``FAILED`` are deleted.                                 |
|                          |                   |  VMs in ``UNKNOWN`` are booted.                                            |
|                          |                   |  For a scale-down, the shutdown actions are retried.                       |
+--------------------------+-------------------+----------------------------------------------------------------------------+
| ``COOLDOWN``             | ``RUNNING``       | The Service is simply set to running before the cooldown period is over.   |
+--------------------------+-------------------+----------------------------------------------------------------------------+
| ``WARNING``              | ``WARNING``       | VMs in ``DONE`` or ``FAILED`` are deleted.                                 |
|                          |                   |  VMs in ``UNKNOWN`` are booted.                                            |
|                          |                   |  New VMs are instantiated to maintain the current cardinality.             |
+--------------------------+-------------------+----------------------------------------------------------------------------+

Service Template Reference
==========================

For more information on the resource representation, please check the :ref:`API guide <appflow_api>`

Read the :ref:`elasticity policies documentation <appflow_elasticity>` for more information.

.. |image0| image:: /images/service_sample.png
.. |image1| image:: /images/oneflow-templates-create.png
.. |image2| image:: /images/oneflow-templates.png
.. |image3| image:: /images/oneflow-service.png
.. |image4| image:: /images/flow_lcm.png
