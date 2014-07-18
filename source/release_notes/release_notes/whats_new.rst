.. _whats_new:

=================
What's New in 4.8
=================

.. todo:: intro

In the following list you can check the highlights of OpenNebula 4.8 .. todo:: Carina
organised by component (`a detailed list of changes can be found here
<http://dev.opennebula.org/projects/opennebula/issues?query_id=55>`__):

.. todo:: link to redmine release 4.8 is missing the tickets planned for 4.8 beta


Hybrid Clouds
--------------------------------------------------------------------------------

.. todo:: #2989 Integrate with Microsoft Azure API

.. todo:: #2959 Integrate with SoftLayer

OneFlow
--------------------------------------------------------------------------------

.. todo:: #2917 Pass information between roles, using onegate facilities


Sunstone
--------------------------------------------------------------------------------

.. todo:: New vdcadmin view
.. todo:: New flow integration in cloud views
.. todo:: #2977 Customize available actions in cloud/admin views

Virtual Networks
-------------------------------------

- You can now define a ``NIC_DEFAULT`` attribute with values that will be copied to each new ``NIC``. This is specially useful for an administrator to define configuration parameters, such as ``MODEL = "virtio``.

.. todo:: New vnet model

.. todo:: #2927 specify which default gateway to use if there are multiple nics

- ARP Cache poisoning prevention can be globally disabled in Open vSwitch: :ref:`arp_cache_poisoning <openvswitch_arp_cache_poisoning>`.

Contextualization
-------------------------------------

- .. todo:: #3008 Move context packages to addon repositories
- .. todo:: #2395 windows guest context

Usage Quotas
--------------------------------------------------------------------------------

- Now you can set a quota of '0' to completely disallow resource usage. Read the :ref:`Quota Management documentation <quota_auth>` for more information.

Images and Storage
--------------------------------------------------------------------------------

- Images can now be :ref:`cloned to a different Datastore <img_guide>`. The only restriction is that the new Datastore must be compatible with the current one, i.e. have the same DS_MAD drivers.

.. todo:: #2530 disk iotune

.. todo:: #2970 Enable use of devices as disks

.. todo:: #2877 RBD format 2 support for MKFS

Public Clouds APIs
--------------------------------------------------------------------------------

.. todo:: #3041 Move OCCI from the main repository to an addon


Packaging
--------------------------------------------------------------------------------
.. todo:: #2429 Compatibility with heartbeat







.. todo:: include? #2950 zone id in logs
