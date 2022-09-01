====================================
OpenNebula Kubernetes Engine (OneKE)
====================================

OneKE is a minimal `hyperconverged <https://en.wikipedia.org/wiki/Hyper-converged_infrastructure>`_ Kubernetes platform that comes with OpenNebula out of the box.

OneKE is based on `RKE2 - Rancher's Next Generation Kubernetes Distribution <https://docs.rke2.io/>`_ with preinstalled components to handle
persistence, ingress traffic, and on-prem load balancing.

Platform Notes
==============

Components
----------

.. table::
    :widths: 100 50 40

    +-----------------------------+-------------------------------------------------------------------------------------------------------------------+
    | Component                   | Version                                                                                                           |
    +=============================+=====================================================================================+=============================+
    | `Service OneKE 1.24 CE <https://marketplace.opennebula.io/appliance/b5033eba-cd31-487e-892a-035cd70441ef>`_       |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | `Service OneKE 1.24 EE <https://marketplace.opennebula.io/appliance/5f008301-2390-4c51-8e7f-6a35fb084954>`_       |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | Ubuntu                      | 22.04 LTS                                                                           | |certified-kubernetes-logo| |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | Kubernetes/RKE2             | v1.24.1+rke2r2                                                                      |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | Longhorn                    | 1.2.4                                                                               |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | MetalLB                     | 0.12.1                                                                              |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | Traefik                     | 2.7.1                                                                               |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+                             |
    | Contextualization package   | 6.4.0                                                                               |                             |
    +-----------------------------+-------------------------------------------------------------------------------------+-----------------------------+

Requirements
------------

* OpenNebula 6.2 - 6.4
* `OneFlow <https://docs.opennebula.io/stable/management_and_operations/multivm_service_management/overview.html>`_ and \
  `OneGate <https://docs.opennebula.io/stable/management_and_operations/multivm_service_management/onegate_usage.html>`_ \
  for multi-node orchestration.
* Recommended Memory per VM: 512 MB (**vnf**), 3 GB (**master**), 3 GB (**worker**), 3 GB (**storage**).
* Minimal Cores (VCPU) per VM: 1 (**vnf**), 2 (**master**), 2 (**worker**), 2 (**storage**).

Features / Changelog
====================

OneKE 1.24.1-6.4.0-1.20220624 / **Technology Preview** (Current)
----------------------------------------------------------------

====================== ================
Feature                Version
====================== ================
EE / CE flavors
VNF + HAproxy          6.4.0-1.20220624
RKE2 + Canal           v1.24.1+rke2r2
Longhorn               1.2.4/1.2.4
MetalLB                0.12.1/0.12.1
Traefik                10.23.0/2.7.1
One-Cleaner
Multi-Master
Airgapped install (EE)
====================== ================

Architecture Overview
=====================

OneKE is available as a Virtual Appliance from the `OpenNebula Public MarketPlace <https://marketplace.opennebula.io/appliance>`_.

OneKE comes in two flavors: **CE** (Community Edition) and **EE** (Enterprise Edition). Currently, as OneKE is just a **Technology Preview** the only difference between **CE** and **EE** versions is that **EE** version is a fully airgapped installation and can be installed in isolated VNETs.

Let's take a closer look at the **OneKE 1.24 CE** MarketPlace app:

.. prompt:: bash $ auto

    $ onemarketapp list -f NAME~'OneKE 1.24 CE' -l NAME --no-header
    OneKE 1.24 CE Storage
    OneKE 1.24 CE OS disk
    Service OneKE 1.24 CE
    OneKE 1.24 CE
    OneKE 1.24 CE VNF
    OneKE 1.24 CE Storage disk

A specific version of OneKE/CE consists of:

- A single OneFlow template ``Service OneKE .. CE`` used to instantiate a cluster.
- VM templates ``OneKE .. CE VNF``, ``OneKE .. CE``, ``OneKE .. CE Storage`` used to instantiate VMs.
- Disk images ``OneKE .. CE OS disk``, ``OneKE .. CE Storage disk`` \
  (all Kubernetes nodes are cloned from the ``OneKE .. CE OS disk`` image).

.. note::

    A service template links to VM templates which link to disk images, in such a way that everything is recursively downloaded when importing the Virtual Appliance in the OpenNebula Cloud.

OneFlow Service
----------------

OneKE Virtual Appliance is implemented as a OneFlow Service. OneFlow allows you to define, execute, and manage multi-tiered applications, so called Services, composed of interconnected Virtual Machines with deployment dependencies between them.
Each group of Virtual Machines is deployed and managed as a single entity (called role).

.. note::

    For a full OneFlow API/template reference please refer to the `OneFlow Specification <https://docs.opennebula.io/6.4/integration_and_development/system_interfaces/appflow_api.html>`_.

OneKE Service has four different **Roles**:

- **VNF**: Load Balancer for Control-Plane and Ingress Traffic
- **Master**: Control-Plane nodes
- **Worker**: Nodes to run application workloads
- **Storage**: Dedicated storage nodes for Persistent Volume replicas

|image-oneke-architecture|

You can check the roles defined in the service template by using the following command:

.. prompt:: bash $ auto

    $ oneflow-template show -j 'Service OneKE 1.24 CE' | jq -r '.DOCUMENT.TEMPLATE.BODY.roles[].name'
    vnf
    master
    worker
    storage

Each role is described in more detail in the following sections.

VNF (Virtual Network Functions) Role
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

VNF is a multi-node service that provides Routing, NAT, and Load-Balancing to OneKE clusters. VNF has been implemented on top of
`Keepalived <https://www.keepalived.org/>`_ which allows for a basic HA/Failover functionality via Virtual IPs (VIPs).

OneKE has been designed to run in a dual subnet environment: VNF provides NAT and Routing between public and private VNETs,
and when the public VNET is a gateway to the public Internet it also enables Internet connectivity to all internal VMs.

Dedicated documentation for VNF can be found at `VNF documentation <https://docs.opennebula.io/appliances/service/vnf.html>`_.

Master Role
^^^^^^^^^^^

The master role is responsible for running RKE2's **Control Plane**, managing the etcd database, API server, controller manager and scheduler, along with the worker nodes. It has been implemented according to principles defined in the `RKE2's High Availability <https://docs.rke2.io/install/ha/>`_ section. Specifically, the **fixed registration address** is an HAProxy instance exposing TCP port ``9345`` on a VNF node.

Worker Role
^^^^^^^^^^^

The worker role deploys only standard RKE2 nodes without any taints or labels and it is the default destination for regular workloads.

Storage Role
^^^^^^^^^^^^

The storage role deploys `labeled and tainted <https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity>`_ nodes designated to run only `Longhorn <https://longhorn.io/>`_ replicas.

.. note::

    The following selectors and tolerations can be used to deploy pods into storage nodes.

    .. code-block:: yaml

         tolerations:
           - key: node.longhorn.io/create-default-disk
             value: "true"
             operator: Equal
             effect: NoSchedule
         nodeSelector:
           node.longhorn.io/create-default-disk: "true"

.. note::

    OneKE includes a **retain** version of the default Longhorn's storage class defined as follows:

    .. code-block:: yaml

        kind: StorageClass
        apiVersion: storage.k8s.io/v1
        metadata:
          name: longhorn-retain
        provisioner: driver.longhorn.io
        allowVolumeExpansion: true
        reclaimPolicy: Retain
        volumeBindingMode: Immediate
        parameters:
          fsType: "ext4"
          numberOfReplicas: "3"
          staleReplicaTimeout: "2880"
          fromBackup: ""

    More info about Kubernetes storage classes can be found at `storage classes <https://kubernetes.io/docs/concepts/storage/storage-classes/>`_ documentation.

