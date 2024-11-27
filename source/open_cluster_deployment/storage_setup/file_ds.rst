.. _file_ds:

==============================
The Kernels & Files Datastore
==============================

The Kernels & Files Datastore lets you store plain files to be used as VM kernels, ramdisks or any other files that need to be passed to the VM through the contextualization process. The Kernels & Files Datastore does not expose any special storage mechanism but is a simple and secure way to use files within VM templates.

Configuration
=============

The :ref:`datastores common configuration attributes <datastore_common>` apply to the Kernels & Files Datastores and can be defined during the creation process or updated once the datastore have been created.

The specific attributes for Kernels & Files Datastore are listed in the following table:

+------------+---------------------------+
| Attribute  |  Description              |
+============+===========================+
| ``TYPE``   | ``FILE_DS``               |
+------------+---------------------------+
| ``DS_MAD`` | ``fs``                    |
+------------+---------------------------+
| ``TM_MAD`` | ``local``                 |
+------------+---------------------------+

.. note:: The recommended ``DS_MAD`` and ``TM_MAD`` are the ones stated above but any other can be used to fit specific use cases. Regarding this, the same :ref:`configuration guidelines <datastores>` defined for Image and System Datastores applies for the Kernels & Files Datastore.

For example, the following illustrates the creation of Kernels & Files.

.. code::

    > cat kernels_ds.conf
    NAME = kernels
    DS_MAD = fs
    TM_MAD = local
    TYPE = FILE_DS
    SAFE_DIRS = /var/tmp/files

    > onedatastore create kernels_ds.conf
    ID: 100

    > onedatastore list
      ID NAME                      CLUSTER         IMAGES TYPE DS       TM
       0 system                    -                    0 sys  -        dummy
       1 default                   -                    0 img  dummy    dummy
       2 files                     -                    0 fil  fs       local
     100 kernels                   -                    0 fil  fs       local

You can check more details of the datastore by issuing the ``onedatastore show <ds_id>`` command.

Host Configuration
==================

The recommended ``local`` driver for the File Datastore does not need any special configuration for the Hosts. Just make sure that there is enough space under the datastore location (``/var/lib/one/datastores`` by default) to hold the VM files in the Front-end and Hosts.

If different ``DS_MAD`` or ``TM_MAD`` attributes are used, refer to the corresponding node set up guide of the corresponding driver.
