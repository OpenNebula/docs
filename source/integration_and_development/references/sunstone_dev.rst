.. _sunstone_dev:

================================================================================
Sunstone Development
================================================================================

In OpenNebula 5.0 the graphical interface code, Sunstone, was redesigned and modularized to improve the code readability and ease the task of adding new components. Now, each component (tab, panel, form...) is defined in a separate module using `requirejs <http://requirejs.org/>`__ and HTML code is now defined in separate files using `Handlebars <http://handlebarsjs.com/>`__ templates. External libraries are handled using `Bower <http://bower.io/>`__, a Javascript package manager. `Zurb Foundation <http://foundation.zurb.com/>`__ is used for the styles and layout of the web and additional CSS styles are added using `SASS <http://sass-lang.com/>`__. `Grunt <http://gruntjs.com/>`__ is used as a tasker to automate the different processes to generate the optimized files.

RequireJS
================================================================================

`requirejs <http://requirejs.org/>`__ allows you to define blocks of functionality in different modules/files and then load and reuse them in other modules.

This is an example of the images-tab files layout:

.. code::

  images-tab.js
  images-tab/
    actions.js
    buttons.js
    datatable.js
    dialogs/
      ...
    panels/
      ...

And how the different modules are used in the images-tab file:

.. code-block:: javascript

  /* images-tab.js content */

  define(function(require) {
    var Buttons = require('./images-tab/buttons');
    var Actions = require('./images-tab/actions');
    var Table = require('./images-tab/datatable');

    var _dialogs = [
      require('./images-tab/dialogs/clone')
    ];

    var _panels = [
      require('./images-tab/panels/info'),
      require('./images-tab/panels/vms'),
      require('./images-tab/panels/snapshots')
    ];
  })

The `optimization tool <http://requirejs.org/docs/optimization.html>`__ provided by `requirejs <http://requirejs.org/>`__ is used to group multiple files into a single minified file (dist/main.js). The options for the optimization are defined in the `Gruntfile.js <https://github.com/OpenNebula/one/blob/master/src/sunstone/public/Gruntfile.js>`__ file using the `r.js plugin <https://github.com/gruntjs/grunt-contrib-requirejs>`__ for `Grunt <http://gruntjs.com/>`__.

Handlebars
================================================================================

`Handlebars <http://handlebarsjs.com/>`__ provides the power necessary to let you build semantic templates and is largely compatible with Mustache templates.

