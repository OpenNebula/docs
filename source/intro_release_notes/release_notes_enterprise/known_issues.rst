.. _known_issues_ee:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Upgrading from 5.12.13
======================

When upgrading the configuration from version 5.12.13 the ``onecfg upgrade`` fails. To avoid this you need to revert config change delivered by the package by running following command:


.. prompt:: bash # auto

    sed -i 's/Copyright 2002-2023/Copyright 2002-2020/' \
        /var/lib/one/backups/config/*v5.12.13/etc/one/az_driver.default \
        /var/lib/one/backups/config/*v5.12.13/etc/one/ec2_driver.default

After that the ``onecfg upgrade`` should work again correctly.


Accounting and Showback
=======================

A bug that might lead to inaccurate hours in accounting and showback has been fixed. You can check all the information `here <https://github.com/OpenNebula/one/issues/1662>`_. But, old VMs won't be updated, so the bug might still be on those VMs.

The showback calculation was `optimized <https://github.com/OpenNebula/one/issues/5020>`_. This optimization can cause different results in some edge cases for VMs which changed owner. You can manualy fix this by changing the VM owner again by running ``onevm chown vm_id user_id``. This inconsistency will be solved in 6.0, by ``onedb upgrade``.

Sunstone Browser
================

Current implementation of Sunstone is not working on Internet Explorer due to new Javascript version.

As a workaround you can use the other browsers:

- Chrome (61.0 - 67.0)
- Firefox (59.0 - 61.0)

Hooks
=====

Potential issue with `host_error.rb` hook when receiving the host template argument from command line. You can check all the information `here <https://github.com/OpenNebula/one/issues/5101>`__
