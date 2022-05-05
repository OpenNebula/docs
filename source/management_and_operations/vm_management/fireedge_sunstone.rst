.. _fireedge_sunstone:

================================================================================
Using FireEdge Sunstone
================================================================================

Overview
================================================================================

**FireEdge Sunstone** is the new state-of-the-art web interface, fully featured for VM and VM Template management for end users. This interface is delivered by the :ref:`FireEdge server <fireedge_setup>`, and it is its main interface, meaning that it will redirect to Sunstone when contacted in the ``http://<OPENNEBULA-FRONTEND>:2616/`` address.

Configuration
================================================================================

To configure FireEdge Sunstone, there are several options to consider, and they are described in the :ref:`FireEdge Configuration <fireedge_setup>` guide.

.. _fireedge_sunstone_usage:

Usage
================================================================================

This completely fresh user experience is available by accessing ``http://<OPENNEBULA-FRONTEND>:2616``. Users will find on the left menu the available tabs to manage resources, as described in the following subsections.

VMs Tab
--------------------------------------------------------------------------------

Users will find all their Virtual Machines, allowing you to instantiate and manage them individually by adding attributes and performing operations like changing permissions, attaching disks, attaching networks, taking snapshots, adding scheduled actions, remote console connections and more.

On the other hand, some actions can be done through multiple VMs such as: ``suspend``, ``stop``, ``power-off``, ``reboot``, ``resume``, ``undeploy`` and more.

|fireedge_sunstone_vms_tab|

VM Template Tab
--------------------------------------------------------------------------------

Users will find their Templates, allowing them to update, clone, and instantiate them. Also, the user will be able to manage the permissions, share and unshare, lock and unlock them, and more.

|fireedge_sunstone_templates_tab|

Marketplace Tab
--------------------------------------------------------------------------------

Users will be able to download images and create templates from it or download them locally on their computer.

|fireedge_sunstone_marketapps_tab|

.. _fireedge_sunstone_views:

Views
================================================================================

Using the FireEdge Sunstone Views you will be able to provide a simplified UI aimed at end-users of an OpenNebula cloud. FireEdge Sunstone Views are fully customizable, so you can easily enable or disable specific information tabs or action buttons. :ref:`You can define multiple views for different user groups <fireedge_sunstone_new_view>`. You can define multiple views for different user groups. Each view defines a set of UI components, so each user just accesses and views the relevant parts of the cloud for her role. Default views:

- :ref:`Admin View <fireedge_sunstone_admin_view>`.
- :ref:`User View <fireedge_sunstone_user_view>`.

Each view is in an individual directory, ``admin`` and ``user`` that OpenNebula proposes by default as described in the next section.

Default Views
--------------------------------------------------------------------------------

.. _fireedge_sunstone_admin_view:

Admin View
--------------------------------------------------------------------------------

This view provides complete control of the Virtual Machines, Templates, and Marketplace apps. Details can be configured in ``/etc/one/fireedge/sunstone/admin/`` directory.

|fireedge_sunstone_admin_view|

.. _fireedge_sunstone_user_view:

User View
--------------------------------------------------------------------------------

Based on the Admin View. It is an advanced user view intended for users with fewer privileges than an admin user, allowing them to manage Virtual Machines and Templates. Users will not be able to manage or retrieve the hosts and clusters of the cloud. Details can be configured in the ``/etc/one/fireedge/sunstone/user/`` directory.

|fireedge_sunstone_user_view|

Usage
--------------------------------------------------------------------------------

Sunstone users can change their current view from the top-right dropdown menu:

|fireedge_sunstone_change_view_dropdown|

They can also configure several options from the settings tab:

- **Schema (default = System)**: change the FireEdge Sunstone Theme to dark, light or to match with the system.
- **Language (default = English US)**: select the language that they want to use for the UI.
- Disable the dashboard animations, by default they are enabled.
- **SSH Public key**: allows the user to specify a public SSH key that they can use on the VMs.
- **SSH Private key**: allows the user to specify a private SSH key that they can use when establishing connections with their VMs.
- **SSH Private key passphrase**: if the private SSH key is encrypted, the user must specify the password.

