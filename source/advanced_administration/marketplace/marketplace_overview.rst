.. _marketplace_overview:

====================
MarketPlace Overview
====================

Sharing, provisioning and consuming cloud images is one of the main concerns when using Cloud. OpenNebula provides a simple way to create and integrate with a cloud image provider, called MarketPlaces. A MarketPlace can be either Public, accessible universally by all OpenNebula's, or Private: specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones).

A MarketPlace is a repository of MarketPlaceApps. A MarketPlaceApp can be of the following types:

* **Image**:  A single image which is optionally associated to a Virtual Machine Template.
* **VM Template**: A Virtual Machine Template and one or more images. Each image would represent a disk of the Virtual Machine. Note that if the template only has one image, it can be used interchangeably with the *Image* MarketPlaceApp type.
* **Flow**: A service template for *OneFlow*, which is composed of a collection of *VM Templates*.

+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Type      |                                                                                                           Description                                                                                                           |
+=================+=================================================================================================================================================================================================================================+
| ``Image``       | A single image which is optionally associated to a Virtual Machine Template.                                                                                                                                                    |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``VM Template`` | A Virtual Machine Template and one or more images. Each image would represent a disk of the Virtual Machine. Note that if the template only has one image, it can be used interchangeably with the *Image* MarketPlaceApp type. |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``Flow``        | A service template for *OneFlow*, which is composed of a collection of *VM Templates*.                                                                                                                                          |
+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Supported Actions
=================

MarketPlaces support various actions:

+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
|    Action   |                                                             Description                                                              |
+=============+======================================================================================================================================+
| ``create``  | Create a new MarketPlace.                                                                                                            |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``monitor`` | Discovers the available MarketPlaceApps and monitors the available space of the MarketPlace.                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``delete``  | Removes a MarketPlace from OpenNebula. This does **not** remove the MarketPlaceApps, and will only work if the MarketPlace is empty. |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+
| *other*     | Generic actions common to OpenNebula resources are also available: update, chgrp, chown, chmod and rename.                           |
+-------------+--------------------------------------------------------------------------------------------------------------------------------------+

As for the MarketPlaceApps, they support these actions:

+------------+-----------------------------------------------------------------------------------------------------------------------------+
|   Action   |                                                         Description                                                         |
+============+=============================================================================================================================+
| ``create`` | Upload a local image into the the MarketPlace.                                                                              |
+------------+-----------------------------------------------------------------------------------------------------------------------------+
| ``export`` | Export the MarketPlaceApp (download) into a local Datastore.                                                                |
+------------+-----------------------------------------------------------------------------------------------------------------------------+
| ``delete`` | Removes a MarketPlaceApp                                                                                                    |
+------------+-----------------------------------------------------------------------------------------------------------------------------+
| *other*    | Generic actions common to OpenNebula resources are also available: update, chgrp, chown, chmod, rename, enable and disable. |
+------------+-----------------------------------------------------------------------------------------------------------------------------+

.. warning::

    Currently the **export** action is only available for Datastores of type ``fs`` and ``ceph``.

Backends
========

MarketPlaces store the actual MarketPlaceApp images. How they do so depends on the backend driver. Currently these drivers are shipped with OpenNebula:

+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|  Driver  |                                                                                                                             Description                                                                                                                              |
+==========+======================================================================================================================================================================================================================================================================+
| ``one``  | This driver allows read access to the official public `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>`__, as well as to the `OpenNebula AppMarket Add-on <https://github.com/OpenNebula/addon-appmarket>`__.                                 |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``http`` | When an image is uploaded to a MarketPlace of this kind, the image is written into a file in a specified folder, which is in turn available via a web-server.                                                                                                        |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``S3``   | Images are stored into a S3 API-capable service. This means it can be stored in the official `AWS S3 service <https://aws.amazon.com/s3/>`__ , or in services that implement that API like `Ceph Object Gateway S3 <http://docs.ceph.com/docs/master/radosgw/s3/>`__ |
+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

OpenNebula ships with the OpenNebula Systems MarketPlace pre-registered, so users can access it directly.

Use Cases
=========

Using the MarketPlace is recommended in many scenarios, to name a few:

* When starting with an empty OpenNebula, the `OpenNebula Systems Marketplace <http://marketplace.opennebula.systems>`__ contains a catalog of :ref:`OpenNebula-ready <bcont>` cloud images.
* If a private MarketPlace is available (MarketPlaces with **one** driver do not count as they are generally public), it is possible to upload a local image from a Datastore to the MarketPlace, and downloading it to another local Datastore even if the source and target Datastores are of a different type, thus enabling image cloning to from any datastore to any other datastore.
* In a federation, it is almost essential to have a shared MarketPlace in order to share MarketPlaceApps accross zones.
* In a single OpenNebula Zone, MarketPlaces are a great way to provide images to all the VDCs from a single point.
