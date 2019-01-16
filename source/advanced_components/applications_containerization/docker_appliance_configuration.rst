.. _docker_appliance_configuration:

=========================================================
Docker Appliance Configuration
=========================================================

The Docker Appliance available on the OpenNebula marketplace brings a Docker Engine pre-installed and the contextualization packages configured to create Docker Hosts in a single click. Alternatively you can prepare your own image, using your favourite distribution, as long as it’s supported by Docker Machine and it has the latest OpenNebula Contextualization packages.

The Docker Appliance is based on Ubuntu and have installed Docker, you can found more information about ths specific versions at the :ref:`platform notes<uspng>`. In order to access the appliance once it's have been deployed it's necessary to update the template with the network and the password for the root user or the SSH key.

In order to prepare your cloud to serve Docker Engines please follow the next steps.

Step 1 - Create a Template
=========================================================

KVM
---------------------------------------------------------

  Download the appliance from the apps marketplace:

  |img-marketplace-kvm|

  When the appliance is downloaded a template with the same name it's created. It's recomended to update the template with a network for make the vm accessible from outside, set the disk size, the root password or the ssh key.

  You can also create a template and include the appliance image in it.

  Once the template is ready you can instantiate it.

vCenter
---------------------------------------------------------

  Download the appliance from the apps marketplace:

  |img-marketplace-vcenter|

  Create a vCenter template or update an existing one, the template must have a network for make the vm accessible from outside. Once the template is ready import both the template and the network into OpenNebula.

  From OpenNebula update the template and attach the appliance disk to the vm. Also it's recommended to update the context of the template for set the root password or to include an SSH key.

Step 2 - Customize The Template
=========================================================

If you want to make any changes in the appliance and save them for latter use, you can set the image as persistent before launching the appliance. After the changes are performed, you need to shut the VM down and remove the persistent option from the image. This way you can create a golden image and new instances of the appliance won't overwrite it.

|image-persistent|

If you have already run the appliance as non persistent image you can take a look at Step 4 from the :ref:`Docker Application Usage <docker_appliance_usage>` guide.

.. |img-marketplace-kvm| image:: /images/ubuntu1604-docker-kvm-marketplace.png
.. |img-marketplace-vcenter| image:: /images/ubuntu1604-docker-vcenter-marketplace.png
.. |image-persistent| image:: /images/ubuntu-docker-image-persistent.png
