
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.12.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`.

Visit the :ref:`Features list <features>` and the `Release Notes <https://opennebula.io/use/>`__ for a comprehensive list of what's new in OpenNebula 5.12.

Distributed Edge Provisioning
=============================

Information about provision is stored in a JSON document. For this reason, the ERB evaluation must be done using the variable ``@body['provision']``.

To access to infrastructure resources, just access to key ``infrastrcuture`` following by the object, e.g:

.. code::

    @body['provision']['infrastructure']['datastores'][0]['id']

To access to resources, just access to key ``resource`` following by the object, e.g:

.. code::

    @body['provision']['resource']['images'][0]['id']

Check more information :ref:`here <ddc_virtual>`.
