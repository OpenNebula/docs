.. _hooks:

============
Using Hooks
============

The Hook Manager present in OpenNebula enables the triggering of custom scripts tied to a change in state in a particular resource, being that a Host or a Virtual Machine. This opens a wide area of automation for system administrators to tailor their cloud infrastructures.

Configuration
=============

Hook Manager configuration is set in ``/etc/one/oned.conf``. Hooks can be tied to changes in host or virtual machine states, and they can be executed locally to the OpenNebula front-end and remotely in the relevant worker node.

In general, hook definition in ``/etc/one/oned.conf`` has two paremeters:

-  **executable**: path of the hook driver executable, can be an absolute path or relative to ``/usr/lib/one/mads``

-  **arguments**: for the driver executable, can be an absolute path or relative to ``/etc/one/``

Hooks for VirtualMachines
=========================

In the case of VirtualMachine hooks, the following can be defined:

-  **name** : for the hook, useful to track the hook (OPTIONAL)
-  **on** : when the hook should be executed,

   -  **CREATE**, when the VM is created (onevm create)
   -  **RUNNING**, after the VM is successfully booted
   -  **SHUTDOWN**, after the VM is shutdown
   -  **STOP**, after the VM is stopped (including VM image transfers)
   -  **DONE**, after the VM is destroyed or shutdown
   -  **UNKNOWN**, when the VM enters the unknown state
   -  **FAILED**, when the VM enters the failed state
   -  **CUSTOM**, user defined specific STATE and LCM\_STATE combination of states to trigger the hook.

-  **command** : path can be absolute or relative to ``/var/lib/one/remotes/hooks``
-  **arguments** : for the hook. You can access the following VM attributes with $

   -  **$ID**, the ID of the VM that triggered the hook execution
   -  **$TEMPLATE**, the template of the VM that triggered the hook, in xml and base64 encoded
   -  **$PREV\_STATE**, the previous STATE of the Virtual Machine
   -  **$PREV\_LCM\_STATE**, the previous LCM STATE of the Virtual Machine

-  **remote** : values,

   -  **YES**, The hook is executed in the host where the VM was allocated
   -  **NO**, The hook is executed in the OpenNebula server (default)

The following is an example of a hook tied to the DONE state of a VM:

.. code::

    VM_HOOK = [
        name      = "notify_done",
        on        = "DONE",
        command   = "notify.rb",
        arguments = "$ID $TEMPLATE" ]

Or an more advanced example:

.. code::

    VM_HOOK = [
      name      = "advanced_hook",
      on        = "CUSTOM",
      state     = "ACTIVE",
      lcm_state = "BOOT_UNKNOWN",
      command   = "log.rb",
      arguments = "$ID $PREV_STATE $PREV_LCM_STATE" ]

Hooks for Hosts
===============

In the case of Host hooks, the following can be defined:

-  **name** : for the hook, useful to track the hook (OPTIONAL)
-  **on** : when the hook should be executed,

   -  **CREATE**, when the Host is created (onehost create)
   -  **ERROR**, when the Host enters the error state
   -  **DISABLE**, when the Host is disabled

-  **command** : path can be absolute or relative to ``/var/lib/one/remotes/hooks``
-  **arguments** : for the hook. You can use the following Host attributes with $

   -  **$ID**, the ID of the Host that triggered the hook execution
   -  **$TEMPLATE**, the full Host information, in xml and base64 encoded

-  **remote** : values,

   -  **YES**, The hook is executed in the host
   -  **NO**, The hook is executed in the OpenNebula server (default)

The following is an example of a hook tied to the ERROR state of a Host:

.. code::

    #-------------------------------- Host Hook -----------------------------------
    # This hook is used to perform recovery actions when a host fails.
    # Script to implement host failure tolerance
    #   It can be set to
    #           -r recreate VMs running in the host
    #           -d delete VMs running in the host
    #   Additional flags
    #           -f force resubmission of suspended VMs
    #           -p <n> avoid resubmission if host comes
    #                  back after n monitoring cycles
    #------------------------------------------------------------------------------
    #
    #HOST_HOOK = [
    #    name      = "error",
    #    on        = "ERROR",
    #    command   = "ft/host_error.rb",
    #    arguments = "$ID -r",
    #    remote    = "no" ]
    #-------------------------------------------------------------------------------

Other Hooks
===========

Other OpenNebula entities like Virtual Networks, Users, Groups and Images can be hooked on creation and removal. These hooks are specified with the following variables in oned.conf:

-  **VNET\_HOOK**, for virtual networks
-  **USER\_HOOK**, for users
-  **GROUP\_HOOK**, for groups
-  **IMAGE\_HOOK**, for disk images.

These hooks are always executed on the front-end and are defined by the following attributes

-  **name** : for the hook, useful to track the hook (OPTIONAL)
-  **on** : when the hook should be executed,

   -  **CREATE**, when the object (virtual network, user, group or image) is created
   -  **REMOVE**, when the object is removed from the DB

-  **command** : path can be absolute or relative to ``/var/lib/one/remotes/hooks``
-  **arguments** : for the hook. You can use the following Host attributes with $

   -  **$ID**, the ID of the Host that triggered the hook execution
   -  **$TEMPLATE**, the full Host information, in xml and base64 encoded

The following is an example of a hook that sends and email to a new register user:

.. code::


    USER_HOOK = [
        name      = "mail",
        on        = "CREATE",
        command   = "email2user.rb",
        arguments = "$ID $TEMPLATE"]

Developing your Hooks
=====================

The execution of each hook is tied to the object that trigger the event. The data of the object can be passed to the hook through the $ID and the $TEMPLATE variables:

-  $TEMPLATE will give you the full output of the corresponding show command in XML and base64 encoding. This can be easily deal with in any language. If you are using bash for your scripts you may be interested in the xpath.rb util, check the following example:

.. code::

    #!/bin/bash
    # Argument hook for virtual network add to oned.conf
    # VNET_HOOK = [
    #   name="bash_arguments",
    #   on="CREATE",
    #   command=<path_to_this_file>,
    #   arguments="$TEMPLATE" ]
     
    XPATH=/var/lib/one/remotes/datastore/xpath.rb
    T64=$1
     
    USER_NAME=`$XPATH -b $T64 UNAME`
    OWNER_USE_PERMISSION=`$XPATH -b $T64 PERMISSIONS/OWNER_U`
     
    #UNAME and PERMISSIONS/OWNER_U are the XPATH for the attributes without the root element

-  $ID you can use the ID of the object to retreive more information or to perform an action over the object. (e.g. onevm hold $ID)

Note that within the hook you can further interact with OpenNebula to retrieve more information, or perform any other action
