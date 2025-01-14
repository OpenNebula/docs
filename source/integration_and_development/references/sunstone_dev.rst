.. _sunstone_dev:

================================================================================
Sunstone Development
================================================================================

OpenNebula FireEdge server provides a **next-generation web-management interface**.

- Sunstone GUI: ``<http://<OPENNEBULA-FRONTEND>:2616/fireedge/sunstone>`` (automatically redirected from ``<http://<OPENNEBULA-FRONTEND>:2616/``)

This second Sunstone incarnation is written in `React <https://reactjs.org/>`__ / `Redux <https://redux.js.org/>`__ and `Material-UI <https://mui.com/>`__ is used for the styles and layout of the web.

If you want to do development work over Sunstone, you need to install OpenNebula from source. For this, you will need :ref:`build dependencies <build_deps>`, `git <https://git-scm.com/>`__, `nodeJS v12 <https://nodejs.org/en/blog/release/v12.22.12>`__ and `npm v6 <https://docs.npmjs.com/downloading-and-installing-node-js-and-npm>`__.

Once the environment has been prepared, you need to clone `one repository <https://github.com/OpenNebula/one>`__ and follow the steps :ref:`to compile the OpenNebula software <compile>`.

Then move to FireEdge directory (``src/fireedge``) and run:

.. prompt:: bash $ auto

    $ npm i         # Install dependencies from package.json
    $ npm run       # List the available scripts
    $ npm run build # Build all the modules. 
    $ npm run start # Start the server, by default accessible on http://localhost:2616/fireedge

You can read more about this in the :ref:`FireEdge configuration guide <fireedge_install_configuration>`.

Architecture
================================================================================

In our latest generation of FireEdge Sunstone, we have done a architectural revamp, moving from our previously Monolithic architecture towards a more modern and streamlined Micro-Frontend like architecture.This new architecture is based on the latest Module Federation implementation in Webpack. Which allows us to dynamically, and remotely, load different modules in our baseline Sunstone client.

.. _base_modules:

The Sunstone client has been split up into **8** different base modules:

  * Components.
  * Constants.
  * Containers.
  * Features.
  * Hooks.
  * Models.
  * Providers.
  * Utils.

These modules have been separated in such a way that no hard links exist between them. Any internal cross-module dependencies are handled at runtime, by the module federation through it's shared dependency scope. This ensures modules can be rebuilt and served separately from each other.

.. note:: By default, when a new version is released, all modules are packaged and shipped with the client, and served from the FireEdge server.


.. _remotes_config:

Remotes Configuration
================================================================================

The ``remotes-config.json`` file, typically located at ``/etc/one/fireedge/sunstone/remotes-config.json``, dictates where different modules are loaded from. At a minimum, the eight :ref:`base modules <base_modules>` must be defined in this file, in order for the client to load properly.

The configuration file is structured according to the following schema:

.. code-block:: json

   {
       "<ModuleKey>": {
           "name": "<ModuleName>",
           "entry": "<ModuleEntryURL>"
       },
   }

Where:
  * ``<ModuleKey>`` : A unique identifier for the module. Typically matches ``name`` but serves as the configuration key.
  * ``name`` : The runtime namespace exposed by the module. Must match the ``name`` configured in the remote module's Webpack configuration file.
  * ``entry`` : The URL to the module's ``remoteEntry.js`` file.

Notes:
------
- Each module's ``entry`` must point to a valid and accessible ``remoteEntry.js`` file.
- The ``name`` property must match the runtime namespace as defined in the remote module's Webpack configuration.
- The ``<ModuleKey>`` and ``name`` can be identical but are defined separately to allow flexibility in naming conventions.

.. tip::
   The ``__HOST__`` flag can be used to simplify setups, as this resolves to the current navigator URL in the client. This should be used most of the time when the remote modules are being served directly from the FireEdge server.

This example shows the default configuration of the different modules, when they are being loaded locally from the FireEdge server.

.. code-block:: json

    {
      "UtilsModule": {
        "name": "UtilsModule",
        "entry": "__HOST__/fireedge/modules/UtilsModule/remoteEntry.js"
      },
      "ConstantsModule": {
        "name": "ConstantsModule",
        "entry": "__HOST__/fireedge/modules/ConstantsModule/remoteEntry.js"
      },
      "ContainersModule": {
        "name": "ContainersModule",
        "entry": "__HOST__/fireedge/modules/ContainersModule/remoteEntry.js"
      },
      "ComponentsModule": {
        "name": "ComponentsModule",
        "entry": "__HOST__/fireedge/modules/ComponentsModule/remoteEntry.js"
      },
      "FeaturesModule": {
        "name": "FeaturesModule",
        "entry": "__HOST__/fireedge/modules/FeaturesModule/remoteEntry.js"
      },
      "ProvidersModule": {
        "name": "ProvidersModule",
        "entry": "__HOST__/fireedge/modules/ProvidersModule/remoteEntry.js"
      },
      "ModelsModule": {
        "name": "ModelsModule",
        "entry": "__HOST__/fireedge/modules/ModelsModule/remoteEntry.js"
      },
      "HooksModule": {
        "name": "HooksModule",
        "entry": "__HOST__/fireedge/modules/HooksModule/remoteEntry.js"
      }
    }