All those settings are saved in the user template.

|fireedge_sunstone_settings|

.. _fireedge_sunstone_new_view:

Defining a New View
--------------------------------------------------------------------------------

The views definitions are placed in ``/etc/one/fireedge/sunstone/`` directory. Each view is defined by a folder (named as the view) with the needed configuration files inside.

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

The easiest way to create a custom view is to copy the ``admin`` or ``user`` folder and modify its content as needed. After that, add the new view into ``/etc/one/fireedge/sunstone/sunstone-views.yaml``.

.. _fireedge_sunstone_view_customization:

View Customization
--------------------------------------------------------------------------------

On FireEdge Sunstone each view is defined by a folder that has the YAML files for the configured tabs. The content for those files is divided into sections that are described in the followings sections.

In the following tables, the description field contains the expected behavior when is set to ``true``.

.. note:: The attributes can be modified only if they come in the YAML file by default. If an attribute is not present, it has the same behavior as when it is set to false.

.. _fireedge_sunstone_actions_customization:

Actions
--------------------------------------------------------------------------------

The attributes described here indicate which buttons are visible to operate over the resources. The following attributes must be nested in an ``actions`` tag.

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
| ``edit_labels``         | Users will be able to edit the resource labels.                             |
+-------------------------+-----------------------------------------------------------------------------+
| ``export``              | Users will be able to export apps from the marketplace into a datastore.    |
+-------------------------+-----------------------------------------------------------------------------+
| ``hold``                | Users will be able to set to hold Virtual Machines.                         |
+-------------------------+-----------------------------------------------------------------------------+
| ``instantiate_dialog``  | Users will be able to instantiate a VM Template.                            |
+-------------------------+-----------------------------------------------------------------------------+
| ``lock``                | Users will be able to lock the resource.                                    |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate``             | Users will be able to migrate a Virtual Machine to a different host and     |
|                         | datastore.                                                                  |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate_live``        | Users will be able to live migrate a Virtual Machine to a different host    |
|                         | and datastore.                                                              |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate_poff``        | Users will be able to migrate a Virtual Machine in poweroff to a different  |
|                         | host and datastore.                                                         |
+-------------------------+-----------------------------------------------------------------------------+
| ``migrate_poff_hard``   | Users will be able to migrate a Virtual Machine in poweroff (hard way) to a |
|                         | different host and datastore.                                               |
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

.. _fireedge_sunstone_filters_customization:

Filters
--------------------------------------------------------------------------------

The attributes described here indicate which filters are visible to select resources. The following attributes must be nested in a ``filters`` tag.

+---------------------------+---------------------------------------------------------------------------+
| Attribute                 | Description                                                               |
+===========================+===========================================================================+
| ``group``                 | Filtering by the resource group will be enabled.                          |
+---------------------------+---------------------------------------------------------------------------+
| ``hostname``              | Filtering by the resource hostname will be enabled.                       |
+---------------------------+---------------------------------------------------------------------------+
| ``ips``                   | Filtering by the resource IPs will be enabled.                            |
+---------------------------+---------------------------------------------------------------------------+
| ``label``                 | Filtering by the resource labels will be enabled.                         |
+---------------------------+---------------------------------------------------------------------------+
| ``locked``                | Filtering by the resource lock state will be enabled.                     |
+---------------------------+---------------------------------------------------------------------------+
| ``marketplace``           | Filtering by the marketplace will be enabled.                             |
+---------------------------+---------------------------------------------------------------------------+
| ``owner``                 | Filtering by the resource owner will be enabled.                          |
+---------------------------+---------------------------------------------------------------------------+
| ``state``                 | Filtering by the resource state will be enabled.                          |
+---------------------------+---------------------------------------------------------------------------+
| ``type``                  | Filtering by the resource type will be enabled.                           |
+---------------------------+---------------------------------------------------------------------------+
| ``vrouter``               | Filtering based on if the resource is for vRouters will be enabled.       |
+---------------------------+---------------------------------------------------------------------------+
| ``zone``                  | Filtering by the resource zone will be enabled.                           |
+---------------------------+---------------------------------------------------------------------------+

