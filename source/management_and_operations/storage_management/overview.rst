.. _storage_overview:

================================================================================
Overview
================================================================================

How Should I Read This Chapter
================================================================================

In OpenNenbula there are two main places where VM disk images are stored:

* :ref:`Marketplaces <marketplaces>`, these are shared locations across multiple OpenNebula clouds. They can be public or for private use. Marketplaces store :ref:`Marketplace Applications <marketapp>` (or Appliances), that includes the application definition together with the disk images.
* :ref:`Datastores <datastores>`, these are the local storage areas of a cloud. They typically refer to storage clusters or hypervisor disks and are mainly devoted to store disk :ref:`Images <images>`.

In these chapter you will learn how to operate effectively these entities.

Hypervisor Compatibility
================================================================================

These guides are compatible with all hypervisors.
