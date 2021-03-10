.. _container_overview:

================================================================================
Overview
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

As a complement to the traditional installation via operating system packages (see :ref:`Single Front-end Installation <frontend_installation>`), it's possible to deploy the complete OpenNebula Front-end (only, not hypervisor nodes!) from the official container image on supported container runtimes `Docker <https://www.docker.com/>`__ and `Podman <https://podman.io>`__  in multiple ways.

Containerized front-end deployment features:

- **Simpler and faster setup** than conventional installation.
- **Easy code rollback** to the previous version on upgrade failure (NOTE: still requires revert to a particular snapshot of database/datastores).
- **Reproducible setup** with all dependencies and their versions persisted (and fully certified) in the image.
- Use on **new platforms**, for which there are no OpenNebula packages yet.
- Improved **security** with Front-end isolation among services and from the host.
- **Multi-tenant deployment**, when a single host can run multiple isolated instances of OpenNebula Front-end.
- Requires **proficiency in using and maintaining container** runtime environments!
- Might look **harder or less transparent** when compared to the traditional approach!
- Supports only Docker and Podman runtimes and covers only Front-end, not nodes!

.. note::

    Check the comprehensive explanation and comparison of virtual machines and containers on `What is a Container? <https://www.docker.com/resources/what-container>`__ page at `Docker <https://www.docker.com/>`__ website. You can then follow with more in-depth `documentation and tutorial <https://docs.docker.com/get-started/overview/>`__. Please note the administrator is required to have knowledge about using and maintaining the containerized deployments, these **topics are not covered by these guides**!

How Should I Read This Chapter
================================================================================

Continue with the :ref:`Architecture and Deployment <container_deployment>` where you learn how to deploy containerized OpenNebula Front-end.

The subsequent :ref:`Troubleshooting and Reference <container_reference>` will be a very helpful guide for various deployment configurations. It starts with a few troubleshooting hints and quickly follows-up with comprehensive information about the internals of the container image and contains a complete reference about all possible deployment parameters and options. There is also a collection of some miscellaneous topics and bits of advice in :ref:`the Appendix <container_appendix>`.

Hypervisor Compatibility
================================================================================

:ref:`Containerized Deployment <container_deployment>` describes only the deployment of containerized OpenNebula Front-end. Such deployment supports all hypervisors as the traditionally installed OpenNebula Front-end. Hypervisors are not covered by the containerized deployment and this guide, continue to the :ref:`Customized Clusters Installation <node_installation>`.
