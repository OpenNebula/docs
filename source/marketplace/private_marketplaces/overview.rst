.. _private_marketplace_overview:

====================
Overview
====================

Besides the :ref:`public Marketplaces <public_marketplaces>` (leveraging various remote public repositories with existing Appliances and accessible universally by all OpenNebula instances), the private ones allow the cloud administrators to create the **private Marketplaces** within an single organization in a specific OpenNebula (single zone) or shared by a Federation (collection of zones). Private Marketplaces provide their users with an easy way of privately publishing, downloading and sharing their own custom Appliances.

A Marketplace is a repository of Marketplace Appliances. There are three types of Appliances:

- **Image**: an image that can be downloaded and used (optionally it can have an associated virtual machine template)
- **Virtual Machine Template**: a virtual machine template that contains a list of images that are allocated in the Marketplaces.
- **Service Template**: a template to be used in OneFlow that contains a list of virtual machine templates that are allocated in the Marketplaces.

Using private Marketplaces is very convenient, as it will allow you to move images across different kinds of datastores (using the Marketplace as an exchange point). It is a way to share OpenNebula images in a Federation, as these resources are federated. In an OpenNebula deployment where the different VDCs don't share any resources, a Marketplace will act like a shared datastore for all the users.

Back-ends
=========

Marketplaces store the actual Marketplace Appliances. How they do so depends on the Back-end driver. Currently, the following private Marketplace drivers are shipped with OpenNebula:

+-------------------------------+--------+--------------------------------------------------------------------------------+
| Driver                        | Upload | Description                                                                    |
+===============================+========+================================================================================+
| :ref:`http <market_http>`     | Yes    | When an image is uploaded to a Marketplace of this kind, the image             |
|                               |        | is written into a file in a specified folder, which is in turn                 |
|                               |        | available via a web server.                                                    |
+-------------------------------+--------+--------------------------------------------------------------------------------+
| :ref:`S3 <market_s3>`         | Yes    | Images are stored to an S3 API-capable service. This means they can            |
|                               |        | be stored in the official `AWS S3 service                                      |
|                               |        | <https://aws.amazon.com/s3/>`__ , or in services that implement                |
|                               |        | that API like `Ceph Object Gateway S3                                          |
|                               |        | <https://docs.ceph.com/en/latest/radosgw/s3/>`__                               |
+-------------------------------+--------+--------------------------------------------------------------------------------+

Check :ref:`this <public_marketplaces>` to see information about public Marketplaces. OpenNebula ships with the OpenNebula Systems Marketplace pre-registered, so users can access it directly.

Use Cases
=========

Using the Marketplace is recommended in many scenarios. To name a few:

* You can upload an image into a Marketplace and download it later to other Datastores, even if the source and target Datastores are of a different type, thus enabling image cloning from any datastore to any other datastore.
* In a Federation, it is almost essential to have a shared Marketplace in order to share Marketplace Apps across Zones.
* Marketplaces are a great way to provide content for the users in VDCs with no initial virtual resources.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Deployment Guide <deployment_guide>`.

Read the :ref:`Public Marketplaces <public_marketplaces>` as it's global for all OpenNebula installations. Then, read the specific guide for the private Marketplace flavor you are interested in. Finally, read the :ref:`Managing Marketplace Apps <marketapp>` to understand what operations you can perform on Marketplace Apps.

Hypervisor Compatibility
================================================================================

This chapter applies to all Hypervisors.