.. warning::

    Each storage node expects a dedicated storage block device to be attached to the VM (``/dev/vdb`` by default)
    to hold Longhorn's replicas (mounted at ``/var/lib/longhorn/``).
    **Please note, deleting a cluster will also remove all its Longhorn replicas.. Always back up your data!**

Networking
^^^^^^^^^^

OneKE's OneFlow Service requires two networks: a **public** and a **private** VNET.
These two VNETs can be, for example, just a simple `bridged networks <https://docs.opennebula.io/6.4/open_cluster_deployment/networking_setup/bridged.html>`_.

.. note::
  - In case of the **CE** flavor the **public** VNET must have access to the public Internet to allow Kubernetes to download the in-cluster components, i.e. ``Longhorn``, ``Traefik``, ``MetalLB``, and other supplementary docker images when required.
  - In case of the **CE** flavor the **private** VNET must have the ``DNS`` context parameter defined, for example ``1.1.1.1``, ``8.8.8.8``, or any other DNS server/proxy capable of resolving public domains.

Let's assume the following:

- The **public** VNET/subnet is ``10.2.11.0/24`` with the IPv4 range ``10.2.11.200-10.2.11.249`` and it has access to the public Internet via NAT.
- The **private** VNET/subnet is ``172.20.0.0/24`` with the IPv4 range ``172.20.0.100-172.20.0.199``, DNS context value ``1.1.1.1`` and it's completely isolated from the public Internet.

Then VIP adresses should not be included inside VNET ranges due to possible conflicts, for example:

============================ ===============
VIP                          IPv4
============================ ===============
``ONEAPP_VROUTER_ETH0_VIP0`` ``10.2.11.86``
``ONEAPP_VROUTER_ETH1_VIP0`` ``172.20.0.86``
============================ ===============

.. graphviz::

    digraph {
      graph [splines=true rankdir=LR ranksep=0.7 bgcolor=transparent];
      edge [dir=both color=blue arrowsize=0.6];
      node [shape=record style=rounded fontsize="11em"];

      i1 [label="Internet" shape=ellipse style=dashed];
      v1 [label="<f0>vnf / 1|<f1>eth0:\n10.2.11.86|<f2>NAT ⇅|<f3>eth1:\n172.20.0.86"];
      m1 [label="<f0>master / 1|<f1>eth0:\n172.20.0.101|<f2>GW: 172.20.0.86\nDNS: 1.1.1.1"];
      w1 [label="<f0>worker / 1|<f1>eth0:\n172.20.0.102|<f2>GW: 172.20.0.86\nDNS: 1.1.1.1"];
      s1 [label="<f0>storage / 1|<f1>eth0:\n172.20.0.103|<f2>GW: 172.20.0.86\nDNS: 1.1.1.1"];

      i1:e -> v1:f1:w;
      v1:f3:e -> m1:f1:w [dir=forward];
      v1:f3:e -> w1:f1:w;
      v1:f3:e -> s1:f1:w [dir=forward];
    }

|

On a leader VNF node IP/NAT configuration will look like these listings:

.. prompt:: bash localhost:~# auto

   localhost:~# ip address list
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
       inet6 ::1/128 scope host
          valid_lft forever preferred_lft forever
   2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
       link/ether 02:00:0a:02:0b:c8 brd ff:ff:ff:ff:ff:ff
       inet 10.2.11.200/24 scope global eth0
          valid_lft forever preferred_lft forever
       inet 10.2.11.86/32 scope global eth0
          valid_lft forever preferred_lft forever
       inet6 fe80::aff:fe02:bc8/64 scope link
          valid_lft forever preferred_lft forever
   3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
       link/ether 02:00:ac:14:00:64 brd ff:ff:ff:ff:ff:ff
       inet 172.20.0.100/24 scope global eth1
          valid_lft forever preferred_lft forever
       inet 172.20.0.86/32 scope global eth1
          valid_lft forever preferred_lft forever
       inet6 fe80::acff:fe14:64/64 scope link
          valid_lft forever preferred_lft forever

.. prompt:: bash localhost:~# auto

    localhost:~# iptables -t nat -vnL POSTROUTING
    Chain POSTROUTING (policy ACCEPT 20778 packets, 1247K bytes)
     pkts bytes target     prot opt in     out     source               destination
     2262  139K MASQUERADE  all  --  *      eth0    0.0.0.0/0            0.0.0.0/0

On Kubernetes nodes the Routing/DNS configuration will look like these listings:

.. prompt:: bash root@onekube-ip-172-20-0-101:~# auto

    root@onekube-ip-172-20-0-101:~# ip route list
    default via 172.20.0.86 dev eth0
    10.42.0.2 dev calicf569944d00 scope link
    10.42.1.0/24 via 10.42.1.0 dev flannel.1 onlink
    10.42.2.0/24 via 10.42.2.0 dev flannel.1 onlink
    10.42.3.0/24 via 10.42.3.0 dev flannel.1 onlink
    10.42.4.0/24 via 10.42.4.0 dev flannel.1 onlink
    172.20.0.0/24 dev eth0 proto kernel scope link src 172.20.0.101

.. prompt:: bash root@onekube-ip-172-20-0-101:~# auto

    root@onekube-ip-172-20-0-101:~# cat /etc/resolv.conf
    nameserver 1.1.1.1


.. note::

    Please refer to the `Virtual Networks <https://docs.opennebula.io/6.4/management_and_operations/network_management/manage_vnets.html>`_ document for more info about networking in OpenNebula.

.. note::

    The default gateway on every Kubernetes node is automatically set to the **private** VIP address,
    which facilitates (NATed) access to the public Internet.

In-Cluster Components
---------------------
Persistence (Longhorn)
^^^^^^^^^^^^^^^^^^^^^^

Longhorn is deployed during the cluster creation from an official Helm chart with the following manifest:

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: Namespace
    metadata:
      name: longhorn-system
    ---
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: one-longhorn
      namespace: kube-system
    spec:
      targetNamespace: longhorn-system
      chartContent: <BASE64 OF A LONGHORN HELM CHART TGZ FILE>
      valuesContent: |
        defaultSettings:
          createDefaultDiskLabeledNodes: true
          taintToleration: "node.longhorn.io/create-default-disk=true:NoSchedule"
        longhornManager:
          tolerations:
            - key: node.longhorn.io/create-default-disk
              value: "true"
              operator: Equal
              effect: NoSchedule
        longhornDriver:
          tolerations:
            - key: node.longhorn.io/create-default-disk
              value: "true"
              operator: Equal
              effect: NoSchedule
          nodeSelector:
            node.longhorn.io/create-default-disk: "true"
        longhornUI:
          tolerations:
            - key: node.longhorn.io/create-default-disk
              value: "true"
              operator: Equal
              effect: NoSchedule
          nodeSelector:
            node.longhorn.io/create-default-disk: "true"
    ---
    kind: StorageClass
    apiVersion: storage.k8s.io/v1
    metadata:
      name: longhorn-retain
    provisioner: driver.longhorn.io
    allowVolumeExpansion: true
    reclaimPolicy: Retain
    volumeBindingMode: Immediate
    parameters:
      fsType: "ext4"
      numberOfReplicas: "3"
      staleReplicaTimeout: "2880"
      fromBackup: ""