.. hint:: Loading modules over HTTPS is fully supported and requires no extra setting up in the client.


A module fails to load
--------------------------------------------------------------------------------

In the case that a module fails to load, either due to a failed network request or due to a error in the code itself, the `fallback editor` will be employed. The client checks all modules when loading to make sure that they are properly initialized, in order to try and prevent and narrow down any fatal problems as early on as possible. The fallback editor allows the user to try and repair any misconfigured remotes, directly in the browser. 

The server passes the ``remotes-config.json`` file to the client through the `Window Interface <https://developer.mozilla.org/en-US/docs/Web/API/Window>`__, accessible through ``window.__REMOTES_MODULE_CONFIG__`` from the browser console. This configuration gets potentially modified by the `fallback editor` and cached using the browsers `localStorage API <https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage>`__. This cache is implemented in order for the client to be able to use a temporary configuration that persists across reloads, in order to mitigate potential lockouts from the user interface.

|image_fallback_editor|

Inside the fallback editor, you will have access to a simple interface, consisting of a text area for editing the configured remotes (changes do not affect any file on-disk), and three different buttons.

Where:
  * ``Reset`` : Resets the entire configuration to the minimal eight :ref:`base modules <base_modules>`.
  * ``Clear fallback configuration`` : Clears the fallback flag, discarding any modifications made to the ``remotes-config.json`` file loaded from the server & attempts to re-use it.
  * ``Continue`` : Attempts to continue loading the currently defined configuration.


Tab Manifest
================================================================================

The ``tab-manifest.json`` file, typically located at ``/etc/one/fireedge/sunstone/tab-manifest.json``, controls the loading of components and is the key to dynamic tab management. This file allows you to dynamically specify new endpoints and how different modules are loaded at those endpoints.

The configuration file is structured according to the following schema:

.. code-block:: json

  {
      "title": "<TabTitle>",
      "path": "<TabPath>",
      "sidebar": "<ShowInSidebar>",
      "icon": "<IconName>",
      "moduleId": "<ModuleIdentifier>",
      "Component": "<ComponentName>"
  }

Where:
  * ``title``: The display name of the tab as shown in the UI.
  * ``path``: The URL path that maps to this tab. It must be unique across all tabs.
  * ``sidebar``:  A boolean (`true` or `false`) Indicates whether the tab should appear in the sidebar navigation.
  * ``icon``: The name of the icon to represent the tab visually. Must correspond to a valid icon identifier from the `iconoir-react library <https://www.npmjs.com/package/iconoir-react>`__.
  * ``moduleId``: The identifier for the remote module. It must match the `name` field in the corresponding module's entry in the ``remotes-config.json``.
  * ``Component``: The exported name of the component that renders the tab's content.

.. note:: The client searches for the ``Component`` from the base of the ``<ModuleIdentifier>`` and does not support nested imports. All modules should expose their exports through a global barrel file, see :ref:`Module webpack configuration <exporting_remote_modules>` for more details.


Adding a new tab
--------------------------------------------------------------------------------

In order to develop a new tab, you need to make sure it has the correct webpack configuration & has been added to the ``tab-manifest.json`` & ``remotes-config.json`` files. In this example we will use the `OpenNebula ONE repo <https://github.com/OpenNebula/one>`__ to create a new module and add it to the Sunstone client. 


1. Begin by cloning the `one repo <https://github.com/OpenNebula/one>`__.

   .. prompt:: bash

      git clone git@github.com:OpenNebula/one.git
      # Cd into the fireedge directory
      cd ./one/src/fireedge

2. Build the :ref:`base modules <base_modules>` & start the fireedge server

  .. prompt:: bash $ auto

      $ npm i         # Install dependencies from package.json
      $ npm run       # List the available scripts
      $ npm run build # Build all the modules. 
      $ npm run start # Start the server, by default accessible on http://localhost:2616/fireedge

  Now lets create a new module called ``CustomContainers``, based off the original ``ContainersModule``. 

3. We will begin by creating a new ``src/modules/customContainers`` folder

  .. prompt:: bash

      mkdir -p  src/modules/customContainers

