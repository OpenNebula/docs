.. _sunstone_server_plugin_guide:

==================================
Custom Routes for Sunstone Server
==================================

:ref:`OpenNebula Sunstone <sunstone>` server plugins consist a set files defining custom routes. Custom routes will have priority over default routes and allow administrators to integrate their own custom controllers in the Sunstone Server.

Configuring Sunstone Server Plugins
===================================

It is very easy to enable custom plugins:

#. Place your custom routes in the ``/usr/lib/one/sunstone/routes`` folder.
#. Modify ``/etc/one/sunstone-server.conf`` to indicate which files should be loaded, as shown in the following example:

.. code::

    # This will load ''custom.rb'' and ''other.rb'' plugin files.
    :routes:
        - custom
        - other

Creating Sunstone Server Plugins
================================

Sunstone server is a `Sinatra <http://www.sinatrarb.com/>`__ application. A server plugin is simply a file containing one or several custom routes, as defined in sinatra applications.

The following example defines 4 custom routes:

.. code::

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

Custom routes take preference over Sunstone server routes. In order to easy debugging and ensure that plugins are not interfering with each others, we recommend however to place the routes in a custom namespace (``myplugin`` in the example).

From the plugin code routes, there is access to all the variables, helpers etc which are defined in the main sunstone application code. For example:

.. code::

    opennebula_client = $cloud_auth.client(session[:user])
    sunstone_config = $conf
    logger.info("New route")
    vm3_log = @SunstoneServer.get_vm_log(3)