- A dedicated namespace ``longhorn-system`` is provided.
- Tolerations and nodeSelectors are applied to specific components of the Longhorn cluster \
  to prevent storage nodes from handling regular workloads.
- Additional storage class is provided.

Ingress Controller (Traefik)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Traefik is deployed during the cluster creation from an official Helm chart with the following manifest:

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: Namespace
    metadata:
      name: traefik-system
    ---
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: one-traefik
      namespace: kube-system
    spec:
      targetNamespace: traefik-system
      chartContent: <BASE64 OF A TRAEFIK HELM CHART TGZ FILE>
      valuesContent: |
        deployment:
          replicas: 2
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              - topologyKey: kubernetes.io/hostname
                labelSelector:
                  matchLabels:
                    app.kubernetes.io/name: traefik
        service:
          type: NodePort
        ports:
          web:
            nodePort: 32080
          websecure:
            nodePort: 32443

- A dedicated namespace ``traefik-system`` is provided.
- An `anti-affinity <https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity>`_ rule is applied to Traefik pods to minmize potential downtime during failures and upgrades.
- Traefik is exposed on a ``NodePort`` type of the `Kubernetes Service <https://kubernetes.io/docs/concepts/services-networking/service/>`_. By default HAProxy instance (running on the leader VNF node) connects to all worker nodes to ports ``32080`` and ``32443``, then forwards all traffic coming to HAProxy to ports ``80`` and ``443``, to the Traefik instance (running inside Kubernetes).

.. graphviz::

    digraph {
      graph [splines=true rankdir=LR ranksep=0.7 bgcolor=transparent];
      edge [dir=both color=blue arrowsize=0.6];
      node [shape=record style=rounded fontsize="11em"];

      i1 [label="Internet" shape=ellipse style=dashed];
      v1 [label="<f0>vnf / 1|<f1>haproxy / \*:80,443|<f2>eth0:\n10.2.11.86|<f3>NAT ⇅|<f4>eth1:\n172.20.0.86"];
      m1 [label="<f0>master / 1|<f1>eth0:\n172.20.0.101|<f2>GW: 172.20.0.86"];
      w1 [label="<f0>worker / 1|<f1>traefik / \*:32080,32443|<f2>eth0:\n172.20.0.102|<f3>GW: 172.20.0.86"];
      s1 [label="<f0>storage / 1|<f1>eth0:\n172.20.0.103|<f2>GW: 172.20.0.86"];

      i1:e -> v1:f2:w;
      v1:f4:e -> m1:f1:w [dir=forward];
      v1:f4:e -> w1:f2:w;
      v1:f4:e -> s1:f1:w [dir=forward];
    }

|

Load Balancing (MetalLB)
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: Namespace
    metadata:
      name: metallb-system
    ---
    apiVersion: helm.cattle.io/v1
    kind: HelmChart
    metadata:
      name: one-metallb
      namespace: kube-system
    spec:
      targetNamespace: metallb-system
      chartContent: <BASE64 OF A METALLB HELM CHART TGZ FILE>
      valuesContent: |
        existingConfigMap: config
        controller:
          image:
            pullPolicy: IfNotPresent
        skpeaker:
          image:
            pullPolicy: IfNotPresent

- A dedicated namespace ``metallb-system`` is provided.
- `Image Pull Policy <https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy>`_ is optimized for airgapped deployments.
- A precreated ``ConfigMap/config`` resource is provided (not managed by the Helm chart). Please refer for the official documentation on `MetalLB's configuration <https://metallb.universe.tf/configuration/>`_ to learn what the use cases of MetalLB are.

.. warning::

   MetalLB is not suitable for use in
   `AWS Edge Clusters <https://docs.opennebula.io/6.2/management_and_operations/edge_cluster_management/aws_cluster.html>`_,
   this is because AWS VPC is API-oriented and doesn't fully support networking protocols like ARP or BGP in a standard way.
   Please refer to the `MetalLB's Cloud Compatibility <https://metallb.universe.tf/installation/clouds/>`_ document for more info.

Cleanup Routine (One-Cleaner)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``One-Cleaner`` is a simple ``CronJob`` resource deployed by default in OneKE during cluster creation.
It is triggered every ``2`` minutes and its sole purpose is to remove/clean up non-existent/destroyed nodes from the cluster by comparing Kubernetes and OneGate states.


Deployment
==========

In this section we focus on a deployment of OneKE using CLI commands. For an easier Sunstone UI guide (with screenshots) please refer to the `Running Kubernetes Clusters <https://docs.opennebula.io/6.4/quick_start/usage_basics/running_kubernetes_clusters.html>`_ quick-start document.

Importing OneKE Virtual Appliance
---------------------------------

Let's run the following command to import in the OpenNebula Cloud the whole set of resources corresponding to the OneKE Virtual Appliance (CE flavor). An image datastore must be specified for storing the Virtual Appliance images.

.. prompt:: bash $ auto

    $ onemarketapp export 'Service OneKE 1.24 CE' 'Service OneKE 1.24 CE' --datastore 1
    IMAGE
        ID: 202
        ID: 203
        ID: 204
    VMTEMPLATE
        ID: 204
        ID: 205
        ID: 206
    SERVICE_TEMPLATE
        ID: 104

.. note::

    IDs are automatically assigned and their actual values depend on the state of the OpenNebula cluster at hand.

Create a K8s Cluster
--------------------

Once the OneKE Virtual Appliance has been imported, a new cluster can be created by instantiating the OneKE OneFlow Service as shown here:

.. prompt:: bash $ auto

    $ oneflow-template instantiate 'Service OneKE 1.24 CE' /dev/fd/0 <<'EOF'
    {
        "name": "OneKE/1",
        "networks_values": [
            {"Public": {"id": "0"}},
            {"Private": {"id": "1"}}
        ],
        "custom_attrs_values": {
            "ONEAPP_VROUTER_ETH0_VIP0": "10.2.11.86",
            "ONEAPP_VROUTER_ETH1_VIP0": "172.20.0.86",
            "ONEAPP_K8S_EXTRA_SANS": "localhost,127.0.0.1,k8s.yourdomain.it",
            "ONEAPP_K8S_LOADBALANCER_RANGE": "172.20.0.87-172.20.0.88",
            "ONEAPP_K8S_LOADBALANCER_CONFIG": "",
            "ONEAPP_STORAGE_DEVICE": "/dev/vdb",
            "ONEAPP_STORAGE_FILESYSTEM": "xfs",
            "ONEAPP_VNF_NAT4_ENABLED": "YES",
            "ONEAPP_VNF_NAT4_INTERFACES_OUT": "eth0",
            "ONEAPP_VNF_ROUTER4_ENABLED": "YES",
            "ONEAPP_VNF_ROUTER4_INTERFACES": "eth0,eth1",
            "ONEAPP_VNF_HAPROXY_INTERFACES": "eth0",
            "ONEAPP_VNF_HAPROXY_REFRESH_RATE": "30",
            "ONEAPP_VNF_HAPROXY_CONFIG": "",
            "ONEAPP_VNF_HAPROXY_LB2_PORT": "443",
            "ONEAPP_VNF_HAPROXY_LB3_PORT": "80",
            "ONEAPP_VNF_KEEPALIVED_VRID": "1"
        }
    }
    EOF
    ID: 105

K8s cluster creation can take some minutes. The cluster is available once the OneFlow service is in RUNNING state

.. prompt:: bash $ auto

    $ oneflow show 'OneKE/1'
    SERVICE 105 INFORMATION
    ID                  : 105
    NAME                : OneKE/1
    USER                : oneadmin
    GROUP               : oneadmin
    STRATEGY            : straight
    SERVICE STATE       : RUNNING
    ...

