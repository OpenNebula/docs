.. _sunstone_dev:

================================================================================
Sunstone Development
================================================================================

OpenNebula FireEdge server provides a **next-generation web-management interface**. It is able to deliver several applications accessible through the following URLs:

- Provision GUI: ``<http://<OPENNEBULA-FRONTEND>:2616/fireedge/provision>``
- Sunstone GUI: ``<http://<OPENNEBULA-FRONTEND>:2616/fireedge/sunstone>`` (automatically redirected from ``<http://<OPENNEBULA-FRONTEND>:2616/``)

This second Sunstone incarnation is written in `React <https://reactjs.org/>`__ / `Redux <https://redux.js.org/>`__ and `Material-UI <https://mui.com/>`__ is used for the styles and layout of the web.

If you want to do development work over Sunstone, you need to install OpenNebula from source. For this, you will need :ref:`build dependencies <build_deps>`, `git <https://git-scm.com/>`__, `nodeJS v12 <https://nodejs.org/en/blog/release/v12.22.12>`__ and `npm v6 <https://docs.npmjs.com/downloading-and-installing-node-js-and-npm>`__.

Once the environment has been prepared, you need to clone `one repository <https://github.com/OpenNebula/one>`__ and follow the steps :ref:`to compile the OpenNebula software <compile>`.

Then move to FireEdge directory (``src/fireedge``) and run:

.. prompt:: bash $ auto

    $ npm i         # Install dependencies from package.json
    $ npm run       # List the available scripts
    $ npm run dev   # Start the development server. By default on http://localhost:2616/fireedge

You can read more about this in the :ref:`FireEdge configuration guide <fireedge_install_configuration>`.

FireEdge API
================================================================================

OpenNebula FireEdge API is a RESTful service to communicate with other OpenNebula services.

Among others, it includes the OpenNebula Cloud API Specification for JS. It been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers to return the data in JSON formats. This means that you should be familiar with the XML-RPC API and the JSON formats returned by the OpenNebula core.

Authentication & Authorization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

User authentication is done via XMLRPC using the OpenNebula authorization module. If the username and password matches with the serveradmin data, the user's request will be granted, the session data will be saved in a global variable (cache-nodejs), and a JSON Web Token (JWT) will be generated that must be sent in the authorization header of the HTTP request.

.. prompt:: bash $ auto

    $ curl -X POST -H "Content-Type: application/json" \
    $ -d '{"user": "username", "token": "password"}' \
    $ http://fireedge.server/fireedge/api/auth

.. note:: The JWT lifetime can be configured in the fireedge_server.conf configuration file.

Methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Auth
--------------------------------------------------------------------------------

+--------------+--------------------------------------+--------------------------------------------------------+
| Method       | URL                                  | Meaning / Entity Body                                  |
+==============+======================================+========================================================+
| **POST**     | ``/fireedge/api/auth``               | Authenticate user by credentials.                      |
+--------------+--------------------------------------+--------------------------------------------------------+
| **POST**     | ``/fireedge/api/tfa``                | Set the Two factor authentication (2FA).               |
+--------------+--------------------------------------+--------------------------------------------------------+
| **GET**      | ``/fireedge/api/tfa``                | **Show** the QR code resource.                         |
+--------------+--------------------------------------+--------------------------------------------------------+
| **DELETE**   | ``/fireedge/api/tfa``                | **Delete** the QR code resource.                       |
+--------------+--------------------------------------+--------------------------------------------------------+

File
--------------------------------------------------------------------------------

+--------------+--------------------------------------+--------------------------------------------------------+
| Method       | URL                                  | Meaning / Entity Body                                  |
+==============+======================================+========================================================+
| **GET**      | ``/fireedge/api/files``              | **List** the files collection.                         |
+--------------+--------------------------------------+--------------------------------------------------------+
| **GET**      | ``/fireedge/api/files/<id>``         | **Show** the file identified by <id>.                  |
+--------------+--------------------------------------+--------------------------------------------------------+
| **POST**     | ``/fireedge/api/files``              | **Create** a new file.                                 |
+--------------+--------------------------------------+--------------------------------------------------------+
| **PUT**      | ``/fireedge/api/files/<id>``         | **Update** the file identified by <id>.                |
+--------------+--------------------------------------+--------------------------------------------------------+
| **DELETE**   | ``/fireedge/api/files/<id>``         | **Delete** the file identified by <id>.                |
+--------------+--------------------------------------+--------------------------------------------------------+

