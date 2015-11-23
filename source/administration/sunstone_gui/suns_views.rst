.. _suns_views:

===============
Sunstone Views
===============

Using the OpenNebula Sunstone Views you will be able to provide a simplified UI aimed at end-users of an OpenNebula cloud. The OpenNebula Sunstone Views are fully customizable, so you can easily enable or disable specific information tabs or action buttons. You can define multiple  views for different user groups. Each view defines a set of UI components so each user just access and view the relevant parts of the cloud for her role.

The OpenNebula Sunstone Views can be grouped in two different layouts. On one hand, the classic Sunstone layout exposes a complete view of the cloud, allowing administrators and advanced users to have full control of any physical or virtual resource of the cloud. On the other hand, the newer cloud layout exposes a simplified version of the cloud where group administrators and cloud end-users will be able to manage any virtual resource of the cloud, without taking care of the physical resources management.

Default Views
=============

OpenNebula provides three default advanced views, ``admin``, ``admin_vcenter`` and ``user`` and three simplified cloud view ``groupadmin``, ``cloud_vcenter`` and ``cloud`` that implements six common views. By default, the ``admin`` view is only available to the oneadmin group. New users will be included in the users group and will use the default ``cloud`` view.

+----------------------+--------+----------------+-------------------+-------+----------+------------+-------+-------+-----+--------+-----------+----------+
| Advanced view layout |        |                |                   |       |          |            |       |       |     |        |           |          |
+======================+========+================+===================+=======+==========+============+=======+=======+=====+========+===========+==========+
|                      | System | Infrastructure | Virtual Resources |       |          |            |       |       |     |        |           |          |
+----------------------+--------+----------------+-------------------+-------+----------+------------+-------+-------+-----+--------+-----------+----------+
|                      | Users  | Groups         | ACLs              | Hosts | Clusters | Datastores | VNets | Zones | VMs | Images | Templates | Services |
+----------------------+--------+----------------+-------------------+-------+----------+------------+-------+-------+-----+--------+-----------+----------+
| Admin                | x      | x              | x                 | x     | x        | x          | x     | x     | x   | x      | x         | x        |
+----------------------+--------+----------------+-------------------+-------+----------+------------+-------+-------+-----+--------+-----------+----------+
| Admin vCenter        | x      | x              | x                 | x     | x        | x          | x     | x     | x   |        | x         | x        |
+----------------------+--------+----------------+-------------------+-------+----------+------------+-------+-------+-----+--------+-----------+----------+
| User                 |        |                |                   |       |          | x          | x     |       | x   | x      | x         | x        |
+----------------------+--------+----------------+-------------------+-------+----------+------------+-------+-------+-----+--------+-----------+----------+

+-------------------+--------+-------------------+-----------------+----------+
| Cloud view layout |        |                   |                 |          |
+===================+========+===================+=================+==========+
|                   | System | Virtual Resources |                 |          |
+-------------------+--------+-------------------+-----------------+----------+
|                   | Users  | VMs               | Saved Templates | Services |
+-------------------+--------+-------------------+-----------------+----------+
| Group Admin       | x      | x                 | x               | x        |
+-------------------+--------+-------------------+-----------------+----------+
| Cloud vCenter     |        | x                 |                 | x        |
+-------------------+--------+-------------------+-----------------+----------+
| Cloud             |        | x                 | x               | x        |
+-------------------+--------+-------------------+-----------------+----------+

Admin View
----------

This view provides full control of the cloud.

|admin_view|

.. _vcenter_view:

Admin vCenter View
--------------------------------------------------------------------------------

View designed to present the valid operations agaist a vCenter infrastructure to a cloud administrator.

|vcenter_view|

User View
---------

In this view users will not be able to manage nor retrieve the hosts and clusters of the cloud. They will be able to see Datastores and Virtual Networks in order to use them when creating a new Image or Virtual Machine, but they will not be able to create new ones. For more information about this view, please check the ``/etc/one/sunstone-views/user.yaml`` file.

|user_view|

Group Admin View
--------------------------------------------------------------------------------

This view provides control of all the resources belonging to a group, but with no access to resources outside that group, that is, restricted to the physical and virtual resources of the group. This view features the ability to create new users within the group as well as set and keep track of user quotas. For more information on how to configure this scenario see :ref:`this guide <group_admin_view>`

|groupadmin_dash|

Cloud View
----------

This is a simplified view mainly intended for user that just require a portal where they can provision new virtual machines easily from pre-defined Templates. For more information about this view, please check the ``/etc/one/sunstone-views/cloud.yaml`` file.

