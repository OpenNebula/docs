.. _external_auth:

=======================
External Auth Overview
=======================

OpenNebula comes by default with an internal user/password authentication system, see the :ref:`Users & Groups Subsystem guide <auth_overview>` for more information. You can enable an external Authentication driver.

Authentication
==============

|image0|

In the figure to the right of this text you can see three authentication configurations you can customize in OpenNebula.

a) CLI Authentication
---------------------

You can choose from the following authentication drivers to access OpenNebula from the command line:

-  :ref:`Built-in User/Password <manage_users_adding_and_deleting_users>`
-  :ref:`SSH Authentication <ssh_auth>`
-  :ref:`X509 Authentication <x509_auth>`
-  :ref:`LDAP Authentication <ldap>`

b) Sunstone Authentication
--------------------------

By default, users with the “core” authentication driver (user/password) can login in Sunstone. You can enable users with the “x authentication driver to login using an external **SSL proxy** (e.g. Apache).

Proceed to the Sunstone documentation to configure the x509 access:

-  :ref:`Sunstone Authentication Methods <suns_auth>`

c) Servers Authentication
-------------------------

OpenNebula ships with two servers: :ref:`Sunstone <sunstone>` and :ref:`EC2 <ec2qcg>`. When a user interacts with one of them, the server authenticates the request and then forwards the requested operation to the OpenNebula daemon.

The forwarded requests are encrypted by default using a Symmetric Key mechanism. The following guide shows how to strengthen the security of these requests using x509 certificates. This is specially relevant if you are running your server in a machine other than the frontend.

-  :ref:`Cloud Servers Authentication <cloud_auth>`

.. |image0| image:: /images/auth_options_350.png