OneFlow
--------------------------------------------------------------------------------

+--------------+---------------------------------------------------------------+------------------------------------------------------------------------+
| Method       | URL                                                           | Meaning / Entity Body                                                  |
+==============+===============================================================+========================================================================+
| **GET**      | ``/fireedge/api/service_template``                            | **List** the service template collection.                              |
+--------------+---------------------------------------------------------------+------------------------------------------------------------------------+
| **GET**      | ``/fireedge/api/service_template/<id>``                       | **Show** the service template identified by <id>.                      |
+--------------+---------------------------------------------------------------+------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/service_template``                            | **Create** a new service template.                                     |
+--------------+---------------------------------------------------------------+------------------------------------------------------------------------+
| **PUT**      | ``/fireedge/api/service_template/<id>``                       | **Update** the service template identified by <id>.                    |
+--------------+---------------------------------------------------------------+------------------------------------------------------------------------+
| **DELETE**   | ``/fireedge/api/service_template/<id>``                       | **Delete** the service template identified by <id>.                    |
+--------------+---------------------------------------------------------------+------------------------------------------------------------------------+

+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| Method       | URL                                                           | Meaning / Entity Body                                                                               |
+==============+===============================================================+=====================================================================================================+
| **GET**      | ``/fireedge/api/service``                                     | **List** the service collection.                                                                    |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **GET**      | ``/fireedge/api/service/<id>``                                | **Show** the service identified by <id>.                                                            |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/service``                                     | **Create** a new service.                                                                           |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **PUT**      | ``/fireedge/api/service/<id>``                                | **Update** the service identified by <id>.                                                          |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **DELETE**   | ``/fireedge/api/service/<id>``                                | **Delete** the service identified by <id>.                                                          |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/service/action/<id>``                         | **Perform** an action on the service identified by <id>.                                            |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/service/scale/<id>``                          | **Perform** an scale on the service identified by <id>.                                             |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/service/role_action/<role_id>/<id>``          | **Perform** an action on all the VMs belonging to the role to the service identified both by <id>.  |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/service/sched_action/<id>``                   | **Create** a new schedule action on the service identified by <id>.                                 |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **PUT**      | ``/fireedge/api/service/sched_action/<sched_action_id>/<id>`` | **Update** the schedule action on the service identified both by <id>.                              |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+
| **DELETE**   | ``/fireedge/api/service/sched_action/<sched_action_id>/<id>`` | **Delete** the schedule action on the service identified both by <id>.                              |
+--------------+---------------------------------------------------------------+-----------------------------------------------------------------------------------------------------+

Sunstone
--------------------------------------------------------------------------------

+--------------+---------------------------------------+---------------------------------------------------------+
| Method       | URL                                   | Meaning / Entity Body                                   |
+==============+=======================================+=========================================================+
| **GET**      | ``/fireedge/api/sunstone/views``      | **Get** the Sunstone view.                              |
+--------------+---------------------------------------+---------------------------------------------------------+
| **GET**      | ``/fireedge/api/sunstone/config``     | **Get** the Sunstone config.                            |
+--------------+---------------------------------------+---------------------------------------------------------+


Zendesk
--------------------------------------------------------------------------------

