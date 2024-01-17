.. _service_overview:
.. _one_service_appliance:

========
Overview
========

The public OpenNebula `Marketplace <https://marketplace.opennebula.io/>`_ includes easy-to-use appliances, which are preconfigured Virtual Machines that can be used to deploy different services. These appliance include the images with all necessary packages installed for the service run, including the :ref:`OpenNebula contextualization packages <context_overview>` and specific scripts that bring the service up on boot. This allows to customize the final service state by the cloud user via special contextualization parameters.

No security credentials are persisted in the distributed appliances. Initial passwords are provided via the contextualization parameters or are dynamically generated for each new virtual machine. No two virtual machines with default contextualization parameters share the same passwords or database credentials.

OneKE Service (Kubernetes)
==========================
.. include:: oneke.txt

Virtual Router (VR)
===================
.. include:: vr.txt

WordPress
=========
.. include:: wordpress.txt

