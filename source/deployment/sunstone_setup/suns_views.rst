.. _suns_views:

================================================================================
Sunstone Views
================================================================================

Using the OpenNebula Sunstone Views you will be able to provide a simplified UI aimed at end-users of an OpenNebula cloud. The OpenNebula Sunstone Views are fully customizable, so you can easily enable or disable specific information tabs or action buttons. You can define multiple  views for different user groups. Each view defines a set of UI components so each user just accesses and views the relevant parts of the cloud for her role.

The OpenNebula Sunstone Views can be grouped into two different layouts. On one hand, the classic Sunstone layout exposes a complete view of the cloud, allowing administrators and advanced users to have full control of any physical or virtual resource of the cloud. On the other hand, the cloud layout exposes a simplified version of the cloud where end-users will be able to manage any virtual resource of the cloud, without taking care of the physical resources management.

Default Views
================================================================================

Admin View
--------------------------------------------------------------------------------

This view provides full control of the cloud. Details can be configured in the ``/etc/one/sunstone-views/admin.yaml`` file.

|admin_view|

.. _vcenter_view:

Admin vCenter View
--------------------------------------------------------------------------------

Based on the Admin View. It is designed to present the valid operations against a vCenter infrastructure to a cloud administrator. Details can be configured in the ``/etc/one/sunstone-views/admin_vcenter.yaml`` file.

.. _suns_views_group_admin:

Group Admin View
--------------------------------------------------------------------------------

Based on the Admin View. It provides control of all the resources belonging to a group, but with no access to resources outside that group, that is, restricted to the physical and virtual resources of the group. This view features the ability to create new users within the group as well as set and keep track of user quotas. For more information on how to configure this scenario see :ref:`this section <group_admin_view>`

Cloud View
--------------------------------------------------------------------------------

This is a simplified view mainly intended for end-users that just require a portal where they can provision new virtual machines easily from pre-defined Templates. For more information about this view, please check the ``/etc/one/sunstone-views/cloud.yaml`` file.

In this scenario the cloud administrator must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated. Before using them, users can optionally customize the VM capacity, add new network interfaces and provide values required by the template.  Thereby, the user doesn't have to know any details of the infrastructure such as networking or storage. For more information on how to configure this scenario see :ref:`this section <cloud_view>`

|cloud_dash|

.. _vcenter_cloud_view:

vCenter Cloud View
--------------------------------------------------------------------------------

Based on the Cloud View, this view is designed to present the valid operations against a vCenter infrastructure to a cloud end-user.

User View
--------------------------------------------------------------------------------

Based on the Admin View, it is an advanced user view. It is intended for users that need access to more actions that the limited set available in the cloud view. Users will not be able to manage nor retrieve the hosts and clusters of the cloud. They will be able to see Datastores and Virtual Networks in order to use them when creating a new Image or Virtual Machine, but they will not be able to create new ones. Details can be configured in the ``/etc/one/sunstone-views/user.yaml`` file.

|user_view|

.. _suns_views_configuring_access:

Configuring Access to the Views
================================================================================

By default, the ``admin`` view is only available to the ``oneadmin`` group. New users will be included in the ``users`` group and will use the default ``cloud`` view. The views assigned to a given group can be defined in the group creation form or updating an existing group to implement different OpenNebula models. For more information on the different OpenNebula models please check the :ref:`Understanding OpenNebula documentation <understand>`.

|sunstone_group_defview|

.. _sunstone_settings:

Usage
================================================================================

Sunstone users can change their current view from the top-right drop-down menu:

|views_change|

They can also configure several options from the settings tab:

-  Views: change between the different available views
-  Language: select the language that they want to use for the UI.
-  Use secure websockets for VNC: Try to connect using secure websockets when starting VNC sessions.
-  Display Name: If the user wishes to customize the username that is shown in Sunstone it is possible to so by adding a special parameter named ``SUNSTONE_DISPLAY_NAME`` with the desired value. It is worth noting that Cloud Administrators may want to automate this with a hook on user create in order to fetch the user name from outside OpenNebula.

These options are saved in the user template, as well as other hidden settings like for instance the attribute that lets Sunstone remember the number of items displayed in the datatables per user. If not defined, defaults from ``/etc/one/sunstone-server.conf`` are taken.

|views_settings|

.. _suns_views_define_new:

Defining a New OpenNebula Sunstone View or Customizing an Existing one
================================================================================

View definitions are placed in the ``/etc/one/sunstone-views`` directory. Each view is defined by a configuration file, in the form:

.. code::

       <view_name>.yaml

The name of the view will be the filename without the yaml extension.

.. code::

    /etc/one/
    ...
    |-- sunstone-views/
    |   |-- admin.yaml       <--- the admin view
    |   `-- cloud.yaml       <--- the cloud view
    `-- sunstone-views.yaml
    ...