In this scenario the cloud administrator must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated, i.e. they define all the mandatory attributes. Before using them, users can optinally customize the VM capacity, add new network interfaces and provide values required by the template.  Thereby, the user doesn't have to know any details of the infrastructure such as networking, storage. For more information on how to configure this scenario see :ref:`this guide <cloud_view>`

|cloud_dash|

.. _vcenter_cloud_view:

vCenter Cloud View
------------------

View designed to present the valid operations agaist a vCenter infrastructure to a cloud consumer.

Requirements
============

OpenNebula Sunstone Views does not require any additional service to run. You may want to review the Sunstone configuration to deploy advanced setups, to scale the access to the web interface or to use SSL security.

.. _suns_views_configuring_access:

Configuring Access to the Views
===============================

By default, the ``admin`` view is only available to the oneadmin group. New users will be included in the users group and will use the default ``cloud`` view. The views assigned to a given group can be defined in the group creation form or updating an existing group to implement different OpenNebula models, for more information on the different OpenNebula models please check the :ref:`Understanding OpenNebula guide <understand>`.

|sunstone_group_defview|

Sunstone will calculate the views available to users using:

- From all the groups the user belongs to, the SUNSTONE_VIEWS (comma separated list of views) attributes is pulled. Those views combined would be presented to the user
- If no views available from users, the defaults would be fetched from ``sunstone-views.yaml``. Here, views can be defined for:

  -  Each user (``users:`` section), list each user and the set of views available for her.
  -  Each group (``groups:`` section), list the set of views for the group.
  -  The default view, if a user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default views will be used.

- By default users in the oneadmin group have access to all views
- By default users in the users group can use ``coud_view``

Regarding ``sunstone-views.yaml``, the following example enables the user (user.yaml) and the cloud (cloud.yaml) views for helen and the cloud (cloud.yaml) view for group cloud-users. If more than one view for a given user the first one is the default.

.. code::

    ...
    users:
        helen:
            - cloud
            - user
    groups:
        cloud-users:
            - cloud
    default:
        - user

.. _sunstone_settings:

Usage
=====

Sunstone users can configure several options from the configuration tab:

-  Language: select the language that they want to use for the UI.
-  Use secure websockets for VNC: Try to connect using secure websockets when starting VNC sessions.
-  Views: change between the different available views for the given user/group
-  Display Name: If the user wishes to customize the username that is shown in Sunstone it is possible to so by adding a special parameter named ``SUNSTONE_DISPLAY_NAME`` with the desired value. It is worth noting that Cloud Administrators may want to automate this with a hook on user create in order to fetch the user name from outside OpenNebula.

These options are saved in the user template, as well as other hidden settings like for instance the attribute that lets Sunstone remember the number of items displayer in the datatables per user. If not defined, defaults from ``sunstone-server.conf`` are taken.

|views_settings|

Changing your View
------------------

If more than one view are available for this user, she can easily change between them in the settings window, along with other settings (e.g. language). See the :ref:`Configuring Access to the Views <suns_views_configuring_access>` section to learn how views are calculated per user.

Internationalization and Languages
----------------------------------

Sunstone support multiple languages. If you want to contribute a new language, make corrections or complete a translation, you can visit our:

-  `Transifex poject page <https://www.transifex.com/projects/p/one/>`__

Translating through Transifex is easy and quick. All translations should be submitted via Transifex.

Users can update or contribute translations anytime. Prior to every release, normally after the beta release, a call for translations will be made in the user list. Then the source strings will be updated in Transifex so all the translations can be updated to the latest OpenNebula version. Translation with an acceptable level of completeness will be added to the final OpenNebula release.

Advanced Configuration
======================

There are three basic areas that can be tuned to adapt the default behavior to your provisioning needs:

-  Define views, the set of UI components that will be enabled.
-  Define the users and groups that may access to each view.
-  Brand your OpenNebula Sunstone portal.

.. _suns_views_define_new:

Defining a New OpenNebula Sunstone View or Customizing an Existing one
----------------------------------------------------------------------

View definitions are placed in the ``/etc/one/sunstone-views`` directory. Each view is defined by a configuration file, in the form:

.. code::

       <view_name>.yaml

The name of the view is the the filename without the yaml extension. The default views are defined by the user.yaml and admin.yaml files, as shown below:

.. code::

    etc/
    ...
    |-- sunstone-views/
    |   |-- admin.yaml   <--- the admin view
    |   `-- user.yaml
    `-- sunstone-views.yaml
    ...

The content of a view file specifies the tabs available in the view (note: tab is on of the main sections of the UI, those in the left-side menu). Each tab can be enabled or disabled by updating the ``enabled_tabs:`` attribute. For example to disable the Clusters tab, comment the ``clusters-tab`` entry:

