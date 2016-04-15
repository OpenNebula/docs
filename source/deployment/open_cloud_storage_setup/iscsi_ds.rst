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


Further notes on Installation and Usage 
========================================

Ubuntu Hypervisors
------------------
Libiscsi is needed for OpenNebula to present the iSCSI LUN to the (KVM) VM running off the qemu hypervisor.

Ubuntu 14.04's  qemu package  does not have libiscsi support built into it (Note: the stock qemu package with Centos is
already libiscsi-enabled, so these steps are unnecessary for Centos Hypervisors). The stock Ubuntu 14.04 Qemu needs to be replaced with a qemu binary that has libiscsi support.  This writeup assumes "opennebula-node" has been installed previously: therefore qemu (without libiscsi)  and libvirt are available on the system.

.. code:: bash

  #On the hypervisor - first install the stock hypervisor software.
   sudo apt-get install opennebula-node

  #installing some packages needed for compiling libiscsi and qemu
   sudo apt-get install -y libvdeplug2 libvdeplug2-dev libaio1 libaio-dev \
   libcap-dev libattr1-dev libsdl-dev libxml2-dev dh-autoreconf 

  #Obtaining the libiscsi and qemu source packages 
  
  #libiscsi (make sure you do not install libiscsi packages via apt)
  git clone https://github.com/sahlberg/libiscsi.git
  cd libiscsi
  ./autogen.sh
  ./configure --prefix=/usr
  make
  sudo make install

  #qemu
  wget http://wiki.qemu-project.org/download/qemu-2.5.0.tar.bz2
  #(This is the current version as of this writing, you may want to get the another version if you want)
  cd qemu-2.5.0/
  ./configure --prefix=/usr \
  --sysconfdir=/etc \
  --enable-kvm \
  --enable-vde \
  --enable-virtfs \
  --enable-linux-aio \
  --enable-libiscsi \
  --enable-sdl \
  --target-list=i386-softmmu,x86_64-softmmu,i386-linux-user,x86_64-linux-user \
  --audio-drv-list=alsa
  make
  sudo make install

Working with iSCSI LUN images
-----------------------------

**Specifying LUN IDs**

Here is an example of an iSCSI LUN template that uses the iSCSI transfer manager.

.. code::

  oneadmin@onedv:~/exampletemplates$ more iscsiimage.tpl
  NAME=iscsi_device_with_lun
  PATH=iqn.2014.01.192.168.50.61:test:7cd2cc1e/0
  ISCSI_HOST=192.168.50.61
  PERSISTENT=YES

Note the explicit "/0" at the end of the IQN target path. This is the iSCSI LUN ID.

**Err state post-VM delete**

Another characteristic of the persistent iSCSI LUNs is that after a VM is deleted, the iSCSI LUN will go into a "err" state; the iSCSI LUN needs to be "re-enabled" before re-using the LUN. Here is an example:

.. code::

  oneadmin@onedv:~/exampletemplates$ onevm list 
      ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
      16 oneadmin oneadmin testvm20        runn  0.5  263.9M 192.168.50   0d 00h49
  oneadmin@onedv:~/exampletemplates$ oneimage list
    ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
     2 oneadmin   oneadmin   Ubuntu 1404, 64 default        10G OS    No used    1
     4 oneadmin   oneadmin   iscsi_device_wi iscsi           0M OS   Yes used    1
  oneadmin@onedv:~/exampletemplates$ onevm delete 16
  oneadmin@onedv:~/exampletemplates$ oneimage list
    ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
     2 oneadmin   oneadmin   Ubuntu 1404, 64 default        10G OS    No rdy     0
     4 oneadmin   oneadmin   iscsi_device_wi iscsi           0M OS   Yes err     0
  oneadmin@onedv:~/exampletemplates$ oneimage enable 4
  oneadmin@onedv:~/exampletemplates$ oneimage list 
    ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
     2 oneadmin   oneadmin   Ubuntu 1404, 64 default        10G OS    No rdy     0
     4 oneadmin   oneadmin   iscsi_device_wi iscsi           0M OS   Yes rdy     0
  oneadmin@onedv:~/exampletemplates$ 

Please refer to this issue (http://dev.opennebula.org/issues/3989) for further information.

**Live-migration**

The iSCSI LUNs are live-migrated when the VMs are live-migrated.

.. code::

  oneadmin@onedv:~/exampletemplates$ onetemplate instantiate 0 --name testvm
  VM ID: 17
  oneadmin@onedv:~/exampletemplates$ onevm list
      ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
      17 oneadmin oneadmin testvm          runn 51.5    256M 192.168.50   0d 00h00
  oneadmin@onedv:~/exampletemplates$ onehost list
    ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT  
     1 192.168.50.232  -           0       0 / 200 (0%)   0K / 993.9M (0%) on    
     6 192.168.50.231  -           1    100 / 200 (50%) 256M / 993.9M (25% on    
  oneadmin@onedv:~/exampletemplates$ oneimage list
    ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
     2 oneadmin   oneadmin   Ubuntu 1404, 64 default        10G OS    No used    1
     4 oneadmin   oneadmin   iscsi_device_wi iscsi           0M OS   Yes used    1
  oneadmin@onedv:~/exampletemplates$ onevm migrate  17 192.168.50.232 --live
  oneadmin@onedv:~/exampletemplates$ onehost list 
    ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT  
     1 192.168.50.232  -           1    100 / 200 (50%) 256M / 993.9M (25% on    
     6 192.168.50.231  -           0       0 / 200 (0%)   0K / 993.9M (0%) on    
  oneadmin@onedv:~/exampletemplates$ 



