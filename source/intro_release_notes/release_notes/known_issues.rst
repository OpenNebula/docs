.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

In Sunstone inputs expressing sizes (disk, memory) that have units in MB, GB or TB have a bug. Once expressed in MB, if you want to update its value you'll need to change the units to GB or TB.

Accounting and Showback
=======================

A bug that might lead to innacurate hours in accounting and showback has been fixed. You can check all the information `here <https://github.com/OpenNebula/one/issues/1662>`_. But, old VMs won't be updated, so the bug might still be on those VMs.