+--------------+---------------------------------------------+----------------------------------------------------+
| Method       | URL                                         | Meaning / Entity Body                              |
+==============+=============================================+====================================================+
| **POST**     | ``/fireedge/api/zendesk/login``             | Authenticate user by credentials.                  |
+--------------+---------------------------------------------+----------------------------------------------------+
| **GET**      | ``/fireedge/api/zendesk``                   | **List** the tickets collection.                   |
+--------------+---------------------------------------------+----------------------------------------------------+
| **GET**      | ``/fireedge/api/zendesk/<id>``              | **Show** the ticket identified by <id>.            |
+--------------+---------------------------------------------+----------------------------------------------------+
| **GET**      | ``/fireedge/api/zendesk/comments/<id>``     | **List** the ticket's comments identified by <id>. |
+--------------+---------------------------------------------+----------------------------------------------------+
| **POST**     | ``/fireedge/api/zendesk``                   | **Create** a new ticket.                           |
+--------------+---------------------------------------------+----------------------------------------------------+
| **PUT**      | ``/fireedge/api/zendesk/<id>``              | **Update** the ticket identified by <id>.          |
+--------------+---------------------------------------------+----------------------------------------------------+


Frontend Architecture
================================================================================

An important part of managing OpenNebula through an interface is the use of forms and lists of resources. For this reason, we decided to extract some of this logic in configuration files.

Unlike the current, ruby-based Sunstone, it's the behavior of requests in parallel which allows the use of the interface with greater flexibility and fluidity.

Queries to get the pool resource from OpenNebula are greatly optimized, which ensures a swift response of the interface. If a large amount of certain types of resources are present (for example VMs or Hosts), a performance strategy that consists of making queries with intervals is implemented. Thus, the representation of the first interval list of resources is faster and the rest of the queries are kept in the background.

Sunstone Configuration Files
================================================================================

Through the configuration files we can define view types and assign them to different groups. Then, we differentiate between the master and view files.

Master File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This file orchestrates the views according to the user's primary group and it's located in ``etc/sunstone/sunstone-view.yaml``.

In the following example, all groups have access to the user view and ``oneadmin`` to the admin view also:

.. code-block:: yaml

  # etc/sunstone/sunstone-view.yaml
  groups:
    oneadmin:
      - admin
      - user
  default:
    - user


View Directory And Tab Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The view directory contains the route or tab files. These tab files, with YAML extension, describe the behavior of each resource list within the application: VMs, Networks, Hosts, etc.

The tab files are located in ``etc/sunstone/<view_name>/<resource_tab>``.

Adding New Tabs
================================================================================

OpenNebula resources are grouped into pools and can be managed from the interface through resource tab (or route) where we can operate over one or more resources, filter by attributes or get detailed information about individual resources.

To develop a new tab, it's necessary to understand the structure of the configuration tab files:

- **Resource**: related information about resources.
- **Actions**: buttons to operate over the resources.
- **Filters**: list of criteria to filter the resources.
- **Information Tabs**: list of tabs to show detailed information.
- **Dialogs**: steps and logic to render the dialog.


Resource
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the view files as a starting point, the interface generates the available routes and defines them in a menu.

Through each tab in the sidebar you can control and manage OpenNebula resources. All tabs should have a folder in the containers directory ``src/client/containers`` and enabled the route in ``src/client/apps/sunstone/routesOne.js``.

+------------------------------------+--------------------------------------------------------------------------------------------------+
|               Property             |                                     Description                                                  |
+====================================+==================================================================================================+
| ``resource_name``                  | Reference to ``RESOURCE_NAMES`` in ``src/client/constants/index.js``                             |
+------------------------------------+--------------------------------------------------------------------------------------------------+

.. note::

  It's important that ``resource_name`` matches the ``RESOURCE_NAMES`` constant, because the constants are used to define the routes in ``src/client/apps/sunstone/routesOne.js``.


Actions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

List of actions to operate over the resources: ``refresh``, ``chown``, ``chgrp``, ``lock``, ``unlock``, etc.

There are three action types:

- Form modal actions. These actions do not have a ``_dialog`` suffix.
- Actions referenced in other files. For example, the VM Template ``create_app_dialog`` references the Marketplace App ``create_dialog``.
- Form actions on separate route. These actions have a ``_dialog`` suffix. For example, the VM Template ``instantiate_dialog`` will have a route defined similar to ``http://localhost:2616/fireedge/sunstone/vm-template/instantiate``.

All actions are defined in the resource constants. For example, the VM Template's are located in ``src/client/constants/vmTemplate.js`` as ``VM_TEMPLATE_ACTIONS``.

Filter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This includes the list of criteria to filter each OpenNebula resource pool.

