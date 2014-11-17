.. _ceph_ds:

===================
The Ceph Datastore
===================

The Ceph datastore driver provides OpenNebula users with the possibility of using Ceph block devices as their Virtual Images.

.. warning:: This driver **only** works with libvirt/KVM drivers. Xen is not (yet) supported.

.. warning:: This driver requires that the OpenNebula nodes using the Ceph driver must be Ceph clients of a running Ceph cluster. More information in `Ceph documentation <http://ceph.com/docs/master/>`__.

.. warning:: The hypervisor nodes need to be part of a working Ceph cluster and the Libvirt and QEMU packages need to be recent enough to have support for Ceph. For Ubuntu systems this is available out of the box, however for CentOS systems you will need to manually install `this version <http://ceph.com/packages/qemu-kvm/>`__ of qemu-kvm.

Requirements
============

Ceph Cluster Configuration
--------------------------

The hosts where Ceph datastores based images will be deployed must be part of a running Ceph cluster. To do so refer to the `Ceph documentation <http://ceph.com/docs/master/>`__.

The Ceph cluster must be configured in such a way that no specific authentication is required, which means that for ``cephx`` authentication the keyring must be in the expected path so that ``rbd`` and ``ceph`` commands work without specifying explicitely the keyring's location.

Also the ``mon`` daemon must be defined in the ``ceph.conf`` for all the nodes, so ``hostname`` and ``port`` doesn't need to be specified explicitely in any Ceph command.

Additionally each OpenNebula datastore is backed by a ceph pool, these pools must be created and configured in the Ceph cluster. The name of the pool by default is ``one`` but can be changed on a per-datastore basis (see below).

``ceph`` cluster admin must include a valid user to be used by ``one`` ``ceph`` datastore (see below).

This driver can work with either RBD Format 1 or RBD Format 2. To set the default you can specify this option in ``ceph.conf``:

.. code::

  [global]
  rbd_default_format = 2


OpenNebula Ceph Frontend
------------------------

This driver requires the system administrator to specify one or several Ceph frontends (which need to be nodes in the Ceph cluster) where many of the datastores storage actions will take place. For instance, when creating an image, OpenNebula will choose one of the listed Ceph frontends (using a round-robin algorithm) and transfer the image to that node and run ``qemu-img convert -O rbd``. These nodes need to be specified in the ``BRIDGE_LIST`` section.

Note that this Ceph frontend can be any node in the OpenNebula setup: the OpenNebula frontend, any worker node, or a specific node (recommended).

Ceph Nodes
----------

All the nodes listed in the ``BRIDGE_LIST`` variable must have\ ``qemu-img`` installed.

OpenNebula Hosts
----------------

There are no specific requirements for the host, besides being libvirt/kvm nodes, since xen is not (yet) supported for the Ceph drivers.

Configuration
=============

Configuring the System Datastore
--------------------------------

To use ceph drivers, the system datastore will work both with ``shared`` or as ``ssh``. This sytem datastore will hold only the symbolic links to the block devices, so it will not take much space. See more details on the :ref:`System Datastore Guide <system_ds>`

It will also be used to hold context images and Disks created on the fly, they will be created as regular files.

Configuring Ceph Datastores
---------------------------

The first step to create a Ceph datastore is to set up a template file for it. In the following table you can see the supported configuration attributes. The datastore type is set by its drivers, in this case be sure to add ``DS_MAD=ceph`` and ``TM_MAD=ceph`` for the transfer mechanism, see below.

