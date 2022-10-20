.. _monitor_alert_overview:

================================================================================
Monitoring and Alerting (EE)
================================================================================

This chapter contains documentation on how to configure OpenNebula to work with `Prometheus monitoring and alerting toolkit <http://prometheus.io>`_. The integration consists of four components:

  - A Libvirt Exporter, that provides information about VM (KVM domains) running on an OpenNebula host.
  - An OpenNebula Exporter, that provides basic information about the overall OpenNebula cloud.
  - Alert rules sample files based on the provided metrics
  - `Grafana <https://grafana.com/>`_ dashboards to visualize VM, Host and OpenNebula information in a convenient way.

.. important:: This feature is only available for OpenNebula Enterprise Edition.

How Should I Read This Chapter
================================================================================

Before reading this chapter, you should have already installed your :ref:`Frontend <frontend_installation>`, the :ref:`KVM Hosts <kvm_node>` and have an OpenNebula cloud up and running with at least one virtualization node.

This Chapter is structured as follows:

  - The :ref:`installation guide <monitor_alert_installation>` describes the installation and basic configuration of the integration.
  - How to :ref:`visualize monitor data with Grafana <monitor_alert_grafana>` explained in a dedicated Section.
  - Specific procedures to :ref:`set up alarms <monitor_alert_alarms>` is also addressed in this Chapter.

Finally you can find a reference of the :ref:`metrics gathered by the exporters here <monitor_alert_metrics>`.

Hypervisor Compatibility
================================================================================

These guides are compatible with the KVM hypervisor.