.. code-block:: html

  <div id="comments">
    {{#each comments}}
    <h2><a href="/posts/{{../permalink}}#{{id}}">{{title}}</a></h2>
    <div>{{body}}</div>
    {{/each}}
  </div>

The integration between `Handlebars <http://handlebarsjs.com/>`__ and `requirejs <http://requirejs.org/>`__ is done using the `Handlebars plugin for requirejs <https://github.com/SlexAxton/require-handlebars-plugin>`__, that allows you to use the templates just adding a prefix to the require call

.. code-block:: javascript

  var TemplateHTML = require('hbs!./auth-driver/html');
  return TemplateHTML({
    'dialogId': this.dialogId,
    'userCreationHTML': this.userCreation.html()
  });

Additional helpers can be defined just creating a new file inside the ``app/templates/helpers`` folder. These helpers will be available for any template of the app.

.. code-block:: html+handlebars

  {{#isTabActionEnabled "vms-tab" "VM.attachdisk"}}
  <span class="right">
    <button id="attach_disk" class="button tiny success right radius">
      {{tr "Attach disk"}}
    </button>
  </span>
  {{/isTabActionEnabled}}

SASS & Foundation
================================================================================

The `Zurb Foundation <http://foundation.zurb.com/>`__ framework is used for the layout of the app. It provides a powerful grid system and different nifty widgets such as tabs, sliders, dialogs...

The Zurb Foundation configuration parameters are defined in the ``app/scss/settings.scss`` file and new styles for the app can be added in the ``app/scss/app.scss`` file. After modifying these files, the app.css and app.min.css files must be generated as explained in the following section.


Modifying JS & CSS files
================================================================================

Sunstone can be run in two different environments:

- Production, using the minified css ``css/app.min.css`` and javascript ``dist/main.js`` files.
- Development, using the non minified css ``css/app.css`` and javascript files ``app/main.js``. Note that each file/module will be retrieved in a different HTTP request and the app will take longer to start, therefore it is not recommended for production environments

By default Sunstone is configured to use the minified files, therefore any change in the source code will not apply until the minified files are generated again. But you can set the ``env`` parameter in sunstone-server.conf to ``dev`` to use the non minified files and test your changes.

After testing the changes, the minified files can be generated by running the ``grunt requirejs`` task or the ``scons sunstone=yes`` command as explained in the following section. It is recommended to change again the ``env`` parameter in sunstone-server.conf to ``prod`` and test again the changes.

.. code::

  sunstone/
    public/
      app/                    # JS sources
      bower_components/       # External libraries
      css/                    # CSS optimized files
      dist/                   # JS optimized files
      node_modules/           # Development dependencies
      scss/                   # CSS sources
      bower.json              # List of external libraries
      Gruntfile.js            # Tasks to optimize files
      package.json            # List of dev dependencies
    routes/                   # Custom routes for Sunstone Server

Sunstone Development Dependencies
--------------------------------------------------------------------------------

1. Install nodejs and npm
2. Install the following npm packages:

.. code::

    sudo npm install -g bower
    sudo npm install -g grunt
    sudo npm install -g grunt-cli


3. Move to the Sunstone public folder and run:

.. code::

    npm install     # Dependencies defined in package.json
    bower install   # Dependenciees define in bower.json

.. warning:: In order to run npm and bower commands ``git`` is required


Building minified JS and CSS files
--------------------------------------------------------------------------------

Scons includes an option to build the minified JS and CSS files. Sunstone development dependencies must be installed before running this command.

.. code::

    scons sunstone=yes

Or you can do this process manually by running the following commands:

Run the following command to generate the app.css file in the css folder, including any modification done to the ``app/scss/app.scss`` and ``app/scss/settings.scss`` files:

.. code::

    grunt sass

Run the following command to generate the minified files in the dist folder, including any modification done to the js files and the app.min.css in the css folder, based on the app.css file generated in the previous step:

.. code::

    grunt requirejs

These are the files generated by the ``grunt requirejs`` command:

.. code::

    css
        app.min.css
    dist
        login.js login.js.map main-dist.js main.js.map
    console
        spice.js spice.js.map vnc.js vnc.js.map

.. warning:: If the following error appears when running scons sunstone=yes or any of the grunt commands, you may have skip one step, so move to the Sunstone public folder and run 'bower install'

.. code::

  Running "sass:dist" (sass) task
  >> Error: File to import not found or unreadable: util/util
  ...
  >>         on line 43 of scss/_settings.scss
  >> >> @import 'util/util';
  >>    ^
  Warning:  Use --force to continue.

Install.sh
--------------------------------------------------------------------------------

By default the install.sh script will install all the files, including the non-minified ones. Providing the -p option, only the minified files will be installed.

The script generates a symbolic link **main.js** pointing to ``VAR_LOCATION/sunstone/main.js``. This file has been generated the first time that Sunstone starts, joining the base of Sunstone and the active addons.

Adding Custom Tabs
================================================================================

New tabs can be included following these steps:

* Add your code inside the ``app`` folder. The tab must be provided as a module.
* Include the new tab as a dependency in the ``app/main.js`` file for the ``app`` module.

.. code-block:: javascript

  shim: {
    'app': {
      deps: [
        'tabs/provision-tab',
        'tabs/dashboard-tab',
        'tabs/system-tab',
        ...
        'tabs/mycustom-tab'
      ]
    },

* Include the tab configuration inside the different Sunstone views ``/etc/one/sunstone-views/(admin|user|...).yaml``

.. code-block:: yaml

  enabled_tabs:
    - dashboard-tab
    - system-tab
    ...
    - mycustom-tab
  tabs:
    mycustom-apps-tab:
        panel_tabs:
            myscustom_info_tab: true
        table_columns:
            - 0         # Checkbox
            - 1         # ID
            - 2         # Name
        actions:
            MyCustom.create: true
            MyCustom.refresh: true

* Generate the minified files including the new tab by running the ``grunt requirejs`` command.

You can see an example of external tabs and custom routes for AppMarket in its own `Github repository <https://github.com/OpenNebula/addon-appmarket/tree/master/src/sunstone>`_

Custom Routes for Sunstone Server
================================================================================

:ref:`OpenNebula Sunstone <sunstone>` server plugins consist of a set files defining custom routes. Custom routes will have priority over default routes and allow administrators to integrate their own custom controllers in the Sunstone Server.

Configuring Sunstone Server Plugins
--------------------------------------------------------------------------------

It is very easy to enable custom plugins:

#. Place your custom routes in the ``/usr/lib/one/sunstone/routes`` folder.
#. Modify ``/etc/one/sunstone-server.conf`` to indicate which files should be loaded, as shown in the following example:

.. code-block:: yaml

    # This will load ''custom.rb'' and ''other.rb'' plugin files.
    :routes:
        - custom
        - other

Creating Sunstone Server Plugins
--------------------------------------------------------------------------------

Sunstone server is a `Sinatra <http://www.sinatrarb.com/>`__ application. A server plugin is simply a file containing one or several custom routes, as defined in sinatra applications.

The following example defines 4 custom routes:

.. code-block:: ruby

    get '/myplugin/myresource/:id' do
        resource_id = params[:id]
        # code...
    end
     
    post '/myplugin/myresource' do
        # code
    end
     
    put '/myplugin/myresource/:id' do
        # code
    end
     
    del '/myplugin/myresource/:id' do
        # code
    end

Custom routes take preference over Sunstone server routes. In order to ease debugging and ensure that plugins are not interfering with each other, we recommend however to place the routes in a custom namespace (``myplugin`` in the example).

From the plugin code routes, there is access to all the variables, helpers, etc. which are defined in the main sunstone application code. For example:

.. code-block:: ruby

    opennebula_client = $cloud_auth.client(session[:user])
    sunstone_config = $conf
    logger.info("New route")
    vm3_log = @SunstoneServer.get_vm_log(3)

ESLint
================================================================================

Install ESLint:

.. code::

  sudo npm install -g eslint

After the installation you can initialize ESLint with your own rules or use OpenNebula's configuration:

1. Use the command ``eslint --init`` to create your own `.eslintrc.json` with your personal configuration.

  or

2. Manually create the `.eslintrc.json` and copy/paste the following code:

``one/src/sunstone/public/.eslintrc.json``

.. code::

  {
    "env": {
        "browser": true,
        "es6": true
    },
    "parserOptions": {
        "sourceType": "module"
    },
    "rules": {
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "double"
        ],
        "semi": [
            "error",
            "always"
        ],
        "eqeqeq": 2,
        "no-trailing-spaces": [
            "error"
        ]
        //new rules here
    }
  }

.. note::

  The usage of ESLint is not mandatory but we recomend our contributors to use it, to be sure that the code is standardiced.

More information about `ESlint <https://eslint.org/>`__ project.

.. _autorefresh:

Autorefresh
================================================================================

When Sunstone is working alongside FireEdge, it's constantly receiving changes via OpenNebula's ZeroMQ server, which means no more clicks on the refresh button at the VM instances view and the Hosts view.

It works in an easy way when you open the browser and get logged into Sunstone, after that will create a WebSocket with FireEdge Server, and they will exchange information about VM and Hosts and send it back to the front-end where JavaScript functions update the views when they receive new information.

In order to configure the autorefresh feature you need two things, first FireEdge running and tune the parameters ":private_fireedge_endpoint", ":public_fireedge_endpoint" in :ref:`sunstone-server.conf <sunstone_sunstone_server_conf>`.