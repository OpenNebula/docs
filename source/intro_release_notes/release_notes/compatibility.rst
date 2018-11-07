
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.7.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.7.

To consider only if upgrading from OpenNebula 5.x.x
================================================================================

* The virtual machine pool table includes a new column with a short XML description of the VM. This speedups list operations on the VM pool for large deployments. Note that the XML document includes only the most relevant information, you need to perform a show API call or command to get the full information of the VM.
* Listing operations are shorted in descending order by default.
