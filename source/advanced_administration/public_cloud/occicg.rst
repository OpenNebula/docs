=========================
OCCI Server Configuration
=========================

The OpenNebula OCCI (Open Cloud Computing Interface) server is a web
service that enables you to launch and manage virtual machines in your
OpenNebula installation using an implementation of the `OGF OCCI API
specification <http://www.occi-wg.org>`__ based on the `draft
0.8 <http://forge.ogf.org/sf/docman/do/downloadDocument/projects.occi-wg/docman.root.drafts/doc15731/3>`__.
This implementation also includes some extensions, requested by the
community, to support OpenNebula specific functionality. The OpenNebula
OCCI service is implemented upon the **OpenNebula Cloud API** (OCA)
layer that exposes the full capabilities of an OpenNebula private cloud;
and `Sinatra <http://www.sinatrarb.com/>`__, a widely used light web
framework.

|image0|

The following sections explain how to install and configure the OCCI
service on top of a running OpenNebula cloud.

|:!:| The OpenNebula OCCI service provides an OCCI interface to your
cloud instance, that can be used alongside the native OpenNebula CLI,
Sunstone or even the EC2 Query API

|:!:| The OpenNebula distribution includes the tools needed to use the
OpenNebula OCCI service

Requirements
============

You must have an OpenNebula site properly configured and running to
install the OpenNebula OCCI service, be sure to check the `OpenNebula
Installation and Configuration
Guides </./#designing_and_installing_your_cloud_infrastructure>`__ to
set up your private cloud first. This guide also assumes that you are
familiar with the configuration and use of OpenNebula.

The OpenNebula OCCI service was installed during the OpenNebula
installation, and the dependencies of this service are installed when
using the install\_gems tool as explained in the `installation
guide </./ignc#ruby_libraries_requirements_front-end>`__

If you installed OpenNebula from source you can install the OCCI
dependencias as explained at the end of the `Building from Source Code
guide </./compile#ruby_dependencies-end>`__

Considerations & Limitations
============================

The OCCI Server included in the OpenNebula distribution does not
implement the latest OCCI specification, it is based on the `draft
0.8 <http://forge.ogf.org/sf/docman/do/downloadDocument/projects.occi-wg/docman.root.drafts/doc15731/3>`__
of the OFG OCCI specification. The implementation of the latest
specification is being developed by TU-Dortmund in a `ecosystem
project <http://www.opennebula.org/software:ecosystem:occi>`__. You can
check the documentation of this project in the following
`link <http://dev.opennebula.org/projects/ogf-occi/wiki>`__

Configuration
=============

occi-server.conf
----------------

The service is configured through the ``/etc/one/occi-server.conf``
file, where you can set up the basic operational parameters for the OCCI
service, namely:

The following table summarizes the available options:

VARIABLE

VALUE

Server configuration

:tmpdir:

Directory to store temp files when uploading images

:one\_xmlrpc

oned xmlrpc service, http://localhost:2633/RPC2

:host

Host where OCCI server will run

:port

Port where OCCI server will run

:ssl\_server

SSL proxy that serves the API (set if is being used)

Log

:debug\_level

Log debug level, 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG

Auth

:auth

Authentication driver for incoming requests

:core\_auth

Authentication driver to communicate with OpenNebula core

Resources

:instance\_types

The Computes types for your cloud

:datastore\_id

Datastore in which the Images uploaded through OCCI will be allocated,
by default 1

:cluster\_id

Cluster associated with the OCCI resources, by default no Cluster is
defined

|:!:| The ``SERVER`` **must** be a FQDN, do not use IP's here

|:!:| Preserve YAML syntax in the ``occi-server.conf`` file

Example:

.. code:: code

#############################################################
# Server configuration
#############################################################

# Directory to store temp files when uploading images
:tmpdir: /var/tmp/one

# OpenNebula sever contact information
:one_xmlrpc: http://localhost:2633/RPC2

# Host and port where OCCI server will run
:host: 127.0.0.1
:port: 4567

# SSL proxy that serves the API (set if is being used)
#:ssl_server: fqdm.of.the.server

#############################################################
# Auth
#############################################################

# Authentication driver for incomming requests
#   occi, for OpenNebula's user-password scheme
#   x509, for x509 certificates based authentication
#   opennebula, use the driver defined for the user in OpenNebula
:auth: occi

