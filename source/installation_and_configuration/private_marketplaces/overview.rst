.. _private_marketplace_overview:

====================
Overview
====================

Besides the available current Marketplaces supported by OpenNebula, private Marketplaces are supported in order to allow the cloud administrators to create Marketplaces to provide their users an easy way of downloading and sharing custom applications.
Sharing, provisioning and consuming cloud images is one of the main concerns when using Cloud. OpenNebula provides a simple way to create and integrate with a cloud image provider, called Marketplaces. Think of them as external datastores.

A Marketplace can be:

* **Public**: accessible universally by all OpenNebulas.
* **Private**: local within an organization and specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones).

A Marketplace is a repository of Marketplace Apps. There are three types of apps:

- **Image**: an image that can be download and used (optionally it can have a virtual machine template associated)
- **VM template**: a virtual machine template that contains a list of images that are allocated in the Marketplaces.
- **Service template**: a template to be used in OneFlow that contains a list of virtual machine templates that are allocated in the Marketplaces.

Using Marketplaces is very convenient, as it will allow you to move images across different kinds of datastores (using the Marketplace as an exchange point). It is a way to share OpenNebula images in a Federation, as these resources are federated. In an OpenNebula deployment where the different VDCs don't share any resources, a Marketplace will act like a shared datastore for all the users.

Backends
========

Marketplaces store the actual Marketplace Apps. How they do so depends on the backend driver. Currently these drivers are shipped with OpenNebula:

+---------------------------------------------+--------+--------------------------------------------------------------------+
| Driver                                      | Upload | Description                                                        |
+=============================================+========+====================================================================+
| :ref:`http <market_http>`                   | Yes    | When an image is uploaded to a Marketplace of this kind, the image |
|                                             |        | is written into a file in a specified folder, which is in turn     |
|                                             |        | available via a web-server.                                        |
+---------------------------------------------+--------+--------------------------------------------------------------------+
| :ref:`S3 <market_s3>`                       | Yes    | Images are stored to an S3 API-capable service. This means they can|
|                                             |        | be stored in the official `AWS S3 service                          |
|                                             |        | <https://aws.amazon.com/s3/>`__ , or in services that implement    |
|                                             |        | that API like `Ceph Object Gateway S3                              |
|                                             |        | <https://docs.ceph.com/en/latest/radosgw/s3/>`__                   |
+---------------------------------------------+--------+--------------------------------------------------------------------+

Check :ref:`this <public_marketplaces>` to see information about public Marketplaces. OpenNebula ships with the OpenNebula Systems Marketplace pre-registered, so users can access it directly.

Use Cases
=========

Using the Marketplace is recommended in many scenarios; to name a few:

* When starting with an empty OpenNebula, the public `OpenNebula Systems Marketplace <https://marketplace.opennebula.io/appliance>`__ contains a catalog of :ref:`OpenNebula-ready <context_overview>` cloud images, allowing you to get on your feet very quickly.
* You can upload an image into a Marketplace, and download it later on to other Datastores, even if the source and target Datastores are of a different type, thus enabling image cloning from any datastore to any other datastore.
* In a federation, it is almost essential to have a shared Marketplace in order to share Marketplace Apps across zones.
* Marketplaces are a great way to provide content for the users in VDCs with no initial virtual resources.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Deployment Guide <deployment_guide>`.

Read the :ref:`OpenNebula Systems Marketplace <market_one>` as it's global for all OpenNebula installations. Then read the specific guide for the Marketplace flavor you are interested in. Finally, read the :ref:`Managing Marketplace Apps <marketapp>` to understand what operations you can perform on Marketplace Apps.

Hypervisor Compatibility
================================================================================

This chapter applies to all Hypervisors.
