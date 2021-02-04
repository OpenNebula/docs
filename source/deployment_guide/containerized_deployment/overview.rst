.. _containerized_deployment_overview:

================================================================================
Overview
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

OpenNebula offers an official Docker image with all required dependencies installed inside. Running such image via (supported) container runtime like `Docker <https://www.docker.com/>`_ will create application container(s) acting as OpenNebula Frontend. The image is parametrized and can be configured to be deployed in multiple ways.

Container deployment in general provides a few benefits:

- Lightweight alternative to Virtualization
- Arguably easier and faster deployment than conventional installation
- Reproducible setup / initial deployment
- New installation option for systems without available OpenNebula packages
- Isolation of OpenNebula services from the host system and vice versa
- Parallel deployment of multiple OpenNebula Front-ends on the same system
- Easier rollback to some previous functioning version

.. note::

    There is a comprehensive explanation and comparison between virtual machines and containers on `What is a Container? <https://www.docker.com/resources/what-container>`_ page at `Docker <https://www.docker.com/>`_ website. You can then follow with the more in-depth `documentation and tutorial <https://docs.docker.com/get-started/overview/>`_.

How Should I Read This Chapter
================================================================================

Continue on with the :ref:`Architecture and Deployment <containerized_deployment>` where you learn how to install and deploy OpenNebula as Docker containers.

The subsequent :ref:`Troubleshooting and Reference <containerized_deployment_reference>` will be a very helpful guide for various deployment configurations. It starts with a few troubleshooting hints and quickly follows-up with comprehensive information about the internals of the container image and contains a complete reference about all possible deployment parameters and options. There is also a collection of some miscellaneous topics and advices in :ref:`the Appendix <appendix>`.

Hypervisor Compatibility
================================================================================

:ref:`Containerized Deployment <containerized_deployment>` is describing a deployment of a container image implementing the OpenNebula Front-end and therefore it supports all hypervisors which are supported by OpenNebula.
