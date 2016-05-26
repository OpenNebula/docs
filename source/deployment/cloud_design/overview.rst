================================================================================
Overview
================================================================================

.. todo:: Jaime's Table

    -* Cloud Architect
    -* KVM
    -* vCenter

The first step of building a reliable, useful and successful cloud is to decide a clear design. This design needs to be aligned with the expected use of the cloud, and it needs to describe which data center components are going to be part of the cloud. This comprises i) all the infrastructure components such as networking, storage, authorization and virtualization back-ends, as well as the ii) planned dimension of the cloud (characteristics of the workload, numbers of users and so on) and the iii) provisioning workflow, ie, how end users are going to be isolated and using the cloud.

How Should I Read This Chapter
================================================================================

This is the first Chapter to read, as it introduces the needed concepts to correctly define a cloud architecture.

Within this Chapter, as first step a design of the cloud and its dimension should be drafted. For KVM clouds proceed to :ref:`Open Cloud Architecture <open_cloud_architecture>` and for vCenter clouds read :ref:`VMware Cloud Architecture <vmware_cloud_architecture>`.

Then you could read the :ref:`OpenNebula Provisioning Model <understand>` to identify the wanted model to provision resources to end users. In a small installation with a few hosts, you can skip this provisioning model guide and use OpenNebula without giving much thought to infrastructure partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure.

Once the cloud architecture has been designed the next step would be to learn how to install the :ref:`OpenNebula front-end <opennebula_installation>`.

Hypervisor Compatibility
================================================================================

+--------------------------------------------------------------+-----------------------------------------------+
|                           Section                            |                 Compatibility                 |
+==============================================================+===============================================+
| :ref:`OpenNebula Provisioning Model <understand>`            | This Section applies to both KVM and vCenter. |
+--------------------------------------------------------------+-----------------------------------------------+
| :ref:`Open Cloud Architecture <open_cloud_architecture>`     | This Section applies to KVM.                  |
+--------------------------------------------------------------+-----------------------------------------------+
| :ref:`VMware Cloud Architecture <vmware_cloud_architecture>` | This Section  applies to vCenter.             |
+--------------------------------------------------------------+-----------------------------------------------+
