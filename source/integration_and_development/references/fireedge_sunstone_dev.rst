.. _fireedge_sunstone_dev:

================================================================================
FireEdge Sunstone Development
================================================================================

OpenNebula FireEdge server provides a **next-generation web-management interface**. It is able to deliver several applications accessible through the following URLs:

- Provision GUI: ``<http://<OPENNEBULA-FRONTEND>:2616/fireedge/provision>``
- Sunstone GUI: ``<http://<OPENNEBULA-FRONTEND>:2616/fireedge/sunstone>`` (automatically redirected from ``<http://<OPENNEBULA-FRONTEND>:2616/``)

This second Sunstone incarnation is written in `React <https://reactjs.org/>`__ / `Redux <https://redux.js.org/>`__ and `Material-UI <https://mui.com/>`__ is used for the styles and layout of the web.

If you want to do development work over Sunstone, you need to install OpenNebula from source code. For this, you will need :ref:`build dependencies <build_deps>`, `git <https://git-scm.com/>`__, `nodeJS <https://nodejs.org/en/>`__ and `npm <https://docs.npmjs.com/downloading-and-installing-node-js-and-npm>`__.

Once the environment has been prepared, you need to clone `one repository <https://github.com/OpenNebula/one>`__ and follow the steps :ref:`to compile the OpenNebula software <compile>`.

Then move to FireEdge directory (``src/fireedge``) and run:

.. code::

  npm i         # Install dependencies from package.json
  npm run       # List the available scripts
  npm run dev   # Start the development server. By default on http://localhost:2616/fireedge

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
| **GET**      | ``/fireedge/api/sunstone/views``      | **Get** the sunstone view.                              |
+--------------+---------------------------------------+---------------------------------------------------------+
| **GET**      | ``/fireedge/api/sunstone/config``     | **Get** the sunstone config.                            |
+--------------+---------------------------------------+---------------------------------------------------------+

vCenter
--------------------------------------------------------------------------------

+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| Method       | URL                                         | Meaning / Entity Body                                                      |
+==============+=============================================+============================================================================+
| **GET**      | ``/fireedge/api/vcenter``                   | **List** Show a list with unimported vCenter objects                       |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| **GET**      | ``/fireedge/api/vcenter/<id>``              | **Show** Show unimported vCenter object                                    |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| **GET**      | ``/fireedge/api/vcenter/listall``           | **List** Show a list with unimported vCenter objects excluding all filters |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| **GET**      | ``/fireedge/api/vcenter/listall/<id>``      | **Get** Show unimported vCenter objects excluding all filters              |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/vcenter/hosts/<vCenter>``   | **Perform** Import vCenter clusters as OpenNebula hosts                    |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/vcenter/import/<vObject>``  | **Perform** Import the the desired vCenter object                          |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+
| **POST**     | ``/fireedge/api/vcenter/cleartags/<id>``    | **Perform** Clear extraconfig tags from a vCenter VM                       |
+--------------+---------------------------------------------+----------------------------------------------------------------------------+

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

This file orchestrates the views according to the users's primary group and it's located in ``etc/sunstone/sunstone-view.yaml``.

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

The view directory contains the route or tab files. These tab files, with yaml extension, describe the behavior of each resource list within the application: VMs, Networks, Hosts, etc.

The tab files are located in ``etc/sunstone/<view_name>/<resource_tab>``.

Adding New Tabs
================================================================================

OpenNebula resources are grouped into pools and can be managed from the interface through resource tab (or route) where we can operate over one or more resources, filter by attributes or get detailed information about individual resource.

To develop a new tab, it's necessary to understand the structure of the configuration tab files:

- **Resource**: related information about resources.
- **Actions**: buttons to operate over the resources.
- **Filters**: list of criteria to filter the resources.
- **Information Tabs**: list of tabs to show detailed information.
- **Dialogs**: steps and logic to render the dialog.


Resource
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the view files as a starting point, the interface generates the available routes and defines them in a menu.

Through each tab in sidebar you can control and manage one of OpenNebula resource pool. All tabs should have a folder in the containers directory ``src/client/containers`` and enable the route in ``src/client/apps/sunstone/routesOne.js``.

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

There're three action types:

- Form modal actions. All of actions that they haven't ``_dialog`` suffix.
- Actions referenced in other files, E.g.: VM Template ``create_app_dialog`` references to  Marketplace App ``create_dialog``.
- Form actions on separate route. All of actions that they have ``_dialog`` suffix. E.g.: VM Template ``instantiate_dialog`` will have defined a route similar to ``http://localhost:2616/fireedge/sunstone/vm-template/instantiate``.

All actions are defined in the resource constants, e.g.: for VM Templates are located in ``src/client/constants/vmTemplate.js`` as ``VM_TEMPLATE_ACTIONS``.

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

.. todo:: Labels aren't supported yet.

Information Tabs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The detailed view of a resource is structure in a tabs layout. Tabs are defined in the ``index.js`` of each resource folder ``src/client/components/Tabs/<resource>``. E.g.: VM Templates tabs are located in ``src/client/components/Tabs/VmTemplate/index.js``.

Each entry in the ``info-tabs`` represents a tab and they have two attributes, except the ``info`` tab:

- ``enabled``: defines if the tab is visible.
- ``actions``: contains the allowed actions in the tab. The function to get available actions is located in ``src/client/models/Helper.js``.

The ``info`` tab is special because it contains panels sections. Each panel section is an attributes group that can include actions.

Attributes group can be separated on four panels:

- Information: main attributes to explain the resource.
- Permissions: associated permissions for the owner, the users in her group, and others.
- Ownership: user and group to which it belongs.
- Attributes (not always): these panels are singular because they have information about each hypervisor and monitoring.

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

The resource actions that have ``_dialog`` suffix, need to define their structure in this section.

The first entries in the dialog mean the available steps. Then, within the step are defined the accessible sections.

Each step and section should match the **id** in code and can filter by hypervisor (**only resources with hypervisor**).

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
