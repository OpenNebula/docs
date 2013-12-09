======================
External Auth Overview
======================

OpenNebula comes by default with an internal user/password
authentication system, see the `Users & Groups Subsystem
guide </./auth_overview>`__ for more information. You can enable an
external Authentication driver.

Authentication
==============

|image0|

In the figure to the right of this text you can see three authentication
configurations you can customize in OpenNebula.

a) CLI Authentication
---------------------

You can choose from the following authentication drivers to access
OpenNebula from the command line:

-  `Built-in
User/Password </./manage_users#adding_and_deleting_users>`__
-  `SSH Authentication </./ssh_auth>`__
-  `X509 Authentication </./x509_auth>`__
-  `LDAP Authentication </./ldap>`__

b) Sunstone Authentication
--------------------------

By default, users with the â€œcoreâ€? authentication driver
(user/password) can login in Sunstone. You can enable users with the
â€œx authentication driver to login using an external **SSL proxy**
(e.g. Apache).

Proceed to the Sunstone documentation to configure the x509 access:

-  `Sunstone Authentication Methods </./suns_auth>`__

c) Servers Authentication
-------------------------

OpenNebula ships with three servers: `Sunstone </./sunstone>`__,
`EC2 </./ec2qcg>`__ and `OCCI </./occicg>`__. When a user interacts with
one of them, the server authenticates the request and then forwards the
requested operation to the OpenNebula daemon.

The forwarded requests are encrypted by default using a Symmetric Key
mechanism. The following guide shows how to strengthen the security of
these requests using x509 certificates. This is specially relevant if
you are running your server in a machine other than the frontend.

-  `Cloud Servers Authentication </./cloud_auth>`__

.. |image0| image:: /./_media/documentation:rel3.2:auth_options_350.png
:target: /./_detail/documentation:rel3.2:auth_options_350.png?id=
