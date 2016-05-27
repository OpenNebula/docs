.. _introc:

================================================================================
Overview
================================================================================

.. todo::

    * Architect
    * Admin
    * KVM
    * vCenter

A Public Cloud is an **extension of a Private Cloud to expose RESTful Cloud interfaces**. Cloud interfaces can be added to your Private or Hybrid Cloud if you want to provide partners or external users with access to your infrastructure, or to sell your overcapacity. Obviously, a local cloud solution is the natural back-end for any public cloud.

The :ref:`EC2 Query subset <ec2qcg>` interfaces provide a simple and remote management of cloud (virtual) resources at a high abstraction level. There is no modification in the operation of OpenNebula to expose Cloud interfaces. Users can interface the infrastructure using any Private or Public Cloud interface.

.. |image0| image:: /images/publiccloud.png

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you have read the :ref:`Deployment Guide <deployment_guide>`.

Read the :ref:`EC2 Server Configuration <ec2qcg>` to understand how to start the EC2 API for OpenNebula. :ref:`OpenNebula EC2 User Guide <ec2qug>` contains a reference of the supported commands and their usage.

After reading this chapter you can continue configuring more :ref:`Advanced Components <advanced_components>`.

Hypervisor Compatibility
================================================================================

This Chapter applies both to KVM and vCenter.