+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|          Attribute           |                                                                                                                Description                                                                                                                |
+==============================+===========================================================================================================================================================================================================================================+
| ``NAME``                     | The name of the datastore                                                                                                                                                                                                                 |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DS_MAD``                   | The DS type, use ``ceph`` for the Ceph datastore                                                                                                                                                                                          |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``                   | Transfer drivers for the datastore, use ``ceph``, see below                                                                                                                                                                               |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``                | The type **must** be ``RBD``                                                                                                                                                                                                              |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``BRIDGE_LIST``              | **Mandatory** space separated list of Ceph servers that are going to be used as frontends.                                                                                                                                                |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``POOL_NAME``                | The OpenNebula Ceph pool name. Defaults to ``one``. **This pool must exist before using the drivers**.                                                                                                                                    |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``STAGING_DIR``              | Default path for image operations in the OpenNebula Ceph frontend.                                                                                                                                                                        |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``RESTRICTED_DIRS``          | Paths that can not be used to register images. A space separated list of paths.                                                                                                                                                           |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``SAFE_DIRS``                | If you need to un-block a directory under one of the RESTRICTED\_DIRS. A space separated list of paths.                                                                                                                                   |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``NO_DECOMPRESS``            | Do not try to untar or decompress the file to be registered. Useful for specialized Transfer Managers                                                                                                                                     |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``LIMIT_TRANSFER_BW``        | Specify the maximum transfer rate in bytes/second when downloading images from a http/https URL. Suffixes K, M or G can be used.                                                                                                          |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``DATASTORE_CAPACITY_CHECK`` | If ``yes``, the available capacity of the datastore is checked before creating a new image                                                                                                                                                |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CEPH_HOST``                | Space-separated list of Ceph monitors. Example: ``host1 host2:port2 host3 host4:port4`` (if no port is specified, the default one is chosen). **Required for Libvirt 1.x when cephx is enabled** .                                        |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CEPH_USER``                | The OpenNebula Ceph user name. If set it is used by RBD commands. **This ceph user must exist before using the drivers**. **Required for Libvirt 1.x when cephx is enabled** .                                                            |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``CEPH_SECRET``              | A generated UUID for a LibVirt secret (to hold the CephX authentication key in Libvirt on each hypervisor). This should be generated when creating the Ceph datastore in OpenNebula. **Required for Libvirt 1.x when cephx is enabled** . |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``RBD_FORMAT``               | By default RBD Format 1 will be used, with no snapshotting support. If ``RBD_FORMAT=2`` is specified then when instantiating non-persistent images the Ceph driver will perform ``rbd snap`` instead of ``rbd copy``.                     |
+------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. warning:: This will prevent users registering important files as VM images and accessing them through their VMs. OpenNebula will automatically add its configuration directories: /var/lib/one, /etc/one and oneadmin's home. If users try to register an image from a restricted directory, they will get the following error message: “Not allowed to copy image file”.

For example, the following examples illustrates the creation of an Ceph datastore using a configuration file. In this case we will use the host ``cephfrontend`` as one the OpenNebula Ceph frontend The ``one`` pool must already exist, if it doesn't create it with:

.. code::

    > ceph osd pool create one 128

    > ceph osd lspools
    0 data,1 metadata,2 rbd,6 one,

An example of datastore:

.. code::

    > cat ds.conf
    NAME = "cephds"
    DS_MAD = ceph
    TM_MAD = ceph

    # the following lines *must* be preset
    DISK_TYPE = RBD
    POOL_NAME = one

    # CEPH_USER and CEPH_SECRET are mandatory for cephx
    CEPH_USER = libvirt
    CEPH_SECRET="6f88b54b-5dae-41fe-a43e-b2763f601cfc"

    BRIDGE_LIST = cephfrontend

    > onedatastore create ds.conf
    ID: 101

    > onedatastore list
      ID NAME            CLUSTER  IMAGES TYPE   TM
       0 system          none     0      fs     shared
       1 default         none     3      fs     shared
     100 cephds          none     0      ceph   ceph

The DS and TM MAD can be changed later using the ``onedatastore update`` command. You can check more details of the datastore by issuing the ``onedatastore show`` command.

.. warning:: Note that datastores are not associated to any cluster by default, and they are supposed to be accessible by every single host. If you need to configure datastores for just a subset of the hosts take a look to the :ref:`Cluster guide <cluster_guide>`.

After creating a new datastore the LN\_TARGET and CLONE\_TARGET parameters will be added to the template. These values should not be changed since they define the datastore behaviour. The default values for these parameters are defined in :ref:`oned.conf <oned_conf_transfer_driver>` for each driver.

Using Datablocks with Ceph
==========================

