.. _open_cloud_architecture:
.. _plan:

================================================================================
Open Cloud Reference Architecture
================================================================================

The OpenNebula Cloud Reference Architecture is a blueprint to guide IT architects, consultants, administrators, and field practitioners in the design and deployment of public and private clouds fully based on open source platforms and technologies. It has been created from the collective information and experiences of hundreds of users and cloud client engagements. Besides the main logical components and interrelationships, this reference  architecture documents software products, configurations, and requirements of infrastructure platforms recommended for a smooth OpenNebula installation. Three optional functionalities complete the architecture: high availability, true hybrid and edge cloud for workload outsourcing, and federation of geographically dispersed data centers.

The document describes the reference architecture for Basic and Advanced OpenNebula Clouds, provides software recommendations for the main architectural components, and details the rationale behind them. Each section also provides information about other open source infrastructure platforms tested and certified by OpenNebula to work in enterprise environments. As a complement for these certified components, OpenNebula provides a browseable add-on catalog providing further options supported by partners and the OpenNebula community. Moreover, there are other components in the open cloud ecosystem that are not part of the reference architecture, but are nonetheless important to consider at the time of designing a cloud, such as Configuration Management and Automation Tools for configuring cloud infrastructure and managing a large number of devices.

|image|

.. note:: The White Paper on the Open Cloud Architecture is publicly available for download `here <https://support.opennebula.pro/hc/en-us/articles/204210319-Open-Cloud-Reference-Architecture-White-Paper>`__.

Storage
=======

Deciding which is the right storage backend for your cloud depends on your performance, scalability, and availability requirements; your existing storage infrastructure; your budget for new hardware, licenses, and support; and your skills and the IT staff you want to dedicate to its operation. OpenNebula provides a variety of ways for Virtual Machines and containers to access storage. It supports multiple traditional storage models including NAS, SAN, NFS, iSCSI, and Fiber Channel (FC), which allow virtualized applications to access storage resources in the same way as they would on a regular physical machine. It also supports distributed Software-Defined Storage (SDS) models like Ceph, GlusterFS, StorPool, and LinStor, that allow you to create and scale elastic pools of storage and hyperconvergence deployments.

.. |image| image:: /images/one_high.png
  :width: 70%