and all VMs are also in RUNNING state

.. prompt:: bash $ auto

    $ onevm list -f NAME~'service_105' -l NAME,STAT
    NAME                    ... STAT
    storage_0_(service_105) ... runn
    worker_0_(service_105)  ... runn
    master_0_(service_105)  ... runn
    vnf_0_(service_105)     ... runn


Deployment Customization
------------------------

It is possible to modify VM templates related to the OneKE Virtual Appliance in order to customize the deployment, for example by adding more VM memory, VCPU cores to the workers, and resizing the Disk for the storage nodes. This should be done before the creation of the K8s cluster, i.e. before instantiating the OneKE OneFlow Service Template.

When instantiating OneKE's OneFlow Service Template, you can further customize the deployment using the following
`custom attributes <https://docs.opennebula.io/6.4/management_and_operations/multivm_service_management/appflow_use_cli.html#using-custom-attributes>`_:

==================================== ============ ======================= ========= ======= ===========
Parameter                            Mandatory    Default                 Stage     Role    Description
==================================== ============ ======================= ========= ======= ===========
``ONEAPP_VROUTER_ETH0_VIP0``         ``YES``                              configure all     Control Plane Endpoint VIP (IPv4)
``ONEAPP_VROUTER_ETH1_VIP0``                                              configure all     Default Gateway VIP (IPv4)
``ONEAPP_K8S_EXTRA_SANS``                         ``localhost,127.0.0.1`` configure master  ApiServer extra certificate SANs
``ONEAPP_K8S_LOADBALANCER_RANGE``                                         configure worker  MetalLB IP range
``ONEAPP_K8S_LOADBALANCER_CONFIG``                                        configure worker  MetalLB custom config
``ONEAPP_STORAGE_DEVICE``            ``YES``      ``/dev/vdb``            configure storage Dedicated storage device for Longhorn
``ONEAPP_STORAGE_FILESYSTEM``                     ``xfs``                 configure storage Filesystem type to init dedicated storage device
``ONEAPP_VNF_NAT4_ENABLED``                       ``YES``                 configure vnf     Enable NAT for the whole cluster
``ONEAPP_VNF_NAT4_INTERFACES_OUT``                ``eth0``                configure vnf     NAT - Outgoing (public) interfaces
``ONEAPP_VNF_ROUTER4_ENABLED``                    ``YES``                 configure vnf     Enable IPv4 forwarding for selected NICs
``ONEAPP_VNF_ROUTER4_INTERFACES``                 ``eth0,eth1``           configure vnf     IPv4 Router - NICs selected for IPv4 forwarding
``ONEAPP_VNF_HAPROXY_INTERFACES``                 ``eth0``                configure vnf     Interfaces to run HAProxy on
``ONEAPP_VNF_HAPROXY_REFRESH_RATE``               ``30``                  configure vnf     HAProxy / OneGate refresh rate
``ONEAPP_VNF_HAPROXY_CONFIG``                                             configure vnf     Custom HAProxy config
``ONEAPP_VNF_HAPROXY_LB2_PORT``                   ``443``                 configure vnf     HTTPS ingress port
``ONEAPP_VNF_HAPROXY_LB3_PORT``                   ``80``                  configure vnf     HTTP ingress port
``ONEAPP_VNF_KEEPALIVED_VRID``                    ``1``                   configure vnf     Global vrouter id (1-255)
==================================== ============ ======================= ========= ======= ===========

.. important::

    ``ONEAPP_VROUTER_ETH0_VIP0`` - VNF cluster uses this VIP to bind and expose Kubernetes API port ``6443`` and RKE2's management port ``9345``.
    The ``eth0`` NIC should be connected to the **public** subnet (Routed or NATed).

.. important::

    ``ONEAPP_VROUTER_ETH1_VIP0`` - VNF cluster uses this VIP to act as a NAT gateway for every other VM deployed inside the **private** subnet.
    The ``eth1`` NIC should be connected to the **private** subnet.

.. warning::

    If you intend to reuse your public/private subnets to deploy multiple OneKE clusters into them,
    please make sure to provide a distinct value for the ``ONEAPP_VNF_KEEPALIVED_VRID`` context parameter for each OneKE cluster.
    This will allow for VNF instances to correctly synchronize using VRRP protocol.


High-Availability
-----------------

By default, OneKE Virtual Appliance is preconfigured to work as a non-Highly-Available K8s cluster, since OneFlow Service Templates deploys each service role as a single VM. Kubernetes High-Availability is about setting up a Kubernetes cluster, along with its components, in such a way that there is no single point of failure. To achieve high-availability, the following OneKE components should be scaled up: VNF (at least 2 VMs), master (at least 3 VMs) and storage (at least 2 VMs).

OneKE HA setup can be achieved by modifying the OneFlow Service Template before creating the cluster or by scaling up each role after the cluster creation.

For example, to scale the **master** role from a single node to ``3``, you can use the following command:

.. prompt:: bash $ auto

    $ oneflow scale 'OneKE/1' master 3

.. warning::

   You can scale the master role up to an odd number of masters, but be careful while scaling down as it may break your cluster.
   If you require multi-master HA, just start with a single master and then scale up to 3 and keep it that way.

After a while we can examine the service log:

.. prompt:: bash $ auto

    $ oneflow show 'OneKE/1'
    ...
    LOG MESSAGES
    06/29/22 15:20 [I] New state: DEPLOYING_NETS
    06/29/22 15:20 [I] New state: DEPLOYING
    06/29/22 15:28 [I] New state: RUNNING
    06/29/22 15:42 [I] Role master scaling up from 1 to 3 nodes
    06/29/22 15:42 [I] New state: SCALING
    06/29/22 15:49 [I] New state: COOLDOWN
    06/29/22 15:54 [I] New state: RUNNING

And afterwards we can list cluster nodes using ``kubectl``:

.. prompt:: bash $ auto

    $ kubectl get nodes
    NAME                      STATUS   ROLES                       AGE     VERSION
    onekube-ip-172-20-0-101   Ready    control-plane,etcd,master   32m     v1.24.1+rke2r2
    onekube-ip-172-20-0-102   Ready    <none>                      29m     v1.24.1+rke2r2
    onekube-ip-172-20-0-103   Ready    <none>                      29m     v1.24.1+rke2r2
    onekube-ip-172-20-0-104   Ready    control-plane,etcd,master   10m     v1.24.1+rke2r2
    onekube-ip-172-20-0-105   Ready    control-plane,etcd,master   8m30s   v1.24.1+rke2r2

.. warning::

    Please plan ahead and avoid scaling down **master** and **storage** roles as it may break ETCD's quorum or cause data loss.
    There is no obvious restriction for the **worker** role, however. It can be safely rescaled at will.

Anti-affinity
^^^^^^^^^^^^^

VMs related to the same role should be scheduled on different physical hosts in an HA setup to guarantee HA in case of a host failure. OpenNebula provides ``VM Group`` resources to achieve proper Host/VM
`affinity/anti-affinity <https://docs.opennebula.io/6.4/management_and_operations/capacity_planning/affinity.html#virtual-machine-affinity>`_.

In the following section, we provide an example of how to create  ``VM Group`` resources and how to modify OneKE's OneFlow Service Template to include VM groups.

Let's assume that ``epsilon`` and ``omicron`` are hosts we want to use to deploy OneKE; a VM Group may be created in the following way:

