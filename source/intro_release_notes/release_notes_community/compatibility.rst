
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.12.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`.

Visit the :ref:`Features list <features>` and the `Release Notes <https://opennebula.io/use/>`__ for a comprehensive list of what's new in OpenNebula 5.12.

Ruby API
========

Some functions has been moved from API to new API extensions:

- save_as_template

To be able to use them, you need to extend from the extensions file:

.. code::

    require 'opennebula/virtual_machine_ext'

    vm_new = VirtualMachine.new(VirtualMachine.build_xml(@pe_id), @client)
    vm_new.extend(VirtualMachineExt)
