.. _understand:

================================
Cloud Access Model and Roles
================================

In a small installation with a few Hosts you can use OpenNebula without giving much thought to infrastructure partitioning and provisioning. Yet, for medium and large-scale deployments you'll probably want to provide some level of isolation and structure. OpenNebula offers a flexible and powerful cloud provisioning model based on Virtual Data Centers (VDCs) that enables an integrated, comprehensive framework to dynamically provision the infrastructure resources in large multi-datacenter and multi-cloud environments to different customers, business units or groups. Another key management task in an OpenNebula Infrastructure environment has to do with determining who can use the cloud interfaces and what tasks those users are authorized to perform. This White Paper is meant for cloud architects, builders and administrators, to help them understand the OpenNebula models for managing and provisioning virtual resources, and the default user roles.

|image|

.. note:: The White Paper of the True Hybrid Cloud Architecture is publicly available for download `here <https://support.opennebula.pro/hc/en-us/articles/360018778938-Cloud-Provisioning-Models-and-User-Roles>`__.

.. |image| image:: /images/overview_vdc.png
  :width: 70%