.. prompt:: bash $ auto

    $ onevmgroup create /dev/fd/0 <<EOF
    NAME = "Service OneKE 1.24 CE"
    ROLE = [
        NAME         = "vnf",
        HOST_AFFINED = "epsilon,omicron",
        POLICY       = "ANTI_AFFINED"
    ]
    ROLE = [
        NAME         = "master",
        HOST_AFFINED = "epsilon,omicron",
        POLICY       = "ANTI_AFFINED"
    ]
    ROLE = [
        NAME         = "worker",
        HOST_AFFINED = "epsilon,omicron"
    ]
    ROLE = [
        NAME         = "storage",
        HOST_AFFINED = "epsilon,omicron",
        POLICY       = "ANTI_AFFINED"
    ]
    EOF
    ID: 1

.. important::

    The **worker** role does not have ``POLICY`` defined, this allows you to reuse hosts multiple times!

Now, let's modify the OneKE OneFlow Service Template:

.. prompt:: bash $ auto

    $ oneflow-template show 'Service OneKE 1.24 CE' --json | >/tmp/OneKE-update.json jq -r --arg vmgroup 'Service OneKE 1.24 CE' -f /dev/fd/3 3<<'EOF'
    .DOCUMENT.TEMPLATE.BODY | del(.registration_time) | . += {
      roles: .roles | map(
        .vm_template_contents = "VMGROUP=[VMGROUP_NAME=\"\($vmgroup)\",ROLE=\"\(.name)\"]\n" + .vm_template_contents
      )
    }
    EOF

Content of the update (``/tmp/OneKE-update.json``) will look like this:

.. code-block:: json

    {
      "name": "Service OneKE 1.24 CE",
      "deployment": "straight",
      "description": "",
      "roles": [
        {
          "name": "vnf",
          "cardinality": 1,
          "min_vms": 1,
          "vm_template_contents": "VMGROUP=[VMGROUP_NAME=\"Service OneKE 1.24 CE\",ROLE=\"vnf\"]\nNIC=[NAME=\"NIC0\",NETWORK_ID=\"$Public\"]\nNIC=[NAME=\"NIC1\",NETWORK_ID=\"$Private\"]\nONEAPP_VROUTER_ETH0_VIP0=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VROUTER_ETH1_VIP0=\"$ONEAPP_VROUTER_ETH1_VIP0\"\nONEAPP_VNF_NAT4_ENABLED=\"$ONEAPP_VNF_NAT4_ENABLED\"\nONEAPP_VNF_NAT4_INTERFACES_OUT=\"$ONEAPP_VNF_NAT4_INTERFACES_OUT\"\nONEAPP_VNF_ROUTER4_ENABLED=\"$ONEAPP_VNF_ROUTER4_ENABLED\"\nONEAPP_VNF_ROUTER4_INTERFACES=\"$ONEAPP_VNF_ROUTER4_INTERFACES\"\nONEAPP_VNF_HAPROXY_INTERFACES=\"$ONEAPP_VNF_HAPROXY_INTERFACES\"\nONEAPP_VNF_HAPROXY_REFRESH_RATE=\"$ONEAPP_VNF_HAPROXY_REFRESH_RATE\"\nONEAPP_VNF_HAPROXY_CONFIG=\"$ONEAPP_VNF_HAPROXY_CONFIG\"\nONEAPP_VNF_HAPROXY_LB0_IP=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VNF_HAPROXY_LB0_PORT=\"9345\"\nONEAPP_VNF_HAPROXY_LB1_IP=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VNF_HAPROXY_LB1_PORT=\"6443\"\nONEAPP_VNF_HAPROXY_LB2_IP=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VNF_HAPROXY_LB2_PORT=\"$ONEAPP_VNF_HAPROXY_LB2_PORT\"\nONEAPP_VNF_HAPROXY_LB3_IP=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VNF_HAPROXY_LB3_PORT=\"$ONEAPP_VNF_HAPROXY_LB3_PORT\"\nONEAPP_VNF_KEEPALIVED_VRID=\"$ONEAPP_VNF_KEEPALIVED_VRID\"\n",
          "elasticity_policies": [],
          "scheduled_policies": [],
          "vm_template": 255
        },
        {
          "name": "master",
          "cardinality": 1,
          "min_vms": 1,
          "vm_template_contents": "VMGROUP=[VMGROUP_NAME=\"Service OneKE 1.24 CE\",ROLE=\"master\"]\nNIC=[NAME=\"NIC0\",NETWORK_ID=\"$Private\"]\nONEAPP_VROUTER_ETH0_VIP0=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VROUTER_ETH1_VIP0=\"$ONEAPP_VROUTER_ETH1_VIP0\"\nONEAPP_K8S_EXTRA_SANS=\"$ONEAPP_K8S_EXTRA_SANS\"\nONEAPP_K8S_LOADBALANCER_RANGE=\"$ONEAPP_K8S_LOADBALANCER_RANGE\"\nONEAPP_K8S_LOADBALANCER_CONFIG=\"$ONEAPP_K8S_LOADBALANCER_CONFIG\"\n",
          "parents": [
            "vnf"
          ],
          "elasticity_policies": [],
          "scheduled_policies": [],
          "vm_template": 256
        },
        {
          "name": "worker",
          "cardinality": 1,
          "vm_template_contents": "VMGROUP=[VMGROUP_NAME=\"Service OneKE 1.24 CE\",ROLE=\"worker\"]\nNIC=[NAME=\"NIC0\",NETWORK_ID=\"$Private\"]\nONEAPP_VROUTER_ETH0_VIP0=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VROUTER_ETH1_VIP0=\"$ONEAPP_VROUTER_ETH1_VIP0\"\nONEAPP_VNF_HAPROXY_LB2_IP=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VNF_HAPROXY_LB2_PORT=\"$ONEAPP_VNF_HAPROXY_LB2_PORT\"\nONEAPP_VNF_HAPROXY_LB3_IP=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VNF_HAPROXY_LB3_PORT=\"$ONEAPP_VNF_HAPROXY_LB3_PORT\"\n",
          "parents": [
            "vnf"
          ],
          "elasticity_policies": [],
          "scheduled_policies": [],
          "vm_template": 256
        },
        {
          "name": "storage",
          "cardinality": 1,
          "min_vms": 1,
          "vm_template_contents": "VMGROUP=[VMGROUP_NAME=\"Service OneKE 1.24 CE\",ROLE=\"storage\"]\nNIC=[NAME=\"NIC0\",NETWORK_ID=\"$Private\"]\nONEAPP_VROUTER_ETH0_VIP0=\"$ONEAPP_VROUTER_ETH0_VIP0\"\nONEAPP_VROUTER_ETH1_VIP0=\"$ONEAPP_VROUTER_ETH1_VIP0\"\nONEAPP_STORAGE_DEVICE=\"$ONEAPP_STORAGE_DEVICE\"\nONEAPP_STORAGE_FILESYSTEM=\"$ONEAPP_STORAGE_FILESYSTEM\"\n",
          "parents": [
            "vnf"
          ],
          "elasticity_policies": [],
          "scheduled_policies": [],
          "vm_template": 257
        }
      ],
      "networks": {
        "Public": "M|network|Public||id:",
        "Private": "M|network|Private||id:"
      },
      "custom_attrs": {
        "ONEAPP_VROUTER_ETH0_VIP0": "M|text|Control Plane Endpoint VIP (IPv4)||",
        "ONEAPP_VROUTER_ETH1_VIP0": "O|text|Default Gateway VIP (IPv4)||",
        "ONEAPP_K8S_EXTRA_SANS": "O|text|ApiServer extra certificate SANs||localhost,127.0.0.1",
        "ONEAPP_K8S_LOADBALANCER_RANGE": "O|text|MetalLB IP range (default none)||",
        "ONEAPP_K8S_LOADBALANCER_CONFIG": "O|text64|MetalLB custom config (default none)||",
        "ONEAPP_STORAGE_DEVICE": "M|text|Storage device path||/dev/vdb",
        "ONEAPP_STORAGE_FILESYSTEM": "O|text|Storage device filesystem||xfs",
        "ONEAPP_VNF_NAT4_ENABLED": "O|boolean|Enable NAT||YES",
        "ONEAPP_VNF_NAT4_INTERFACES_OUT": "O|text|NAT - Outgoing Interfaces||eth0",
        "ONEAPP_VNF_ROUTER4_ENABLED": "O|boolean|Enable Router||YES",
        "ONEAPP_VNF_ROUTER4_INTERFACES": "O|text|Router - Interfaces||eth0,eth1",
        "ONEAPP_VNF_HAPROXY_INTERFACES": "O|text|Interfaces to run Haproxy on||eth0",
        "ONEAPP_VNF_HAPROXY_REFRESH_RATE": "O|number|Haproxy refresh rate||30",
        "ONEAPP_VNF_HAPROXY_CONFIG": "O|text|Custom Haproxy config (default none)||",
        "ONEAPP_VNF_HAPROXY_LB2_PORT": "O|number|HTTPS ingress port||443",
        "ONEAPP_VNF_HAPROXY_LB3_PORT": "O|number|HTTP ingress port||80",
        "ONEAPP_VNF_KEEPALIVED_VRID": "O|number|Global vrouter id (1-255)||1"
      },
      "ready_status_gate": true
    }