.. _fireedge_sunstone_infotabs_customization:

Info Tabs
--------------------------------------------------------------------------------

The attributes described here indicate the available actions on each info tab on the resource. The following attributes must be nested in an ``info-tabs`` and the corresponding tab.

+--------------------------+-----------------------------------------------------------------------------+
| Attribute                | Description                                                                 |
+==========================+=============================================================================+
| ``actions``              | Describes a list of available actions on this tab that can be disabled.     |
+--------------------------+-----------------------------------------------------------------------------+
| ``attributes_panel``     | Describes the behavior for the ``attributes`` panel in the resource         |
|                          | info tab.                                                                   |
+--------------------------+-----------------------------------------------------------------------------+
| ``enabled``              | This tab will be showed in the resource info.                               |
+--------------------------+-----------------------------------------------------------------------------+
| ``information_panel``    | Describes the behavior for the ``information`` panel in the resource        |
|                          | info tab.                                                                   |
+--------------------------+-----------------------------------------------------------------------------+
| ``lxc_panel``            | Describes the behavior for the ``LXC`` panel in the resource info tab.      |
+--------------------------+-----------------------------------------------------------------------------+
| ``monitoring_panel``     | Describes the behavior for the ``monitoring`` panel in the resource         |
|                          | info tab.                                                                   |
+--------------------------+-----------------------------------------------------------------------------+
| ``ownership_panel``      | Describes the behavior for the ``ownership`` panel in the resource          |
|                          | info tab.                                                                   |
+--------------------------+-----------------------------------------------------------------------------+
| ``permissions_panel``    | Describes the behavior for the ``permissions`` panel in the resource        |
|                          | info tab.                                                                   |
+--------------------------+-----------------------------------------------------------------------------+
| ``vcenter_panel``        | Describes the behavior for the ``vCenter`` panel in the resource info tab.  |
+--------------------------+-----------------------------------------------------------------------------+

The available actions in the info tabs are described in the following table.

+--------------------------+-----------------------------------------------------------------------------+
| Action                   | Description                                                                 |
+==========================+=============================================================================+
| ``add``                  | Users will be able to add information to that panel.                        |
+--------------------------+-----------------------------------------------------------------------------+
| ``attach_disk``          | Users will be able to attach disks.                                         |
+--------------------------+-----------------------------------------------------------------------------+
| ``attach_nic``           | Users will be able to attach NICs.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``attach_secgroup``      | Users will be able to attach security groups to NICs.                       |
+--------------------------+-----------------------------------------------------------------------------+
| ``charter_create``       | Users will be able to create charters.                                      |
+--------------------------+-----------------------------------------------------------------------------+
| ``chgrp``                | Users will be able to change the resource group.                            |
+--------------------------+-----------------------------------------------------------------------------+
| ``chmod``                | Users will be able to change the resource permissions.                      |
+--------------------------+-----------------------------------------------------------------------------+
| ``chown``                | Users will be able to change the resource owner.                            |
+--------------------------+-----------------------------------------------------------------------------+
| ``copy``                 | Users will be able to copy the information available in that panel.         |
+--------------------------+-----------------------------------------------------------------------------+
| ``delete``               | Users will be able to delete the information available in that panel.       |
+--------------------------+-----------------------------------------------------------------------------+
| ``detach_disk``          | Users will be able to detach disks.                                         |
+--------------------------+-----------------------------------------------------------------------------+
| ``detach_nic``           | Users will be able to detach NICs.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``detach_secgroup``      | Users will be able to detach security groups to NICs.                       |
+--------------------------+-----------------------------------------------------------------------------+
| ``disk_saveas``          | Users will be able to save disks as an image.                               |
+--------------------------+-----------------------------------------------------------------------------+
| ``edit``                 | Users will be able to edit the information available in that panel.         |
+--------------------------+-----------------------------------------------------------------------------+
| ``rename``               | Users will be able to rename the resource.                                  |
+--------------------------+-----------------------------------------------------------------------------+
| ``resize_capacity``      | Users will be able to perform capacity resize.                              |
+--------------------------+-----------------------------------------------------------------------------+
| ``resize_disk``          | Users will be able to perform disk resize.                                  |
+--------------------------+-----------------------------------------------------------------------------+
| ``sched_action_create``  | Users will be able to create scheduled actions.                             |
+--------------------------+-----------------------------------------------------------------------------+
| ``sched_action_delete``  | Users will be able to delete scheduled actions.                             |
+--------------------------+-----------------------------------------------------------------------------+
| ``sched_action_update``  | Users will be able to update scheduled actions.                             |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_create``      | Users will be able to create snapshots.                                     |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_delete``      | Users will be able to delete snapshots.                                     |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_disk_create`` | Users will be able to create disk snapshots.                                |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_disk_delete`` | Users will be able to delete disk snapshots.                                |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_disk_rename`` | Users will be able to rename disk snapshots.                                |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_disk_revert`` | Users will be able to revert disk snapshots.                                |
+--------------------------+-----------------------------------------------------------------------------+
| ``snapshot_revert``      | Users will be able to revert snapshots.                                     |
+--------------------------+-----------------------------------------------------------------------------+