4. Then we'll copy the ``/Users`` directory & webpack configuration file from the original ``ContainersModule``

  .. prompt:: bash $ auto
      
      # Copying the Users directory
      cp -r src/modules/containers/Users src/modoules/customContainers 

      # Copying containers webpack config for reference
      cp src/modules/containers/webpack.config.prod.containers.js src/modules/customContainers/webpack.config.prod.customcontainers.js

      # We'll also create a index.js file which will expose our new component
      touch src/modules/customContainers/index.js 

5. Now we need to modify the ``webpack.config.prod.customcontainers.js`` file

  .. code-block:: javascript

      // We will update the module name at the top to `CustomContainers`
      const moduleName = 'ContainersModule'

      // Make sure your module can import the shared dependency script!
      const sharedDeps = require('../sharedDeps')

  .. note::
     We can now save this file as this is really the only modification we need to make, assuming we don't want to add any new dependencies to the shared context scope, which is defined in ``src/modules/sharedDeps.js`` if you want to have a look.

     The ``sharedDeps.js`` file imports the ``package.json`` file in order to parse dependency versions, but these can be overwritten and modified as you see fit.

     .. code-block:: javascript

        const deps = require('../../package.json').dependencies

        const sharedDeps = ({ eager = false } = {}) => ({
          react: {
            singleton: true,
            eager,
            requiredVersion: deps.react,
          },
          // Add other dependencies here as needed
        })

        module.exports = sharedDeps
        
6. Moving onto the actual code now, we'll move into the new ``customContainers`` directory and modify the ``Users.js`` file.

   For this example, we'll modify the normal Users component to also display groups in a column like layout.

   .. code-block:: javascript

      import { Chip, Stack, Typography, Grid } from '@mui/material' // Adding the Grid import

      import {
        Tr,
        MultipleTags,
        ResourcesBackButton,
        GroupsTable, // Adding the GroupsTable import
        UsersTable,
        UserTabs,
        SubmitButton,
        TranslateProvider,
      } from '@ComponentsModule'


  .. note::  Notice how we import from the ``@ComponentsModule`` instead of using a relative path to the ``src/modules/components`` directory. This is because the import goes through the module federation and is resolved dynamically at runtime, as opposed to being bundled within our new module directly. 

.. _cross_module_imports:

.. important:: Cross-module imports should *NEVER* be done relative to one another, only inside subdirectories of the module itself should you use relative import paths like ``import ... from @modules/<moduleName>``. Any cross-module dependencies should be resolved through ``@<ModuleName>``.

7. Now lets rename our component to "UsersAndGroups" and modify the code so that we return a 2 column grid with both our tables inside

  .. code-block:: jsx

      export function UsersAndGroups() {
        const [selectedRows, setSelectedRows] = useState(() => [])
        const actions = UsersTable.Actions()
        const { zone } = useGeneral()

        return (
          <TranslateProvider>
            <ResourcesBackButton
              selectedRows={selectedRows}
              setSelectedRows={setSelectedRows}
              useUpdateMutation={UserAPI.useUpdateUserMutation}
              zone={zone}
              actions={actions}
              table={(props) => (
                <Grid container spacing={2}>
                  <Grid item sm={6}>
                    <UsersTable.Table
                      onSelectedRowsChange={props.setSelectedRows}
                      globalActions={props.actions}
                      onRowClick={props.resourcesBackButtonClick}
                      useUpdateMutation={props.useUpdateMutation}
                      zoneId={props.zone}
                      initialState={{
                        selectedRowIds: props.selectedRowsTable,
                      }}
                    />
                  </Grid>

                  <Grid item sm={6}>
                    <GroupsTable.Table
                      onSelectedRowsChange={props.setSelectedRows}
                      globalActions={props.actions}
                      onRowClick={props.resourcesBackButtonClick}
                      useUpdateMutation={props.useUpdateMutation}
                      zoneId={props.zone}
                      initialState={{
                        selectedRowIds: props.selectedRowsTable,
                      }}
                    />
                  </Grid>
                </Grid>
              )}
              simpleGroupsTags={(props) => (
                <GroupedTags
                  tags={props.selectedRows}
                  handleElement={props.handleElement}
                  onDelete={props.handleUnselectRow}
                />
              )}
              info={(props) => {
                const propsInfo = {
                  user: props?.selectedRows?.[0]?.original,
                  selectedRows: props?.selectedRows,
                }
                props?.gotoPage && (propsInfo.gotoPage = props.gotoPage)
                props?.unselect && (propsInfo.unselect = props.unselect)

                return <InfoTabs {...propsInfo} />
              }}
            />
          </TranslateProvider>
        )
      }

