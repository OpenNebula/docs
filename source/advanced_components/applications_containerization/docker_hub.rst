.. _docker_hub_overview:

================================================================================
Docker Hub
================================================================================

`Docker Hub <https://hub.docker.com>`_ is the official, public, and free `Docker <https://www.docker.com>`_ image repository.

OpenNebula provides integration with Docker Hub via a dedicated :ref:`marketplace <market_dh>` driver. It allows to export the images hosted on Docker Hub into the OpenNebula to the image datastores. Such images can be used to run as micro virtual machines on specialized :ref:`Firecracker <fcmg>` (or even common) hypervisor.