.. _fireedge_sunstone_dialogs_customization:

Dialogs
--------------------------------------------------------------------------------

The attributes described here indicate the available actions on each dialog on the resource.

+--------------------------+-----------------------------------------------------------------------------+
| Attribute                | Description                                                                 |
+==========================+=============================================================================+
| ``booting``              | Booting section will be displayed.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``capacity``             | Capacity section will be displayed.                                         |
+--------------------------+-----------------------------------------------------------------------------+
| ``context``              | Context section will be displayed.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``information``          | Information section will be displayed.                                      |
+--------------------------+-----------------------------------------------------------------------------+
| ``input_output``         | Input/Output section will be displayed.                                     |
+--------------------------+-----------------------------------------------------------------------------+
| ``network``              | Network section will be displayed.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``numa``                 | Numa section will be displayed.                                             |
+--------------------------+-----------------------------------------------------------------------------+
| ``ownership``            | Ownership section will be displayed.                                        |
+--------------------------+-----------------------------------------------------------------------------+
| ``placement``            | Placement section will be displayed.                                        |
+--------------------------+-----------------------------------------------------------------------------+
| ``sched_action``         | Scheduled Actions section will be displayed.                                |
+--------------------------+-----------------------------------------------------------------------------+
| ``showback``             | Showback section will be displayed.                                         |
+--------------------------+-----------------------------------------------------------------------------+
| ``storage``              | Storage section will be displayed.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``vcenter``              | vCenter section will be displayed.                                          |
+--------------------------+-----------------------------------------------------------------------------+
| ``vm_group``             | VM groups section will be displayed.                                        |
+--------------------------+-----------------------------------------------------------------------------+

.. |fireedge_sunstone_admin_view| image:: /images/fireedge_sunstone_admin_view.png
.. |fireedge_sunstone_change_view_dropdown| image:: /images/fireedge_sunstone_change_view_dropdown.png
.. |fireedge_sunstone_settings| image:: /images/fireedge_sunstone_settings.png
.. |fireedge_sunstone_user_view| image:: /images/fireedge_sunstone_user_view.png
.. |fireedge_sunstone_vms_tab| image:: /images/fireedge_sunstone_vms_tab.png
.. |fireedge_sunstone_templates_tab| image:: /images/fireedge_sunstone_templates_tab.png
.. |fireedge_sunstone_marketapps_tab| image:: /images/fireedge_sunstone_marketapps_tab.png
