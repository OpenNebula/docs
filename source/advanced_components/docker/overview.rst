.. _overview:

================================================================================
Overview
================================================================================

OpenNebula integration with Docker aims at building a infrastructure fabric managed by OpenNebula that allows to deploy Docker containers.

Coupled with Docker Machine, OpenNebula is able to provision individual or sets of Docker Engines, taking care of all the network and storage provision as it does for regular VMs. With this integratoin, having access to an OpenNebula clouds means being able to remotely deploy Docker container using the resources managed by OpenNebula.

|docker-machine|

.. |docker-machine| image:: /images/docker_arch.png