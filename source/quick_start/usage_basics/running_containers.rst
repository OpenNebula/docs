.. _running_containers:

==================
Running Containers
==================

OpenNebula comes out of the box with integrations with various container marketplaces like Docker Hub, Turnkey Linux and Linux Containers. We are going to use the nginx container from Docker Hub to try out our brand new cloud.

.. warning:: We are going to use the virtual AWS edge cluster deployed in the Operations Basics guide in order to achieve this. We are going to assume the naming schema “aws-cluster” (which is the default if you haven't changed it).

Step 1. Download the container image from Docker Hub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login into Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab, and search for "nginx". Make sure you select the nginx coming from the "Docker Hub" marketplace. Then click on the icon with the cloud and the down arrow inside (two positions to the left from the green "+").

|nginx_marketplace|

Now you need to select a datastore. Taking into account we are only going to run this appliaction in the OpenNeblua cluster created in "Operations Basics", select the aws-cluster-images datastore.

|aws_cluster_images_datastore_nginx|

The appliance will be ready when the image in ``Storage --> Images`` (aptly called "nginx") gets in READY from LOCKED state. This image contains the docker image that we are going to launch using lxc (instead of docker).

.. |nginx_marketplace| image:: /images/nginx_marketplace.png
.. |aws_cluster_images_datastore_nginx| image:: /images/aws_cluster_images_datastore_nginx.png

Step 2. Specify the nginx start command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The lxc container needs to know how to invoke the process in the docker app. In this case, it is simply calling the "nginx" command. You can specify this in the Start Script section of the VM Template representing the nginx container. Proceed to the ``Templates --> VM`` tab and select the nginx VM Template  (that should one of two available, along with the default CentOS 7 pulled from the marketplace by miniONE). Click on update, proceed to the Context subtab and write "nginx" in the Start Script field.

|nginx_start_script|

.. |nginx_start_script| image:: /images/nginx_start_script.png

Step 3. Instantiate the container
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With the nginx VM Template selected in the ``Templates --> VMs`` tab, click on Instantiate.

Feel free to modify the capacity. A required step is clicking on Network and selecting the aws-cluster-public network.

|select_aws_cluster_public_network_nginx|

Now proceed to ``Instances --> VMs`` and wait for the only VM there to get into RUNNING state.

.. note:: Even though Sunstone shows the VNC console button, VNC access to Containers or VMs running in edge clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work to VMs running in edge clusters.

.. |select_aws_cluster_public_network_nginx| image:: /images/select_aws_cluster_public_network_nginx.png

Step 4. Connect to nginx
~~~~~~~~~~~~~~~~~~~~~~~~

Select the public IP of the VM, which is highlighted in bold. You should only have one bold IP in that VM.

|get_public_ip_nginx|

Simply enter that IP in a new tab in your browser and you'll be greeted by the following (sober) nginx welcome page. That's it, you have a working OpenNebula cloud. Congrats!

|nginx_install_page|

.. |get_public_ip_nginx| image:: /images/get_public_ip_nginx.png

Step 5. Building a Multi-Container Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
