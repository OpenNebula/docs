.. _onprem_cluster:

================================================================================
On-Premise Edge Cluster
================================================================================

Edge Cluster Types
================================================================================

On-Premise provider allows to automatically configure On-Premise infrastructure as an Edge Cluster. You can run the following hypervisors on your On-Premises clusters:

* **KVM**, runs virtual machines.
* **Firecracker**, runs microVMs.
* **LXC**, runs system containers.

Onprem Provider
================================================================================

The ``onprem`` provider is automatically created by OpenNebula. This provider needs no prior configuration as it will retrieve the FQDNs of the host to be configured while creating the provisions.

The ``onprem`` provider can be shown by running the command below:

.. prompt:: bash $ auto

    $ oneprovider show onprem
    PROVIDER 0 INFORMATION
    ID   : 0
    NAME : onprem

.. note:: OpenNebula frontend node requires root access to the hosts that are going to be configured using ``onprem`` provider.

On-Premise Edge Cluster Implementation
================================================================================

An On-Premise Edge Cluster will configure existing On-Premise infrastructure so no new physical resources will be allocated.

The network model will depend on the underlying datacenter networking infrastructure. By default the ``onprem`` provider will configure the nodes in order to be managed by OpenNebula but no Virtual Network will be created. Once the host are ready, you need to :ref:`create Virtual Networks <manage_vnets>` for your On-Premise cluster. Also you maybe interested in :ref:`customize <edge_cluster_customization>` the ``onprem`` provision to automate Virtual Network creation.

Operating Providers & Edge Clusters
================================================================================

Refer to the :ref:`cluster operation guide <cluster_operations>` to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the :ref:`providers guide <provider_operations>` to check all of the operations related to providers.

You can also manage On-Premise Clusters using the OneProvision FireEdge GUI.

|image_fireedge|

.. |image_fireedge| image:: /images/oneprovision_fireedge.png
