.. _appflow_configure:

=============================
OneFlow Server Configuration
=============================

The OneFlow commands do not interact directly with the OpenNebula daemon, there is a server that takes the requests and manages the service (multi-tiered application) life-cycle. This guide shows how to start OneFlow, and the different options that can be configured.

Installation
============

OneFlow server is shipped with the main distribution. The oneflow server is usually contained in the 'opennebula-flow' package, and the commands in the specific CLI paclage. Check the :ref:`Installation guide <ignc>` for details of what packages you have to install depending on your distribution.

Make sure you execute ``ìnstall_gems`` to install the required gems, in particular: ``treetop``, ``parse-cron``.

Configuration
=============

The OneFlow configuration file can be found at ``/etc/one/oneflow-server.conf``. It uses YAML syntax to define the following options:

+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        Option        |                                                                               Description                                                                               |
+======================+=========================================================================================================================================================================+
| **Server Configuration**                                                                                                                                                                       |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :one\_xmlrpc         | OpenNebula daemon host and port                                                                                                                                         |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :lcm\_interval       | Time in seconds between Life Cycle Manager steps                                                                                                                        |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :host                | Host where OneFlow will listen                                                                                                                                          |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :port                | Port where OneFlow will listen                                                                                                                                          |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Defaults**                                                                                                                                                                                   |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :default\_cooldown   | Default cooldown period after a scale operation, in seconds                                                                                                             |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :shutdown\_action    | Default shutdown action. Values: 'shutdown', 'shutdown-hard'                                                                                                            |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :action\_number      | Default number of virtual machines (action\_number) that will receive the given call in each interval defined by action\_period, when an action is performed on a role. |
| :action\_period      |                                                                                                                                                                         |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :vm\_name\_template  | Default name for the Virtual Machines created by oneflow. You can use any of the following placeholders:                                                                |
|                      |                                                                                                                                                                         |
|                      | - $SERVICE_ID                                                                                                                                                           |
|                      | - $SERVICE_NAME                                                                                                                                                         |
|                      | - $ROLE_NAME                                                                                                                                                            |
|                      | - $VM_NUMBER                                                                                                                                                            |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Auth**                                                                                                                                                                                       |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :core\_auth          | Authentication driver to communicate with OpenNebula core                                                                                                               |
|                      | ``cipher``: for symmetric cipher encryption of tokens                                                                                                                   |
|                      | ``x509``: for x509 certificate encryption of tokens                                                                                                                     |
|                      | For more information, visit the :ref:`OpenNebula Cloud Auth documentation <cloud_auth>`                                                                                 |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **Log**                                                                                                                                                                                        |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :debug\_level        | Log debug level. 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG                                                                                                            |
+----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


This is the default file

.. code::

    ################################################################################
    # Server Configuration
    ################################################################################
     
    # OpenNebula daemon contact information
    #
    :one_xmlrpc: http://localhost:2633/RPC2
     
    # Time in seconds between Life Cycle Manager steps
    #
    :lcm_interval: 30
     
    # Host and port where OneFlow server will run
    :host: 127.0.0.1
    :port: 2474
     
    ################################################################################
    # Defaults
    ################################################################################
     
    # Default cooldown period after a scale operation, in seconds
    :default_cooldown: 300
     
    # Default shutdown action. Values: 'shutdown', 'shutdown-hard'
    :shutdown_action: 'shutdown'
     
    # Default oneflow action options when only one is supplied
    :action_number: 1
    :action_period: 60
     
    # Default name for the Virtual Machines created by oneflow. You can use any
    # of the following placeholders:
    #   $SERVICE_ID
    #   $SERVICE_NAME
    #   $ROLE_NAME
    #   $VM_NUMBER
     
    :vm_name_template: '$ROLE_NAME_$VM_NUMBER_(service_$SERVICE_ID)'
     
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

Start OneFlow
=============

To start and stop the server, use the ``oneflow-server start/stop`` command:

.. code::

    $ oneflow-server start
    oneflow-server started

.. warning:: By default, the server will only listen to requests coming from localhost. Change the ``:host`` attribute in ``/etc/one/oneflow-server.conf`` to your server public IP, or 0.0.0.0 so oneflow will listen on any interface.

Inside ``/var/log/one/`` you will find new log files for the server, and individual ones for each service in ``/var/log/one/oneflow/<id>.log``

.. code::

    /var/log/one/oneflow.error
    /var/log/one/oneflow.log

Enable the Sunstone Tabs
========================

The OneFlow tabs are enabled by default. To enable or disable them, edit ``/etc/one/sunstone-views/admin.yaml`` and ``user.yaml`` and set oneflow tabs inside ``enabled_tabs`` to ``true`` or ``false``:

.. code::

    enabled_tabs:
        dashboard-tab: true
     
        ...
     
        oneflow-dashboard: true
        oneflow-services: true
        oneflow-templates: true

Be sure to restart Sunstone for the changes to take effect.

For more information on how to customize the views based on the user/group interacting with Sunstone check the :ref:`sunstone views guide <suns_views>`

Advanced Setup
==============

Permission to Create Services
--------------------------------------------------------------------------------

By default, :ref:`new groups <manage_groups>` are allowed to create Document resources. Documents are a special tool used by OneFlow to store Service Templates and instances. When a new Group is created, you can decide if you want to allow or deny its users to create OneFlow resources (Documents).

|oneflow-config-acl|

.. |oneflow-config-acl| image:: /images/oneflow-config-acl.png