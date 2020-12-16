.. _appflow_use_cli:

================================================================================
OneFlow Services Management
================================================================================

OneFlow allows users and administrators to define, execute and manage multi-tiered applications, which we call Services, composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced :ref:`OpenNebula user and group management <auth_overview>`.

What Is a Service
=================

The following diagram represents a multi-tier application. Each node represents a Role, and its cardinality (the number of VMs that will be deployed). The arrows indicate the deployment dependencies: each Role's VMs are deployed only when all its parent's VMs are running.

|image0|

This Service can be represented with the following JSON template:

.. code-block:: javascript

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

Defining a new Service: Templates
=================================

OneFlow allows OpenNebula administrators and users to register Service Templates in OpenNebula, to be instantiated later as Services. These Templates can be instantiated several times, and also shared with other users.

Users can manage the Service Templates using the command ``oneflow-template``, or Sunstone. For each user, the actual list of Service Templates available is determined by the ownership and permissions of the Templates.

Create and List Existing Service Templates
------------------------------------------

The command ``oneflow-template create`` registers a JSON template file. For example, if the previous example template is saved in /tmp/my_service.json, you can execute:

.. prompt:: bash $ auto

    $ oneflow-template create /tmp/my_service.json
    ID: 0


To list the available Service Templates, use ``oneflow-template list/show/top``:

.. code::

    $ oneflow-template list
            ID USER            GROUP           NAME         REGTIME
             0 oneadmin        oneadmin        my_service   10/28 17:42:46

    $ oneflow-template show 0
    SERVICE TEMPLATE 0 INFORMATION
    ID                  : 0
    NAME                : my_service
    USER                : oneadmin
    GROUP               : oneadmin
    REGISTRATION_TIME   : 10/28 17:42:46

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

.. _appflow_use_cli_delete_service_template:

Templates can be deleted with ``oneflow-template delete``.

You can also delete VM templates associated to the service template:

- ``--delete-vm-templates``: this will delete all the VM templates associated and the service template.
- ``--delete-images``: this will delete all the VM templates and images associated and the service template.

You can also create and manage Service Templates from Sunstone.

.. _appflow_use_cli_automatic_delete:

Automatic delete service if all roles are terminated
----------------------------------------------------

Service VMs can be terminated using scheduled actions or VM charters. This can lead to a situation where you have a running service with no VMs associated to it.
To avoid this you can use automatic deletion feature.

CLI
^^^

To enable it using the CLI, you need to add the following attribute to the service template:

.. prompt:: bash $ auto

    "automatic_deletion": true

.. _appflow_use_cli_running_state:

Determining when a VM is READY
-------------------------------

Depending on the deployment strategy, OneFlow will wait until all the VMs in a specific Role are all in running state before deploying VMs that belong to a child Role. How OneFlow determines the running state of the VMs can be specified with the checkbox ``Wait for VMs to report that the are READY`` available in the Service creation dialog in Sunstone, or the attribute in ``ready_status_gate`` in the top level of the Service Template JSON.

|oneflow-ready-status-checkbox|

If ``ready_status_gate`` is set to ``true``, a VM will only be considered to be in running state the following points are true:

* VM is in running state for OpenNebula. Which specifically means that ``LCM_STATE==3`` and ``STATE>=3``
* The VM has ``READY=YES`` in the user template.

The idea is to report via :ref:`OneGate <onegate_usage>` from inside the VM that it's running during the boot sequence:

.. code::

  curl -X "PUT" http://<onegate>/vm \
    --header "X-ONEGATE-TOKEN: ..." \
    --header "X-ONEGATE-VMID: ..." \
    -d "READY = YES"

This can also be done directly using OpenNebula's interfaces: CLI, Sunstone or API.

If ``ready_status_gate`` is set to ``false``, a VM will be considered to be in running state when it's in running state for OpenNebula (``LCM_STATE==3`` and ``STATE>=3``). Take into account that the VM will be considered RUNNING the very same moment the hypervisor boots the VM (before it loads the OS).

.. _appflow_use_cli_networks:

Configure Dynamic Networks
--------------------------------------------------------------------------------

Each Service Role has a :ref:`Virtual Machine Template <vm_guide>` assigned. The VM Template will define the capacity, disks, and network interfaces. Apart from defining the Virtual Networks in the VM Template, the Service Template can define a set of dynamic networks.

