.. _docker_hub_overview:

================================================================================
Importing Docker Hub Images
================================================================================

`Docker Hub <https://hub.docker.com>`_ is the official, public, and free `Docker <https://www.docker.com>`_ image repository.

OpenNebula provides integration with Docker Hub via a dedicated :ref:`marketplace <market_dh>` driver. It allows to easily import these DockerHub images to the OpenNebula cloud. The OpenNebula context packages are installed during the import process so once an image is imported it’s fully prepared to be used. Such images can be used to run as Firecracker micro-VMs, LXD system containers or KVM virtual machines.
