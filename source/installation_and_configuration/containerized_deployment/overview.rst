.. _container_overview:

================================================================================
Overview
================================================================================

.. important:: This feature is a **Technology Preview**. It's not recommended for production environments!

As a complement to the traditional installation via operating system packages (see :ref:`Single Front-end Installation <frontend_installation>`), it's possible to deploy the complete OpenNebula Front-end (without hypervisor nodes!) from the official container image on supported container runtimes `Docker <https://www.docker.com/>`__ and `Podman <https://podman.io>`__  in multiple ways.

Containerized front-end deployment features:

- **Simpler and faster setup** than conventional installation.
- **Easy code rollback** to the previous version on upgrade failure (NOTE: still requires revert to a particular snapshot of database/datastores).
- **Reproducible setup** with all dependencies and their versions persisted (and fully certified) in the image.
- Use on **new platforms**, for which there are no OpenNebula packages yet.
- Improved **security** with Front-end isolation among services and from the host.
- **Multi-tenant deployment**, when a single host can run multiple isolated instances of OpenNebula Front-end.
- Requires **proficiency in using and maintaining container** runtime environments!
- Might look **harder or less transparent** when compared to the traditional approach!
- Supports and covers only direct usage of Docker and Podman runtimes, it is not Kubernetes ready by default.
- Implements only the OpenNebula Front-end, there is no containerized nodes!

.. note::

    Check the comprehensive explanation and comparison of virtual machines and containers on `What is a Container? <https://www.docker.com/resources/what-container>`__ page at `Docker <https://www.docker.com/>`__ website. You can then follow with more in-depth `documentation and tutorial <https://docs.docker.com/get-started/overview/>`__. Please note the administrator is required to have knowledge about using and maintaining the containerized deployments, these **topics are not covered by these guides**!

How Should I Read This Chapter
================================================================================

Continue with the :ref:`Architecture and Simple Deployment <container_deployment>` where you learn how to deploy containerized OpenNebula Front-end. Also check the :ref:`Advanced Deployment and Customizations <container_custom>` for a more fine-tuned deployment and description of the internal :ref:`Bootstrap Process <container_bootstrap>`.

The subsequent :ref:`Troubleshooting and Reference <container_reference>` will be a very helpful guide for various deployment configurations. It starts with a few troubleshooting hints and quickly follows up with a complete reference about all possible deployment parameters and options. There is also a collection of some miscellaneous topics and other bits of advice in :ref:`the Appendix <container_appendix>`.

Hypervisor Compatibility
================================================================================

This chapter applies to all supported hypervisors.
