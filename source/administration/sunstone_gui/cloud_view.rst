.. _cloud_view:

========================
Self-service Cloud View
========================

This is a simplified view intended for cloud consumers that just require a portal where they can provision new virtual machines easily. To create new VMs, they just have to select one of the available templates prepared by the administrators.

In this scenario the cloud administrator, or the vDC administrator, must prepare a set of templates and images and make them available to the cloud users. These Templates must be ready to be instantiated, i.e. they define all the mandatory attributes. Before using them, users can optinally customize the VM capacity, and add new network interfaces.


|image0|

How to Prepare the Templates
=============================

When launching a new VM, users are required to select a Template. These templates should be prepared by the cloud or vDC administrator. Make sure that any Image or Network referenced by the Template can be also used by the users. Read more about how to prepare resources for end users in the :ref:`Adding Content to Your Cloud <add_content>` guide.

|cloud-view-create|

How to Enable
================

The cloud view is enabled by default for all users. If you want to disable it, or enable just for certain groups, proceed to the :ref:`Sunstone Views <suns_views>` documentation.

.. note:: Any user can change the current view in the Sunstone settings. Administrators can use this view without any problem if they find it easier to manage their VMs.

.. |image0| image:: /images/cloud-view.png
   :width: 100 %
.. |cloud-view-create| image:: /images/cloud-view-create.png
   :width: 100 %
