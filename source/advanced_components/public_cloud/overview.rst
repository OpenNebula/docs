.. _introc:

========================
Overview
========================

.. todo:: outdated guide. review further

What is a Public Cloud?
=======================

|image0|

A Public Cloud is an **extension of a Private Cloud to expose RESTful Cloud interfaces**. Cloud interfaces can be added to your Private or Hybrid Cloud if you want to provide partners or external users with access to your infrastructure, or to sell your overcapacity. Obviously, a local cloud solution is the natural back-end for any public cloud.

The User View
=============

The following interfaces provide a **simple and remote management of cloud (virtual) resources at a high abstraction level**:

-  :ref:`EC2 Query subset <ec2qcg>`

Users will be able to use commands that\ **clone the functionality of the EC2 Cloud service**. Starting with a working installation of an OS residing on an **.img** file, with three simple steps a user can launch it in the cloud.

First, they will be able to **upload** it to the cloud using:

.. code::

    $ ./econe-upload /images/gentoo.img
    Success: ImageId ami-00000001

After the image is uploaded in OpenNebula repository, it needs to be **registered** to be used in the cloud:

.. code::

    $ ./econe-register ami-00000001
    Success: ImageId ami-00000001

Now the user can **launch** the registered image to be run in the cloud:

.. code::

    $ ./econe-run-instances -H ami-00000001
    Owner       ImageId                InstanceId InstanceType
    ------------------------------------------------------------------------------
    helen       ami-00000001           i-15       m1.small

Additionally, the instance can be **monitored** with:

.. code::

    $ ./econe-describe-instances  -H
    Owner       Id    ImageId      State         IP              Type
    ------------------------------------------------------------------------------------------------------------
    helen       i-15  ami-00000001 pending       147.96.80.33     m1.small

How the System Operates
=======================

There is **no modification in the operation of OpenNebula to expose Cloud interfaces**. Users can interface the infrastructure using any Private or Public Cloud interface.

.. |image0| image:: /images/publiccloud.png

Hypervisor Compatibility
================================================================================

This chapter applies both to KVM and vCenter.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Deployment Guide <deployment_guide>`.

Read the :ref:`EC2 Server Configuration <ec2qcg>` to understand how to start the EC2 API for OpenNebula. :ref:`OpenNebula EC2 User Guide <ec2qug>` contains a reference of the supported commands and their usage. In :ref:`EC2 Ecosystem <ec2qec>` you can find information about specific EC2 Ecosystem components and how to configure them to connect to OpenNebula.

After reading this chapter you can continue configuring more :ref:`Advanced Components <advanced_components>`.
