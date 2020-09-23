.. _known_issues_ee:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Accounting and Showback
=======================

A bug that might lead to inaccurate hours in accounting and showback has been fixed. You can check all the information `here <https://github.com/OpenNebula/one/issues/1662>`_. But, old VMs won't be updated, so the bug might still be on those VMs.

Sunstone Browser
================

Current implementation of Sunstone is not working on Internet Explorer due to new Javascript version.

As a workaround you can use the other browsers:

- Chrome (61.0 - 67.0)
- Firefox (59.0 - 61.0)

Hooks
=====

Potential issue with `host_error.rb` hook when receiving the host template argument from command line. You can check all the information `here <https://github.com/OpenNebula/one/issues/5101>`__
