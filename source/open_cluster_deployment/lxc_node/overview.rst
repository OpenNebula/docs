.. _lxc_node_deployment_overview:

================================================================================
Overview
================================================================================

`LXC <https://linuxcontainers.org/lxc/introduction/>`__ is a Linux technology which allows us to create and manage system and application containers. The containers are computing environments running on a particular hypervisor Node alongside other containers or Host services, but secured and isolated in their own namespaces (user, process, network).

From the perspective of a hypervisor Node, such a container environment is just an additional process tree among other hypervisor processes. Inside of the environment, it looks like a standard Linux installation that sees only its own resources but shares the host kernel.

How Should I Read This Chapter
================================================================================

This chapter focuses on the configuration options for LXC-based Nodes. Read the :ref:`installation <lxc_node>` section to add an LXC Node to your OpenNebula cloud to start deploying containers. Continue with the :ref:`driver <lxcmg>` section in order to understand the specific requirements, functionalities, and limitations of the LXC driver.

You can then move on to look at the Open Cloud :ref:`Storage <storage>` and :ref:`Networking <nm>` chapters to be able to deploy your containers on your LXC Nodes and access them remotely over the network.

Hypervisor Compatibility
================================================================================

This chapter applies only to LXC.
