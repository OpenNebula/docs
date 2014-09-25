.. _vcenterg:

======================
VMware vCenter Drivers
======================

OpenNebula seamlessly integrates vCenter virtualized infrastructures leveraging the VMware product features such as vMotion, HA or DRS scheduling. On top of it, OpenNebula exposes a multi-tenancy and cloud like provisioning layer, including advanced features like datacenter federation or hybrid cloud computing to connect in-house vCenter infrastructures with public clouds.

The OpenNebula - vCenter combination allows you to deploy advanced provisioning infrastructures of virtualized resources. In this guide you'll learn how to configure OpenNebula to access one or more vCenters and set-up VMware-based virtual machines for launch.

Overview and Architecture
=========================

The VMware vCenter drivers enables OpenNebula to access one or more vCenter servers that manages one or more ESX Clusters. Each ESX Cluster is then presented in OpenNebula as an aggregated hyperviosr, i.e. as an OpenNebula host. Note that OpenNebula scheduling decisions are therefore made at ESX Cluster level, vCenter uses then the DRS component to select the actual ESX host and Datastore to deploy the Virtual Machine.

As the figure shows, the OpenNebula components see two hosts that each represents a cluster in a vCenter. You can further group this hosts into OpenNebula clusters to build complex resource providers for your user groups in OpenNebula.

.. note:: Together with the ESX Cluster hosts you can add other hypervisor types or even hybrid cloud instances like Microsoft Azure or Amazon EC2.

.. image:: /images/JV_architecture.png
    :width: 250px
    :align: center

Virtual Machines are deployed from VMware VM Templates. There is a one-to-one relationship between each VMware VM Template and the equivalent OpenNebula Template. Users will then instantiate the OpenNebula Templates where you can easily build from any provisioning strategy (e.g. access control, quota...).

Therefore there is no need to convert your current Virtual Machines or import/export them through any process; once ready just save them as VM Templates in vCenter.

.. note:: After a VM Template is cloned and booted into a vCenter Cluster it can access VMware advanced features and it can be managed through the OpenNebula provisioning portal or through vCenter (e.g. to move the VM to another datastore or migrate it to another ESX).

Requirements
============

The following must be meet for a functional vCenter environment:

- Define a vCenter user to access the clusters. The user needs access to the following permissions:

+-------------------------+----------------------------------------------------+
| vCenter Operation       | Notes                                              |
+-------------------------+----------------------------------------------------+
| cloneVM...              |                                                    |
+-------------------------+----------------------------------------------------+

.. note:: For security reasons, you may define different users to access different ESX Clusters.

- Enable DRS and shared storage for the ESX Clusters that are going to be exposed to OpenNebula.

- Save as VMs Templates those VMs that will be instantiated through the OpenNebula provisioning portal.

.. important:: OpenNebula will *NOT* modify any vCenter configuration or manage any existing Virtual Machine.

Considerations & Limitations
============================
- No context
- Not supported actions
- No security groups
- VNC ports

Configuration
=============

OpenNebula Configuration
------------------------

Just enable the drivers, need connectivity with the vCenters, need connectivity
with ESX for VNC access.

Usage
=====

Importing vCenter Clusters and VM Templates
-------------------------------------------

The JV tool, sample session (e.g. based on the screenies)

VMTemplate definition
---------------------

Describe the supported attributes for a Template (MEMORY, CPU, GRAPHICS, PUBLIC_CLOUD)

Procedure to add new templates

VM Scheduling
-------------

Describe SCHED_REQUIREMENTS and DRS. Also describe the clonning proceure:
- Cloning options diskParent...
- Default ResourcePool
