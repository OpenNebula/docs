.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Scheduler
=========

Metrics referring to Datastore monitoring (``MAX_DISK``, ``FREE_DISK``, ``USED_DISK`` and ``DISK_USAGE``) no longer works because of a missing XPATH route. Until a proper fix is released you need to update the ``RANK`` or ``REQUIREMENTS`` expressions using the new location with double quotes e.g. ``"DATASTORES/MAX_DISK"``. You can check all the information `here <https://github.com/OpenNebula/one/issues/5154>`__.

Accounting and Showback
=======================

A bug that might lead to inaccurate hours in accounting and showback has been fixed. You can check all the information `here <https://github.com/OpenNebula/one/issues/1662>`__. But, old VMs won't be updated, so the bug might still be on those VMs.

Sunstone Translate
==================

If you are experiencing translation errors switching Suntone language, this fix might alleviate the issue. Download the following po2json.rb from the OpenNebula repository and run it for each of the languages that you are planing to use.

.. code-block:: bash

     # wget https://raw.githubusercontent.com/OpenNebula/one/master/share/scons/po2json.rb

.. note:: to see the existing languages proceed to ``/usr/lib/one/sunstone/public/locale/languages``. Each language is contained in separate file with the **.po** extension).

To apply the fix for a given language, adapt the following instructions for spanish.

.. code-block:: bash

     # wget https://raw.githubusercontent.com/OpenNebula/one/master/src/sunstone/public/locale/languages/es_ES.po
     # ruby po2json.rb es_ES.po > /usr/lib/one/sunstone/public/locale/languages/es_ES.js

Afterwards please make sure you clear your browser cache.

Sunstone Browser
================

Current implementation of Sunstone is not working on Internet Explorer due to new Javascript version.

As a workaround you can use the other browsers:

- Chrome (61.0 - 67.0)
- Firefox (59.0 - 61.0)

Hooks
=====

Potential issue with `host_error.rb` hook when receiving the host template argument from command line. You can check all the information `here <https://github.com/OpenNebula/one/issues/5101>`__

OneFlow
=======

Elasticity rules that apply to monitoring information do not work. This issue will be fixed on 5.12.6 and 5.12.0.4 versions.
