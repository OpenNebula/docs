.. _react_sunstone_dev:

================================================================================
React Sunstone Development (Beta)
================================================================================

OpenNebula FireEdge server provides a **next-generation web-management interface**. It is able to deliver several applications accessible through the following URLs:

- Provision GUI: `http://<OPENNEBULA-FRONTEND>:2616/fireedge/provision`__
- Sunstone GUI: `http://<OPENNEBULA-FRONTEND>:2616/fireedge/sunstone`__

This second Sunstone incarnation is written in `React <https://reactjs.org/>`__ / `Redux <https://redux.js.org/>`__ and `Material-UI <https://mui.com/>`__ is used for the styles and layout of the web.

If you want to do development work over Sunstone, you need to install OpenNebula from source code. For this, you will need :ref:`build dependencies <build_deps>`, `git <https://git-scm.com/>`__, `nodeJS <https://nodejs.org/en/>`__ and `npm <https://docs.npmjs.com/downloading-and-installing-node-js-and-npm>`__.

Once the environment has been prepared, you need to clone `one repository <https://github.com/OpenNebula/one>`__ and follow the steps :ref:`to compile the OpenNebula software <compile>`.

Then move to FireEdge directory (``src/fireedge``) and run:

.. code::

  npm i         # Install dependencies from package.json
  npm run       # List the available scripts
  npm run dev   # Start the development server. By default on http://localhost:2616/fireedge

You can read more about this in the :ref:`FireEdge configuration guide <fireedge_install_configuration>`.

Adding New Tabs
================================================================================

OpenNebula resources are grouped into pools and can be managed from the interface through resource tab (or route) where we can operate over one or more resources, filter by attributes or get detailed information about individual resource.

For this reason, a configuration file has been created for each tab, located in ``etc/sunstone``.

To develop a new tab, it's necessary to understand the structure of the configuration files:

- **Resource**: related information about resources.
- **Actions**: buttons to operate over the resources.
- **Filters**: list of criteria to filter the resources.
- **Information Tabs**: list of tabs to show detailed information.
- **Dialogs**: steps and logic to render the dialog.


Resource
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

To add one, first it's necessary implement the filter in table columns. E.g.:

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
