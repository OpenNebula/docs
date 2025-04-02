.. _monitor_alert_overview:

.. _monitoring_alerting:

================================================================================
Monitoring and Alerting
================================================================================

This chapter provides documentation on how different resources are monitored in OpenNebula. There are two primary monitoring mechanisms:

- **OpenNebula Built-in Monitoring**: This system provides essential information about hosts and virtual machines, which is utilized for the lifecycle management of each resource.
- **Integration with Prometheus**: OpenNebula can be integrated with the `Prometheus monitoring and alerting toolkit <http://prometheus.io>`_ to enable seamless data center monitoring.

How to Use This Chapter
================================================================================

Before proceeding with this chapter, ensure you have already installed your :ref:`Frontend <frontend_installation>`, configured :ref:`KVM Hosts <kvm_node>`, and set up an OpenNebula cloud with at least one virtualization node.

This chapter is organized as follows:

- The :ref:`OpenNebula Monitoring guide <monitor_alert_configuration>` covers the setup and operation of the built-in monitoring system.
- The :ref:`Resource Monitoring guide <monitor_alert_resource>` outlines the metrics collected for each resource type.
- The :ref:`Resource Forecasting guide <monitor_alert_forecast>` explains how to configure the monitoring system to generate resource usage forecasts.
- Lastly, the :ref:`Prometheus Integration Guide <monitor_alert_prom_overview>` provides instructions for setting up Prometheus to monitor your OpenNebula cloud.

Hypervisor Compatibility
================================================================================

The monitoring and alerting features described in this guide are compatible with the KVM hypervisor.
