.. _intropr:

========================================
Introduction to Private Cloud Computing
========================================

|image0|

The aim of a Private Cloud is not to expose to the world a cloud interface to sell capacity over the Internet, but to **provide local cloud users and administrators with a flexible and agile private infrastructure to run virtualized service workloads within the administrative domain**. OpenNebula virtual infrastructure interfaces expose **user and administrator functionality for virtualization, networking, image and physical resource configuration, management, monitoring and accounting**. This guide briefly describes how OpenNebula operates to build a Cloud infrastructure. After reading this guide you may be interested in reading the :ref:`guide describing how an hybrid cloud operates <introh>` and the :ref:`guide describing how a public cloud operates <introc>`.

The User View
=============

|image1|

An OpenNebula Private Cloud provides infrastructure users with an **elastic platform for fast delivery and scalability of services to meet dynamic demands of service end-users**. Services are hosted in VMs, and then submitted, monitored and controlled in the Cloud by using :ref:`Sunstone <sunstone>` or any of the OpenNebula interfaces:

-  :ref:`Command Line Interface (CLI) <cli>`
-  :ref:`XML-RPC API <api>`
-  OpenNebula :ref:`Ruby <ruby>` and :ref:`Java <java>` Cloud APIs

Lets do a **sample session to illustrate the functionality provided by the OpenNebula CLI for Private Cloud Computing**. First thing to do, **check the hosts in the physical cluster**:

.. code::

     $ onehost list
      ID NAME               RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM   STAT
       0 host01               0    800    800    800    16G    16G    16G     on
       1 host02               0    800    800    800    16G    16G    16G     on

We can then **register an image** in OpenNebula, by using ``oneimage``. We are going to build an :ref:`image template <img_template>` to register the image file we had previously placed in the ``/home/cloud/images`` directory.

.. code::

    NAME          = Ubuntu
    PATH          = /home/cloud/images/ubuntu-desktop/disk.0
    PUBLIC        = YES
    DESCRIPTION   = "Ubuntu 10.04 desktop for students."

.. code::

    $ oneimage create ubuntu.oneimg
    ID: 0

    $ oneimage list
      ID USER     GROUP    NAME            SIZE TYPE          REGTIME PUB PER STAT  RVMS
       1 oneadmin oneadmin Ubuntu           10G   OS   09/29 07:24:35 Yes  No  rdy     0

This image is now ready to be used in a virtual machine. We need to define a :ref:`virtual machine template <template>` to be submitted using the ``onetemplate`` command.

.. code::

    NAME   = my_vm
    CPU    = 1
    MEMORY = 2056

    DISK = [ IMAGE_ID  = 0 ]

    DISK = [ type   = swap,
             size   = 1024 ]

    NIC    = [ NETWORK_ID = 0 ]

Once we have tailored the requirements to our needs (specially, CPU and MEMORY fields), ensuring that the VM *fits* into at least one of both hosts, let's submit the VM (assuming you are currently in your home folder):

.. code::

    $ onetemplate create vm
    ID: 0

    $ onetemplate list
      ID USER     GROUP    NAME                         REGTIME PUB
       0 oneadmin oneadmin my_vm                 09/29 07:28:41  No

The listed template is just a VM definition. To execute an instance, we can use the onetemplate command again:

.. code::

    $ onetemplate instantiate 1
    VM ID: 0

This should come back with an ID, that we can use to identify the VM for **monitoring and controlling**, this time through the use of the ``onevm`` command:

.. code::

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin one-0        runn   0      0K          host01 00 00:00:06

The **STAT** field tells the state of the virtual machine. If there is an **runn** state, the virtual machine is up and running. Depending on how we set up the image, we may be aware of it's IP address. If that is the case we can try now and log into the VM.

To **perform a migration**, we use yet again the ``onevm`` command. Let's move the VM (with VID=0) to *host02* (HID=1):

.. code::

    $ onevm migrate --live 0 1

This will move the VM from *host01* to *host02*. The ``onevm list`` shows something like the following:

.. code::

    $ onevm list
        ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
         0 oneadmin oneadmin one-0        runn   0      0K          host02 00 00:00:48

You can also reproduce this sample session using the graphical interface provided by :ref:`Sunstone <sunstone>`, that will simplify the typical management operations.

|image2|

Next Steps
==========

You can now read the different guides describing how to define and manage virtual resources on your OpenNebula cloud:

-  :ref:`Virtual Networks <vgg>`
-  :ref:`Virtual Machine Images <img_guide>`
-  :ref:`Virtual Machine Templates <vm_guide>`
-  :ref:`Virtual Machine Instances <vm_guide_2>`

You can also install :ref:`OneFlow <oneapps_overview>` to allows users and administrators to define, execute and manage multi-tiered applications composed of interconnected Virtual Machines with auto-scaling.

.. |image0| image:: /images/privatecloud.png
.. |image1| image:: /images/userview.png
.. |image2| image:: /images/sunstone_vm_list.png