# Authentication driver to communicate with OpenNebula core
#   cipher, for symmetric cipher encryption of tokens
#   x509, for x509 certificate encryption of tokens
:core_auth: cipher

#############################################################
# Log
#############################################################

# Log debug level
#   0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG
:debug_level: 3

#############################################################
# Resources
#############################################################

# Cluster associated with the OCCI resources, by default no Cluster is defined
#:cluster_id:

# Datastore in which the Images uploaded through OCCI will be allocated, by default 1
#:datastore_id:

# VM types allowed and its template file (inside templates directory)
:instance_types:
:small:
:template: small.erb
:cpu: 1
:memory: 1024
:medium:
:template: medium.erb
:cpu: 4
:memory: 4096
:large:
:template: large.erb
:cpu: 8
:memory: 8192

Configuring OCCI Virtual Networks
---------------------------------

You have to adapt the ``/etc/one/occi_templates/network.erb`` file to
the configuration that the Virtual Networks created through the OCCI
interface will use. For more information about the Virtual Network
configuration check the following `guide </./vnet_template>`__.

.. code:: code

NAME = "<%= @vnet_info['NAME'] %>"
TYPE = RANGED

NETWORK_ADDRESS = <%= @vnet_info['ADDRESS'] %>
<% if @vnet_info['SIZE'] != nil %>
NETWORK_SIZE    = <%= @vnet_info['SIZE']%>
<% end %>

<% if @vnet_info['DESCRIPTION'] != nil %>
DESCRIPTION = "<%= @vnet_info['DESCRIPTION'] %>"
<% end %>

<% if @vnet_info['PUBLIC'] != nil %>
PUBLIC = "<%= @vnet_info['PUBLIC'] %>"
<% end %>

#BRIDGE = NAME_OF_DEFAULT_BRIDGE
#PHYDEV = NAME_OF_PHYSICAL_DEVICE
#VLAN   = YES|NO

Defining Compute Types
----------------------

You can define as many Compute types as you want, just:

-  Create a template (new\_type.erb) for the new type and place it in
``/etc/one/occi_templates``. This template will be *completed* with
the data for each *occi-compute create* request and the content of
the ``/etc/one/occi_templates/common.erb`` file, and then submitted
to OpenNebula.

.. code:: code

# This is the content of the new /etc/one/occi_templates/new_type.erb file
CPU    = 1
MEMORY = 512

OS = [ kernel     = /vmlinuz,
initrd     = /initrd.img,
root       = sda1,
kernel_cmd = "ro xencons=tty console=tty1"]

-  Add a new type in the instance\_types section of the occi-server.conf

.. code:: code

:new_type:
:template: new_type.erb
:cpu: 1
:memory: 512

-  You can add common attributes for your cloud templates modifying the
``/etc/one/occi_templates/common.erb`` file.

|:!:| The templates are processed by the OCCI service to include
specific data for the instance, you should not need to modify the <%=
â€¦ %> compounds inside the ``common.erb`` file.

Usage
=====

Starting the Cloud Service
--------------------------

To start the OCCI service just issue the following command

.. code::

occi-server start

You can find the OCCI server log file in
``/var/log/one/occi-server.log``.

To stop the OCCI service:

.. code::

occi-server stop

|:!:| In order to start the OCCI server the
``/var/lib/one/.one/occi_auth`` file should be readable by the user that
is starting the server and the serveradmin user must exist in OpenNebula

Cloud Users
-----------

The cloud users have to be created in the OpenNebula system by
``oneadmin`` using the ``oneuser`` utility. Once a user is registered in
the system, using the same procedure as to create private cloud users,
they can start using the system. The users will authenticate using the
`HTTP basic
authentication <http://tools.ietf.org/html/rfc1945#section-11.1>`__ with
``user-ID`` their OpenNebula's username and ``password`` their
OpenNebula's password.

The cloud administrator can limit the interfaces that these users can
use to interact with OpenNebula by setting the driver â€œpublicâ€? for
them. Using that driver cloud users will not be able to interact with
OpenNebula through Sunstone, CLI nor XML-RPC.

.. code::

$ oneuser chauth cloud_user public

Tuning & Extending
==================

Authorization Methods
---------------------

OpenNebula OCCI Server supports two authorization methods in order to
log in. The method can be set in the
`occi-server.conf <#occi-serverconf>`__, as explained above. These two
methods are:

