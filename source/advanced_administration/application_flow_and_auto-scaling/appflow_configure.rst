============================
OneFlow Server Configuration
============================

The OneFlow commands do not interact directly with the OpenNebula
daemon, there is a server that takes the requests and manages the
service (multi-tiered application) life-cycle. This guide shows how to
start OneFlow, and the different options that can be configured.

Installation
============

Starting with OpenNebula 4.2, OneFlow is included in the default
installation. Check the `Installation guide </./ignc>`__ for details of
what package you have to install depending on your distribution

Configuration
=============

The OneFlow configuration file can be found at
``/etc/one/oneflow-server.conf``. It uses YAML syntax to define the
following options:

Option

Description

Server Configuration

:one\_xmlrpc

OpenNebula daemon host and port

:lcm\_interval

Time in seconds between Life Cycle Manager steps

:host

Host where OneFlow will listen

:port

Port where OneFlow will listen

Defaults

:default\_cooldown

Default cooldown period after a scale operation, in seconds

:shutdown\_action

Default shutdown action. Values: 'shutdown', 'shutdown-hard'

:action\_number

Default number of virtual machines (action\_number) that will receive
the given call in each interval defined by action\_period, when an
action is performed on a role.

:action\_period

Auth

:core\_auth

| Authentication driver to communicate with OpenNebula core
|  ``cipher``: for symmetric cipher encryption of tokens
|  ``x509``: for x509 certificate encryption of tokens
|
|  For more information, visit the `OpenNebula Cloud Auth
documentation </./cloud_auth>`__

Log

:debug\_level

Log debug level. 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG

This is the default file

.. code:: code

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

To start and stop the server, use the ``oneflow-server start/stop``
command:

.. code::

$ oneflow-server start
oneflow-server started

|:!:| By default, the server will only listen to requests coming from
localhost. Change the ``:host`` attribute in
``/etc/one/oneflow-server.conf`` to your server public IP, or 0.0.0.0 so
oneflow will listen on any interface.

Inside ``/var/log/one/`` you will find new log files for the server, and
individual ones for each service in ``/var/log/one/oneflow/<id>.log``

.. code:: code

/var/log/one/oneflow.error
/var/log/one/oneflow.log

Enable the Sunstone Tabs
========================

The OneFlow tabs are hidden by default. To enable them, edit
'/etc/one/sunstone-views/admin.yaml' and
'/etc/one/sunstone-views/user.yaml' and set oneflow tabs inside
'enabled\_tabs' to true:

.. code:: code

enabled_tabs:
dashboard-tab: true
 
...
 
oneflow-dashboard: true
oneflow-services: true
oneflow-templates: true

Be sure to restart Sunstone for the changes to take effect.

For more information on how to customize the views based on the
user/group interacting with Sunstone check the `sunstone views
guide </./suns_views>`__

Advanced Setup
==============

ACL Rule
--------

By default this rule is defined in OpenNebula to enable the creation of
new services by any user. If you want to limit this, you will have to
delete this rule and generate new ones.

.. code:: code

* DOCUMENT/* CREATE

If you only want a specific group to be able to use OneFlow, execute:

.. code::

$ oneacl create "@1 DOCUMENT/* CREATE"

Read more about the `ACL Rules system here </./manage_acl>`__.

.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
