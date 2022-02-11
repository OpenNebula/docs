.. _compatibility_621:

=========================
Compatibility Guide 6.2.1
=========================

If you are coming from a version previous to 6.2.1, you will need to read also the :ref:`6.2.1 compatibility guide <compatibility>`.

Packaging and Platform Support
==============================

With CentOS having reached its `end of life <https://www.centos.org/centos-linux-eol/>`_ date, OpenNebula 6.2.1 introduces the following adaptations:

- CentOS packages are no longer built.
- There is a new repository for `AlmaLinux <https://almalinux.org/>`_ 8. Any other distribution compatible with Red Hat Enterprise Linux 8 (e.g. Oracle Linux or Rocky Linux) should be able to use this repository.
- Red Hat Enterprise Linux 7 and 8 are fully supported. Specific repositories has been created for these two distributions.

:ref:`Please refer to the installation guide <frontend_installation>` to update your repository files as needed.

Distributed Edge Provisioning
=============================

- RHEL 7 does not support Edge Cluster provisioning on Equinix.
