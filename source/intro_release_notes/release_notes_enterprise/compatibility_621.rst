.. _compatibility_621:

=========================
Compatibility Guide 6.2.1
=========================

If you are coming from a version previous to 6.2.0, you will need to read also the :ref:`6.2.0 compatibility guide <compatibility>`.

Packaging and Platform Support
==============================

With CentOS having reached its end of life date, OpenNebula 6.2.1 introduces the following adaptations:

- CentOS packages are no longer build.
- There is a new repository for AlmaLinux 8. Any distribution compatible with RedHat Enterprise Linux 8 should be able to use this repository (E.g. RockyLinux).
- RedHat Enterprise Linux 7 and 8 are fully supported, specific repositories has been created for these two distributions.

:ref:`Please refer to the installation guide <frontend_installation>` to update your repository files as needed.

Distributed Edge Provisioning
=============================

- RHEL 7 does not support Equnix for edge clusters provisioning from OpenNebula version 6.2.1