.. code-block:: yaml

    enabled_tabs:
        - dashboard-tab
        - system-tab
        - users-tab
        - groups-tab
        - acls-tab
        - vresources-tab
        - vms-tab
        - templates-tab
        - images-tab
        - files-tab
        - infra-tab
        # - clusters-tab
        - hosts-tab
        - datastores-tab
        - vnets-tab
        - marketplace-tab
        - oneflow-dashboard
        - oneflow-services
        - oneflow-templates

Each tab, can be tuned by selecting:

-  The bottom tabs available (``panel_tabs:`` attribute) in the tab, these are the tabs activated when an object is selected (e.g. the information, or capacity tabs in the Virtual Machines tab).
-  The columns shown in the main information table (``table_columns:`` attribute).
-  The action buttons available to the view (``actions:`` attribute).

The attributes in each of the above sections should be self-explanatory. As an example, the following section, defines a simplified datastore tab, without the info panel\_tab and no action buttons:

.. code::

        datastores-tab:
            panel_tabs:
                datastore_info_tab: false
                datastore_image_tab: true
            table_columns:
                - 0         # Checkbox
                - 1         # ID
                - 2         # Owner
                - 3         # Group
                - 4         # Name
                - 5         # Cluster
                #- 6         # Basepath
                #- 7         # TM
                #- 8         # DS
                #- 9         # Type
            actions:
                Datastore.refresh: true
                Datastore.create_dialog: false
                Datastore.addtocluster: false
                Datastore.chown: false
                Datastore.chgrp: false
                Datastore.chmod: false
                Datastore.delete: false

The table columns defined in the view.yaml file will apply not only to the main tab, but also to other places where the resources are used. For example, if the admin.yaml file defines only the Name and Running VMs columns for the host table:

.. code::

    hosts-tab:
        table_columns:
            #- 0         # Checkbox
            #- 1         # ID
            - 2         # Name
            #- 3         # Cluster
            - 4         # RVMs
            #- 5         # Real CPU
            #- 6         # Allocated CPU
            #- 7         # Real MEM
            #- 8         # Allocated MEM
            #- 9         # Status
            #- 10        # IM MAD
            #- 11        # VM MAD
            #- 12        # Last monitored on

These will be the only visible columns in the main host list:

|sunstone_yaml_columns1|

And also in the dialogs where a host needs to be selected, like the VM deploy action:

|sunstone_yaml_columns2|

The cloud layout can also be customized by changing the following section of the yaml files:

.. code::

    provision-tab:
        panel_tabs:
            users: false
            flows: true
            templates: true
        actions:
            Template.chmod: false
            Template.delete: true
        dashboard:
            quotas: true
            vms: true
            groupquotas: false
            groupvms: false
            users:  false
        create_vm:
            capacity_select: true
            network_select: true

In this section you can customize the options available when instantiating a new template, the dashboard setup or the resources available for cloud users.

.. note:: The easiest way to create a custom view is to copy the ``admin.yaml`` file to the new view then harden it as needed.

A Different Endpoint for Each View
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula Sunstone views can be adapted to deploy a different endpoint for each kind of user. For example if you want an endpoint for the admins and a different one for the cloud users. You will just have to deploy a :ref:`new sunstone server <suns_advance>` and set a default view for each sunstone instance:

.. code::

      # Admin sunstone
      cat /etc/one/sunstone-server.conf
        ...
        :host: admin.sunstone.com
        ...

      cat /etc/one/sunstone-views.yaml
        ...
        users:
        groups:
        default:
            - admin

.. code::

      # Users sunstone
      cat /etc/one/sunstone-server.conf
        ...
        :host: user.sunstone.com
        ...

      cat /etc/one/sunstone-views.yaml
        ...
        users:
        groups:
        default:
            - user

Branding the Sunstone Portal
----------------------------

You can easily add you logos to the login and main screens by updating the ``logo:`` attribute as follows:

-  The login screen is defined in the ``/etc/one/sunstone-views.yaml``.
-  The logo of the main UI screen is defined for each view in the view file.

.. |admin_view| image:: /images/admin_view.png
.. |vcenter_view| image:: /images/vcenter_view.png
.. |groupadmin_dash| image:: /images/vdcadmin_dash.png
.. |user_view| image:: /images/user_view.png
.. |cloud_dash| image:: /images/cloud_dash.png
.. |views_settings| image:: /images/views_settings.png
.. |sunstone_group_defview| image:: /images/sunstone_group_defview.png
.. |sunstone_yaml_columns1| image:: /images/sunstone_yaml_columns1.png
.. |sunstone_yaml_columns2| image:: /images/sunstone_yaml_columns2.png
