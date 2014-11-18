.. _gluster_ds:

=======================
The GlusterFS Datastore
=======================

GlusterFS driver allows KVM machines access VM images using native GlusterFS API. This datastores uses the :ref:`Shared Transfer Manager <fs_ds_using_the_shared_transfer_driver>` and the :ref:`Filesystem Datastore <fs_ds>`  to access a Gluster fuse filesystem to manage images.

.. warning:: This driver **only** works with libvirt/KVM drivers. Xen is not (yet) supported.

.. warning:: All virtualization nodes and the head need to mount the GlusterFS volume used to store images.

.. warning:: The hypervisor nodes need to be part of a working GlusterFS cluster and the Libvirt and QEMU packages need to be recent enough to have support for GlusterFS.

Requirements
============

GlusterFS Volume Configuration
------------------------------

OpenNebula does not run as ``root`` user. To be able to access native GlusterFS API user access must be allowed. This can be achieved by adding this line to ``/etc/glusterfs/glusterd.vol``:

.. code::

    option rpc-auth-allow-insecure on

and executing this command (replace ``<volume>`` with your volume name):

.. code-block:: none

    # gluster volume set <volume> server.allow-insecure on

As stated in the `Libvirt documentation <http://libvirt.org/storage.html#StorageBackendGluster>`_ it will be useful to set the ``owner-uid`` and ``owner-gid`` to the ones used by ``oneadmin`` user and group:

.. code-block:: none

    # gluster volume set <volume> storage.owner-uid <oneadmin uid>
    # gluster volume set <volume> storage.owner-gid <oneadmin gid>

To make Qemu work with Gluster over libgfapi we need to create a file ``/var/lib/glusterd/groups/virt`` with following content

.. code-block:: none

   quick-read=off
   read-ahead=off
   io-cache=off
   stat-prefetch=on
   eager-lock=enable
   remote-dio=enable
   quorum-type=auto
   server.allow-insecure=on
   server-quorum-type=server

Enable the settings on the group

.. code-block:: none

   gluster volume set <volume> group virt

Datastore Mount
---------------

The GlusterFS volume must be mounted in all the virtualization nodes and the head node using fuse mount. This mount will be used to manage images and VM related files (images and checkpoints). The ``oneadmin`` account must have write permissions on the mounted filesystem and it must be accessible by both the system and image datastore. The recommended way of setting the mount points is to mount the gluster volume in a specific path and to symlink the datastore directories:

.. code-block:: none

    # mkdir -p /var/lib/one/datastores/0
    # mount -t gluster server:/volume /var/lib/one/datastores/0
    # chown oneadmin:oneadmin /var/lib/one/datastores/0
    # ln -s /var/lib/one/datastores/0 /var/lib/one/datastores/1

Configuration
=============

Configuring the System Datastore
--------------------------------

The system datastore must be of type ``shared``. See more details on the :ref:`System Datastore Guide <system_ds>`

It will also be used to hold context images and volatile disks.

Configuring GlusterFS Datastore
-------------------------------

The datastore that holds the images will also be of type ``fs`` but you will need to add the parameters ``DISK_TYPE``, ``GLUSTER_HOST`` and ``GLUSTER_VOLUME`` described ins this table.

+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
|       Attribute       |                                                           Description                                                            |
+=======================+==================================================================================================================================+
| ``NAME``              | The name of the datastore                                                                                                        |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DS_MAD``            | The DS type, use ``fs`` for the Gluster datastore                                                                                |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``            | Transfer drivers for the datastore, use ``shared``, see below                                                                    |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``         | The type **must** be ``GLUSTER``                                                                                                 |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``RESTRICTED_DIRS``   | Paths that can not be used to register images. A space separated list of paths.                                                  |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``SAFE_DIRS``         | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths.                          |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``NO_DECOMPRESS``     | Do not try to untar or decompress the file to be registered. Useful for specialized Transfer Managers                            |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``LIMIT_TRANSFER_BW`` | Specify the maximum transfer rate in bytes/second when downloading images from a http/https URL. Suffixes K, M or G can be used. |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``GLUSTER_HOST``      | Host and port of one (only one) Gluster server ``host:port``                                                                     |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| ``GLUSTER_VOLUME``    | Gluster volume to use for the datastore                                                                                          |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+


An example of datastore:

.. code::

    > cat ds.conf
    NAME = "glusterds"
    DS_MAD = fs
    TM_MAD = shared

    # the following line *must* be preset
    DISK_TYPE = GLUSTER

    GLUSTER_HOST = gluster_server:24007
    GLUSTER_VOLUME = one_vol

    CLONE_TARGET="SYSTEM"
    LN_TARGET="NONE"

    > onedatastore create ds.conf
    ID: 101

    > onedatastore list
      ID NAME                SIZE AVAIL CLUSTER      IMAGES TYPE DS       TM
       0 system              9.9G 98%   -                 0 sys  -        shared
       1 default             9.9G 98%   -                 2 img  fs       shared
       2 files              12.3G 66%   -                 0 fil  fs       ssh
     101 default             9.9G 98%   -                 0 img  fs       shared

.. warning:: It is recommended to group the Gluster datastore and the Gluster enabled hypervisors in an OpenNebula ref:`cluster<cluster_guide>`.
