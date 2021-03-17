:orphan:

.. _market_s3:

==============
S3 MarketPlace
==============

Overview
================================================================================

This MarketPlace uses an S3 API-capable service as the backend. This means MarketPlaceApp images will be stored in the official `AWS S3 service <https://aws.amazon.com/s3/>`__ , or in services that implement that API, like `Ceph Object Gateway S3 <http://docs.ceph.com/docs/master/radosgw/s3/>`__.

Limitations
================================================================================

Since the S3 API does not provide a value for available space, this space is hard-coded into the driver file, limiting it to 1TB. See below to learn how to change the default value.

Requirements
================================================================================

To use this driver you require access to an S3 API-capable service.

* If you want to use AWS Amazon S3, you can start with the `Getting Started <http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html>`__ guide.
* For Ceph S3 you must follow the `Configuring Ceph Object Gateway <http://docs.ceph.com/docs/master/radosgw/config/>`__ guide.

Make sure you obtain both an `access_key` and a `secret_key` of a user that has access to a bucket with the exclusive purpose of storing MarketPlaceApp images.

Configuration
================================================================================

These are the configuration attributes of a MarketPlace template of the `S3` kind:

+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       Attribute       |                                                                                            Description                                                                                             |
+=======================+====================================================================================================================================================================================================+
| ``NAME``              | Required                                                                                                                                                                                           |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``MARKET_MAD``        | Must be ``s3``                                                                                                                                                                                     |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ACCESS_KEY_ID``     | (**Required**) The access key of the S3 user.                                                                                                                                                      |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SECRET_ACCESS_KEY`` | (**Required**) The secret key of the S3 user.                                                                                                                                                      |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BUCKET``            | (**Required**) The bucket where the files will be stored.                                                                                                                                          |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``REGION``            | (**Required**) The region to connect to. If you are using Ceph-S3 any value here will work.                                                                                                        |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``ENDPOINT``          | (Optional) This is only required if you are connecting to a service other than Amazon AWS S3. Preferably don't use an endpoint that includes the bucket as the leading part of the host's URL.     |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SIGNATURE_VERSION`` | (Optional) Leave blank for Amazon AWS S3 service. If connecting to Ceph S3 it **must** be ``s3``.                                                                                                  |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``FORCE_PATH_STYLE``  | (Optional) Leave blank for Amazon AWS S3 service. If connecting to Ceph S3 it **must** be ``YES``.                                                                                                 |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TOTAL_MB``          | (Optional) This parameter defines the total size of the MarketPlace in MB. It defaults to ``1024 GB``.                                                                                             |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``READ_LENGTH``       | (Optional) Split the file into chunks of this size (in MB). You should **never** user a quantity larger than `100`. Defaults to `32` (MB).                                                         |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

For example, the following examples illustrate the creation of a MarketPlace:

.. prompt:: bash $ auto

    $ cat market.conf
    NAME=S3CephMarket
    ACCESS_KEY_ID="I0PJDPCIYZ665MW88W9R"
    SECRET_ACCESS_KEY="dxaXZ8U90SXydYzyS5ivamEP20hkLSUViiaR"
    BUCKET="opennebula-market"
    ENDPOINT="http://ceph-gw.opennebula.org"
    FORCE_PATH_STYLE="YES"
    MARKET_MAD=s3
    REGION="default"
    SIGNATURE_VERSION=s3

    $ onemarket create market.conf
    ID: 100

.. warning:: In order to use the ``download`` functionality make sure you read the :ref:`Sunstone Advanced Guide <suns_advance_marketplace>`.

Tuning & Extending
==================

In order to change the available size of the MarketPlace from 1TB to your desired value, you can modify `/var/lib/one/remotes/market/s3/monitor` and change:

.. code::

    TOTAL_MB_DEFAULT = 1048576 # Default maximum 1TB

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the :ref:`Market Driver Development <devel-market>` guide to learn about the driver details.