Basic Auth
~~~~~~~~~~

In the basic mode, username and password(sha1) are matched to those in
OpenNebula's database in order to authenticate the user in each request.

x509 Auth
~~~~~~~~~

This method performs the login to OpenNebula based on a x509 certificate
DN (Distinguished Name). The DN is extracted from the certificate and
matched to the password value in the user database (remember, spaces are
removed from DNs).

The user password has to be changed running one of the following
commands

.. code::

oneuser chauth new_user x509 "/C=ES/O=ONE/OU=DEV/CN=clouduser"
oneuser chauth new_user --x509 --cert /tmp/my_cert.pem

or create a new user:

.. code::

oneuser create new_user "/C=ES/O=ONE/OU=DEV/CN=clouduser" --driver x509
oneuser create new_user --x509 --cert /tmp/my_cert.pem

To enable this login method, set the **``:auth:``** option of
``/etc/one/sunstone-server.conf`` to **``x509``**:

.. code:: code

:auth: x509

Note that OpenNebula will not verify that the user is holding a valid
certificate at the time of login: this is expected to be done by the
external container of the OCCI server (normally Apache), whose job is to
tell the user's client that the site requires a user certificate and to
check that the certificate is consistently signed by the chosen
Certificate Authority (CA).

Configuring a SSL Proxy
-----------------------

OpenNebula OCCI runs natively just on normal HTTP connections. If the
extra security provided by SSL is needed, a proxy can be set up to
handle the SSL connection that forwards the petition to the OCCI Service
and takes back the answer to the client.

This set up needs:

-  A server certificate for the SSL connections
-  An HTTP proxy that understands SSL
-  OCCI Service configuration to accept petitions from the proxy

If you want to try out the SSL setup easily, you can find in the
following lines an example to set a self-signed certificate to be used
by a lighttpd configured to act as an HTTP proxy to a correctly
configured OCCI Service.

Let's assume the server were the lighttpd proxy is going to be started
is called ``cloudserver.org``. Therefore, the steps are:

1. Snakeoil Server Certificate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We are going to generate a snakeoil certificate. If using an Ubuntu
system follow the next steps (otherwise your milleage may vary, but not
a lot):

-  Install the ``ssl-cert`` package

.. code::

$ sudo apt-get install ssl-cert

-  Generate the certificate

.. code::

$ sudo /usr/sbin/make-ssl-cert generate-default-snakeoil

-  As we are using lighttpd, we need to append the private key with the
certificate to obtain a server certificate valid to lighttpd

.. code::

$ sudo cat /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/certs/ssl-cert-snakeoil.pem > /etc/lighttpd/server.pem

2. lighttpd as a SSL HTTP Proxy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You will need to edit the ``/etc/lighttpd/lighttpd.conf`` configuration
file and

-  Add the following modules (if not present already)

-  mod\_access
-  mod\_alias
-  mod\_proxy
-  mod\_accesslog
-  mod\_compress

-  Change the server port to 443 if you are going to run lighttpd as
root, or any number above 1024 otherwise:

.. code:: code

server.port               = 8443

-  Add the proxy module section:

.. code:: code

#### proxy module
## read proxy.txt for more info
proxy.server               = ( "" =>
("" =>
(
"host" => "127.0.0.1",
"port" => 4567
)
)
)


#### SSL engine
ssl.engine                 = "enable"
ssl.pemfile                = "/etc/lighttpd/server.pem"

The host must be the server hostname of the computer running the
EC2Query Service, and the port the one that the EC2Query Service is
running on.

3.OCCI Service Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``occi.conf`` needs to define the following:

.. code:: code

# Host and port where the occi server will run
:server: <FQDN OF OCCI SERVER>
:port: 4567

# SSL proxy that serves the API (set if is being used)
:ssl_server: https://localhost:443

Once the lighttpd server is started, OCCI petitions using HTTPS uris can
be directed to ``https://cloudserver.org:8443``, that will then be
unencrypted, passed to localhost, port 4567, satisfied (hopefully),
encrypted again and then passed back to the client.

.. |image0| image:: /./_media/documentation:rel1.4:occi_diagram.png
:target: /./_detail/documentation:rel1.4:occi_diagram.png?id=
.. |:!:| image:: /./lib/images/smileys/icon_exclaim.gif
