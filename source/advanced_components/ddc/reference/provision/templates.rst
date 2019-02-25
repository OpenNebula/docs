.. _ddc_provision_templates:

=========
Templates
=========

Several templates are shipped in the distribution package. Those are not the final templates, but only provide a partial definition of infrastructure and should be used (extended) as a base in own custom templates. Check the brief description of each template, and continue with reading the content of the template files in your installation.

.. _ddc_provision_templates_default:

Template 'default'
------------------

.. note::

    Installed into
    ``/usr/share/one/oneprovision/templates/default.yaml``.

Template with private OpenNebula virtual network configured by :ref:`default <ddc_config_playbooks_default>` on physical hosts.

Following virtual network(s) are configured:

* nat

.. _ddc_provision_templates_static_vxlan:

Template 'static_vxlan'
-----------------------

.. note::

    Installed into
    ``/usr/share/one/oneprovision/templates/static_vxlan.yaml``.

Template with private OpenNebula virtual networks configured by :ref:`static_vxlan <ddc_config_playbooks_static_vxlan>` on physical hosts.

Following virtual network(s) are configured:

* nat
* private
