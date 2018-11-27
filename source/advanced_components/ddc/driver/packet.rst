.. _ddc_driver_packet:

=============
Packet Driver
=============

Requirements:

* existing Packet project
* generated Packet `API token <https://help.packet.net/quick-start/api-integrations>`_

Supported Packet hosts:

* operating systems: ``centos_7``, ``ubuntu_16_04``, ``ubuntu_18_04``
* plans: ``baremetal_0``

.. _ddc_driver_packet_params:

Provision parameters
====================

The parameters specifying the Packet provision are set in the **provision section** of the :ref:`provision template <ddc_provision_template>`. The following table shows mandatory and optional provision parameters for the Packet driver. No other options/features are supported.

================== ========= ===========
Parameter          Mandatory Description
================== ========= ===========
``packet_project`` **YES**   ID of the existing project you want to deploy the new host
``packet_token``   **YES**   API token
``facility``       **YES**   Datacenter to deploy the host
``plan``           **YES**   Type of HW plan (Packet ID or slug)
``os``             **YES**   Operating system (Packet ID or slug)
``hostname``       NO        Hostname set in the booted operating system (and on Packet dashboard)
``billing_cycle``  NO        Billing period
``userdata``       NO        Custom EC2-like user data passed to the ``cloud-init`` running on host
``tags``           NO        Host tags in the Packet inventory
================== ========= ===========

Example
=======

Example of minimal Packet provision template:

.. code::

    ---
    version: 2
    name: myprovision

    defaults:
      provision:
        driver: packet
        packet_token: ********************************
        packet_project: ************************************
        facility: ams1
        plan: baremetal_0
        os: ubuntu_18_04

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "host1"
