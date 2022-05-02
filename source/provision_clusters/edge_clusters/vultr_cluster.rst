.. _vultr_cluster:

==========================
Vultr Edge Cluster
==========================

Edge Cluster Types
================================================================================

Vultr supports two provision types:

* **Metal**,  uses baremetal instances to create OpenNebula Hosts, providing the best performance and highest capacity. Metal provisions can run **LXC** or **KVM** hypervisors.
* **Virtual**, uses a virtual machine instance to create OpenNebula Hosts. This provision is better suited for PaaS like workloads. Virtual provisions can run **LXC** or **QEMU** hypervisors.

.. important::

    Vultr is not enabled by default, please refer to the :ref:`Vultr provider guide <vultr_provider>` to enable it.

Vultr Edge Cluster Implementation
================================================================================

An Edge Cluster in Vultr creates the following resources:

* **Instance**: Host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from Vultr and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Vultr. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Vultr.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

OpenNebula resources
================================================================================

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources
2. Hosts - for each Vultr instance or server
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network - for public networking
5. Virtual network template - for private networking

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage Vultr Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/vultr_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
