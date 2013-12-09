==========================================
Configuring Sunstone for Large Deployments
==========================================

Low to medium enterprise clouds will typically deploy Sunstone in a
single machine a long with the OpenNebula daemons. However this simple
deployment can be improved by:

-  Isolating the access from Web clients to the Sunstone server. This
can be achieved by deploying the Sunstone server in a separated
machine.
-  Improve the scalability of the server for large user pools. Usually
deploying sunstone in a separate application container in one or more
hosts.

Deploying Sunstone in a Different Machine
=========================================

By default the Sunstone server is configured to run in the frontend, but
you are able to install the Sunstone server in a machine different from
the frontend.

-  You will need to install only the sunstone server packages in the
machine that will be running the server. If you are installing from
source use the -s option for the ``install.sh`` script.

-  Make sure ``:one_xmlprc:`` variable in ``sunstone-server.conf``
points to the right place where OpenNebula frontend is running, You
can also leave it undefined and export ``ONE_XMLRPC`` environment
variable.

-  Provide the serveradmin credentials in the following file
``/var/lib/one/.one/sunstone_auth``. If you changed the serveradmin
password please check the following
`section </./cloud_auth#configure>`__

.. code::

$ cat /var/lib/one/.one/sunstone_auth
serveradmin:1612b78a4843647a4b541346f678f9e1b43bbcf9

Using this setup the VirtualMachine logs will not be available. If you
need to retrieve this information you must deploy the server in the
frontend

Running Sunstone Inside Another Webserver
=========================================

Self contained deployment of Sunstone (using ``sunstone-server`` script)
is ok for small to medium installations. This is no longer true when the
service has lots of concurrent users and the number of objects in the
system is high (for example, more than 2000 simultaneous virtual
machines).

Sunstone server was modified to be able to run as a ``rack`` server.
This makes it suitable to run in any web server that supports this
protocol. In ruby world this is the standard supported by most web
servers. We now can select web servers that support spawning multiple
processes like ``unicorn`` or embedding the service inside ``apache`` or
``nginx`` web servers using the Passenger module. Another benefit will
be the ability to run Sunstone in several servers and balance the load
between them.

Configuring memcached
---------------------

When using one on these web servers the use of a ``memcached`` server is
necessary. Sunstone needs to store user sessions so it does not ask for
user/password for every action. By default Sunstone is configured to use
memory sessions, that is, the sessions are stored in the process memory.
Thin and webrick web servers do not spawn new processes but new threads
an all of them have access to that session pool. When using more than
one process to server Sunstone there must be a service that stores this
information and can be accessed by all the processes. In this case we
will need to install ``memcached``. It comes with most distributions and
its default configuration should be ok. We will also need to install
ruby libraries to be able to access it. The rubygem library needed is
``memcache-client``. If there is no package for your distribution with
this ruby library you can install it using rubygems:

.. code::

$ sudo gem install memcache-client

Then you will have to change in sunstone configuration
(``/etc/one/sunstone-server.conf``) the value of ``:sessions`` to
``memcache``.

If you want to use novcn you need to have it running. You can start this
service with the command:

.. code::

$ novnc-server start

Another thing you have to take into account is the user on which the
server will run. The installation sets the permissions for ``oneadmin``
user and group and files like the Sunstone configuration and credentials
can not be read by other users. Apache usually runs as ``www-data`` user
and group so to let the server run as this user the group of these files
must be changed, for example:

.. code::

$ chgrp www-data /etc/one/sunstone-server.conf
$ chgrp www-data /etc/one/sunstone-plugins.yaml
$ chgrp www-data /var/lib/one/.one/sunstone_auth
$ chmod a+x /var/lib/one
$ chmod a+x /var/lib/one/.one
$ chgrp www-data /var/log/one/sunstone*
$ chmod g+w /var/log/one/sunstone*

We advise to use Passenger in your installation but we will show you how
to run Sunstone inside unicorn web server as an example.

For more information on web servers that support rack and more
information about it you can check the `rack
documentation <http://rack.rubyforge.org/doc/>`__ page. You can
alternatively check a `list of ruby web
servers <https://www.ruby-toolbox.com/categories/web_servers>`__.

Running Sunstone with Unicorn
-----------------------------

To get more information about this web server you can go to its `web
page <http://unicorn.bogomips.org/>`__. It is a multi process web server
that spawns new processes to deal with requests.

The installation is done using rubygems (or with your package manager if
it is available):

.. code::

$ sudo gem install unicorn

In the directory where Sunstone files reside (``/usr/lib/one/sunstone``
or ``/usr/share/opennebula/sunstone``) there is a file called
``config.ru``. This file is specific for ``rack`` applications and tells
how to fun the application. To start a new server using ``unicorn`` you
can run this command from that directory:

.. code::

$ unicorn -p 9869

Default unicorn configuration should be ok for most installations but a
configuration file can be created to tune it. For example, to tell
unicorn to spawn 4 processes and write ``stderr`` to
``/tmp/unicorn.log`` we can create a file called ``unicorn.conf`` that
contains:

.. code:: code

worker_processes 4
logger debug
stderr_path '/tmp/unicorn.log'

and start the server and daemonize it using:

.. code::

$ unicorn -d -p 9869 -c unicorn.conf

You can find more information about the configuration options in the
`unicorn
documentation <http://unicorn.bogomips.org/Unicorn/Configurator.html>`__.

Running Sunstone with Passenger in Apache
-----------------------------------------

`Phusion Passenger <https://www.phusionpassenger.com/>`__ is a module
for `Apache <http://httpd.apache.org/>`__ and
`Nginx <http://nginx.org/en/>`__ web servers that runs ruby rack
applications. This can be used to run Sunstone server and will manage
all its life cycle. If you are already using one of these servers or
just feel comfortable with one of them we encourage you to use this
method. This kind of deployment adds better concurrency and lets us add
an https endpoint.

We will provide the instructions for Apache web server but the steps
will be similar for nginx following `Passenger
documentation <https://www.phusionpassenger.com/support#documentation>`__.

First thing you have to do is install Phusion Passenger. For this you
can use pre-made packages for your distribution or follow the
`installation
instructions <https://www.phusionpassenger.com/download/#open_source>`__
from their web page. The installation is self explanatory and will guide
you in all the process, follow them an you will be ready to run
Sunstone.

Next thing we have to do is configure the virtual host that will run our
Sunstone server. We have to point to the ``public`` directory from the
Sunstone installation, here is an example:

.. code:: code

<VirtualHost *:80>
ServerName sunstone-server
# !!! Be sure to point DocumentRoot to 'public'!
DocumentRoot /usr/lib/one/sunstone/public
<Directory /usr/lib/one/sunstone/publicc>
# This relaxes Apache security settings.
AllowOverride all
# MultiViews must be turned off.
Options -MultiViews
</Directory>
</VirtualHost>

Make sure you change the directory to
``/usr/share/opennebula/sunstone/public`` if you are using Debian or
Ubuntu.

Now the configuration should be ready, restart of reload apache
configuration to start the application and point to the virtual host to
check if everything is running.

Running Sunstone in Multiple Servers
------------------------------------

You can run Sunstone in several servers and use a load balancer that
connects to them. Make sure you are using ``memcache`` for sessions and
both Sunstone servers connect to the same ``memcached`` server. To do
this change the parameter ``:memcache_host`` in the configuration file.
Also make sure that both Sunstone instances connect to the same
OpenNebula server.
