.. _iscsi_ds:

===================
The iSCSI Datastore
===================

This datastore is used to register already existing iSCSI volume available to the hypervisor nodes, to be used with virtual machines. It does not do any kind of device discovering or setup. The iSCSI volume should already exists and be available for all the hypervisors. The Virtual Machines will see this device as a regular disk.

.. warning:: This driver **only** works with KVM hosts.

Requirements
============

The devices you want to attach to a VM should be accessible by the hypervisor.

Images created in this datastore should be persistent. Making the images non persistent allows more than one VM use this device and will probably cause problems and data corruption.

.. warning:: The datastore should only be usable by the administrators. Letting users create images in this datastore can cause security problems.

Configuration
=============

Configuring the System Datastore
--------------------------------

The system datastore can be of type ``shared`` or ``ssh``. See more details on the :ref:`System Datastore Guide <system_ds>`


Configuring DEV Datastore
-------------------------

The datastore needs to have: ``DS_MAD`` and ``TM_MAD`` set to ``iscsi`` and ``DISK_TYPE`` to ``BLOCK``.

+-----------------+-------------------------------------------------------------------------------------------------------------------------+
|    Attribute    |                                                       Description                                                       |
+=================+=========================================================================================================================+
| ``NAME``        | The name of the datastore                                                                                               |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+
| ``DS_MAD``      | ``iscsi``                                                                                                               |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+
| ``TM_MAD``      | ``iscsi``                                                                                                               |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+
| ``DISK_TYPE``   | ``ISCSI``                                                                                                               |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+
| ``ISCSI_HOST``  | iSCSI Host. Example: ``host`` or ``host:port``.                                                                         |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+
| ``ISCSI_USER``  | Optional (requires ``ISCSI_USAGE``). If supplied, this user will be used for the iSCSI CHAP authentication.             |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+
| ``ISCSI_USAGE`` | Optional (required by ``ISCSI_USER``). ``Usage`` of the registered secret that contains the CHAP Authentication string. |
+-----------------+-------------------------------------------------------------------------------------------------------------------------+

Note that for this datastore some of the :ref:`common datastore attributes <sm_common_attributes>` do **not** apply, in particular:
- ``BASE_PATH``: does **NOT** apply
- ``RESTRICTED_DIRS``: does **NOT** apply
- ``SAFE_DIRS``: does **NOT** apply
- ``NO_DECOMPRESS``: does **NOT** apply
- ``LIMIT_TRANSFER_BW``: does **NOT** apply
- ``DATASTORE_CAPACITY_CHECK``: does **NOT** apply

An example of datastore:

.. code::

    > cat iscsi.ds
    NAME=iscsi
    DISK_TYPE="ISCSI"
    DS_MAD="iscsi"
    TM_MAD="iscsi"
    ISCSI_HOST="the_iscsi_host"
    ISCSI_USER="the_iscsi_user"
    ISCSI_USAGE="the_iscsi_usage"

    > onedatastore create iscsi.ds
    ID: 101

    > onedatastore list
      ID NAME                SIZE AVAIL CLUSTER      IMAGES TYPE DS       TM
       0 system              9.9G 98%   -                 0 sys  -        shared
       1 default             9.9G 98%   -                 2 img  shared   shared
       2 files              12.3G 66%   -                 0 fil  fs       ssh
     101 iscsi                 1M 100%  -                 0 img  dev      dev

Use
===

New images can be added as any other image specifying the path. If you are using the CLI **do not use the shorthand parameters** as the CLI check if the file exists and the device most provably won't exist in the frontend. As an example here is an image template to add a node disk ``iqn.1992-01.com.example:storage:diskarrays-sn-a8675309``:

.. code:: bash

    NAME=iscsi_device
    PATH=iqn.1992-01.com.example:storage:diskarrays-sn-a8675309
    PERSISTENT=YES

.. warning:: As this datastore does is just a container for existing devices images does not take any size from it. All devices registered will render size of 0 and the overall devices datastore will show up with 1MB of available space

Note that you may override the Datastore ``ISCSI_HOST``, ``ISCSI_USER``` and ``ISCSI_USAGE`` parameters in the image template, in case you do not want to use the values defined in the datastore template. These overridden parameters will come into effect for new Virtual Machines.

The resulting image template, if you are overriding the aforementioned attributes would take the following form:

.. code:: bash

    NAME=iscsi_device
    PATH=iqn.1992-01.com.example:storage:diskarrays-sn-a8675309
    PERSISTENT=YES
    ISCSI_HOST="the_iscsi_host2"
    ISCSI_USER="the_iscsi_user2"
    ISCSI_USAGE="the_iscsi_usage2"

You don't need to override all of them, you can override any number of the above attributes.

Changing the IQN
----------------

You may change the IQN by defining ``ISCSI_IQN`` in the image template:

.. code::

  ISCSI_IQN="iqn.1992-01.com.example:storage.tape1.sys1.xyz"

Note that like before, it will only come into effect for new Virtual Machines.

iSCSI CHAP Authentication
=========================

In order to use CHAP authentication, you will need to create a libvirt secret in **all** the hypervisors. Follow this `Libvirt Secret XML format <https://libvirt.org/formatsecret.html#iSCSIUsageType>`__ guide to register the secret. Take this into consideration:

- ``incominguser`` field on the iSCSI authentication file should match the Datastore's ``ISCSI_USER`` parameter.
- ``<target>`` field in the secret XML document will contain the ``ISCSI_USAGE`` paremeter.
- Do this in all the hypervisors.
