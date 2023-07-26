:orphan:

OneKE's Features / Changelog
============================

OneKE 1.27.2-6.6.1-1.20230724 (Current)
---------------------------------------

====================== ================
Feature                Version
====================== ================
VNF + HAproxy          6.6.1-1.20230607
RKE2 + Multus / Cilium v1.27.2+rke2r1
Longhorn               1.4.1/1.4.1
MetalLB                0.13.9/0.13.9
Traefik                23.0.0/2.10.0
One-Cleaner
Multi-Master
Airgapped install
====================== ================

* `#6272 <https://github.com/OpenNebula/one/issues/6272>`_:

  * Added ability to turn no/off Longhorn, Traefik and MetalLB during instantiation.

  * Disabled Longhorn, Traefik and MetalLB deployments by default.

  * Renamed ``ONEAPP_K8S_LOADBALANCER_*`` to ``ONEAPP_K8S_METALLB_*``.

* `#6273 <https://github.com/OpenNebula/one/issues/6273>`_:

  * Added ability to change CNI (canal, calico or cilium).

  * Changed default CNI to Cilium (with Kube-Proxy disabled and BGP Control Plane enabled).

  * Added Multus as an optional deployment.

OneKE 1.27.1-6.6.1-1.20230702
-----------------------------

====================== ================
Feature                Version
====================== ================
VNF + HAProxy          6.6.1-1.20230607
RKE2 + Canal           v1.27.1+rke2r1
Longhorn               1.4.1/1.4.1
MetalLB                0.13.9/0.13.9
Traefik                23.0.0/2.10.0
One-Cleaner
Multi-Master
Airgapped install
====================== ================

* Removed CE flavor / Renamed EE flavor `#6253 <https://github.com/OpenNebula/one/issues/6253>`_.

OneKE 1.27.1-6.6.1-1.20230519
---------------------------------------

====================== ================
Feature                Version
====================== ================
EE / CE flavors
VNF + HAProxy          6.4.0-1.20220624
RKE2 + Canal           v1.27.1+rke2r1
Longhorn               1.4.1/1.4.1
MetalLB                0.13.9/0.13.9
Traefik                23.0.0/2.10.0
One-Cleaner
Multi-Master
Airgapped install (EE)
====================== ================

* Fixed MetalLB's regression `#6210 <https://github.com/OpenNebula/one/issues/6210>`_.

OneKE 1.27.1-6.6.1-1.20230511
-----------------------------

====================== ================
Feature                Version
====================== ================
EE / CE flavors
VNF + HAProxy          6.4.0-1.20220624
RKE2 + Canal           v1.27.1+rke2r1
Longhorn               1.4.1/1.4.1
MetalLB                0.13.9/0.13.9
Traefik                23.0.0/2.10.0
One-Cleaner
Multi-Master
Airgapped install (EE)
====================== ================

OneKE 1.24.1-6.4.0-1.20220624 / **Technology Preview**
------------------------------------------------------

====================== ================
Feature                Version
====================== ================
EE / CE flavors
VNF + HAProxy          6.4.0-1.20220624
RKE2 + Canal           v1.24.1+rke2r2
Longhorn               1.2.4/1.2.4
MetalLB                0.12.1/0.12.1
Traefik                10.23.0/2.7.1
One-Cleaner
Multi-Master
Airgapped install (EE)
====================== ================
