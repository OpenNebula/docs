.. _whats_new:

================================================================================
What's New in 5.6
================================================================================


OpenNebula Core
--------------------------------------------------------------------------------

.. - **New HA model**, providing native HA (based on RAFT consensus algorithm) in OpenNebula components, including Sunstone without :ref:`third party dependencies <frontend_ha_setup>`.


Storage
--------------------------------------------------------------------------------


Networking
--------------------------------------------------------------------------------

- Better support for security group rules with a large number of ports. :ref:`See configuration options here <bridged_conf>`.

Hybrid Clouds: Amazon EC2
--------------------------------------------------------------------------------


Scheduler
--------------------------------------------------------------------------------


Sunstone
--------------------------------------------------------------------------------

- **New dashboard**, intuitive, fast and light. The new dashboard will perform better on large deployments.

|sunstone_dashboard|

- **KVM and vCenter more united than ever**, a single view to control the two hypervisors. :ref:`Completely customizable views <suns_views>`.
- **Scheduled Actions** can now be defined in VM Template create and instantiate dialogs. :ref:`More info <sched_actions_templ>`.
- **Display quotas in Clod View**, the end-user can see his quotas in real time.

|sched_actions|


vCenter
--------------------------------------------------------------------------------


.. |sunstone_dashboard| image:: /images/sunstone_dashboard.png
.. |sched_actions| image:: /images/sched_actions.png
