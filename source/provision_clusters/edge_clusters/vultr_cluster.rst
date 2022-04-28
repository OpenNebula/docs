.. _vultr_cluster:

==========================
Vultr Edge Cluster
==========================

.. include:: activate_virtual.txt

Vultr supports both virtual and metal clusters. Vultr **metal** use a bare-metal host to create OpenNebula Hosts. This provision is better for **KVM** & **Firecracker**. Vultr **virtual** Edge Clusters use a Virtual Machine instance to create OpenNebula Hosts. This provision is better suited for PaaS-like workloads. Virtual Vultr Edge Clusters primarily run **LXC** to execute system containers.

Vultr Edge Cluster Implementation
================================================================================

An Edge Cluster in Vultr creates the following resources:

* **Instance**: Host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemeted using elastic IPs from Vultr and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Vultr. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Vultr.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage Vultr Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/vultr_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
