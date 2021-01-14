.. _sunstone_overview:
.. _sunstone:

================================================================================
Overview
================================================================================

OpenNebula Sunstone is a Graphical User Interface (GUI) intended for both end users and administrators that simplifies the typical management operations in private and hybrid cloud infrastructures. OpenNebula Sunstone allows easily managing all OpenNebula resources and performing typical operations on them.

|admin_view|

How Should I Read this Chapter
================================================================================

The :ref:`Sunstone Installation & Configuration <sunstone_setup>` section describes the configuration and customization options for Sunstone.

After Sunstone is running, you can define different sunstone behaviors for each user role in the :ref:`Sunstone Views <suns_views>` section.

For more information on how to customize and extend your Sunstone deployment use the following links:

* :ref:`Security & Authentication Methods <suns_auth>`: improve security with x509 authentication and SSL
* :ref:`Cloud Servers Authentication <cloud_auth>`: advanced reference about the security between Sunstone and OpenNebula
* :ref:`Advanced Deployments <suns_advance>`: improving scalability and isolating the server

Hypervisor Compatibility
================================================================================

Sunstone is available for all the hypervisors. When using vCenter, the cloud admin should enable the ``admin_vcenter``, ``groupadmin_vcenter`` and ``cloud_vcenter`` :ref:`Sunstone views <suns_views>`.

.. |admin_view| image:: /images/admin_view.png
