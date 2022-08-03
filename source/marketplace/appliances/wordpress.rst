.. _service_wp:

=========
WordPress
=========

OpenNebula `Marketplace Appliance <https://marketplace.opennebula.io/appliance/84bd27fe-5d14-4e70-a79a-eb3fdd0072ae>`_ with preinstalled `WordPress <https://wordpress.org/>`_ service.

Without any parameters provided, the appliance boots into the web setup wizard and user has to finish the WordPress initial configuration manually in the browser. This part can be automated (as part of the bootstrap process) with :ref:`contextualization <wordpress_context_param>` parameters.

.. include:: shared/features.txt

Platform Notes
==============

Component versions
------------------

============================= ==================
Component                     Version
============================= ==================
WordPress                     5.1.11
Contextualization package     6.2.0
============================= ==================

Quick Start
===========

.. include:: shared/import.txt
.. include:: shared/update.txt
.. include:: shared/run.txt

The initial configuration can be customized with :ref:`contextualization <wordpress_context_param>` parameters:

|image-context-vars|

.. note::

    The last four inputs are the :ref:`bootstrap parameters <wordpress_bootstrap>` - **all of them must be set** for the bootstrap stage to work. The stage is skipped if any of them are missing.

After you are done, click on the button **Instantiate**. Virtual machine with running service should be ready in a few minutes.

.. include:: shared/report.txt

.. code::

       ___   _ __    ___
      / _ \ | '_ \  / _ \   OpenNebula Service Appliance
     | (_) || | | ||  __/
      \___/ |_| |_| \___|

    All set and ready to serve 8)

   [root@localhost ~]# cat /etc/one-appliance/config
   [DB connection info]
   host     = localhost
   database = wordpress

   [DB root credentials]
   username = root
   password = LNSjsubElGShuVnp

   [DB wordpress credentials]
   username = wordpress
   password = 6NpcbOCIsPWv5I4C

   [Wordpress]
   site_url = 192.168.122.10
   username = john
   password = m7w5Q3MzU

.. _wordpress_context_param:

Contextualization
=================

Contextualization parameters provided in the Virtual Machine template controls the initial VM configuration. Except for the `common set <https://docs.opennebula.io/stable/management_and_operations/references/template.html#context-section>`_ of parameters supported by every appliance on the OpenNebula Marketplace, there are few specific to the particular service appliance. The parameters should be provided in the ``CONTEXT`` section of the Virtual Machine template, read the OpenNebula `Management and Operations Guide <https://docs.opennebula.io/stable/management_and_operations/references/kvm_contextualization.html#set-up-the-virtual-machine-template>`__ for more details.

===================================== ========= ============== ========= ===========
Parameter                             Mandatory Default        Stage     Description
===================================== ========= ============== ========= ===========
``ONEAPP_SITE_HOSTNAME``                        routable IP    configure Fully qualified domain name or IP
``ONEAPP_DB_NAME``                              ``wordpress``  configure Database name
``ONEAPP_DB_USER``                              ``wordpress``  configure Database service user
``ONEAPP_DB_PASSWORD``                          random         configure Database service password
``ONEAPP_DB_ROOT_PASSWORD``                     random         configure Database password for root
``ONEAPP_SSL_CERT``                                            configure SSL certificate
``ONEAPP_SSL_PRIVKEY``                                         configure SSL private key
``ONEAPP_SSL_CHAIN``                                           configure SSL CA chain
``ONEAPP_SITE_TITLE``                                          bootstrap Site Title
``ONEAPP_ADMIN_USERNAME``                                      bootstrap Site Administrator Login
``ONEAPP_ADMIN_PASSWORD``                                      bootstrap Site Administrator Password
``ONEAPP_ADMIN_EMAIL``                                         bootstrap Site Administrator E-mail
===================================== ========= ============== ========= ===========

.. include:: shared/site_address.txt

.. _wordpress_ssl:

SSL
---

If ``ONEAPP_SSL_CERT`` and ``ONEAPP_SSL_PRIVKEY`` are set, the service will be configured to listen to both on HTTP (port 80) and secured HTTPS (port 443). The ``ONEAPP_SSL_CHAIN`` is optional for the service configuration but may be necessary for the connection verification by the clients.

.. note::

    **No automatic redirection** from HTTP to HTTPS is made, both endpoints are usable the same way.

.. include:: shared/cert.txt

Let's Encrypt
~~~~~~~~~~~~~

Not supported yet.

.. _wordpress_bootstrap:

Bootstrap
---------

.. note::

    All parameters must be defined all together to take effect. Otherwise, the bootstrap is skipped.

Bootstrap configures the initial parameters inside the WordPress service itself (WordPress site name and user name, password and e-mail of the administrator). It's controlled by following contextualization parameters:

* ``ONEAPP_SITE_TITLE``
* ``ONEAPP_ADMIN_USERNAME``
* ``ONEAPP_ADMIN_PASSWORD``
* ``ONEAPP_ADMIN_EMAIL``

or, can be specified in the OpenNebula Sunstone on VM template instantiation:

|image-bootstrap-values|

.. |image-download| image:: /images/wordpress-download.png
.. |image-ssl-context-values| image:: /images/wordpress-ssl-context-values.png
.. |image-bootstrap-values| image:: /images/wordpress-bootstrap-values.png
.. |image-context-vars| image:: /images/wordpress-context-vars.png
.. |image-ssh-context| image:: /images/appliance-ssh-context.png
.. |image-custom-vars-password| image:: /images/appliance-custom-vars-password.png
