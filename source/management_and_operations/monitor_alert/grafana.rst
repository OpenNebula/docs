.. _monitor_alert_grafana:

================================================================================
Grafana Visualization
================================================================================

Requirements
================================================================================

This guide assumes you have already and up and running Grafana service. If you do not have already Grafana installed, follow the follwoing guides:

  - `Download and Installation <https://grafana.com/grafana/download>`_.
  - `Add a new Prometheus Data sources <https://grafana.com/blog/2022/01/26/video-how-to-set-up-a-prometheus-data-source-in-grafana/>`_.

.. note:: Prometheus is listening in the standard port (9090) as described in the installation guide.

Grafana Dashboards
================================================================================

We provide three dashboard templates that can be customized to your needs:
  - Dashboard to visualize Virtual Machine information `/usr/share/one/grafana/dashboards/vms.json`.
  - Dashboard to visualize Host information `/usr/share/one/grafana/dashboards/hosts.json`.
  - Dashboard to visualize the overall status of the OpenNebula cloud `/usr/share/one/grafana/dashboards/opennebula.json`.

You can easily import these dashboards by copying the contents of these files in the Dashboards > + Import form.

The Virtual Machine and Host dashboards are by default indexed by ID but it can easily changed in the Settings > Variables dialog to use `one_vm_name` and `one_host_name`, respectively.

|grafana-dashboard|

.. |grafana-dashboard| image:: /images/grafana-dashboard.png
