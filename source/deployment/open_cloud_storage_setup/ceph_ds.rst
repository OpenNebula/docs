.. _ceph_ds:

==============
Ceph Datastore
==============

The Ceph datastore driver provides OpenNebula users with the possibility of using Ceph block devices as their Virtual Images.

.. warning:: This driver requires that the OpenNebula nodes using the Ceph driver must be Ceph clients of a running Ceph cluster. More information in `Ceph documentation <http://ceph.com/docs/master/>`__.

Datastore Layout
================================================================================

Images and virtual machine disks are stored in the same Ceph pool. Each Image is named ``one-<IMAGE ID>`` in the pool. By default an image that is saved on Image Datastore backed by a Ceph pool will deploy on a Ceph System Datastore at least that you change this behavior in the virtual machine template if you want to deploy the virtual machine on SSH System Datastore.

Ceph (Default)
--------------------------------------------------------------------------------
Virtual machines will use these rbd volumes for its disks if the Images are persistent, otherwise new snapshots are created in the form ``one-<IMAGE ID>-<VM ID>-<DISK ID>``.

For example, consider a system using an Image and System Datastore backed by a Ceph pool named ``one``. The pool with one Image (ID 0) and two Virtual Machines 14 and 15 using this Image as virtual disk 0 would be similar to:

.. prompt:: bash $ auto

    $ rbd ls -l -p one --id libvirt
    NAME         SIZE PARENT         FMT PROT LOCK
    one-0      10240M                  2
    one-0@snap 10240M                  2 yes
    one-0-14-0 10240M one/one-0@snap   2
    one-0-15-0 10240M one/one-0@snap   2


.. note:: In this case context disk and auxiliar files (deployment description and checkpoints) are stored locally in the nodes.

SSH
--------------------------------------------------------------------------------
Virtual machines that have been deployed with a template whose ``DISK`` attribute changes the behavior to deploy the machine, will have the disks with type FILE.

For example, consider a system using an Image backed by a Ceph pool and System Datastore backed by a SSH pool (ID=100). The pool with one Image and one Virtual Machine (ID=39) and this Image as virtual disk 0 would be similar to:

.. prompt:: bash $ auto

    $ ls -l /var/lib/one/datastores/100/39
    total 609228
    -rw-rw-r-- 1 oneadmin oneadmin        1020 Dec 20 14:41 deployment.0
    -rw-r--r-- 1 oneadmin oneadmin 10737418240 Dec 20 15:19 disk.0
    -rw-rw-r-- 1 oneadmin oneadmin      372736 Dec 20 14:41 disk.1

.. note:: All disk attributes that are defined in the template, must to have the same ``TM_MAD_SYSTEM`` or not have it defined.

.. important:: Only is necessary to register once image.

Ceph Cluster Setup
================================================================================

This guide assumes that you already have a functional Ceph cluster in place. Additionally you need to:

* Create a pool for the OpenNebula datastores. Write down the name of the pool to include it in the datastore definitions.

.. prompt:: bash $ auto

    $ ceph osd pool create one 128

    $ ceph osd lspools
    0 data,1 metadata,2 rbd,6 one,

* Define a Ceph user to access the datastore pool; this user will also be used by libvirt to access the disk images. For example, create a user ``libvirt``:

On the **Ceph Jewel** (v10.2.x) and before:

.. prompt:: bash $ auto

    $ ceph auth get-or-create client.libvirt \
          mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=one'

On the **Ceph Luminous** (v12.2.x) and later:

.. prompt:: bash $ auto

    $ ceph auth get-or-create client.libvirt \
          mon 'profile rbd' osd 'profile rbd pool=one'

.. warning::

    Ceph Luminous release comes with simplified RBD capabilities (more information about user management and authorization capabilities is in the Ceph `documentation <http://docs.ceph.com/docs/master/rados/operations/user-management/#authorization-capabilities>`__). When **upgrading existing Ceph deployment to the Luminous and later**, please ensure the selected user has proper new capabilities. For example, for above user ``libvirt`` by running:

    .. prompt:: bash $ auto

        $ ceph auth caps client.libvirt \
              mon 'profile rbd' osd 'profile rbd pool=one'

* Get a copy of the key of this user to distribute it later to the OpenNebula nodes.

.. prompt:: bash $ auto

    $ ceph auth get-key client.libvirt | tee client.libvirt.key

    $ ceph auth get client.libvirt -o ceph.client.libvirt.keyring

* Although RBD format 1 is supported it is strongly recommended to use Format 2. Check that ``ceph.conf`` includes:

.. code::

  [global]
  rbd_default_format = 2

* Pick a set of client nodes of the cluster to act as storage bridges. These nodes will be used to import images into the Ceph Cluster from OpenNebula. These nodes must have ``qemu-img`` command installed.

.. note:: For production environments it is recommended to **not co-allocate** ceph services (monitor, osds) with OpenNebula nodes or front-end

Frontend and Node Setup
================================================================================

In order to use the Ceph cluster the nodes need to be configured as follows:

* The ceph client tools must be available in the machine

* The ``mon`` daemon must be defined in the ``ceph.conf`` for all the nodes, so ``hostname`` and ``port`` doesn't need to be specified explicitly in any Ceph command.

* Copy the Ceph user keyring (``ceph.client.libvirt.keyring``) to the nodes under ``/etc/ceph``, and the user key (``client.libvirt.key``) to the oneadmin home.

.. prompt:: bash $ auto

    $ scp ceph.client.libvirt.keyring root@node:/etc/ceph

    $ scp client.libvirt.key oneadmin@node:

Node Setup
================================================================================

Nodes need extra steps to setup credentials in libvirt:

* Generate a secret for the Ceph user and copy it to the nodes under oneadmin home. Write down the ``UUID`` for later use.

.. prompt:: bash $ auto

    $ UUID=`uuidgen`; echo $UUID
    c7bdeabf-5f2a-4094-9413-58c6a9590980

    $ cat > secret.xml <<EOF
    <secret ephemeral='no' private='no'>
      <uuid>$UUID</uuid>
      <usage type='ceph'>
              <name>client.libvirt secret</name>
      </usage>
    </secret>
    EOF

    $ scp secret.xml oneadmin@node:

* Define the a  libvirt secret and remove key files in the nodes:

.. prompt:: bash $ auto

    $ virsh -c qemu:///system secret-define secret.xml

    $ virsh -c qemu:///system secret-set-value --secret $UUID --base64 $(cat client.libvirt.key)

    $ rm client.libvirt.key

* The ``oneadmin`` account needs to access the Ceph Cluster using the ``libvirt`` Ceph user defined above. This requires access to the ceph user keyring. Test that Ceph client is properly configured in the node.

.. prompt:: bash $ auto

  $ ssh oneadmin@node

  $ rbd ls -p one --id libvirt

You can read more information about this in the Ceph guide `Using libvirt with Ceph <http://ceph.com/docs/master/rbd/libvirt/>`__.

* Ancillary virtual machine files like context disks, deployment and checkpoint files are created at the nodes under ``/var/lib/one/datastores/``, make sure that enough storage for these files is provisioned in the nodes.

* If you are going to deploy the machine with the disks in SSH mode, you have to take into account the space of the system datastore ``/var/lib/one/datastores/<ds_id>`` where ``ds_id`` is the ID of the System Datastore.

.. _ceph_ds_templates:

OpenNebula Configuration
================================================================================

To use your Ceph cluster with the OpenNebula, you need to define a System and Image datastores. Each Image/System Datastore pair will share same following Ceph configuration attributes:

+-----------------+---------------------------------------------------------+-----------+
| Attribute       | Description                                             | Mandatory |
+=================+=========================================================+===========+
| ``NAME``        | The name of the datastore                               | **YES**   |
+-----------------+---------------------------------------------------------+-----------+
| ``POOL_NAME``   | The Ceph pool name                                      | **YES**   |
+-----------------+---------------------------------------------------------+-----------+
| ``CEPH_USER``   | The Ceph user name, used by libvirt and rbd commands.   | **YES**   |
+-----------------+---------------------------------------------------------+-----------+
| ``CEPH_KEY``    | Key file for user, if not set default locations are     | NO        |
|                 | used                                                    |           |
+-----------------+---------------------------------------------------------+-----------+
| ``CEPH_CONF``   | Non default ceph configuration file if needed.          | NO        |
+-----------------+---------------------------------------------------------+-----------+
| ``RBD_FORMAT``  | By default RBD Format 2 will be used.                   | NO        |
+-----------------+---------------------------------------------------------+-----------+
| ``BRIDGE_LIST`` | List of storage bridges to access the Ceph cluster      | **YES**   |
+-----------------+---------------------------------------------------------+-----------+
| ``CEPH_HOST``   | Space-separated list of Ceph monitors. Example: ``host1 | **YES**   |
|                 | host2:port2 host3 host4:port4``.                        |           |
+-----------------+---------------------------------------------------------+-----------+
| ``CEPH_SECRET`` | The UUID of the libvirt secret.                         | **YES**   |
+-----------------+---------------------------------------------------------+-----------+
| ``POOL_NAME``   | Name of Ceph pool                                       | **YES**   |
+-----------------+---------------------------------------------------------+-----------+