|oneflow-templates-net-1|

Then each Role of the service can be attached to one or more dynamic networks individually. The network can be attached to the Role as an alias. In this case, you need to specify the interface to add the alias by selecting the virtual network it will be attached to. For example the Role, ``slave`` in the next picture will have one physical interface attached to the ``PRIVATE`` network. This interface will also have a IP alias configured from network ``PUBLIC``.

Additionally you can set if the VMs in the Role exposes an RDP endpoint. Equivalently, you need to specify the IP of the VM for the RDP connection by selecting the virtual network the interface is attached to.

|oneflow-templates-net-2|

A Service Template can define three different dynamic network modes, that determine how the networks will be used:

- You can use an existing Virtual Network, VMs in the Role will just take a lease from that network. You'll probably use this method for networks with a predefined address set (e.g. public IPs).

- You can create a network reservation, in this case it will take the existing network and create a reservation for the service. You have to specify the name of the reservation and the size in the input dialog. Use this method when you need to allocate a pool of IPs for your service.

- You can create a network instantiating a network template. In this case as an extra parameters you may have to specify the address range to create, depending on the selected network template. This is useful for service private VLAN for internal service communication.

This allows you to create more generic Service Templates. For example, the same Service Template can be used by users of different :ref:`groups <manage_groups>` that may have access to different Virtual Networks.

.. note:: When the service is deleted, all the networks that have been created are automatically deleted.

.. note:: You can provide suitable defaults for the dynamic networks

All these operations can be also done through the CLI. When you instantiate the template using ``oneflow-template instantiate <ID> <file>``

.. code::

    # Use existing network
    {"networks_values": [{"Private":{"id":"0"}}]}

    # Reserve from a network
    {"networks_values":[{"Private":{"reserve_from":"0", "extra": ""NAME=RESERVATION\nSIZE=5""}}]}

    # Instantiate a network template
    {"networks_values": [{"Private":{"template_id":"0", "extra":"AR=[ IP=192.168.122.10, SIZE=10, TYPE=IP4 ]"}}]}

Using Custom Attributes
--------------------------------------------------------------------------------

You can use some custom attributes in service template to pass them to the virtual machine context section. This custom attributes are key-value format and can be mandatory or optional.

|oneflow-templates-attrs|

You can also use them through the CLI. When you instantiate the template using ``oneflow-template instantiate <ID> <file>``

