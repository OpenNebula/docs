.. _monitor_alert_alarms:

================================================================================
Alert Manger
================================================================================

Requirements
================================================================================

This guide assumes you have already and up and running Prometheus installation with the AlertManager component enabled.


Alerts Rules
================================================================================

We provide some pre-defined alert rules that cover the common use cases for an OpenNebula cloud. These rules are not intended to use as-is, but as a starting point to define the alert situations for your specific use case.  Please `review the Promethus documentation <https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/>`_ to adapt the provided alert rules.

.. TODO:: Hint about notification mechanism

Group: OpenNebula Servers
================================================================================

.. TODO:: Describe all alerts

- Goal: Alert if OpenNebula server is down
- Level: Critical
- Definition:

.. code:: yaml

   - alert: OpenNebulaServerDown
      expr: opennebula_server_state == 0
      for: 30s
      annotations:
        title: "OpenNebula server {{ $labels.fqdn }} down"
        description: "OpenNebula server {{ $labels.fqdn }} of job {{ $labels.job }} has been down for more than 30 seconds"
      labels: { severity: critical }




