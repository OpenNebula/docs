.. _ddc_provision_templates:

=========
Templates
=========

Several templates are shipped in the distribution package. Those are not the final templates, but only provide a partial definition of infrastructure and should be used as a base (extended) in your custom templates. Check the brief description of each template, and continue with reading the content of the template files in your installation.

.. _ddc_provision_templates_default:

Template 'default'
------------------

.. note::

    Installed into
    ``/usr/share/one/oneprovision/templates/default.yaml``.

Template with private OpenNebula virtual network configured by :ref:`default <ddc_config_playbooks_default>` on physical hosts.

The following virtual network(s) are configured:

* nat

.. _ddc_provision_templates_static_vxlan:

Template 'static_vxlan'
-----------------------

.. note::

    Installed into
    ``/usr/share/one/oneprovision/templates/static_vxlan.yaml``.

Template with private OpenNebula virtual networks configured by :ref:`static_vxlan <ddc_config_playbooks_static_vxlan>` on physical hosts.

The following virtual network(s) are configured:

* nat
* private

.. _ddc_provision_cluster_templates:

=========================
Example Complex Templates
=========================

Few examples of complete cluster templates are shipped in the distribution package. These are for the two providers OpenNebula supports - the Packet and Amazon EC2. The examples should be used following way:

- Copy the file with example template.
- Replace values with ``****`` by valid credentials, depending on the template you are using.
- Uncomment (and create more) hosts you want to deploy.
- On your frontend under oneadmin user, trigger provision based on your template. E.g.,

.. prompt:: bash $ auto

   $ oneprovision create custom_packet.yaml -d

.. _ddc_provision_template_packet:

Packet Cluster
--------------

.. note::

    Installed into ``/usr/share/one/oneprovision/examples/example_packet.yaml``.

Template with the following resources:

- disabled hosts with CentOS 7 and Ubuntu 18.04 to be deployed on Packet
- image and system datastores (driver SSH)
- networks:

 - ``public`` (IPs allocated via :ref:`IPAM <ddc_ipam_packet>` from Packet; should be attached as NIC alias to NIC from ``private-host-only``)
 - ``private-host-only`` (to be used with ``public`` network)
 - ``private``

.. _ddc_provision_template_ec2:

Amazon EC2 Cluster
------------------

.. note::

    Installed into ``/usr/share/one/oneprovision/examples/example_ec2.yaml``.

Template with the following resources:

- disabled hosts with CentOS 7 and Ubuntu 16.04 to be deployed on EC2
- image and system datastores (driver SSH)
- networks:

 - ``private-host-only-nat`` (with NAT enabled)
 - ``private``