.. code::

    {"custom_attrs_values":{"A":"A_VALUE", "B":"B_VALUE"}

.. note:: In order to pass the service custom attributes to the VM  when using the CLI they need to be duplicated inside ``vm_template_contents`` section.

.. _service_clone:

Clone a Service Template
------------------------

A service template can be cloned to produce a copy, ready to be instantiated under another name. This copy can be recursive, so all the VM Templates forming the service will be cloned as well, and referenced from the cloned service.

The ``oneflow-template clone`` (with the optional --recursive flag) can be used to achieve this, as well as from the Sunstone service template tab.

Managing Services
=================

A Service Template can be instantiated as a Service. Each newly created Service will be deployed by OneFlow following its deployment strategy.

Each Service Role creates :ref:`Virtual Machines <vm_instances>` in OpenNebula from :ref:`VM Templates <vm_guide>`, that must be created beforehand.

Create and List Existing Services
---------------------------------

New Services are created from Service Templates, using the ``oneflow-template instantiate`` command:

.. prompt:: bash $ auto

    $ oneflow-template instantiate 0
    ID: 1

To list the available Services, use ``oneflow list/top``:

.. prompt:: bash $ auto

    $ oneflow list
            ID USER            GROUP           NAME          STARTTIME          STATE
             1 oneadmin        oneadmin        my_service    10/28 17:42:46     PENDING

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
    START TIME          : 10/28 17:42:46

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

.. warning:: Once the service has been instantiated, all the operations with the virtual machines **must** be performed using OneFlow commands or API.

Life-cycle
----------

The ``deployment`` attribute defines the deployment strategy that the Life Cycle Manager (part of the :ref:`oneflow-server <appflow_configure>`) will use. These two values can be used:

-  **none**: All Roles are deployed at the same time.
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
| ``UNDEPLOYING``          | The VMs are being shutdown. The Role will stay in this state until all VMs are ``done``   |
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

Services are deployed automatically by the Life Cycle Manager. To undeploy a running Service, users can use the command ``oneflow delete``.

The command ``oneflow delete`` will perform a graceful a ``terminate`` on all the running VMs (see :ref:`onevm terminate <vm_instances>`). If the ``straight`` deployment strategy is used, the Roles will be shutdown in the reverse order of the deployment.

After a successful shutdown, the Service will remain in the ``DONE`` state. If any of the VM terminate operations cannot be performed, the Service state will show ``FAILED``, to indicate that manual intervention is required to complete the cleanup. In any case, the Service can be completely removed using the command ``oneflow recover --delete``.

When a Service fails during a deployment, undeployment or scaling operation, the command ``oneflow recover`` can be used to retry the previous action once the problem has been solved.

.. _flow_purge_done:

In order to delete all the services in ``DONE`` state, to free some space in your database, you can use the command ``oneflow purge-done``.

Managing Permissions
====================

Both Services and Template resources are completely integrated with the :ref:`OpenNebula user and group management <auth_overview>`. This means that each resource has an owner and group, and permissions. The VMs created by a Service are owned by the Service owner, so he can list and manage them.

For example, to change the owner and group of the Service 1, we can use ``oneflow chown/chgrp``:

.. code::

    $ oneflow list
            ID USER            GROUP           NAME           STARTTIME         STATE
             1 oneadmin        oneadmin        my_service     10/28 17:42:46    RUNNING

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
         0 oneadmin oneadmin frontend_0_(ser runn   17   43.5M localhost    0d 01h06
         1 oneadmin oneadmin db_master_0_(se runn   59  106.2M localhost    0d 01h06
    ...

    $ oneflow chown my_service johndoe apptools

    $ oneflow list
            ID USER            GROUP           NAME           STARTTIME         STATE
             1 johndoe         apptools        my_service     10/28 17:42:46    RUNNING

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
         0 johndoe  apptools frontend_0_(ser runn   62   83.2M localhost    0d 01h16
         1 johndoe  apptools db_master_0_(se runn   74  115.2M localhost    0d 01h16
    ...

.. note:: The Service's VM ownership is also changed.

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
    REGISTRATION_TIME   : 10/28 17:42:46

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
    REGISTRATION_TIME   : 10/28 17:42:46

    PERMISSIONS
    OWNER               : um-
    GROUP               : ---
    OTHER               : u--
    ...

Please refer to the OpenNebula documentation for more information about :ref:`users & groups <auth_overview>`, and :ref:`resource permissions <chmod>`.

.. _flow_sched:

Scheduling Actions on the Virtual Machines of a Role
====================================================

You can use the ``action`` command to perform a VM action on all the Virtual Machines belonging to a Role. For example, if you want to suspend the Virtual Machines of the worker Role:

.. code::

    $ oneflow action <service_id> <role_name> <vm_action>

These are the commands that can be performed:

* ``terminate``
* ``terminate-hard``
* ``undeploy``
* ``undeploy-hard``
* ``hold``
* ``release``
* ``stop``
* ``suspend``
* ``resume``
* ``reboot``
* ``reboot-hard``
* ``poweroff``
* ``poweroff-hard``
* ``snapshot-create``
* ``snapshot-revert``
* ``snapshot-delete``
* ``disk-snapshot-create``
* ``disk-snapshot-revert``
* ``disk-snapshot-delete``

Instead of performing the action immediately on all the VMs, you can perform it on small groups of VMs with these options:

-  ``-p, --period x``: Seconds between each group of actions
-  ``-n, --number x``: Number of VMs to apply the action to each period

Let's say you need to reboot all the VMs of a Role, but you also need to avoid downtime. This command will reboot 2 VMs each 5 minutes:

.. prompt:: text $ auto

    $ oneflow action my-service my-role reboot --period 300 --number 2

The ``/etc/one/oneflow-server.conf`` file contains default values for ``period`` and ``number`` that are used if you omit one of them.

.. note:: You can also perform an operation in the whole service using eht command ``service action``. All the above operations and options are supported.

Recovering from Failures
========================

Some common failures can be resolved without manual intervention, calling the ``oneflow recover`` command. This command has different effects depending on the Service state:

+------------------------+-----------------+--------------------------------------------------------------------------+
|         State          |    New State    |                              Recover action                              |
+========================+=================+==========================================================================+
| ``FAILED_DEPLOYING``   | ``DEPLOYING``   | VMs in ``DONE`` or ``FAILED`` are terminated.                            |
|                        |                 |                                                                          |
|                        |                 | VMs in ``UNKNOWN`` are booted.                                           |
+------------------------+-----------------+--------------------------------------------------------------------------+
| ``FAILED_UNDEPLOYING`` | ``UNDEPLOYING`` | The undeployment is resumed.                                             |
+------------------------+-----------------+--------------------------------------------------------------------------+
| ``FAILED_SCALING``     | ``SCALING``     | VMs in ``DONE`` or ``FAILED`` are terminated.                            |
|                        |                 |                                                                          |
|                        |                 | VMs in ``UNKNOWN`` are booted.                                           |
|                        |                 |                                                                          |
|                        |                 | For a scale-down, the shutdown actions are retried.                      |
+------------------------+-----------------+--------------------------------------------------------------------------+
| ``COOLDOWN``           | ``RUNNING``     | The Service is simply set to running before the cooldown period is over. |
+------------------------+-----------------+--------------------------------------------------------------------------+
| ``WARNING``            | ``WARNING``     | VMs in ``DONE`` or ``FAILED`` are terminated.                            |
|                        |                 |                                                                          |
|                        |                 | VMs in ``UNKNOWN`` are booted.                                           |
|                        |                 |                                                                          |
|                        |                 | New VMs are instantiated to maintain the current cardinality.            |
+------------------------+-----------------+--------------------------------------------------------------------------+

You can use the option ``--delete`` to delete the current service and its VMs.

Update Service
==============

You can update a service in running state, to do that you need to use the command ``oneflow update <service_id>``. It will prompt an editor with
the service template body in JSON format.

You can update all the values, except the following ones:

Service
-------

- **custom_attrs**: it only has sense when deploying, not in running.
- **custom_attrs_values**: it only has sense when deploying, not in running.
- **deployment**: changing this, changes the undeploy operation.
- **log**: this is just internal information, no sense to change it.
- **name**: this has to be changed using rename operation.
- **networks**: it only has sense when deploying, not in running.
- **networks_values**: it only has sense when deploying, not in running.
- **ready_status_gate**: it only has sense when deploying, not in running.
- **state**: this is internal information managed by OneFlow server.

Role
----

- **cardinality**: this is internal information managed by OneFlow server.
- **last_vmname**: this is internal information managed by OneFlow server.
- **nodes**: this is internal information managed by OneFlow server.
- **parents**: this has only sense in deploy operation.
- **state**: this is internal information managed by OneFlow server.
- **vm_template**: this will affect scale operation.

.. warning:: If you try to change one of these values above, you will get an error. The server will also check the schema in case there is another error.

.. note:: If you change the value of min_vms the OneFlow server will adjust the cardinality automatically. Also, if you add or edit elasticity rules they will be automatically evaluated.

Advanced Usage
================================================================================

Elasticity
----------

A Role's cardinality can be adjusted manually, based on metrics, or based on a schedule. To start the scalability immediately, use the command ``oneflow scale``:

.. prompt:: bash $ auto

    $ oneflow scale <serviceid> <role_name> <cardinality>

To define automatic elasticity policies, proceed to the :ref:`elasticity documentation guide <appflow_elasticity>`.

Sharing Information between VMs
--------------------------------------------------------------------------------

The Virtual Machines of a Service can share information with each other, using the :ref:`OneGate server <onegate_overview>`.  OneGate allows Virtual Machine guests to push information to OpenNebula, and pull information about their own VM or Service.

From any VM, use the ``PUT ${ONEGATE_ENDPOINT}/vm`` action to store any information in the VM user template. This information will be in the form of attribute=vale, e.g. ``ACTIVE_TASK = 13``. Other VMs in the Service can request that information using the ``GET ${ONEGATE_ENDPOINT}/service`` action.

You can read more details in the :ref:`OneGate API documentation <onegate_usage>`.

Network mapping & Floating IPs
--------------------------------------------------------------------------------

Network mapping can be achieved by using OneFlow and OneGate together. A few steps are required for mapping IP addresses from an internal network into an external one, as shown in the image below:

|oneflow-network-mapping|

**Upload the Network Mapping script**

First of all, it is necessary to upload the Network Mapping script to a :ref:`Kernels & Files Datastore <file_ds>`. Simply, Create a file of type ``Context`` in the File Datastore using ``/usr/share/one/start-scripts/map_vnets_start_script``. Note that you may need to add ``/usr/share/one/start-script`` path to ``SAFE_DIRS`` attribute of the Files Datastore.


**Preparing the Router Virtual Machine Template**

A custom Virtual Machine template acting as router is also needed. Steps similar to those below should be followed:

* Storage. Choose a disk image. For instance, a light weight Alpine that can be get on :ref:`OpenNebula Systems MarketPlace <market_one>`.

* Network. You may want to set ``virtio`` as ``Default hardware model to emulate for all NICs``.

* Context:

  * Configuration:

    * ``Add OneGate token`` must be checked (this is also aplicable to all templates used in the Service Template).

    * Copy the contents of ``/usr/share/one/start-scripts/cron_start_script`` in ``Start script``.

      |oneflow-network-mapping-router_context_config|

    * Files. Select the network mapping script previously uploaded to the File Datastore.

**Prepare the Service Template**

As an example we will create a two-tier server with an external network (*Public*) and an internal (*Private*) one for private traffic:

* Network configuration. Declare the *Public* and *Private* networks to be used on instantiation. :ref:`See Dynamic Networks section above <appflow_use_cli_networks>`.

* Role ``router``. Select the previously created Router Virtual Template, and check ``Private`` and ``Public`` in ``Network Interfaces``.

* Role ``worker``. Select a Virtual Machine Template, check only ``Private`` in ``Network Interfaces``, and check ``router`` in ``Parent roles`` to set up a deploy dependency.

**Instantiate the Service Template**

At this point the Service Template can be instantiated.  If a ``NIC_ALIAS`` on *Pulic* network is attached to any of the virtual machines on the *worker* role, the specific machine can be reached by using the IP address assigned to the ``NIC_ALIAS``.

.. code::

   $ ping -c1 10.0.0.2
   PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
   64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.936 ms

   --- 10.0.0.2 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.936/0.936/0.936/0.000 ms

If the ``NIC_ALIAS`` on *Pulic* network is detached from the virtual machine, the connectivity -through the previously- assigned IP address is lost. You can re-attach the IP as a ``NIC_ALIAS`` to other VM to *float* the IP.

.. code::

   $ ping -c1 10.0.0.2
   PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.

   --- 10.0.0.2 ping statistics ---
   1 packets transmitted, 0 received, 100% packet loss, time 0ms

.. warning:: It takes up to one minute, half a minute on average, to configure the rules on *iptables*.


Service Template Reference
==========================

For more information on the resource representation, please check the :ref:`API guide <appflow_api>`

Read the :ref:`elasticity policies documentation <appflow_elasticity>` for more information.

.. |image0| image:: /images/service_sample.png
.. |image3| image:: /images/oneflow-service.png
.. |image4| image:: /images/flow_lcm.png
.. |oneflow-ready-status-checkbox| image:: /images/oneflow-ready-status-checkbox.png
.. |oneflow-templates-net-1| image:: /images/oneflow-templates-net-1.png
.. |oneflow-templates-net-2| image:: /images/oneflow-templates-net-2.png
.. |oneflow-templates-net-3| image:: /images/oneflow-templates-net-3.png
.. |oneflow-templates-net-4| image:: /images/oneflow-templates-net-4.png
.. |oneflow-templates-net-5| image:: /images/oneflow-templates-net-5.png
.. |oneflow-templates-attrs| image:: /images/oneflow-templates-attrs.png
.. |oneflow-network-mapping| image:: /images/oneflow-network-map.png
.. |oneflow-network-mapping-router_context_config| image:: /images/oneflow-network-map-router_context_config.png
.. |oneflow-network-mapping-service_template_nw_config| image:: /images/oneflow-network-map-service_template_nw_config.png
.. |oneflow-network-mapping-service_template_role_router| image:: /images/oneflow-network-map-service_template_role_router.png