.. note:: The easiest way to create a custom view is to copy the ``admin.yaml`` or ``cloud.yaml`` file and then harden it as needed.

Admin View Customization
--------------------------------------------------------------------------------

The content of a view file specifies the tabs available in the view (note: tab is one of the main sections of the UI, those in the left-side menu). Each tab can be enabled or disabled by updating the ``enabled_tabs:`` attribute. For example to disable the Clusters tab, comment the ``clusters-tab`` entry:

.. code-block:: yaml

    enabled_tabs:
        - dashboard-tab
        - instances-top-tab
        - vms-tab
        - oneflow-services-tab
        - templates-top-tab
        - templates-tab
        - oneflow-templates-tab
        - storage-top-tab
        - datastores-tab
        - images-tab
        - files-tab
        - marketplaces-tab
        - marketplaceapps-tab
        - network-top-tab
        - vnets-tab
        - vrouters-tab
        - vnets-topology-tab
        - secgroups-tab
        - infrastructure-top-tab
        #- clusters-tab
        - hosts-tab
        - zones-tab
        - system-top-tab
        - users-tab
        - groups-tab
        - vdcs-tab
        - acls-tab
        - settings-tab
        - support-tab

Each tab can be tuned by selecting:

-  The individual resource tabs available (``panel_tabs:`` attribute) in the tab, these are the tabs activated when an object is selected (e.g. the information, or capacity tabs in the Virtual Machines tab).
-  The columns shown in the main information table (``table_columns:`` attribute).
-  The action buttons available to the view (``actions:`` attribute).

The attributes in each of the above sections should be self-explanatory. As an example, the following section defines a simplified datastore tab, without the info panel_tab and no action buttons:

.. code-block:: yaml

        datastores-tab:
            panel_tabs:
                datastore_info_tab: false
                datastore_image_tab: true
                datastore_clusters_tab: false
            table_columns:
                - 0         # Checkbox
                - 1         # ID
                - 2         # Owner
                - 3         # Group
                - 4         # Name
                - 5         # Capacity
                - 6         # Cluster
                #- 7         # Basepath
                #- 8         # TM
                #- 9         # DS
                - 10        # Type
                - 11        # Status
                #- 12        # Labels
            actions:
                Datastore.refresh: true
                Datastore.create_dialog: false
                Datastore.import_dialog: false
                Datastore.addtocluster: false
                Datastore.rename: false
                Datastore.chown: false
                Datastore.chgrp: false
                Datastore.chmod: false
                Datastore.delete: false
                Datastore.enable: false
                Datastore.disable: false

Cloud View Customization
--------------------------------------------------------------------------------

The cloud layout can also be customized by changing the corresponding yaml files.

In this section you can customize the options available when instantiating a new template, the dashboard setup or the resources available for cloud users.

.. code-block:: yaml

    provision_logo: images/one_small_logo.png
    enabled_tabs:
        - provision-tab
        - users-tab
        - settings-tab
    features:
        showback: true

        # Allows to change the security groups for each network interface
        # on the VM creation dialog
        secgroups: true

The actions available for a given VM can be customized and extended by modifying the ``cloud.yaml`` file. You can even insert VM panels from the admin view into this view, for example to use the disk snapshots or scheduled actions.

* Hiding the delete button

.. code-block:: yaml

    tabs:
        provision-tab:
            ...
            actions: &provisionactions
                ...
                VM.shutdown_hard: false
                VM.delete: false


* Using undeploy instead of power off

.. code-block:: yaml

    tabs:
        provision-tab:
            ...
            actions: &provisionactions
                ...
                VM.poweroff: false
                VM.poweroff_hard: false
                VM.undeploy: true
                VM.undeploy_hard: true


* Adding panels from the admin view, for example the disk snapshots tab

.. code-block:: yaml

    tabs:
        provision-tab:
            panel_tabs:
                ...
                vm_snapshot_tab: true
                ...
            ...
            actions: &provisionactions
                ...
                VM.disk_snapshot_create: true
                VM.disk_snapshot_revert: true
                VM.disk_snapshot_delete: true

|customizecloudview|


.. |admin_view| image:: /images/admin_view.png
.. |user_view| image:: /images/user_view.png
.. |cloud_dash| image:: /images/cloud_dash.png
.. |views_settings| image:: /images/views_settings.png
.. |views_change| image:: /images/views_change.png
.. |sunstone_group_defview| image:: /images/sunstone_group_defview.png
.. |sunstone_yaml_columns1| image:: /images/sunstone_yaml_columns1.png
.. |sunstone_yaml_columns2| image:: /images/sunstone_yaml_columns2.png
.. |customizecloudview| image:: /images/customizecloudview.png