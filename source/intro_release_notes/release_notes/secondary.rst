.. _secondary:

================================================================================
Secondary Platforms
================================================================================

**Secondary Platforms** are experimental OpenNebula builds for bleeding edge operating systems and software versions, a completely new platforms which haven't gained mature support in the OpenNebula yet, or for non-mainstream CPU architectures. Continuity of support is not guaranteed. Builds for the **Secondary Platforms** are provided with only limited testing coverage and without any commercial support options.

.. important:: **Secondary Platforms** are not recommended for production environments!

Front-End Components
====================

+-------------------------+---------------------------------------------------------+-------------------------------------------------------+
|        Component        |                         Version                         |                    More information                   |
+=========================+=========================================================+=======================================================+
| Fedora                  | 32 (x86-64), 33 (x86-64)                                | :ref:`Front-End Installation <frontend_installation>` |
+-------------------------+---------------------------------------------------------+-------------------------------------------------------+

KVM Nodes
=========

+-------------------------+-----------------------------------------------------------+-----------------------------------------+
|        Component        |                          Version                          |             More information            |
+=========================+===========================================================+=========================================+
| Fedora                  | 32 (x86-64), 33 (x86-64)                                  | :ref:`KVM Driver <kvmg>`                |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+

Firecracker Nodes
=================

+-------------------------+-----------------------------------------------------------+-----------------------------------------+
|        Component        |                          Version                          |             More information            |
+=========================+===========================================================+=========================================+
| Fedora                  | 32 (x86-64), 33 (x86-64)                                  | :ref:`Firecracker Driver <fc_node>`     |
+-------------------------+-----------------------------------------------------------+-----------------------------------------+

Frontend Platform Notes
=======================

Fedora 32, 33
-------------

Docker Hub fails to import image as Docker doesn't support cgroup v2. Front-end must reconfigured to

- use legacy cgroup v1 by passing kernel parameter ``systemd.unified_cgroup_hierarchy=0``
- enable IPv4 forwarding ``sysctl net.ipv4.ip_forward=1``

Nodes Platform Notes
====================

Fedora 32
---------

`Live migration <https://github.com/OpenNebula/one/issues/4695>`__ with KVM virtual machines doesn't work.

Firecracker doesn't support cgroup v2, host must use kernel parameter ``systemd.unified_cgroup_hierarchy=0`` to fallback to cgroup v1.
