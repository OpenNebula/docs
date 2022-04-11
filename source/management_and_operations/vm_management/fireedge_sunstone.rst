.. _fireedge_sunstone:


================================================================================
Using FireEdge Sunstone
================================================================================

Overview
================================================================================

While exploring the universe, the OpenNebula team produced a combination of two nebulas denominated **FireEdge Sunstone**, where administrators and users will be able to manage resources, such as VMs and VM Templates.

Included in the FireEdge server and designed to provide a better user experience than the Ruby Sunstone, this new experience came to stay.


Configuration
================================================================================

To configure FireEdge Sunstone, there are several options to consider, and they are described in the :ref:`FireEdge Configuration <fireedge_setup>` guide.

Usage
================================================================================

This completely fresh user experience is available by accessing ``http://<OPENNEBULA-FRONTEND>:2616``.

On it, users will find on the left menu the available tabs to manage resources, as described in the following subsections: 

VMs Tab
--------------------------------------------------------------------------------

On the VMs tab, users will find all their Virtual Machines, allowing them to instantiate VMs and manage them individually by adding attributes and performing operations like changing permissions, attaching disks, attaching networks, taking snapshots, adding scheduled action, and allowing the remote console connections, and more.

On the other hand, some actions can be done through multiple VMs such as: suspend, stop, power-off, reboot, resume, undeploy, and more.

|fireedge_sunstone_vms_tab|

VM Template Tab
--------------------------------------------------------------------------------

On the VM Templates tab, users will find their Templates, allowing them to update, clone, and instantiate them.

Also, the user will be able to manage the permissions, share and unshare, lock and unlock them, and more.


|fireedge_sunstone_templates_tab|

Marketplace Tab
--------------------------------------------------------------------------------

On the Marketplace Apps tab, users will be able to download images and create templates or download them locally on their computer.

|fireedge_sunstone_marketapps_tab|

Views
================================================================================

Using the OpenNebula FireEdge Sunstone Views you will be able to provide a simplified UI aimed at end-users of an OpenNebula cloud. The OpenNebula FireEdge Sunstone Views are fully customizable, so you can easily enable or disable specific information tabs or action buttons. :ref:`You can define multiple views for different user groups <fireedge_sunstone_new_view>`. You can define multiple views for different user groups. Each view defines a set of UI components, so each user just accesses and views the relevant parts of the cloud for her role. Default views:

- :ref:`Admin View <fireedge_sunstone_admin_view>`.
- :ref:`User View <fireedge_sunstone_user_view>`.

Each view is in an individual directory, ``admin`` and ``user`` that OpenNebula proposes by default as described in the next section.

Default Views
--------------------------------------------------------------------------------

.. _fireedge_sunstone_admin_view:

Admin View
----------
This view provides complete control of the Virtual Machines, Templates, and Marketplace apps. Details can be configured in ``/etc/one/fireedge/sunstone/admin/`` directory.

|fireedge_sunstone_admin_view|

.. _fireedge_sunstone_user_view:

User View
---------
Based on the Admin View. It is an advanced user view intended for users with fewer privileges than an admin user, allowing them to manage Virtual Machines and Templates. Users will not be able to manage or retrieve the hosts and clusters of the cloud. Details can be configured in the ``/etc/one/fireedge/sunstone/user/`` directory.

|fireedge_sunstone_user_view|

Usage
-----
Sunstone users can change their current view from the top-right dropdown menu:

|fireedge_sunstone_change_view_dropdown|

They can also configure several options from the settings tab:

- Schema: Change the FireEdge Sunstone Theme to dark, light, or to match with the system.
- Language: Select the language that they want to use for the UI.
- Be able to disable the dashboard animations.

All those settings are saved in the user template. If not defined, defaults values are:

- Schema: System.
- Language: English US.
- Animations enabled.

|fireedge_sunstone_settings|

.. _fireedge_sunstone_new_view:

Defining a New View
--------------------------------------------------------------------------------

The views definitions are placed in the "/etc/one/fireedge/sunstone/" directory. Each view is defined by a folder (named as the view) with the needed configuration files inside.