It is worth noting that when creating datablock, creating a RAW image is very fast whereas creating a formatted block device takes a longer time. If you want to use a RAW image remember to use the following attribute/option when creating the Image datablock: ``FS_TYPE = RAW``.

Ceph Authentication (Cephx)
===========================

If `Cephx <http://ceph.com/docs/master/rados/operations/authentication/>`__ is enabled, there are some special considerations the OpenNebula administrator must take into account.

Create a Ceph user for the OpenNebula hosts. We will use the name ``client.libvirt``, but any other name is fine. Create the user in Ceph and grant it rwx permissions on the ``one`` pool:

.. code::

    ceph auth get-or-create client.libvirt mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=one'
    ceph auth get-key client.libvirt | tee client.libvirt.key
    ceph auth get client.libvirt -o ceph.client.libvirt.keyring

Distribute the ``client.libvirt.key`` and ``client.libvirt.keyring`` file to all the KVM hosts:
- ``client.libvirt.keyring`` must be placed under ``/etc/ceph`` (in all the hypervisors and frontend)
- ``client.libvirt.key`` must delivered somewhere where oneadmin can read it in order to create the libvirt secret documents.

Generate a UUID, for example running ``uuidgen`` (the generated uuid will referenced as ``$UUID`` from now onwards).

Create a file named ``secret.xml`` (using the generated ``$UUID`` and distribute it to all the KVM hosts:

.. code::

    cat > secret.xml <<EOF
    <secret ephemeral='no' private='no'>
      <uuid>$UUID</uuid>
      <usage type='ceph'>
              <name>client.libvirt secret</name>
      </usage>
    </secret>
    EOF

The following commands must be executed in all the KVM hosts as oneadmin (assuming the ``secret.xml`` and ``client.libvirt.key`` files have been distributed to the hosts):

.. code::

    virsh secret-define secret.xml
    # Replace $UUID with the value generated in the previous step
    virsh secret-set-value --secret $UUID --base64 $(cat client.libvirt.key)

Finally, the Ceph datastore must be updated to add the following values:

.. code::

    CEPH_USER="libvirt"
    CEPH_SECRET="$UUID"
    CEPH_HOST="<list of ceph mon hosts, see table above>"

You can read more information about this in the Ceph guide `Using libvirt with Ceph <http://ceph.com/docs/master/rbd/libvirt/>`__.

Using the Ceph Transfer Driver
==============================

The workflow for Ceph images is similar to the other datastores, which means that a user will create an image inside the Ceph datastores by providing a path to the image file locally available in the OpenNebula frontend, or to an http url, and the driver will convert it to a Ceph block device.

All the usual operations are avalaible: oneimage create, oneimage delete, oneimage clone, oneimage persistent, oneimage nonpersistent, onevm disk-snapshot, etc...

Tuning & Extending
==================

File Location
-------------

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter:

Under ``/var/lib/one/remotes/``:

-  **datastore/ceph/ceph.conf**: Default values for ceph parameters

   -  HOST: Default OpenNebula Ceph frontend
   -  POOL\_NAME: Default volume group
   -  STAGING\_DIR: Default path for image operations in the OpenNebula Ceph frontend.

-  **datastore/ceph/cp**: Registers a new image. Creates a new logical volume in ceph.
-  **datastore/ceph/mkfs**: Makes a new empty image. Creates a new logical volume in ceph.
-  **datastore/ceph/rm**: Removes the ceph logical volume.
-  **tm/ceph/ln**: Does nothing since it's handled by libvirt.
-  **tm/ceph/clone**: Copies the image to a new image.
-  **tm/ceph/mvds**: Saves the image in a Ceph block device for SAVE\_AS.
-  **tm/ceph/delete**: Removes a non-persistent image from the Virtual Machine directory if it hasn't been subject to a ``disk-snapshot`` operation.

Using SSH System Datastore
--------------------------

Another option would be to manually patch the post and pre-migrate scripts for the **ssh** system datastore to ``scp`` the files residing in the system datastore before the live-migration. `Read more <http://lists.opennebula.org/pipermail/users-opennebula.org/2013-April/022705.html>`__.

