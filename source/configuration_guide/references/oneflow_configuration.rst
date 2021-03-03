.. _appflow_configure:

=====================
OneFlow Configuration
=====================

The OneFlow server orchestrates the multi-VM services, it's a dedicated daemon which takes the requests and interacts with the OpenNebula Daemon. It's installed by default, but the use is completely optional and/or can be deployed separately on a different machine. Please check the :ref:`Single Front-end Installation <ignc>`.

Configuration
=============

The OneFlow configuration file can be found at ``/etc/one/oneflow-server.conf``. It uses YAML syntax to define the following options:

+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        Option         |                                                                               Description                                                                               |
+=======================+=========================================================================================================================================================================+
| **Server Configuration**                                                                                                                                                                        |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :one\_xmlrpc          | OpenNebula daemon host and port                                                                                                                                         |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :subscriber\_endpoint | Endpoint to subscribe to ZMQ                                                                                                                                            |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :autoscaler\_interval | Time in seconds between each time elasticity rules are evaluated                                                                                                        |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :host                 | Host where OneFlow will listen                                                                                                                                          |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :port                 | Port where OneFlow will listen                                                                                                                                          |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :force_deletion       | Force deletion of VMs on terminate signal                                                                                                                               |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Defaults**                                                                                                                                                                                    |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :default\_cooldown    | Default cooldown period after a scale operation, in seconds                                                                                                             |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :wait_timeout         | Default time to wait VMs states changes, in seconds                                                                                                                     |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :concurrency          | Number of threads to make actions with flows                                                                                                                            |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :shutdown\_action     | Default shutdown action. Values: 'shutdown', 'shutdown-hard'                                                                                                            |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :action\_number       | Default number of virtual machines (action\_number) that will receive the given call in each interval defined by action\_period, when an action is performed on a Role. |
| :action\_period       |                                                                                                                                                                         |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vm\_name\_template   | Default name for the Virtual Machines created by oneflow. You can use any of the following placeholders:                                                                |
|                       |                                                                                                                                                                         |
|                       | - $SERVICE_ID                                                                                                                                                           |
|                       | - $SERVICE_NAME                                                                                                                                                         |
|                       | - $ROLE_NAME                                                                                                                                                            |
|                       | - $VM_NUMBER                                                                                                                                                            |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Auth**                                                                                                                                                                                        |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :core\_auth           | Authentication driver to communicate with OpenNebula core                                                                                                               |
|                       |                                                                                                                                                                         |
|                       | * ``cipher``: for symmetric cipher encryption of tokens                                                                                                                 |
|                       | * ``x509``: for x509 certificate encryption of tokens                                                                                                                   |
|                       |                                                                                                                                                                         |
|                       | For more information, visit the :ref:`OpenNebula Cloud Auth documentation <cloud_auth>`                                                                                 |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Log**                                                                                                                                                                                         |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :debug\_level         | Log debug level. 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG                                                                                                            |
+-----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

This is the default file

.. code-block:: yaml

    ################################################################################
    # Server Configuration
    ################################################################################

    # OpenNebula daemon contact information
    #
    :one_xmlrpc: http://localhost:2633/RPC2

    # :subscriber_endpoint to subscribe for OpenNebula events must match those in
    # oned.conf
    :subscriber_endpoint: 'tcp://localhost:2101'

    # Time in seconds between each time scale rules are evaluated
    #
    :autoscaler_interval: 90

    # Host and port where OneFlow server will run
    :host: 127.0.0.1
    :port: 2474

    # Force deletion of VMs on terminate signal
    :force_deletion: false

    ################################################################################
    # Defaults
    ################################################################################

    # Default cooldown period after a scale operation, in seconds
    :default_cooldown: 300

    # Default timeout in seconds to wait VMs to report different states
    # This timeout is used when option report ready is true and for normal actions
    :wait_timeout: 30

    # Number of threads to make actions with flows
    # Tune this depending of the load you will have
    :concurrency: 10

    # Default shutdown action. Values: 'terminate', 'terminate-hard'
    :shutdown_action: 'terminate'

    # Default number of virtual machines (action_number) that will receive the
    #   given call in each interval defined by action_period, when an action
    #   is performed on a role.
    :action_number: 1
    :action_period: 60

    # Default name for the Virtual Machines and Virtual Networks created by oneflow. You can use any
    # of the following placeholders:
    #   $SERVICE_ID
    #   $SERVICE_NAME
    #   $ROLE_NAME
    #   $VM_NUMBER (onely for VM names)

    :vm_name_template: '$ROLE_NAME_$VM_NUMBER_(service_$SERVICE_ID)'
    #:vn_name_template: '$ROLE_NAME(service_$SERVICE_ID)'
    #############################################################
    # Auth
    #############################################################

    # Authentication driver to communicate with OpenNebula core
    #   - cipher, for symmetric cipher encryption of tokens
    #   - x509, for x509 certificate encryption of tokens
    :core_auth: cipher

    ################################################################################
    # Log
    ################################################################################

    # Log debug level
    #   0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG
    #
    :debug_level: 2

.. note:: By default, the server will only listen to requests coming from localhost. Change the ``:host`` attribute in ``/etc/one/oneflow-server.conf`` to your server public IP, or 0.0.0.0 so oneflow will listen on any interface.

Inside ``/var/log/one/`` you can find log files for the server, and individual ones for each Service in ``/var/log/one/oneflow/<id>.log``

.. code::

    /var/log/one/oneflow.error
    /var/log/one/oneflow.log

Set the Environment Variables
================================================================================

By default the :ref:`command line tools <cli>` will use the ``one_auth`` file and the ``http://localhost:2474`` OneFlow URL. To change it, set the shell environment variables as explained in the :ref:`Managing Users documentation<manage_users_shell>`.

Enable the Sunstone Tabs
========================

The OneFlow tabs (Services and Service Templates) are visible in Sunstone by default. To customize its visibility for each kind of user, visit the :ref:`Sunstone views documentation <suns_views>`

Advanced Setup
==============

Permission to Create Services
--------------------------------------------------------------------------------

By default, :ref:`new groups <manage_groups>` are allowed to create Document resources. Documents are a special tool used by OneFlow to store Service Templates and instances. When a new Group is created, you can decide if you want to allow or deny its users to create OneFlow resources (Documents).
