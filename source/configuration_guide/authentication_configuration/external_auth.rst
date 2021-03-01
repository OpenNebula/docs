.. _external_auth:

========
Overview
========

OpenNebula comes by default with an internal user/password authentication system; see the :ref:`Users & Groups Subsystem guide <auth_overview>` for more information. You can enable an external Authentication driver.

Authentication
==============

|image0|

In this figure you can see three authentication configurations you can customize in OpenNebula.

a) CLI/API Authentication
-------------------------

You can choose from the following authentication drivers to access OpenNebula from the command line:

-  :ref:`Built-in User/Password and token authentication<manage_users_managing_users>`
-  :ref:`SSH Authentication <ssh_auth>`
-  :ref:`X509 Authentication <x509_auth>`
-  :ref:`LDAP Authentication <ldap>`

b) Sunstone Authentication
--------------------------

By default, any authentication driver configured to work with OpenNebula can be used out-of-the-box with Sunstone. Additionally you can add TLS security to Sunstone as described in the :ref:`Sunstone documentation <suns_auth>`

c) Servers Authentication
-------------------------

This method is designed to delegate the authentication process to high level tools interacting with OpenNebula. You'll be interested in this method if you are developing your own servers.


By default, OpenNebula ships with two servers: :ref:`Sunstone <sunstone>` and :ref:`FireEdge <fireedge_setup>`. When a user interacts with one of them, the server authenticates the request and then forwards the requested operation to the OpenNebula daemon.

The forwarded requests are encrypted by default using a Symmetric Key mechanism. The following guide shows how to strengthen the security of these requests using x509 certificates. This is specially relevant if you are running your server in a machine other than the front-end.

-  :ref:`Cloud Servers Authentication <cloud_auth>`

How Should I Read This Chapter
================================================================================

When designing the architecture of your cloud you will have to choose where to store users' credentials. Different authentication methods can be configured at the same time and selected on a per user basis. One big distinction between the different authentication methods is the ability to be used by API, CLI and/or only Sunstone (the web interface).

Can be used with API, CLI and Sunstone:

* Built-in User/Password
* LDAP

Can be used only with API and CLI:

* SSH

Can be used only with Sunstone:

* X509

The following sections are self-contained so you can directly go to the guide that describes the configuration for the chosen auth method.

Hypervisor Compatibility
================================================================================

+-------------------------------------------------------------------------------------+-----------------------------------------------+
|                                       Section                                       |                 Compatibility                 |
+=====================================================================================+===============================================+
| :ref:`Built-in User/Password and token authentication<manage_users_managing_users>` | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------------------------------------+-----------------------------------------------+
| :ref:`SSH Authentication <ssh_auth>`                                                | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------------------------------------+-----------------------------------------------+
| :ref:`X509 Authentication <x509_auth>`                                              | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------------------------------------+-----------------------------------------------+
| :ref:`LDAP Authentication <ldap>`                                                   | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------------------------------------+-----------------------------------------------+
| :ref:`Sunstone documentation <suns_auth>`                                           | This Section applies to both KVM and vCenter. |
+-------------------------------------------------------------------------------------+-----------------------------------------------+


.. |image0| image:: /images/auth_options_350.png
