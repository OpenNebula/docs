================================================================================
Overview
================================================================================

The first step of building a reliable, useful and successful cloud is to decide a clear design. This design needs to be aligned with the expected use of the cloud, and it needs to describe which data center components are going to be part of the cloud. This comprises i) all the infrastructure components such as networking, storage, authorization and virtualization back-ends, as well as the ii) planned dimension of the cloud (characteristics of the workload, numbers of users and so on) and the iii) provisioning workflow, i.e. how end users are going to be isolated and using the cloud.

In order to get the most out of a OpenNebula Cloud, we recommend that you create a plan with the features, performance, scalability, and high availability characteristics you want in your deployment. This Chapter provides information to plan an OpenNebula cloud based on :ref:`KVM, LXD or Firecracker <open_cloud_architecture>` or :ref:`vCenter <vmware_cloud_architecture>`. With this information, you will be able to easily architect and dimension your deployment, as well as understand the technologies involved in the management of virtualized resources and their relationship.

How Should I Read This Chapter
================================================================================

This is the first Chapter to read, as it introduces the necessary concepts to correctly define a cloud architecture.

Within this Chapter, as a first step, a design of the cloud and its dimension should be drafted. For KVM, LXD and Firecracker clouds proceed to :ref:`Open Cloud Architecture <open_cloud_architecture>` and for vCenter clouds read :ref:`VMware Cloud Architecture <vmware_cloud_architecture>`.

Then you could read the :ref:`OpenNebula Provisioning Model <understand>` to identify the model wanted to provision resources to end users. In a small installation with a few hosts, you can skip this provisioning model guide and use OpenNebula without giving much thought to infrastructure partitioning and provisioning. But for medium and large deployments you will probably want to provide some level of isolation and structure.

Once the cloud architecture has been designed, the next step would be to learn how to install the :ref:`OpenNebula front-end <opennebula_installation>`.

Hypervisor Compatibility
================================================================================

+--------------------------------------------------------------+------------------------------------------------------------+
|                           Section                            |                 Compatibility                              |
+==============================================================+============================================================+
| :ref:`Open Cloud Architecture <open_cloud_architecture>`     | This Section applies to KVM, LXD and Firecracker.          |
+--------------------------------------------------------------+------------------------------------------------------------+
| :ref:`VMware Cloud Architecture <vmware_cloud_architecture>` | This Section applies to vCenter.                           |
+--------------------------------------------------------------+------------------------------------------------------------+
| :ref:`OpenNebula Provisioning Model <understand>`            | This Section applies to both KVM and vCenter.              |
+--------------------------------------------------------------+------------------------------------------------------------+
