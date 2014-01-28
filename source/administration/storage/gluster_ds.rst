.. _gluster_ds:

=======================
The GlusterFS Datastore
=======================

GlusterFS driver allows KVM machines access VM images using native GlusterFS API. This datastores use the same shared Transfer Manager and Datastore Manager scripts to access a Gluster fuse filesystem to manage images.

.. warning:: This driver **only** works with libvirt/KVM drivers. Xen is not (yet) supported.

.. warning:: All virtualization nodes and the head need to mount the GlusterFS volume used to store images.

.. warning:: The hypervisor nodes need to be part of a working GlusterFS server/s and the Libvirt and QEMU packages need to be recent enough to have support for GlusterFS.

.. warning:: KVM/GlusterFS integration does not support more than one host at the moment. VM HA using GlusterFS replicas is not possible.

Requirements
============

GlusterFS Volume Configuration
------------------------------

OpenNebula does not run as ``root`` user. To be able to access native GlusterFS API user access must me allowed. This can be archived adding this line to ``/etc/glusterfs/glusterd.vol``:

.. code::

    option rpc-auth-allow-insecure on

and execute this command changing ``<volume>`` with your volume name:

.. code-block:: none

    # gluster volume set <volume> server.allow-insecure on

As stated in the `Libvirt documentation <http://libvirt.org/storage.html#StorageBackendGluster>`_ it will be useful to set the ``owner-uid`` and ``owner-gid`` to the ones used by ``oneadmin``:

.. code-block:: none

    # gluster volume set <volume> storage.owner-uid=<oneadmin uid>
    # gluster volume set <volume> storage.owner-gid=<oneadmin gid>


Datastore Mount
---------------

The GlusterFS volume must be mounted in all the virtualization nodes and the head node using fuse mount. This mount will be used to manage images and VM related files (images and checkpoints). The mounted filesystem must be able to be written by ``oneadmin`` user and be accessible by both system and image datastore. One possible way of configuring it is mounting in one of the datastore directories and creating a symlink to the other:

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

It will also be used to hold context images and Disks created on the fly, they will be created as regular files.

Configuring GlusterFS Datastore
-------------------------------

The datastore that holds the images will also be of type ``shared`` but you will need to add the parameters ``DISK_TYPE``, ``GLUSTER_HOST`` and ``GLUSTER_VOLUME`` described ins this table.

+---------------------+---------------------------------------------------------------------------------------------------------+
|      Attribute      |                                               Description                                               |
+=====================+=========================================================================================================+
| ``NAME``            | The name of the datastore                                                                               |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``DS_MAD``          | The DS type, use ``shared`` for the Ceph datastore                                                      |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``TM_MAD``          | Transfer drivers for the datastore, use ``shared``, see below                                           |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``       | The type **must** be ``GLUSTER``                                                                        |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``RESTRICTED_DIRS`` | Paths that can not be used to register images. A space separated list of paths.                         |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``SAFE_DIRS``       | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths. |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``NO_DECOMPRESS``   | Do not try to untar or decompress the file to be registered. Useful for specialized Transfer Managers   |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``GLUSTER_HOST``    | Host and port of one Gluster daemon ``host:port``                                                       |
+---------------------+---------------------------------------------------------------------------------------------------------+
| ``GLUSTER_VOLUME``  | Gluster volume to use for the datastore                                                                 |
+---------------------+---------------------------------------------------------------------------------------------------------+

An example of datastore:

.. code::

    > cat ds.conf
    NAME = "glusterds"
    DS_MAD = shared
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
       1 default             9.9G 98%   -                 2 img  shared   shared
       2 files              12.3G 66%   -                 0 fil  fs       ssh
     101 default             9.9G 98%   -                 0 img  gluster  gluster

.. warning:: Note that datastores are not associated to any cluster by default, and they are supposed to be accessible by every single host. If you need to configure datastores for just a subset of the hosts take a look to the :ref:`Cluster guide <cluster_guide>`.
