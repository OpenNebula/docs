.. _ddc_config_playbooks_overview:

=========
Playbooks
=========

Playbooks are extensive descriptions of the configuration process (what and how is installed and configured on the physical host). Each configuration description prepares a physical host from the initial to the final ready-to-use state. Each description can configure the host in a completely different way (e.g. KVM host with private networking, KVM host with shared NFS filesystem, or KVM host supporting Packet elastic IPs, etc.). :ref:`Configuration parameters <ddc_provision_template_configuration>` are only small tunables to the configuration process driven by the playbooks.

Before the deployment, a user must choose from the available playbooks to apply on the host(s).

You can use multiple playbooks at once, you just need to add a list in your provision template, e.g:

.. code::

    ---
    playbooks:
      - default
      - static_vxlan