8. Now that we have saved our modified ``Users.js`` file, we need to make sure we are exporting it properly inside our ``index.js`` file (``src/modules/customContainers/index.js``)

  .. code-block:: javascript

    export * from '@modules/customContainers/Users'

  Also update the exports inside the ``src/modules/customContainers/Users/index.js`` file, as it will point to the wrong directory otherwise

  .. code-block:: javascript

    export * from '@modules/customContainers/Users/Users'

  .. note:: Here the ``@modules`` name is an alias we use in our webpack configuration, which gets resolved to the ``src/modules`` directory when building. You can examine this more closely inside the ``webpack.config.prod.customcontainer.js`` file. In this case, exporting relative to our parent directory is fine as we are not doing any cross-module referencing.

9. Time to build our module (for convenience sake, we will save the build command inside our ``package.json`` file)

  .. code-block:: javascript

      "scripts": {
        "build:ctm": "rimraf dist/modules/ContainersModule && BUILD_TARGET=remote webpack --config ./src/modules/containers/webpack.config.prod.containers.js",

        // Adding it under the alias "build:ccm"
        "build:ccm": "rimraf dist/modules/CustomContainersModule && BUILD_TARGET=remote webpack --config ./src/modules/customContainers/webpack.config.prod.customContainers.js",
        // More module build commands
        }

  Running the build command

  .. prompt:: bash
      
      npm run build:ccm # Building our customContainersModule
      > FireEdge@1.0.0 build:ccm
      > rimraf dist/modules/CustomContainersModule && BUILD_TARGET=remote webpack --config ./src/modules/customContainers/webpack.config.prod.customContainers.js

      assets by info 717 KiB [immutable]
        assets by chunk 647 KiB (id hint: vendors)
          asset 659aeeaf6d97dbdbd377.734.js 419 KiB [emitted] [immutable] [minimized] [big] (id hint: vendors) 1 related asset
          asset d29140b066ef871bf666.935.js 121 KiB [emitted] [immutable] [minimized] (id hint: vendors) 1 related asset
          asset 14fdb556980b10379dbe.521.js 55.1 KiB [emitted] [immutable] [minimized] (id hint: vendors) 1 related asset
          asset 4506de3a3b041a88614a.977.js 15.3 KiB [emitted] [immutable] [minimized] (id hint: vendors) 1 related asset
          asset 8e4788e4aa133cc51773.350.js 13.3 KiB [emitted] [immutable] [minimized] (id hint: vendors) 1 related asset
          asset d81938165469db579b06.586.js 12.9 KiB [emitted] [immutable] [minimized] (id hint: vendors) 1 related asset
          asset 932b89d7c980f063ba5f.657.js 10.3 KiB [emitted] [immutable] [minimized] (id hint: vendors) 1 related asset
        14 assets
      asset main.bundle.js 20.4 KiB [emitted] [minimized] (name: main) 1 related asset
      asset remoteEntry.js 11.3 KiB [emitted] [minimized] (name: CustomContainersModule) 1 related asset
      orphan modules 1.69 MiB (javascript) 42 bytes (consume-shared) [orphan] 801 modules
      runtime modules 48.3 KiB 26 modules
      built modules 1.85 MiB (javascript) 564 bytes (share-init) 504 bytes (consume-shared) 18 bytes (remote) [built]
        javascript modules 1.85 MiB 49 modules
        provide-module modules 546 bytes
          modules by path provide shared module (default) prop-types@15.8.1 = ./node_modules/@mui/ 126 bytes 3 modules
          modules by path provide shared module (default) @emotion/ 84 bytes 2 modules
        consume-shared-module modules 504 bytes
          modules by path consume shared module (default) prop-types@=15.7.2 (singleton) (fallback: ./node_modules/ 126 bytes 3 modules
          modules by path consume shared module (default) @emotion/ 84 bytes 2 modules
        remote-module modules 18 bytes (remote) 18 bytes (share-init)
          remote @FeaturesModule 6 bytes (remote) 6 bytes (share-init) [built] [code generated]
          remote @ComponentsModule 6 bytes (remote) 6 bytes (share-init) [built] [code generated]
          remote @ConstantsModule 6 bytes (remote) 6 bytes (share-init) [built] [code generated]

      WARNING in asset size limit: The following asset(s) exceed the recommended size limit (244 KiB).
      This can impact web performance.
      Assets:
        659aeeaf6d97dbdbd377.734.js (419 KiB)

      webpack 5.64.4 compiled with 1 warning in 2911 ms

10. Now we need to copy our new module to the ``/usr/lib/one/fireedge/dist/modules`` directory, as we will be serving it locally


  .. prompt:: bash

      cp -r dist/modules/customContainers /usr/lib/one/fireedge/dist/modules

  This ensures the fireedge server has access to and can serve the module for the client

11. Now we need to add our module to the ``remotes-config.json`` file

    .. code-block:: json
        
      {
        "ContainersModule": {
          "name": "ContainersModule",
          "entry": "__HOST__/fireedge/modules/ContainersModule/remoteEntry.js"
        },
        "CustomContainersModule": {
          "name": "CustomContainersModule",
          "entry": "__HOST__/fireedge/modules/CustomContainersModule/remoteEntry.js"
        }
      }

  Now the client will fetch and load the ``CustomContainersModule``

12. Then we need to update out ``tab-manifest.json`` file with our new ``UsersAndGroups`` component

    .. code-block:: json

      {
          "title": "System",
          "icon": "Home",
          "routes": [
              {
                  "title": "Create User",
                  "path": "/user/create",
                  "Component": "CreateUser"
              },
              {
                  "title": "Users and Groups",
                  "path": "/usersgroups",
                  "sidebar": true,
                  "icon": "User",
                  "moduleId": "CustomContainersModule", // We explicitly define which module to load the component from
                  "Component": "UsersAndGroups"
              },
              // Other tabs and definitions
           ]
      }


 .. important:: Make sure to add the ``moduleId`` pointing to the "CustomContainersModule", as otherwise the client will attempt loading the Component from the default ``ContainersModule``

13. Finally we need to add a new :ref:`view configuration <fireedge_sunstone_views>`, allowing us to access the `/usersgroups` endpoint

    We will do this for the oneadmin user only

    .. prompt:: bash
        
        cp /etc/one/fireedge/sunstone/admin/user-tab.yaml /etc/one/fireedge/sunstone/admin/usersgroups-tab.yaml

    
    And then we update the resource name inside the new ``usersandgroups-tab.yaml`` view file to match the path of our component

    .. code-block:: yaml

      resource_name: "USERSGROUPS"


Now open up your Sunstone web UI (should be reachable at ``http://localhost:2616/fireedge``) and you should have a new tab under the "System" category, named "Users and Groups", which displays both the users and groups table next to each other!

|users_and_groups_tab|

Note that all of this was done with the FireEdge Sunstone server up and running in production mode, as the new modularized architecture does not require us to rebuild the client nor the server in order to bring in new changes.

Module Webpack Configuration
================================================================================

When defining a new module, you need to make sure that it has a correctly defined webpack configuration file. This configuration file can be tweaked as you see fit, but should include a few key options in order to be compatible with the Sunstone client.

.. _default_module_webpack:

This example shows the default webpack configuration file for a module.

.. code-block:: javascript

    const moduleName = '<ModuleName>' // This is how the module will be referenced
    const path = require('path')
    const { ModuleFederationPlugin } = require('webpack').container
    const sharedDeps = require('../sharedDeps') // Dependencies shared between modules
    const TerserPlugin = require('terser-webpack-plugin')
    const ExternalRemotesPlugin = require('external-remotes-plugin')
    const ONE_LOCATION = process.env.ONE_LOCATION
    const ETC_LOCATION = ONE_LOCATION ? `${ONE_LOCATION}/etc` : '/etc'

    // The path to the remotes-config.json file, necessary in order to resolve cross-module dependencies when building.
    const remotesConfigPath =
      process.env.NODE_ENV === 'production'
        ? `${ETC_LOCATION}/one/fireedge/sunstone/remotes-config.json`
        : path.resolve(
            __dirname,
            '..',
            '..',
            '..',
            'etc',
            'sunstone',
            'remotes-config.json'
          )

    const remotesConfig = require(remotesConfigPath)

    const configuredRemotes = Object.entries(remotesConfig)
      .filter(([_, { name }]) => name !== moduleName)
      .reduce((acc, [module, { name }]) => {
        acc[
          `@${module}`
        ] = `${name}@[window.__REMOTES_MODULE_CONFIG__.${module}.entry]`

        return acc
      }, {})

    module.exports = {
      mode: 'production',
      entry: path.resolve(__dirname, 'index.js'),
      output: {
        path: path.resolve(__dirname, '../../../', 'dist', 'modules', moduleName),
        filename: '[name].bundle.js',
        chunkFilename: '[contenthash].[id].js',
        uniqueName: moduleName,
        publicPath: 'auto',
      },
      plugins: [
        new ModuleFederationPlugin({
          name: moduleName,
          filename: 'remoteEntry.js',
          exposes: {
            '.': path.resolve(__dirname, 'index.js'),
          },
          remotes: configuredRemotes,
          shared: sharedDeps({ eager: false }),
        }),
        new ExternalRemotesPlugin(),
      ],

      optimization: {
        minimizer: [new TerserPlugin({ extractComments: false })],
        moduleIds: 'deterministic',
        chunkIds: 'deterministic',
      },
      resolve: {
        alias: {
          '@modules': path.resolve(__dirname, '../'),
        },
      },
      devtool: 'source-map',
      stats: {
        errorDetails: true,
        warnings: true,
      },
      experiments: {
        topLevelAwait: true,
      },
      module: {
        rules: [
          {
            test: /\.js$/,
            use: 'babel-loader',
            include: path.resolve(__dirname, '../../'),
          },
          {
            test: /\.(png|jpe?g|gif)$/i,
            use: [
              {
                loader: 'file-loader',
                options: {
                  name: '[path][name].[ext]',
                  outputPath: 'assets/images/',
                },
              },
            ],
          },
        ],
      },
    }

When creating a new module, you can use :ref:`this <default_module_webpack>` template as a base. Just make sure you update the ``<ModuleName>`` to match the name of your module.

.. _resolving_remote_modules:

Resolving other modules
--------------------------------------------------------------------------------

Make sure you have added all your modules to the correct :ref:`remotes-config.json <remotes_config>` file, as this file will be imported during builds to help resolve remote module imports. 

.. code-block:: javascript

    // The path to the remotes-config.json file, necessary in order to resolve cross-module dependencies when building.
    const remotesConfigPath =
      process.env.NODE_ENV === 'production'
        ? `${ETC_LOCATION}/one/fireedge/sunstone/remotes-config.json`
        : path.resolve(
            __dirname,
            '..',
            '..',
            '..',
            'etc',
            'sunstone',
            'remotes-config.json'
          )

    const remotesConfig = require(remotesConfigPath)

    const configuredRemotes = Object.entries(remotesConfig)
      .filter(([_, { name }]) => name !== moduleName)
      .reduce((acc, [module, { name }]) => {
        acc[
          `@${module}`
        ] = `${name}@[window.__REMOTES_MODULE_CONFIG__.${module}.entry]`

        return acc
      }, {})

Shared module dependencies
--------------------------------------------------------------------------------

When building your modules you should review the shared dependency configuration, which by default is defined in the ``src/modules/sharedDeps.js`` file. This script imports the ``package.json`` file for resolving different dependency versions and should be sufficient in most cases.

.. note:: Not all dependencies are shared between modules. For more information on which dependencies should be shared and how to configure them, you can refer to the official `Module Federation documentation <https://module-federation.io/configure/shared.html>`_.

Importing from other modules
--------------------------------------------------------------------------------

In order to import correctly between modules, you should not use relative import paths between them, even if this may seem convenient at first. As this creates a hard-link between the modules, and webpack will bundle parts of them together. Which in turn means that the modules cannot be rebuilt independently of one another. Instead, you should use the following syntax to import from another module:

``import ... from @<ModuleName>``

Which should match the key property in the ``configuredRemotes`` object, as mentioned previously in the :ref:`resolving other modules <resolving_remote_modules>` section.

.. _exporting_remote_modules:

Exporting from a module
--------------------------------------------------------------------------------

All remote module exports should be done using a global barrel file. This means that all nested exports should be accessible from the top-level index file of the module. 

.. important:: Default exports should not be used. You should use named exports only, when exposing imports according to the default webpack configuration used :ref:`here <default_module_webpack>`.

An example of the barrel file from the ``ContainersModule``

.. code-block:: javascript

    export * from '@modules/containers/ACLs'
    export * from '@modules/containers/BackupJobs'
    export * from '@modules/containers/Backups'
    export * from '@modules/containers/Clusters'
    export * from '@modules/containers/Dashboard'
    export * from '@modules/containers/Datastores'
    export * from '@modules/containers/Files'
    export * from '@modules/containers/Groups'
    export * from '@modules/containers/Guacamole'
    export * from '@modules/containers/Hosts'
    export * from '@modules/containers/Images'
    export * from '@modules/containers/Login'
    export * from '@modules/containers/MarketplaceApps'
    export * from '@modules/containers/Marketplaces'
    export * from '@modules/containers/Providers'
    export * from '@modules/containers/Provisions'
    export * from '@modules/containers/SecurityGroups'
    export * from '@modules/containers/ServiceTemplates'
    export * from '@modules/containers/Services'
    export * from '@modules/containers/Settings'
    export * from '@modules/containers/Support'
    export * from '@modules/containers/TestApi'
    export * from '@modules/containers/TestForm'
    export * from '@modules/containers/Users'
    export * from '@modules/containers/VDCs'
    export * from '@modules/containers/VnTemplates'
    export * from '@modules/containers/VirtualMachines'
    export * from '@modules/containers/VirtualNetworks'
    export * from '@modules/containers/VirtualRouterTemplates'
    export * from '@modules/containers/VirtualRouters'
    export * from '@modules/containers/VmGroups'
    export * from '@modules/containers/VmTemplates'
    export * from '@modules/containers/WebMKS'
    export * from '@modules/containers/Zones'

These exports are then being exposed directly from the module namespace. See the `exposes` section under the :ref:`default module webpack <default_module_webpack>` configuration. 


FireEdge API
================================================================================

OpenNebula FireEdge API is a RESTful service to communicate with other OpenNebula services.

Among others, it includes the OpenNebula Cloud API Specification for JS. It been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers to return the data in JSON formats. This means that you should be familiar with the XML-RPC API and the JSON formats returned by the OpenNebula core.

Authentication & Authorization
--------------------------------------------------------------------------------

User authentication is done via XMLRPC using the OpenNebula authorization module. If the username and password matches with the serveradmin data, the user's request will be granted, the session data will be saved in a global variable (cache-nodejs), and a JSON Web Token (JWT) will be generated that must be sent in the authorization header of the HTTP request.

.. prompt:: bash $ auto

    $ curl -X POST -H "Content-Type: application/json" \
    $ -d '{"user": "username", "token": "password"}' \
    $ http://fireedge.server/fireedge/api/auth

.. note:: The JWT lifetime can be configured in the fireedge_server.conf configuration file.

Methods
--------------------------------------------------------------------------------

Auth
--------------------------------------------------------------------------------

+--------------------------------------------------------------------------------
| Method       | URL                                  | Meaning / Entity Body                                  |
+==============+======================================+========================================================+
| **POST**     | ``/fireedge/api/auth``               | Authenticate user by credentials.                      |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/tfa``                | Set the Two factor authentication (2FA).               |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/tfa``                | **Show** the QR code resource.                         |
+--------------------------------------------------------------------------------
| **DELETE**   | ``/fireedge/api/tfa``                | **Delete** the QR code resource.                       |
+--------------------------------------------------------------------------------

File
--------------------------------------------------------------------------------

+--------------------------------------------------------------------------------
| Method       | URL                                  | Meaning / Entity Body                                  |
+==============+======================================+========================================================+
| **GET**      | ``/fireedge/api/files``              | **List** the files collection.                         |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/files/<id>``         | **Show** the file identified by <id>.                  |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/files``              | **Create** a new file.                                 |
+--------------------------------------------------------------------------------
| **PUT**      | ``/fireedge/api/files/<id>``         | **Update** the file identified by <id>.                |
+--------------------------------------------------------------------------------
| **DELETE**   | ``/fireedge/api/files/<id>``         | **Delete** the file identified by <id>.                |
+--------------------------------------------------------------------------------

OneFlow
--------------------------------------------------------------------------------

+--------------------------------------------------------------------------------
| Method       | URL                                                           | Meaning / Entity Body                                                  |
+==============+===============================================================+========================================================================+
| **GET**      | ``/fireedge/api/service_template``                            | **List** the service template collection.                              |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/service_template/<id>``                       | **Show** the service template identified by <id>.                      |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/service_template``                            | **Create** a new service template.                                     |
+--------------------------------------------------------------------------------
| **PUT**      | ``/fireedge/api/service_template/<id>``                       | **Update** the service template identified by <id>.                    |
+--------------------------------------------------------------------------------
| **DELETE**   | ``/fireedge/api/service_template/<id>``                       | **Delete** the service template identified by <id>.                    |
+--------------------------------------------------------------------------------

+--------------------------------------------------------------------------------
| Method       | URL                                                           | Meaning / Entity Body                                                                               |
+==============+===============================================================+=====================================================================================================+
| **GET**      | ``/fireedge/api/service``                                     | **List** the service collection.                                                                    |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/service/<id>``                                | **Show** the service identified by <id>.                                                            |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/service``                                     | **Create** a new service.                                                                           |
+--------------------------------------------------------------------------------
| **PUT**      | ``/fireedge/api/service/<id>``                                | **Update** the service identified by <id>.                                                          |
+--------------------------------------------------------------------------------
| **DELETE**   | ``/fireedge/api/service/<id>``                                | **Delete** the service identified by <id>.                                                          |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/service/action/<id>``                         | **Perform** an action on the service identified by <id>.                                            |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/service/scale/<id>``                          | **Perform** an scale on the service identified by <id>.                                             |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/service/role_action/<role_id>/<id>``          | **Perform** an action on all the VMs belonging to the role to the service identified both by <id>.  |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/service/sched_action/<id>``                   | **Create** a new schedule action on the service identified by <id>.                                 |
+--------------------------------------------------------------------------------
| **PUT**      | ``/fireedge/api/service/sched_action/<sched_action_id>/<id>`` | **Update** the schedule action on the service identified both by <id>.                              |
+--------------------------------------------------------------------------------
| **DELETE**   | ``/fireedge/api/service/sched_action/<sched_action_id>/<id>`` | **Delete** the schedule action on the service identified both by <id>.                              |
+--------------------------------------------------------------------------------

Sunstone
--------------------------------------------------------------------------------

+--------------------------------------------------------------------------------
| Method       | URL                                   | Meaning / Entity Body                                   |
+==============+=======================================+=========================================================+
| **GET**      | ``/fireedge/api/sunstone/views``      | **Get** the Sunstone view.                              |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/sunstone/config``     | **Get** the Sunstone config.                            |
+--------------------------------------------------------------------------------


Zendesk
--------------------------------------------------------------------------------

+--------------------------------------------------------------------------------
| Method       | URL                                         | Meaning / Entity Body                              |
+==============+=============================================+====================================================+
| **POST**     | ``/fireedge/api/zendesk/login``             | Authenticate user by credentials.                  |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/zendesk``                   | **List** the tickets collection.                   |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/zendesk/<id>``              | **Show** the ticket identified by <id>.            |
+--------------------------------------------------------------------------------
| **GET**      | ``/fireedge/api/zendesk/comments/<id>``     | **List** the ticket's comments identified by <id>. |
+--------------------------------------------------------------------------------
| **POST**     | ``/fireedge/api/zendesk``                   | **Create** a new ticket.                           |
+--------------------------------------------------------------------------------
| **PUT**      | ``/fireedge/api/zendesk/<id>``              | **Update** the ticket identified by <id>.          |
+--------------------------------------------------------------------------------


Frontend Architecture
================================================================================

An important part of managing OpenNebula through an interface is the use of forms and lists of resources. For this reason, we decided to extract some of this logic in configuration files.

Unlike in the legacy Ruby-based Sunstone, it's the behavior of requests in parallel which allows the use of the interface with greater flexibility and fluidity.

Queries to get the pool resource from OpenNebula are greatly optimized, which ensures a swift response of the interface. If a large amount of certain types of resources are present (for example VMs or Hosts), a performance strategy that consists of making queries with intervals is implemented. Thus, the representation of the first interval list of resources is faster and the rest of the queries are kept in the background.

Sunstone Configuration Files
================================================================================

Through the configuration files we can define view types and assign them to different groups. Then, we differentiate between the master and view files.

Master File
--------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------

Using the view files as a starting point, the interface generates the available routes and defines them in a menu.

Through each tab in the sidebar you can control and manage OpenNebula resources. All tabs should have a folder in the containers directory ``src/client/containers`` and enabled the route in ``src/client/apps/sunstone/routesOne.js``.

+--------------------------------------------------------------------------------
|               Property             |                                     Description                                                  |
+====================================+==================================================================================================+
| ``resource_name``                  | Reference to ``RESOURCE_NAMES`` in ``src/client/constants/index.js``                             |
+--------------------------------------------------------------------------------

.. note::

  It's important that ``resource_name`` matches the ``RESOURCE_NAMES`` constant, because the constants are used to define the routes in ``src/client/apps/sunstone/routesOne.js``.


Actions
--------------------------------------------------------------------------------

List of actions to operate over the resources: ``refresh``, ``chown``, ``chgrp``, ``lock``, ``unlock``, etc.

There are three action types:

- Form modal actions. These actions do not have a ``_dialog`` suffix.
- Actions referenced in other files. For example, the VM Template ``create_app_dialog`` references the Marketplace App ``create_dialog``.
- Form actions on separate route. These actions have a ``_dialog`` suffix. For example, the VM Template ``instantiate_dialog`` will have a route defined similar to ``http://localhost:2616/fireedge/sunstone/vm-template/instantiate``.

All actions are defined in the resource constants. For example, the VM Template's are located in ``src/client/constants/vmTemplate.js`` as ``VM_TEMPLATE_ACTIONS``.

Filter
--------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------

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
          - lxc

Dialogs
--------------------------------------------------------------------------------

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
    information: true
    ownership: true
    capacity: true
    vm_group: true
    network: true
    storage: true
    placement: true
    sched_action: true
    booting: true
    backup: true
  create_dialog:
    ownership: true
    capacity: true
    showback: true
    vm_group: true
    network: true
    storage: true
    placement: true
    pci: true
    input_output: true
    sched_action: true
    context: true
    booting: true
    numa:
      enabled: true
      not_on:
        - lxc
    backup: true



SSO (Single sign-on)
--------------------------------------------------------------------------------
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



.. |image_fallback_editor| image:: /images/fireedge_fallback_editor.png
.. |users_and_groups_tab| image:: /images/users_and_groups_tab.png