.. note:: You may add another Image and System Datastores pointing to other pools with different allocation/replication policies in Ceph.

Create a System Datastore
--------------------------------------------------------------------------------

System Datastore also requires these attributes:

+-----------------+-----------------------------------------------------------+-----------+
|    Attribute    |  Description                                              | Mandatory |
+=================+===========================================================+===========+
| ``TYPE``        | ``SYSTEM_DS``                                             | **YES**   |
+-----------------+-----------------------------------------------------------+-----------+
| ``TM_MAD``      | ``ceph`` (only with local FS on the DS directory)         | **YES**   |
|                 |                                                           |           |
|                 | ``shared`` for shared transfer mode (only with shared FS) |           |
+-----------------+-----------------------------------------------------------+-----------+

.. note:: Ceph can also work with a System Datastore of type Filesystem in a shared transfer mode, as described :ref:`in the Filesystem Datastore section <fs_ds>`. In that case volatile and swap disks are created as plain files in the System Datastore. Note that apart from the Ceph Cluster you need to setup and mount a shared FS on the System Datastore directory.

.. warning:: The correct transfer mode TM_MAD must be specified for the System Datastore. Otherwise, you can experience the data loss while treating the shared filesystem as a local!

Create a System Datastore in Sunstone or through the CLI, for example:

.. prompt:: text $ auto

    $ cat systemds.txt
    NAME    = ceph_system
    TM_MAD  = ceph
    TYPE    = SYSTEM_DS

    POOL_NAME   = one
    CEPH_HOST   = "host1 host2:port2"
    CEPH_USER   = libvirt
    CEPH_SECRET = "6f88b54b-5dae-41fe-a43e-b2763f601cfc"

    BRIDGE_LIST = cephfrontend

    $ onedatastore create systemds.txt
    ID: 101


Create an Image Datastore
--------------------------------------------------------------------------------

Apart from the previous attributes, that need to be the same as the associated System Datastore, the following can be set for an Image Datastore:

+-----------------+-------------------------------------------------------+-----------+
| Attribute       | Description                                           | Mandatory |
+=================+=======================================================+===========+
| ``NAME``        | The name of the datastore                             | **YES**   |
+-----------------+-------------------------------------------------------+-----------+
| ``DS_MAD``      | ``ceph``                                              | **YES**   |
+-----------------+-------------------------------------------------------+-----------+
| ``TM_MAD``      | ``ceph``                                              | **YES**   |
+-----------------+-------------------------------------------------------+-----------+
| ``DISK_TYPE``   | ``RBD``                                               | **YES**   |
+-----------------+-------------------------------------------------------+-----------+
| ``STAGING_DIR`` | Default path for image operations in the bridges      | NO        |
+-----------------+-------------------------------------------------------+-----------+

An example of datastore:

.. code::

    > cat ds.conf
    NAME = "cephds"
    DS_MAD = ceph
    TM_MAD = ceph

    DISK_TYPE = RBD

    POOL_NAME   = one
    CEPH_HOST   = "host1 host2:port2"
    CEPH_USER   = libvirt
    CEPH_SECRET = "6f88b54b-5dae-41fe-a43e-b2763f601cfc"

    BRIDGE_LIST = cephfrontend

    > onedatastore create ds.conf
    ID: 101


.. warning:: If you are going to use the TM_MAD_SYSTEM attribute with SSH mode, you must take into account that you need to have an :ref:`SSH type system Datastore <fs_ds>`

Additional Configuration
--------------------------------------------------------------------------------

Default values for the Ceph drivers can be set in ``/var/lib/one/remotes/datastore/ceph/ceph.conf``:

* ``POOL_NAME``: Default volume group
* ``STAGING_DIR``: Default path for image operations in the storage bridges
* ``RBD_FORMAT``: Default format for RBD volumes.

Using different modes
--------------------------------------------------------------------------------

How to save an Image in different modes. Only have to add an attribute into the ``DISK`` attribute to the virtual machine template.

* ``DISK/TM_MAD_SYSTEM``: Define a ``DS_REQUIREMENT`` for deploy the virtual machine.

You can define this disk attribute through the CLI or in Sunstone.
