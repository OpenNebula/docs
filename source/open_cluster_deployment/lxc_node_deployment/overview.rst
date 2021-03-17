.. _lxc_node_deployment_overview:

================================================================================
Overview
================================================================================

`LXC <https://linuxcontainers.org/lxc/introduction/>`__ allows Linux users to create and manage system and application containers. LXC uses Linux kernel features as kernel namespaces, CGroups or Seccomp policies among others to contain processes.

The goal of LXC is to create environments similar to an standard Linux installation without the need for a separate kernel.

How Should I Read This Chapter
================================================================================

This chapter focuses on the configuration options for an LXC based Hosts. Read the :ref:`installation <lxc_node>` section to add an LXC host to your OpenNebula cloud to start deploying containers. Continue with :ref:`driver <lxcmg>` section in order to understand the specific requirements, functionalities, and limitations of the LXC driver.

You can then continue with Open Cloud :ref:`Storage <storage>` and :ref:`Networking <nm>` chapters to be able to deploy your containers on your LXC hosts and access them remotely over the network.

Hypervisor Compatibility
================================================================================

This chapter applies only to LXC.
