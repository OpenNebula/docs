.. _rancher_integration_overview:

=========================================================
Rancher Integration
=========================================================

**WIP**

.. _rancher_tutorial:

Manage Rancher with Docker Machine
--------------------------------------------------------------------------------

In order to use Rancher with OpenNebula, you first need to create a VM with OpenNebula's `Docker appliance <https://docs.opennebula.io/appliances/service/docker.html>`_, by using OpenNebula :ref:`Docker Machine driver <docker_machine_overview>`. You can find information about this step here :ref:`Step 4 - Start your First Docker Host <start_your_first_docker_host>`.

**Step 1 – Rancher Installation**

Once the machine is created, we can install the rancher server using the following commands:

.. prompt:: bash # auto

    $ eval $(docker-machine env rancher-server)

    $ docker run -d --restart=unless-stopped -p 8080:8080 rancher/server

After about a minute, your host should be ready and you can browse to http://rancher-server-ip:8080 and bring up the Rancher UI. If you deploy the Rancher server on a VM with access to the to the Internet, it’s a good idea to set up access control (via github, LDAP …). For more information regarding the Rancher installation (single node and HA setup and the authentication) you can refer to the official `documentation <http://docs.rancher.com//>`__.

**Step 2 – Adding OpenNebula Machine Driver**

To add OpenNebula Virtual Machines as hosts to Rancher you need to add the docker machine plugin binary in the Admin Machine Drivers settings.

|add the docker machine plugin binary|

A Linux binary of the OpenNebula machine driver is available at https://github.com/OpenNebula/docker-machine-opennebula/releases/download/release-0.2.0/docker-machine-driver-opennebula.tgz.

|adding the docker machine plugin binary|

Once you added the machine driver, a screen with the OpenNebula driver should be active.

|added the docker machine plugin binary|

**Step 3 – Adding OpenNebula Hosts**

The first time adding a host, you will see a screen asking you to confirm the IP address your Rancher server is available on, i.e. where the compute nodes will connect.

|adding openNebula hosts|

Once you save the settings, you can proceed to create the first Rancher host.

|create the first rancher host|

Select the opennebula driver and insert at least the following options:

* Authentication: user, password
* OpenNebula endpoint: xmlrpcurl (http://one:2633/RPC2)
* ImageID
* NetworkID

and then you can proceed to create the host. After few minutes, when the creation process is complete, you should get a screen with the active host.

**Step 4 – Deploy a container**

To test the environment, you can select the host and add a container.

.. |add the docker machine plugin binary| image:: /images/add_the_docker_machine_plugin_binary.png
.. |adding the docker machine plugin binary| image:: /images/adding_the_docker_machine_plugin_binary.png
.. |added the docker machine plugin binary| image:: /images/added_the_docker_machine_plugin_binary.png
.. |adding openNebula hosts| image:: /images/adding_openNebula_hosts.png
.. |create the first rancher host| image:: /images/create_the_first_rancher_host.png

