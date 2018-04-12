.. _overview:

================================================================================
Overview
================================================================================

Application containerization is an OS-level virtualization method used to deploy and run distributed applications without launching an entire virtual machine (VM) for each application. OpenNebula supports the execution of multiple isolated applications within the VM instances, which means an instance could have multiple containers all sharing the same resources allocated to the running VM. 

OpenNebula brings a built-in integration with Docker, the most common application containerization, to simplify the provision and management of Dockerized hosts. These virtualized Docker hosts are created using the OpenNebula Docker appliance (for `KVM <http://marketplace.opennebula.org/appliance/38cddc1e-8ef5-4759-9c38-954bfa9ae8d1>`__ or `vCenter <http://marketplace.opennebula.org/appliance/f39f36f3-bc8e-4151-bd86-ac3c9a5b6bac>`__) available on the OpenNebula Marketplace that should be previously downloaded and registered in the cloud datastore. OpenNebula provides cloud users with three approaches to use the Docker engine instances hosted by these virtualized Docker hosts. 

The simpler approach is to directly instantiate and access the OpenNebula Docker image, and manage the dockerized hosts by using the OpenNebula GUI and CLI.
OpenNebula also provides a driver for Docker Machine, which allows the remote provision and management of Docker hosts, and execution of Docker commands on the remote host from your Docker client.


|docker-machine|

How Should I Read This Chapter
================================================================================

We recommend you start reading with the guide about how to use the Opennebula Docker application with the OpenNebula CLI and GUI, and continue with the Docker Machine and the Docker Swarm guides only if you are interested in remote management of Docker hosts and clusters from your remote Docker client.

After reading this chapter you can continue configuring more Advanced Components.

Hypervisor Compatibility
================================================================================

This Chapter applies both to KVM and vCenter.

.. |docker-machine| image:: /images/docker_arch.png