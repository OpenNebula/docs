.. _suns_views:

===============
Sunstone Views
===============

Using the new OpenNebula Sunstone Views you will be able to provide a simplified UI aimed at end-users of an OpenNebula cloud. The OpenNebula Sunstone Views are fully customizable, so you can easily enable or disable specific information tabs or action buttons. You can define multiple cloud views for different user groups. Each view defines a set of UI components so each user just access and view the relevant parts of the cloud for her role.

Default Views
=============

.. todo:: still applies? is ``user`` the default view?

OpenNebula provides a default ``admin``, ``vdcadmin``, ``user`` and ``cloud`` view that implements four common views. By default, the ``admin`` view is only available to the oneadmin group. New users will be included in the users group and will use the deafault ``user`` view.

Admin View
----------

This view provides full control of the cloud.

|image0|

VDCAdmin View
-------------

.. todo:: needs to be updated

This view provides control of all the resources belonging to a Virtual DataCenter (VDC), but with no access to resources outside that VDC. It is basically and Admin view restricted to the physical and virtual resources of the VDC, with the ability to create new users within the VDC.

|image1|

User View
---------

In this view users will not be able to manage nor retrieve the hosts and clusters of the cloud. They will be able to see Datastores and Virtual Networks in order to use them when creating a new Image or Virtual Machine, but they will not be able to create new ones. For more information about this view, please check the ``/etc/one/sunstone-views/user.yaml`` file.

|image2|

Cloud View
----------

This is a simplified view mainly intended for user that just require a portal where they can provision new virtual machines easily. They just have to select one of the available templates and the operating system that will run in this virtual machine. For more information about this view, please check the ``/etc/one/sunstone-views/cloud.yaml`` file.

In this scenario the cloud administrator must prepare a set of templates and images and make them available to the cloud users. Templates must define all the required parameters and just leave the DISK section empty, so the user can select any of the available images. New virtual machines will be created merging the information provided by the user (image, vm\_name...) and the base template. Thereby, the user doesn't have to know any details of the infrastructure such as networking, storage. For more information on how to configure this scenario see :ref:`this guide <cloud_view>`

|image3|

Requirements
============

OpenNebula Sunstone Views does not require any additional service to run. You may want to review the Sunstone configuration to deploy advanced setups, to scale the access to the web interface or to use SSL security.

Usage
=====

Sunstone users can configure several options from the configuration tab:

-  Language: select the language that they want to use for the UI.
-  Use secure websockets for VNC: Try to connect using secure websockets when starting VNC sessions.
-  Views: change between the different available views for the given user/group
-  Display Name: If the user wishes to customize the username that is shown in Sunstone it is possible to so by adding a special parameter named ``SUNSTONE_DISPLAY_NAME`` with the desired value. It is worth noting that Cloud Administrators may want to automate this with a hook on user create in order to fetch the user name from outside OpenNebula.

This options are saved in the user template. If not defined, defaults from ``sunstone-server.conf`` are taken.

|image4|

|image5|

Changing your View
------------------

If more than one view are available for this user, she can easily change between them in the settings window, along with other settings (e.g. language).

.. warning:: By default users in the oneadmin group have access to all the views; users in the users group can only use the ``users view``. If you want to expose the ``cloud view`` to a given group of users, you have to modify the ``sunstone-views.yaml``. For more information check the `configuring access to views <#configuring-access-to-the-views>`_ section

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

The content of a view file specifies the tabs available in the view (note: tab is on of the main sections of the UI, those in the left-side menu). Each tab can be enabled or disabled by updating the ``enabled_tabs:`` attribute. For example to disable the Clusters tab, just set ``clusters-tab`` value to ``false``:

.. code::

    enabled_tabs:
        dashboard-tab: true
        system-tab: true
        users-tab: true
        groups-tab: true
        acls-tab: true
        vresources-tab: true
        vms-tab: true
        templates-tab: true
        images-tab: true
        files-tab: true
        infra-tab: true
        clusters-tab: false
        hosts-tab: true
        datastores-tab: true
        vnets-tab: true
        marketplace-tab: true
        oneflow-dashboard: tru
        oneflow-services: true
        oneflow-templates: true

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

.. warning:: The easiest way to create a custom view is to copy the ``admin.yaml`` file to the new view then harden it as needed.

Configuring Access to the Views
-------------------------------

.. todo:: does not apply, update with screenshots of group wizard

Once you have defined and customized the UI views for the different roles, you need to define which user groups or users may access to each view. This information is defined in the ``/etc/one/sunstone-views.yaml``.

The views can be defined for:

-  Each user (``users:`` section), list each user and the set of views available for her.
-  Each group (``groups:`` section), list the set of views for the group.
-  The default view, if a user is not listed in the ``users:`` section, nor its group in the ``groups:`` section, the default views will be used.

For example the following enables the user (user.yaml) and the cloud (cloud.yaml) views for helen and the cloud (cloud.yaml) view for group cloud-users. If more than one view for a given user the first one is the default:

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

A Different Endpoint for Each View
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenNebula Sunstone views can be adapted to deploy a different endpoint for each kind of user. For example if you want an endpoint for the admins and a different one for the cloud users. You will just have to deploy a new sunstone server (TODO deploy in a different machine link) and set a default view for each sunstone instance:

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

.. |image0| image:: /images/admin_view.jpg
.. |image1| image:: /images/vdcadmin_view.png
.. |image2| image:: /images/user_view.jpg
.. |image3| image:: /images/cloud-view.png
.. |image4| image:: /images/views_settings.jpg
.. |image5| image:: /images/views_conf.jpg