To add one, first it's necessary to implement the filter in the table columns. E.g.:

.. code-block:: javascript

  // src/client/components/Tables/MarketplaceApps/columns.js
  {
    Header: 'State',
    id: 'STATE',
    disableFilters: false,
    Filter: ({ column }) =>
      CategoryFilter({
        column,
        multiple: true,
        title: 'State',
      }),
    filter: 'includesValue',
  }

Information Tabs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The detailed view of a resource is structured in a tab-like layout. Tabs are defined in the ``index.js`` file of each resource's folder ``src/client/components/Tabs/<resource>``. E.g.: The VM Templates tabs are located in ``src/client/components/Tabs/VmTemplate/index.js``.

Each entry in the ``info-tabs`` represents a tab and they all have two attributes, except for the ``info`` tab:

- ``enabled``: defines if the tab is visible.
- ``actions``: contains the allowed actions in the tab. The utility function to get the available actions for a tab is located at ``src/client/models/Helper.js``.

The ``info`` tab is special because it contains panels sections. Each panel section is an attribute group that can include actions itself.

Attribute groups can be separated into four panels:

- Information: Main attributes and details for the resource.
- Permissions: associated permissions for the owner, the users in her group, and others.
- Ownership: user and group to which it belongs.
- Attributes (not always displayed): these panels are separate because they have information about each hypervisor and monitoring.

Each group of actions can filter by hypervisor (**only resources with hypervisor**), e.g.:

.. code-block:: yaml

  # etc/sunstone/admin/vm-tab.yaml
  storage:
    enabled: true
    actions:
      attach_disk:
        enabled: true
        not_on:
          - firecracker

Dialogs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The resource actions that have the ``_dialog`` suffix, need to define their structure in this section.

The first entries in the dialog refer to the available steps. Then, within the individual step definitions are the accessible sections.

Each step and section should match the **id** in the code and can filter by hypervisor (**only resources with hypervisor**).

See some examples:

- Required step: ``src/client/components/Forms/VmTemplate/InstantiateForm/Steps/VmTemplatesTable/index.js``
- Step with sections: ``src/client/components/Forms/VmTemplate/InstantiateForm/Steps/BasicConfiguration/index.js``
- Step with tabs: ``src/client/components/Forms/VmTemplate/InstantiateForm/Steps/AdvancedOptions/index.js``

.. code-block:: yaml

  # etc/sunstone/admin/vm-template-tab.yaml
  # ** Required means that it's necessary for the operation of the form
  dialogs:
    instantiate_dialog:
      select_vm_template: true # required
      configuration:
        information: true
        ownership: true
        permissions: true
        capacity: true
        vm_group: true
        vcenter:
          enabled: true
          not_on:
            - kvm
            - lxc
            - firecracker
      advanced_options:
        storage: true
        network: true
        placement: true
        sched_action: true
        booting: true

SSO (Single sign-on)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
With this function you can access the Sunstone UI from the browser without logging in. For this, you need to send the JWT of the user in the ``externalToken`` parameter of the URL.

For example:

.. prompt:: bash $ auto

    $ https://{fireedge-sunstone}?externalToken={JWT}

.. note::

    To obtain the JWT you must first make a call to ``http://{fireedge}/fireedge/api/auth`` sending the user's credentials and retrieving only the value of **token**, e.g.:

    .. code::

        $ curl -X POST -H "Content-Type: application/json" \
        $ -d '{ "user": "username", "token": "password" }' \
        $ http://{fireedge}/fireedge/api/auth

       {"id":200,"message":"OK","data":{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIwIiwiYXVkIjoic2VydmVyYWRtaW46b25lYWRtaW4iLCJqdGkiOiJ2SU85ME91VUU5b1RNaXRRVytLYmNqRXZlS252Qnc5c2Ura1pPNlVRdmRjPSIsImlhdCI6MTY1MDI3NTQzMC45MzcsImV4cCI6MTY1MDI4NjIzMH0.AqJGLbCNG470PbjoI4yLqvKNOl1FR4Ui6YlK6pSZddQ","id":"0"}}
