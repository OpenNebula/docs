.. _iscsi_ds:

================================================================================
iSCSI - Libvirt Datastore
================================================================================

This datastore is used to register already existing iSCSI volume available to the hypervisor nodes

.. warning:: The datastore should only be usable by the administrators. Letting users create images in this datastore can cause security problems.

Frontend Setup
================================================================================
No additional configuration is needed

Node Setup
================================================================================
The nodes need to meet the following requirements:

* The devices you want to attach to a VM should be accessible by the hypervisor.
* Qemu needs to be compiled with Libiscsi support.

iSCSI CHAP Authentication
--------------------------------------------------------------------------------
In order to use CHAP authentication, you will need to create a libvirt secret in **all** the hypervisors. Follow this `Libvirt Secret XML format <https://libvirt.org/formatsecret.html#iSCSIUsageType>`__ guide to register the secret. Take this into consideration:

* ``incominguser`` field on the iSCSI authentication file should match the Datastore's ``ISCSI_USER`` parameter.
* ``<target>`` field in the secret XML document will contain the ``ISCSI_USAGE`` paremeter.
* Do this in all the hypervisors.


.. _iscsi_ds_templates:

OpenNebula Configuration
================================================================================
Once the storage is setup, the OpenNebula configuration comprises two steps:

* Create a System Datastore
* Create an Image Datastore

Create a System Datastore
--------------------------------------------------------------------------------

The RDM Datastore can work with the following System Datastores:

* Filesystem, shared transfer mode
* Filesystem, ssh transfer mode

Please refer to the :ref:`Filesystem Datastore section <fs_ds>` for more details. Note that the System Datastore is only used for volatile disks and context devices.


Create an Image Datastore
--------------------------------------------------------------------------------

To create an Image Datastore you just need to define the name, and set the following:

+----------------+-------------------------------------------------+
|   Attribute    |                   Description                   |
+================+=================================================+
| ``NAME``       | The name of the datastore                       |
+----------------+-------------------------------------------------+
| ``TYPE``       | ``IMAGE_DS``                                    |
+----------------+-------------------------------------------------+
| ``DS_MAD``     | ``iscsi_libvirt``                               |
+----------------+-------------------------------------------------+
| ``TM_MAD``     | ``iscsi_libvirt``                               |
+----------------+-------------------------------------------------+
| ``DISK_TYPE``  | ``ISCSI``                                       |
+----------------+-------------------------------------------------+
| ``ISCSI_HOST`` | iSCSI Host. Example: ``host`` or ``host:port``. |
+----------------+-------------------------------------------------+

If you need to use CHAP authentication (optional) add the following attributes to the datastore:

+-----------------+-------------------------------------------------+
|   Attribute     |                   Description                   |
+=================+=================================================+
| ``ISCSI_USAGE`` | Usage of the secret with the CHAP Auth string.  |
+-----------------+-------------------------------------------------+
| ``ISCSI_USER``  | user the iSCSI CHAP authentication.             |
+-----------------+-------------------------------------------------+

An example of datastore:

.. code::

    > cat iscsi.ds
    NAME = iscsi

    DISK_TYPE = "ISCSI"

    DS_MAD = "iscsi_libvirt"
    TM_MAD = "iscsi_libvirt"

    ISCSI_HOST  = "the_iscsi_host"
    ISCSI_USER  = "the_iscsi_user"
    ISCSI_USAGE = "the_iscsi_usage"

    > onedatastore create iscsi.ds
    ID: 101

.. warning:: Images created in this datastore should be persistent. Making the images non persistent allows more than one VM use this device and will probably cause problems and data corruption.

Datastore Usage
================================================================================

New images can be added as any other image specifying the path. If you are using the CLI **do not use the shorthand parameters** as the CLI check if the file exists and the device most probably won't exist in the frontend.

As an example here is an image template to add a node disk ``iqn.1992-01.com.example:storage:diskarrays-sn-a8675309``:

.. code::

    NAME = iscsi_device
    PATH = iqn.1992-01.com.example:storage:diskarrays-sn-a8675309
    PERSISTENT = YES

.. warning:: As this datastore does is just a container for existing devices images does not take any size from it. All devices registered will render size of 0 and the overall devices datastore will show up with 1MB of available space

.. note:: You may override any of the following: ``ISCSI_HOST``, ``ISCSI_USER```, ``ISCSI_USAGE`` and ``ISCSI_IQN`` parameters in the image template. These overridden parameters will come into effect for new Virtual Machines.

Here is an example of an iSCSI LUN template that uses the iSCSI transfer manager.

.. code::

  oneadmin@onedv:~/exampletemplates$ more iscsiimage.tpl
  NAME=iscsi_device_with_lun
  PATH=iqn.2014.01.192.168.50.61:test:7cd2cc1e/0
  ISCSI_HOST=192.168.50.61
  PERSISTENT=YES

Note the explicit "/0" at the end of the IQN target path. This is the iSCSI LUN ID.