.. note::

    We removed the **registration_time** key from the document as it is immutable.

Next, let's update the template:

.. prompt:: bash $ auto

    $ oneflow-template update 'Service OneKE 1.24 CE' /tmp/OneKE-update.json


Operations
==========

Accessing K8s Cluster
---------------------

The leader VNF node runs an HAProxy instance that by default exposes Kubernetes API port ``6443`` on the **public** VIP address over the HTTPS protocol (secured with two-way SSL/TLS certificates).

This HAProxy instance can be used in two ways:

- As a stable Control Plane endpoint for the whole Kubernetes cluster.
- As an external Kubernetes API endpoint that can be reached from outside the internal VNET.

.. graphviz::

    digraph {
      graph [splines=true rankdir=LR ranksep=0.7 bgcolor=transparent];
      edge [dir=both color=blue arrowsize=0.6];
      node [shape=record style=rounded fontsize="11em"];

      i1 [label="Internet" shape=ellipse style=dashed];
      v1 [label="<f0>vnf / 1|<f1>haproxy / \*:6443|<f2>eth0:\n10.2.11.86|<f3>NAT ⇅|<f4>eth1:\n172.20.0.86"];
      m1 [label="<f0>master / 1|<f1>kube-apiserver / \*:6443|<f2>eth0:\n172.20.0.101|<f3>GW: 172.20.0.86"];
      w1 [label="<f0>worker / 1|<f1>eth0:\n172.20.0.102|<f2>GW: 172.20.0.86"];
      s1 [label="<f0>storage / 1|<f1>eth0:\n172.20.0.103|<f2>GW: 172.20.0.86"];

      i1:e -> v1:f2:w;
      v1:f4:e -> m1:f2:w [dir=forward];
      v1:f4:e -> w1:f1:w;
      v1:f4:e -> s1:f1:w [dir=forward];
    }

|

To access the Kubernetes API you'll need a **kubeconfig** file which, in the case of RKE2, can be copied from the ``/etc/rancher/rke2/rke2.yaml`` file located on every master node, for example:

.. prompt:: bash $ auto

    $ install -d ~/.kube/
    $ scp -J root@10.2.11.86 root@172.20.0.101:/etc/rancher/rke2/rke2.yaml ~/.kube/config
    Warning: Permanently added '10.2.11.86' (ED25519) to the list of known hosts.
    Warning: Permanently added '172.20.0.101' (ED25519) to the list of known hosts.
    rke2.yaml

Additionally you must adjust the Control Plane endpoint inside the file to point to the **public** VIP:

.. prompt:: bash $ auto

    $ gawk -i inplace -f- ~/.kube/config <<'EOF'
    /^    server: / { $0 = "    server: https://10.2.11.86:6443" }
    { print }
    EOF

And then your local ``kubectl`` command should work just fine:

.. prompt:: bash $ auto

    $ kubectl get nodes
    NAME                      STATUS   ROLES                       AGE    VERSION
    onekube-ip-172-20-0-101   Ready    control-plane,etcd,master   132m   v1.24.1+rke2r2
    onekube-ip-172-20-0-102   Ready    <none>                      129m   v1.24.1+rke2r2
    onekube-ip-172-20-0-103   Ready    <none>                      129m   v1.24.1+rke2r2
    onekube-ip-172-20-0-104   Ready    control-plane,etcd,master   111m   v1.24.1+rke2r2
    onekube-ip-172-20-0-105   Ready    control-plane,etcd,master   108m   v1.24.1+rke2r2

.. important::

    If you'd like to use a custom domain name for the Control Plane endpoint instead of the direct public VIP address,
    you need to add the domain to the ``ONEAPP_K8S_EXTRA_SANS`` context parameter, for example ``localhost,127.0.0.1,k8s.yourdomain.it``, and set the domain inside the ``~/.kube/config`` file as well. You can set up your domain in a public/private DNS server or in your local ``/etc/hosts`` file, whatever works for you.

Accessing K8s API via SSH tunnels
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default Kubernetes API Server's extra SANs are set to ``localhost,127.0.0.1`` which allows you to access Kubernetes API via SSH tunnels.

.. note::

    We recommend using the ``ProxyCommand`` SSH feature.

Download the ``/etc/rancher/rke2/rke2.yaml`` kubeconfig file:

.. prompt:: bash $ auto

    $ install -d ~/.kube/
    $ scp -o ProxyCommand='ssh -A root@10.2.11.86 -W %h:%p' root@172.20.0.101:/etc/rancher/rke2/rke2.yaml ~/.kube/config

.. note::

    The ``10.2.11.86`` is the **public** VIP address, ``172.20.0.101`` is a **private** address of a master node
    inside the **private** VNET.

Create SSH tunnel, forward the ``6443`` TCP port:

.. prompt:: bash $ auto

    $ ssh -o ProxyCommand='ssh -A root@10.2.11.86 -W %h:%p' -L 6443:localhost:6443 root@172.20.0.101

and then run ``kubectl`` in another terminal:

.. prompt:: bash $ auto

    $ kubectl get nodes
    NAME                      STATUS   ROLES                       AGE    VERSION
    onekube-ip-172-20-0-101   Ready    control-plane,etcd,master   156m   v1.24.1+rke2r2
    onekube-ip-172-20-0-102   Ready    <none>                      152m   v1.24.1+rke2r2
    onekube-ip-172-20-0-103   Ready    <none>                      152m   v1.24.1+rke2r2
    onekube-ip-172-20-0-104   Ready    control-plane,etcd,master   134m   v1.24.1+rke2r2
    onekube-ip-172-20-0-105   Ready    control-plane,etcd,master   132m   v1.24.1+rke2r2


Usage Example
-------------

Create a Longhorn PVC
^^^^^^^^^^^^^^^^^^^^^

