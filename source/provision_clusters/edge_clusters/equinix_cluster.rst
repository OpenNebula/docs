.. _equinix_cluster:

================================================================================
Equinix Edge Cluster
================================================================================

Edge Cluster Types
================================================================================

Equinix supports **metal** edge clusters that use bare-metal instances to create OpenNebula Hosts. Metal provisions can run the **LXC** or **KVM** hypervisors.

Equinix Edge Cluster Implementation
================================================================================

An Edge Cluster in Equinix creates the following resources:

* **Packet Device**: Host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from Equinix and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Equinix. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Equinix.

* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

|image_cluster|

OpenNebula resources
================================================================================

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources
2. Hosts - for each Equinix device
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network - for public networking
5. Virtual network template - for private networking

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage Equinix Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_cluster| image:: /images/equinix_deployment.png
.. |image_fireedge| image:: /images/oneprovision_fireedge.png
