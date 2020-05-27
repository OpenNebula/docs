.. _docker_appliance_overview:

================================================================================
Docker
================================================================================

`Docker <https://www.docker.com>`_ is one of the many Linux container runtimes but it is also the most popular and the most supported. Docker pioneered the new approach to the containerization and with the advent of microservices it changed the landscape of how complex applications are designed and built.

OpenNebula can create virtualized Docker instances using the `OpenNebula Docker appliance <https://docs.opennebula.io/appliances/service/docker.html>`_ which is available on the `OpenNebula Marketplace <http://marketplace.opennebula.org>`_. This image must be downloaded and registered in the cloud datastore before it can be used. OpenNebula then can utilize the Docker engine instances hosted by these virtualized Docker hosts thanks to OpenNebula's own driver for :ref:`Docker Machine <docker_machine_overview>`.

This allows the remote provision and management of Docker hosts like execution of Docker commands on the remote host or instantiation of the whole Dockerized host with already up and running Docker inside.

There is also always an option to directly instantiate and access the OpenNebula Docker image, and manage the Dockerized hosts by using the OpenNebula GUI and CLI.

OpenNebula's users thus can execute multiple isolated applications within the VM instances, which means that an instance could have multiple containers all sharing the same resources allocated to the running VM.