To create a 4 GiB persistent volume apply the following manifest using ``kubectl``:

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: nginx
    spec:
      accessModes:
        - ReadWriteOnce
      volumeMode: Filesystem
      resources:
        requests:
          storage: 4Gi
      storageClassName: longhorn-retain

.. prompt:: bash $ auto

    $ kubectl apply -f nginx-pvc.yaml
    persistentvolumeclaim/nginx created

.. prompt:: bash $ auto

    $ kubectl get pvc,pv
    NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
    persistentvolumeclaim/nginx   Bound    pvc-5b0f9618-b840-4544-bccc-6479c83b49d3   4Gi        RWO            longhorn-retain   78s

    NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM           STORAGECLASS      REASON   AGE
    persistentvolume/pvc-5b0f9618-b840-4544-bccc-6479c83b49d3   4Gi        RWO            Retain           Bound    default/nginx   longhorn-retain            76s

.. important::

    The `Retain reclaim policy <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#retain>`_ may protect your persistent data
    from accidental removal. Always back up your data!

Create an NGINX Deployment
^^^^^^^^^^^^^^^^^^^^^^^^^^

To deploy an NGINX instance using the PVC created previously, apply the following manifest using ``kubectl``:

.. code-block:: yaml

    ---
    kind: Deployment
    apiVersion: apps/v1
    metadata:
      name: nginx
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: http
            image: nginx:alpine
            imagePullPolicy: IfNotPresent
            ports:
            - name: http
              containerPort: 80
            volumeMounts:
            - mountPath: "/persistent/"
              name: nginx
          volumes:
          - name: nginx
            persistentVolumeClaim:
              claimName: nginx

.. prompt:: bash $ auto

    $ kubectl apply -f nginx-deployment.yaml
    deployment.apps/nginx created

.. prompt:: bash $ auto

    $ kubectl get deployments,pods
    NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/nginx   1/1     1            1           32s

    NAME                         READY   STATUS    RESTARTS   AGE
    pod/nginx-6b5d47679b-sjd9p   1/1     Running   0          32s

Create a Traefik IngressRoute
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To expose the running NGINX instance over HTTP, on the port ``80``, on the public VNF VIP address,
apply the following manifest using ``kubectl``:

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx
    spec:
      selector:
        app: nginx
      type: ClusterIP
      ports:
        - name: http
          protocol: TCP
          port: 80
          targetPort: 80
    ---
    apiVersion: traefik.containo.us/v1alpha1
    kind: IngressRoute
    metadata:
      name: nginx
    spec:
      entryPoints: [web]
      routes:
        - kind: Rule
          match: Path(`/`)
          services:
            - kind: Service
              name: nginx
              port: 80
              scheme: http

.. prompt:: bash $ auto

    $ kubectl apply -f nginx-svc-ingressroute.yaml
    service/nginx created
    ingressroute.traefik.containo.us/nginx created

.. prompt:: bash $ auto

    $ kubectl get svc,ingressroute
    NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
    service/kubernetes   ClusterIP   10.43.0.1     <none>        443/TCP   3h18m
    service/nginx        ClusterIP   10.43.99.36   <none>        80/TCP    63s

    NAME                                     AGE
    ingressroute.traefik.containo.us/nginx   63s

Verify that the new ``IngressRoute`` CRD (Custom Resource Definition) object is operational:

.. prompt:: bash $ auto

    $ curl -fsSL http://10.2.11.86/ | grep title
    <title>Welcome to nginx!</title>

Create a MetalLB LoadBalancer service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To expose the running NGINX instance over HTTP, on the port ``80``, using a private ``LoadBalancer`` service
provided by ``MetalLB``, apply the following manifest using ``kubectl``:

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-lb
    spec:
      selector:
        app: nginx
      type: LoadBalancer
      ports:
        - name: http
          protocol: TCP
          port: 80
          targetPort: 80

.. prompt:: bash $ auto

    $ kubectl apply -f nginx-loadbalancer.yaml
    service/nginx-lb created

.. prompt:: bash $ auto

    $ kubectl get svc
    NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
    kubernetes   ClusterIP      10.43.0.1       <none>        443/TCP        3h25m
    nginx        ClusterIP      10.43.99.36     <none>        80/TCP         8m50s
    nginx-lb     LoadBalancer   10.43.222.235   172.20.0.87   80:30050/TCP   73s

Verify that the new ``LoadBalancer`` service is operational:

.. prompt:: bash $ auto

    $ curl -fsSL http://172.20.0.87/ | grep title
    <title>Welcome to nginx!</title>

Upgrade
-------

K8s clusters can be upgraded with the
`System Upgrade Controller <https://rancher.com/docs/k3s/latest/en/upgrades/automated/#install-the-system-upgrade-controller>`_ provided by RKE2.

Here's a handy bash snippet to illustrate the procedure:

.. code-block:: bash

    #!/usr/bin/env bash

    : "${SUC_VERSION:=0.9.1}"
    : "${RKE2_VERSION:=v1.24.2-rc2+rke2r1}"

    set -o errexit -o nounset

    # Deploy the System Upgrade Controller.
    kubectl apply -f "https://github.com/rancher/system-upgrade-controller/releases/download/v${SUC_VERSION}/system-upgrade-controller.yaml"

    # Wait for required Custom Resource Definitions to appear.
    for RETRY in 9 8 7 6 5 4 3 2 1 0; do
      if kubectl get crd/plans.upgrade.cattle.io --no-headers; then break; fi
      sleep 5
    done && [[ "$RETRY" -gt 0 ]]

    # Plan the upgrade.
    kubectl apply -f- <<EOF
    ---
    # Server plan
    apiVersion: upgrade.cattle.io/v1
    kind: Plan
    metadata:
      name: server-plan
      namespace: system-upgrade
      labels:
        rke2-upgrade: server
    spec:
      concurrency: 1
      nodeSelector:
        matchExpressions:
           - {key: rke2-upgrade, operator: Exists}
           - {key: rke2-upgrade, operator: NotIn, values: ["disabled", "false"]}
           # When using k8s version 1.19 or older, swap control-plane with master
           - {key: node-role.kubernetes.io/control-plane, operator: In, values: ["true"]}
      serviceAccountName: system-upgrade
      tolerations:
      - key: CriticalAddonsOnly
        operator: Exists
      cordon: true
    #  drain:
    #    force: true
      upgrade:
        image: rancher/rke2-upgrade
      version: "$RKE2_VERSION"
    ---
    # Agent plan
    apiVersion: upgrade.cattle.io/v1
    kind: Plan
    metadata:
      name: agent-plan
      namespace: system-upgrade
      labels:
        rke2-upgrade: agent
    spec:
      concurrency: 1
      nodeSelector:
        matchExpressions:
          - {key: rke2-upgrade, operator: Exists}
          - {key: rke2-upgrade, operator: NotIn, values: ["disabled", "false"]}
          # When using k8s version 1.19 or older, swap control-plane with master
          - {key: node-role.kubernetes.io/control-plane, operator: NotIn, values: ["true"]}
      prepare:
        args:
        - prepare
        - server-plan
        image: rancher/rke2-upgrade
      serviceAccountName: system-upgrade
      tolerations:
        - key: node.longhorn.io/create-default-disk
          value: "true"
          operator: Equal
          effect: NoSchedule
      cordon: true
      drain:
        force: true
      upgrade:
        image: rancher/rke2-upgrade
      version: "$RKE2_VERSION"
    EOF

    # Enable/Start the upgrade process on all cluster nodes.
    kubectl label nodes --all rke2-upgrade=true

