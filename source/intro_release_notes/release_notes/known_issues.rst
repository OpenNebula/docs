.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Accounting and Showback
=======================

A bug that might lead to innacurate hours in accounting and showback have been fixed. You can check all the information `here <https://github.com/OpenNebula/one/issues/1662>`_. But, old VMs won't be updated, so the bug might be still on those VMs.

vCenter Driver
==========================

The vCenter driver is not fully adapted yet to the new monitoring system. Functionality is working as expected, however there is a greater memory consumption that we are working to mitigate.

OneFlow
=======

Services using ``ready_status_gate: true``, will be in running state although ``READY=YES`` is not in the VM template.

DockerHub Images
==========================

DockerHub images are currently only fully tested for Firecracker MicroVMs, it could fail for LXD containers. KVM Virtual Machines are not supported yet, we are working on it for the final release.