.. code::

    /etc/one/fireedge/sunstone/
    ...
    |-- admin/
    |   |-- marketplace-app-tab.yaml  <--- the Marketplace App tab configuration file
    |   |-- vm-tab.yaml               <--- the VM tab configuration file
    |   `-- vm-template-tab.yaml      <--- the VM Template tab configuration file
    |-- sunstone-server.conf
    |-- sunstone-views.yaml           <--- the FireEdge Sunstone views main configuration
    `-- user/
        |-- vm-tab.yaml               <--- the VM tab configuration file
        `-- vm-template-tab.yaml      <--- the VM Template tab 
    ...

The easiest way to create a custom view is to copy the ``admin`` or ``user`` folder and modify its content as needed. After that, add the new view into ``sunstone-view.yaml``.

View Customization
--------------------------------------------------------------------------------
On FireEdge Sunstone each view is defined by a folder that has the YAML files for the configured tabs.
The content for those files is divided into sections that are described in the followings sections.

.. note:: The attributes can be modified only if they come in the YAML file by default. 

.. note:: If an attribute is not present, it has the same behavior as when it is set to false.

.. note:: In the following tables, the description field contains the expected behavior when is set to ``true``.

Actions
-------
The attributes described here indicate which buttons are visible to operate over the resources.
The following atributes must be nested in an ``actions`` tag.

+-------------------------+-----------------------------------------------------------------------------+
| Attribute               | Description                                                                 |
+=========================+=============================================================================+
| ``chgrp``               | Users will be able to change the resource group.                            |
+-------------------------+-----------------------------------------------------------------------------+
| ``chown``               | Users will be able to change the resource owner.                            |
+-------------------------+-----------------------------------------------------------------------------+
| ``clone``               | Users will be able to clone VM Templates.                                   |
+-------------------------+-----------------------------------------------------------------------------+
| ``create_app_dialog``   | Users will be able to create a new marketplace app from a VM Template.      |
+-------------------------+-----------------------------------------------------------------------------+
| ``create_dialog``       | Users will be able to create a new resource.                                |
+-------------------------+-----------------------------------------------------------------------------+
| ``delete``              | Users will be able to delete Virtual Machines.                              |
+-------------------------+-----------------------------------------------------------------------------+
| ``deploy``              | Users will be able to manually deploy Virtual Machines.                     |
+-------------------------+-----------------------------------------------------------------------------+
| ``download``            | Users will be able to download apps from the marketplace into their         |
|                         | computers.                                                                  |
+-------------------------+-----------------------------------------------------------------------------+
| ``export``              | Users will be able to export apps from the marketplace into a datastore.    |
+-------------------------+-----------------------------------------------------------------------------+
| ``hold``                | Users will be able to set to hold Virtual Machines.                         |
+-------------------------+-----------------------------------------------------------------------------+
| ``instantiate_dialog``  | Users will be able to instantiate a VM Template.                            |
+-------------------------+-----------------------------------------------------------------------------+
| ``lock``                | Users will be able to lock the resource.                                    |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate``             | Users will be able to migrate a Virtual Machine to a diferent host and      |
|                         | datastore.                                                                  |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate_live``        | Users will be able to live migrate a Virtual Machine to a diferent host and |
|                         | datastore.                                                                  |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate_poff``        | Users will be able to migrate a Virtual Machine in poweroff to a diferent   |
|                         | host and datastore.                                                         |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate_poff_hard``   | Users will be able to migrate a Virtual Machine in poweroff (hard way) to a |
|                         | diferent host and datastore.                                                |
+-------------------------+-----------------------------------------------------------------------------+
| ``poweroff``            | Users will be able to poweroff Virtual Machines.                            |
+-------------------------+-----------------------------------------------------------------------------+
| ``poweroff_hard``       | Users will be able to poweroff Virtual Machines (hard way).                 |
+-------------------------+-----------------------------------------------------------------------------+
| ``rdp``                 | Users will be able to establish an RDP connection.                          |
+-------------------------+-----------------------------------------------------------------------------+
| ``reboot``              | Users will be able to reboot Virtual Machines.                              |
+-------------------------+-----------------------------------------------------------------------------+
| ``reboot_hard``         | Users will be able to reboot Virtual Machines (hard way).                   |
+-------------------------+-----------------------------------------------------------------------------+
| ``recover``             | Users will be able to recover Virtual Machines.                             |
+-------------------------+-----------------------------------------------------------------------------+
| ``release``             | Users will be able to release Virtual Machines.                             |
+-------------------------+-----------------------------------------------------------------------------+
| ``resched``             | Users will be able to reschedule Virtual Machines.                          |
+-------------------------+-----------------------------------------------------------------------------+
| ``resume``              | Users will be able to resume Virtual Machines.                              |
+-------------------------+-----------------------------------------------------------------------------+
| ``save_as_template``    | Users will be able to save a Virtual Machine as a VM Template.              |
+-------------------------+-----------------------------------------------------------------------------+
| ``share``               | Users will be able to share VM Templates.                                   |
+-------------------------+-----------------------------------------------------------------------------+
| ``ssh``                 | Users will be able to establish a SSH connection.                           |
+-------------------------+-----------------------------------------------------------------------------+
| ``stop``                | Users will be able to stop Virtual Machines.                                |
+-------------------------+-----------------------------------------------------------------------------+
| ``suspend``             | Users will be able to suspend Virtual Machines.                             |
+-------------------------+-----------------------------------------------------------------------------+
| ``terminate``           | Users will be able to terminate Virtual Machines.                           |
+-------------------------+-----------------------------------------------------------------------------+
| ``terminate_hard``      | Users will be able to terminate Virtual Machines (hard way).                |
+-------------------------+-----------------------------------------------------------------------------+
| ``undeploy``            | Users will be able to undeploy Virtual Machines.                            |
+-------------------------+-----------------------------------------------------------------------------+
| ``undeploy_hard``       | Users will be able to undeploy Virtual Machines (hard way).                 |
+-------------------------+-----------------------------------------------------------------------------+
| ``unlock``              | Users will be able to unlock the resource.                                  |
+-------------------------+-----------------------------------------------------------------------------+
| ``update_dialog``       | Users will be able to update VM Templates.                                  |
+-------------------------+-----------------------------------------------------------------------------+
| ``unresched``           | Users will be able to un-reschedule Virtual Machines.                       |
+-------------------------+-----------------------------------------------------------------------------+
| ``unshare``             | Users will be able to unshare VM Templates.                                 |
+-------------------------+-----------------------------------------------------------------------------+
| ``vmrc``                | Users will be able to establish a VMRC connection.                          |
+-------------------------+-----------------------------------------------------------------------------+
| ``vnc``                 | Users will be able to establish a VNC connection.                           |
+-------------------------+-----------------------------------------------------------------------------+

Filters
-------
The attributes described here indicate which filters are visible to select resources.
The following atributes must be nested in an ``filters`` tag.

+---------------------------+---------------------------------------------------------------------------+
| Attribute                 | Description                                                               |
+===========================+===========================================================================+
| ``label``                 | Filtering by the resource labels will be enabled.                         |
+---------------------------+---------------------------------------------------------------------------+
| ``marketplace``           | Filtering by the marketplace will be enabled.                             |
+---------------------------+---------------------------------------------------------------------------+
| ``state``                 | Filtering by the resource state will be enabled.                          |
+---------------------------+---------------------------------------------------------------------------+
| ``type``                  | Filtering by the resource type will be enabled.                           |
+---------------------------+---------------------------------------------------------------------------+

Info Tabs
---------

The attributes described here indicate the available actions on each info tab on the resource.

Dialogs
-------

The attributes described here indicate the available actions on each dialog on the resource.

.. |fireedge_sunstone_admin_view| image:: /images/fireedge_sunstone_admin_view.png
.. |fireedge_sunstone_change_view_dropdown| image:: /images/fireedge_sunstone_change_view_dropdown.png
.. |fireedge_sunstone_settings| image:: /images/fireedge_sunstone_settings.png
.. |fireedge_sunstone_user_view| image:: /images/fireedge_sunstone_user_view.png
.. |fireedge_sunstone_vms_tab| image:: /images/fireedge_sunstone_vms_tab.png
.. |fireedge_sunstone_templates_tab| image:: /images/fireedge_sunstone_templates_tab.png
.. |fireedge_sunstone_marketapps_tab| image:: /images/fireedge_sunstone_marketapps_tab.png