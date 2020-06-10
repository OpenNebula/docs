.. _docker_appliance_overview:

================================================================================
Docker
================================================================================

`Docker <https://www.docker.com>`_ is one of the many Linux container runtimes but it is also the most popular and the most supported. Docker pioneered the new approach to the containerization and with the advent of microservices it changed the landscape of how complex applications are designed and built.

OpenNebula brings a built-in integration with Docker to simplify the provision and management of Dockerized hosts on your private cloud. OpenNebula provides cloud users with two approaches to use the Docker engine instances hosted by these virtualized Docker hosts.

The simpler approach is to directly instantiate the :ref:`OpenNebula Docker Appliance <docker_appliance_overview>` available on the OpenNebula Marketplace that should be previously downloaded and registered in the cloud datastore and then manage the Dockerized hosts by using OpenNebula CLI or Sunstone.

OpenNebula also provides a driver for :ref:`Docker Machine <docker_machine_overview>`, which allows the remote provision and management of Docker hosts within OpenNebula cloud, and the execution of Docker commands on the remote host from your Docker client.

OpenNebula's users thus can execute multiple isolated applications within the VM instances, which means that an instance could have multiple containers all sharing the same resources allocated to the running VM.

Finally, within your OpenNebula cloud you can build and manage a :ref:`cluster of Docker engines <docker_swarm_overview>`