.. important::

    To make the upgrade happen RKE2 needs to be able to download various docker images,
    that's why enabling access to the public Internet during the upgrade procedure is recommended.

Component Upgrade
^^^^^^^^^^^^^^^^^

By default OneKE deploys Longhorn, Traefik, and MetalLB during cluster bootstrap. All these apps are deployed
as **Addons** using `RKE2's Helm Integration <https://docs.rke2.io/helm/#helm-integration>`_ and official Helm charts.

To illustrate the process let's upgrade Traefik Helm chart from the ``10.23.0`` to the ``10.24.0`` version according to these
four basic steps:

1. To avoid downtime make sure the number of worker nodes is at least ``2`` so ``2`` (anti-affined) Traefik replicas are running.

    .. prompt:: bash $ auto

        $ oneflow scale 'Service OneKE 1.24 CE' worker 2
        $ oneflow show 'Service OneKE 1.24 CE'
        ...
        LOG MESSAGES
        06/30/22 21:32 [I] New state: DEPLOYING_NETS
        06/30/22 21:32 [I] New state: DEPLOYING
        06/30/22 21:39 [I] New state: RUNNING
        06/30/22 21:54 [I] Role worker scaling up from 1 to 2 nodes
        06/30/22 21:54 [I] New state: SCALING
        06/30/22 21:56 [I] New state: COOLDOWN
        06/30/22 22:01 [I] New state: RUNNING

    .. prompt:: bash $ auto

        $ kubectl -n traefik-system get pods
        NAME                           READY   STATUS    RESTARTS   AGE
        one-traefik-6768f7bdf4-cvqn2   1/1     Running   0          23m
        one-traefik-6768f7bdf4-qqfcl   1/1     Running   0          23m

    .. prompt:: bash $ auto

        $ kubectl -n traefik-system get pods -o jsonpath='{range .items[*]}{.spec.containers[0].image}{"\n"}{end}'
        traefik:2.7.1
        traefik:2.7.1

2. Update Helm repositories to be able to download Traefik Helm charts.

    .. prompt:: text $ auto

        $ helm repo add traefik https://helm.traefik.io/traefik
        "traefik" has been added to your repositories
        $ helm repo update
        Hang tight while we grab the latest from your chart repositories...
        ...Successfully got an update from the "traefik" chart repository
        Update Complete. ⎈Happy Helming!⎈

3. Pull the chart (version ``10.24.0``).

    .. prompt:: bash $ auto

        $ helm pull traefik/traefik --version '10.24.0'

4. Patch the ``HelmChart/one-traefik`` CRD object.

    .. prompt:: bash $ auto

        $ kubectl -n kube-system patch helmchart/one-traefik --type merge --patch-file /dev/fd/0 <<EOF
        {"spec": {"chartContent": "$(base64 -w0 < ./traefik-10.24.0.tgz)"}}
        EOF
        helmchart.helm.cattle.io/one-traefik patched

    .. prompt:: bash $ auto

        $ kubectl -n traefik-system get pods
        NAME                           READY   STATUS    RESTARTS   AGE
        one-traefik-7c5875d657-9v5h2   1/1     Running   0          88s
        one-traefik-7c5875d657-bsp4v   1/1     Running   0          88s

    .. prompt:: bash $ auto

        $ kubectl -n traefik-system get pods -o jsonpath='{range .items[*]}{.spec.containers[0].image}{"\n"}{end}'
        traefik:2.8.0
        traefik:2.8.0

.. important::

    To make the upgrade happen RKE2 needs to be able to download various docker images,
    that's why enabling access to the public Internet during the upgrade procedure is recommended.

.. important::

    This was a very simple and quick Helm chart upgrade, but in general config changes in the **spec.valuesContent** field
    may also be required. **Please plan your upgrades ahead!**

Troubleshooting
===============

Broken OneGate access
---------------------

For detailed info about OneGate please refer to the
`OneGate Usage <https://docs.opennebula.io/6.4/management_and_operations/multivm_service_management/onegate_usage.html>`_
and
`OneGate Configuration <https://docs.opennebula.io/6.4/installation_and_configuration/opennebula_services/onegate.html>`_
documents.

Because OneKE is a OneFlow service it requires OneFlow and OneGate OpenNebula components to be operational.

If the OneKE service is stuck in the ``DEPLOYING`` state and only VMs from the VNF role are visible, it is likely
there is some networking or configuration issue regarding the OneGate component. You can try to confirm if OneGate is
reachable from VNF nodes by logging in to a VNF node via SSH and executing the following command:

.. prompt:: bash # auto

    $ ssh root@10.2.11.86 onegate vm show
    Warning: Permanently added '10.2.11.86' (ED25519) to the list of known hosts.
    VM 227
    NAME                : vnf_0_(service_105)

If the OneGate endpoint is not reachable from VNF nodes, you'll see an error/timeout message.

If the OneKE service is stuck in the ``DEPLOYING`` state and all VMs from all roles are visible, and you've also confirmed that
VMs from the VNF role can access the OneGate component, there still may be a networking issue on the leader VNF node itself.
You can try to confirm if OneGate is reachable from Kubernetes nodes via SSH by executing the following command:

.. prompt:: bash # auto

    $ ssh -J root@10.2.11.86 root@172.20.0.101 onegate vm show
    Warning: Permanently added '10.2.11.86' (ED25519) to the list of known hosts.
    Warning: Permanently added '172.20.0.101' (ED25519) to the list of known hosts.
    VM 228
    NAME                : master_0_(service_105)

If you see error/timeout message on a Kubernetes node, but not on a VNF node, you should investigate networking config and logs
on the leader VNF VM, specifically the ``/var/log/messages`` file.

Broken access to the public Internet
------------------------------------

If you're constantly getting the ``ImagePullBackOff`` error in Kubernetes, please log in to a worker node and check:

- Check if the default gateway points to the private VIP address: \
    .. prompt:: bash # auto

        $ ssh -J root@10.2.11.86 root@172.20.0.102 ip route show default
        Warning: Permanently added '10.2.11.86' (ED25519) to the list of known hosts.
        Warning: Permanently added '172.20.0.102' (ED25519) to the list of known hosts.
        default via 172.20.0.86 dev eth0
- Check if the DNS config points to the nameserver defined in the private VNET: \
    .. prompt:: bash # auto

        $ ssh -J root@10.2.11.86 root@172.20.0.102 cat /etc/resolv.conf
        Warning: Permanently added '10.2.11.86' (ED25519) to the list of known hosts.
        Warning: Permanently added '172.20.0.102' (ED25519) to the list of known hosts.
        nameserver 1.1.1.1

If in all the above cases everything looks correct, then you should investigate networking config and logs
on the leader VNF VM, specifically the ``/var/log/messages`` file.

OneFlow service is stuck in DEPLOYING but RKE2 looks healthy
------------------------------------------------------------

If the OneKE service is stuck in the ``DEPLOYING`` state and
you can see the following error messages inside the ``/var/log/one/oneflow.log`` file on your OpenNebula Front-end machine:

.. code-block:: text

    [E]: [LCM] [one.document.info] User couldn't be authenticated, aborting call.

then most likely you've hit this known issue `OneFlow resilient to oned timeouts <https://github.com/OpenNebula/one/issues/5814>`_,
and recreating the OneKE cluster is your best option here.

.. |image-oneke-architecture| image:: /images/oneke-architecture.png
.. |certified-kubernetes-logo| image:: /images/certified-kubernetes-logo.svg
