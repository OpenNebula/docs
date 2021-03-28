.. _running_containers:

==================
Running Containers
==================

OpenNebula comes out of the box with integrations with various container marketplaces like Docker Hub, Turnkey Linux and Linux Containers. We are going to use the nginx container from Docker Hub to try out our brand new cloud.

.. warning:: We are going to use the virtual AWS edge cluster deployed in the Operations Basics guide in order to achieve this. We are going to assume the naming schema “aws-cluster” (which is the default if you haven't changed it).

Step 1. Download the container image from Docker Hub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login into Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab, and search for "nginx". Make sure you select the nginx coming from the "Docker Hub" marketplace. Then click on the icon with the cloud and the down arrow inside (two positions to the right from the green "+").

|nginx_marketplace|

Now you need to select a datastore. Taking into account we are only going to run this application in the OpenNebula cluster created in "Operations Basics", select the aws-cluster-images datastore.

|aws_cluster_images_datastore_nginx|

The appliance will be ready when the image in ``Storage --> Images`` (called "nginx") gets in READY from LOCKED state. This image contains the docker image that we are going to launch using lxc (instead of docker).

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
.. |nginx_install_page| image:: /images/nginx_install_page.png

Step 5. Building a Multi-Container Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Now we are going to build a Multi-Container Service based on two docker images: wordpress and mariadb. MariaDB will be used as a database for the Wordpress deployment.

First of all you have to download from the Marketplace the docker images related to wordpress and mariadb as explained in the previous steps.

Go to the ``Storage --> Apps`` tab, and search for wordpress. Select it and click on the icon with the cloud and the down arrow inside (two positions to the right from the green "+"). Make sure you select the wordpress image coming from the "Docker Hub" marketplace.

|wordpress_marketplace|

Now you need to select a datastore. Taking into account we are only going to run this application in the OpenNebula cluster created in "Operations Basics", select the aws-cluster-image datastore.

|aws_cluster_images_datastore_wordpress|

The appliance will be ready when the image in ``Storage --> Images`` (called "wordpress") gets in READY from LOCKED state.

You need to modify the wordpress VM template. Proceed to the ``Templates --> VMs`` tab and select the wordpress VM Template. Click on update, proceed to the Network tab and select the aws-cluster-public network. 

|wordpress_public_network|

Then proceed to the Context tab, and add the following script in the Start Script section; the script will be executed during the booting process of the VM. You need also to tick the ``Add OneGate token`` option. 

|wordpress_start_script|

You need to repeat the same operations for the mariadb image. Go to the ``Storage --> Apps`` tab, and search for mariadb. Select it and click on the icon with the cloud and the down arrow inside (two positions to the right from the green "+").

|mariadb_marketplace|

Now you need to select a datastore. Taking into account we are only going to run this application in the OpenNebula cluster created in "Operations Basics", select the aws-cluster-image datastore.

|aws_cluster_images_datastore_mariadb|

The appliance will be ready when the image in ``Storage --> Images`` (called "mariadb") gets in READY from LOCKED state. 

You need to modify the wordpress VM template. Proceed to the ``Templates --> VMs`` tab and select the wordpress VM Template. Click on update, proceed to the Network tab and select the aws-cluster-public network. 

|mariadb_public_network|

Then proceed to the Context tab, and add the following script in the Start Script section; the script will be executed during the booting process of the VM. You need also to tick the ``Add OneGate token`` option.

|mariadb_start_script|

Now you can proceed to the creation of the OneFlow service. Go to the ``Templates --> Services`` tab and click on the green button with + sign and the on ``Create`` from the drop-down menu.

Write "wordpress" as the name of the service, and in the section ``Advanced service parameters`` tick the option ``Wait for VMs to report that they are READY via OneGate to consider them running``

|wordpress_service_template_create|

Then, you need to add two roles to the service: one role for the db and one for wordpress. Go to the ``Roles`` section of the template, write db in the ``Role name`` input text and select the mariadb VM template previously created. 

|mariadb_oneflow_role|

Then click on the + sign close to ``Roles`` to create a new role. Write wordpress in the ``Role name`` input text and select the wordpress VM template previously created. In this case, also tick the option for the dependency with the parent db role; this means that the wordpress role will be deployed after the db role is READY.

|wordpress_oneflow_role|

Once you have finished click the green ``Create`` button. 

Now go to the ``Instances --> Services`` tab, click on the green + sign and create a new service selecting the oneflow service template named wordpress.

|wordpress_service_instantiate|

Once the VM related to the two roles are in RUNNING state, you can connect to the Public IP of wordpress (select the public IP of the wordpress VM that is highlighted in bold).

|wordpress_service_running|

|wordpress_public_ip|

Simply enter that IP in a new tab in your browser and you’ll be greeted by the famous 5 minutes WordPress installation process! That's it, you have deployed your first OpenNebula service. Congrats!

|wordpress_installation|

.. |wordpress_marketplace| image:: /images/wordpress_dh_marketplace.png
.. |aws_cluster_images_datastore_wordpress| image:: /images/aws_cluster_images_datastore_wordpress.png
.. |mariadb_marketplace| image:: /images/mariadb_dh_marketplace.png
.. |aws_cluster_images_datastore_mariadb| image:: /images/aws_cluster_images_datastore_mariadb.png
.. |mariadb_start_script| image:: /images/mariadb_start_script.png
.. |mariadb_public_network| image:: /images/mariadb_public_network.png
.. |wordpress_public_network| image:: /images/wordpress_public_network.png
.. |wordpress_start_script| image:: /images/wordpress_start_script.png
.. |wordpress_service_template_create| image:: /images/wordpress_service_template_create.png
.. |mariadb_oneflow_role| image:: /images/wordpress_service_db_role.png
.. |wordpress_oneflow_role| image:: /images/wordpress_service_wp_role.png
.. |wordpress_service_instantiate| image:: /images/wordpress_service_instantiate.png
.. |wordpress_service_running| image:: /images/wordpress_service_running.png
.. |wordpress_public_ip| image:: /images/wordpress_public_ip.png
.. |wordpress_installation| image:: /images/wordpress_install_page.png