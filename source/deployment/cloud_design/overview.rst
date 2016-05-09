================================================================================
Overview
================================================================================

* Cloud Architect
* KVM
* vCenter

The first step of building a reliable, useful and successful cloud is to decide a clear design. This design needs to be aligned with the expected use of the cloud, and it needs to describe which data center components are going to be part of the cloud. This comprises i) all the infrastructure components such as networking, storage, authorization and virtualization back-ends, as well as the ii) planned dimension of the cloud (characteristics of the workload, numbers of users and so on) and the iii) provisioning workflow, ie, how end users are going to be isolated and using the cloud.

Hypervisor compatibility
------------------------

+--------------------------------------------------------------+---------------------------------------------+
|                           Section                            |                Compatibility                |
+==============================================================+=============================================+
| :ref:`OpenNebula Provisioning Model <understand>`            | This guide applies to both KVM and vCenter. |
+--------------------------------------------------------------+---------------------------------------------+
| :ref:`Open Cloud Architecture <open_cloud_architecture>`     | This guide applies to KVM.                  |
+--------------------------------------------------------------+---------------------------------------------+
| :ref:`VMware Cloud Architecture <vmware_cloud_architecture>` | This guide applies to vCenter.              |
+--------------------------------------------------------------+---------------------------------------------+

How should I read this guide
----------------------------

The first step would be to read the :ref:`OpenNebula Provisioning Model <understand>` to identify the wanted model to provision resources to end users. Afterwards a design of the cloud and its dimension should be drafted. For KVM clouds proceed to :ref:`Open Cloud Architecture <open_cloud_architecture>` and for vCenter clouds read :ref:`VMware Cloud Architecture <vmware_cloud_architecture>`.
