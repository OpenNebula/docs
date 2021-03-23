.. _container_overview:

================================================================================
Overview
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

As a complement to the traditional installation via operating system packages (see :ref:`Single Front-end Installation <frontend_installation>`), it's possible to deploy the complete OpenNebula Front-end (only, not hypervisor nodes!) from the official container image on supported container runtimes `Docker <https://www.docker.com/>`__ and `Podman <https://podman.io>`__  in multiple ways.

Containerized Front-end deployment features:

- **Simpler and faster setup** than conventional installation.
- **Easy code rollback** to the previous version on upgrade failure (NOTE: still requires revert to a particular snapshot of database/datastores).
- **Reproducible setup** with all dependencies and their versions persisted (and fully certified) in the image.
- Use on **new platforms**, for which there are no OpenNebula packages yet.
- Improved **security** with Front-end isolation among services and from the host.
- **Multi-tenant deployment**, when a single host can run multiple isolated instances of OpenNebula Front-end.
- Requires **proficiency in using and maintaining container** runtime environments!
- Might look **harder or less transparent** when compared to the traditional approach!
- Supports only direct deployment on Docker and Podman runtimes (not Kubernetes or others).
- Deploys only Front-end, hypervisor Nodes must be handled separately in a traditional way. See :ref:`Open Cluster Deployment <open_cluster_deployment>`.

.. note::

    Check the comprehensive explanation and comparison of virtual machines and containers on `What is a Container? <https://www.docker.com/resources/what-container>`__ page at `Docker <https://www.docker.com/>`__ website. You can then follow with more in-depth `documentation and tutorial <https://docs.docker.com/get-started/overview/>`__. Please note the administrator is required to have knowledge about using and maintaining the containerized deployments, these **topics are not covered by these guides**!

How Should I Read This Chapter
================================================================================

Start with the :ref:`Architecture and Simple Deployment <container_deployment>` where you learn how to deploy simple containerized OpenNebula Front-end. Continue with the :ref:`Advanced Deployment Customizations <container_custom>` for a more fine-tuned deployment and description of the internal :ref:`Bootstrap Process <container_bootstrap>`. The last section :ref:`Troubleshooting and Reference <container_reference>` is a helpful guide for various deployment configurations. It starts with a few troubleshooting hints, tutorials, and follows up with a complete reference about all deployment parameters and options.

Hypervisor Compatibility
================================================================================

This chapter applies to all supported hypervisors.
