.. _secondary:

================================================================================
Secondary Platforms
================================================================================

**Secondary Platforms** are experimental OpenNebula builds for bleeding edge operating systems and software versions, a completely new platform which hasn't gained mature support in OpenNebula yet, or for non-mainstream CPU architectures. Continuity of support is not guaranteed. Builds for the **Secondary Platforms** are provided with only limited testing coverage and without any commercial support options.

.. important:: **Secondary Platforms** are not recommended for production environments, nor officially supported by OpenNebula Systems.

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

Nodes Platform Notes
====================

Fedora 32
---------

`Live migration <https://github.com/OpenNebula/one/issues/4695>`__ with KVM virtual machines doesn't work.

Firecracker doesn't support cgroup v2; Host must use kernel parameter ``systemd.unified_cgroup_hierarchy=0`` to fall back to cgroup v1.
