.. _marketplace_overview:

====================
Overview
====================

.. todo::

    * Architect
    * Admin
    * KVM
    * vCenter

Sharing, provisioning and consuming cloud images is one of the main concerns when using Cloud. OpenNebula provides a simple way to create and integrate with a cloud image provider, called MarketPlaces. Think of them as external datastores.

A MarketPlace can be either Public, accessible universally by all OpenNebula's, or Private: local within an organization and specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones).

A MarketPlace is a repository of MarketPlaceApps. A MarketPlaceApp can be thought of as an external image optionally associated to a Virtual Machine Template.

Using MarketPlaces is very convenient, as it will allow you to move images across different kinds of datastores (using the MarketPlace as an exchange point), it is a way to share OpenNebula images in a Federation, as these resources are federated. In an OpenNebula deployment where the different VDCs don't share any resources, a MarketPlace will act like a shared datastore for all the users.

Supported Actions
=================

.. todo:: check onemarket delete, is it properly described?

MarketPlaces support various actions:

+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
|    Action   |                                                             Description                                                              |
+=============+======================================================================================================================================+
| ``create``  | Create a new MarketPlace.                                                                                                            |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``monitor`` | This automatic action, discovers the available MarketPlaceApps and monitors the available space of the MarketPlace.                  |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``delete``  | Removes a MarketPlace from OpenNebula. This does **not** remove the MarketPlaceApps, and will only work if the MarketPlace is empty. |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
| *other*     | Generic actions common to OpenNebula resources are also available: update, chgrp, chown, chmod and rename.                           |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+

As for the MarketPlaceApps, they support these actions:

+--------------+-----------------------------------------------------------------------------------------------------------------------------+
|    Action    |                                                         Description                                                         |
+==============+=============================================================================================================================+
| ``create``   | Upload a local image into the the MarketPlace.                                                                              |
+--------------+-----------------------------------------------------------------------------------------------------------------------------+
| ``export``   | Export the MarketPlaceApp and download it into a local Datastore.                                                           |
+--------------+-----------------------------------------------------------------------------------------------------------------------------+
| ``delete``   | Removes a MarketPlaceApp.                                                                                                   |
+--------------+-----------------------------------------------------------------------------------------------------------------------------+
| ``download`` | Downloads a MarketPlaceApp to a file.                                                                                       |
+--------------+-----------------------------------------------------------------------------------------------------------------------------+
| *other*      | Generic actions common to OpenNebula resources are also available: update, chgrp, chown, chmod, rename, enable and disable. |
+--------------+-----------------------------------------------------------------------------------------------------------------------------+

.. warning::

    Currently the **export** action is only available for Datastores of type ``fs`` and ``ceph``.

.. warning:: In order to use the ``download`` functionality make sure you read the :ref:`Sunstone Advanced Guide <suns_advance_marketplace>`.

Backends
========

MarketPlaces store the actual MarketPlaceApp images. How they do so depends on the backend driver. Currently these drivers are shipped with OpenNebula:

+---------------------------+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|           Driver          | Upload |                                                                                                                             Description                                                                                                                              |
+===========================+========+======================================================================================================================================================================================================================================================================+
| :ref:`one <market_one>`   | No     | This driver allows read access to the official public `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>`__, as well as to the `OpenNebula AppMarket Add-on <https://github.com/OpenNebula/addon-appmarket>`__.                                 |
+---------------------------+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :ref:`http <market_http>` | Yes    | When an image is uploaded to a MarketPlace of this kind, the image is written into a file in a specified folder, which is in turn available via a web-server.                                                                                                        |
+---------------------------+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| :ref:`S3 <market_s3>`     | Yes    | Images are stored into a S3 API-capable service. This means it can be stored in the official `AWS S3 service <https://aws.amazon.com/s3/>`__ , or in services that implement that API like `Ceph Object Gateway S3 <http://docs.ceph.com/docs/master/radosgw/s3/>`__ |
+---------------------------+--------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

OpenNebula ships with the OpenNebula Systems MarketPlace pre-registered, so users can access it directly.

Use Cases
=========

Using the MarketPlace is recommended in many scenarios, to name a few:

* When starting with an empty OpenNebula, the public `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>`__ contains a catalog of :ref:`OpenNebula-ready <bcont>` cloud images, allowing you to get on your feet very quickly.
* You can upload an image into a MarketPlace, and download it later on to another Datastores even if the source and target Datastores are of a different type, thus enabling image cloning from any datastore to any other datastore.
* In a federation, it is almost essential to have a shared MarketPlace in order to share MarketPlaceApps across zones.
* MarketPlaces are a great way to provide content for the users in VDCs with no initial virtual resources.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Deployment Guide <deployment_guide>`.

Read the :ref:`OpenNebula Systems MarketPlace <market_one>` as it's global for all the OpenNebula installations. Then read the specific guide for the MarketPlace flavor you are interested in. Finally, read the :ref:`Managing MarketPlaceApps <marketapp>` to understand what operations you can perform on MarketPlaceApps.

After reading this chapter you can continue configuring more :ref:`Advanced Components <advanced_components>`.

Hypervisor Compatibility
================================================================================

This chapter applies both to KVM and vCenter.
