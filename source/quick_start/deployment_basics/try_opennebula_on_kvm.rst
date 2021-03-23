.. _try_opennebula_on_kvm:

=====================
Try OpenNebula on KVM
=====================

In this guide, we'll go through a front-end OpenNebula environment deployment, where all the necessary OpenNebula services to use, manage and run the cloud will be colocated on the single dedicated bare-metal host. Afterwards you can continue to the Operations Basics section to add a remote edge cluster to your shiny new OpenNebula cloud!

While all the :ref:`installation and configuration <opennebula_installation>` steps could be done manually and would give you a better insight and control over what and how it is configured, we'll focus on the most straightforward approach leveraging the miniONE tool.

The `miniONE <https://github.com/OpenNebula/minione>`_ tool is simple deployment script which deploys an OpenNebula front-end. This tool is mainly intended for evaluation, development and testing, but can also be used as a base for larger short-lived deployments. Usually, it takes just a few minutes to get the environment ready.


If you're feeling adventurous, go ahead and try out the following.

.. prompt:: bash # auto

    # wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
    # sudo bash minione --frontend --with-onegate=<FE-PublicIP>

Otherwise, read on!

Requirements
============

You'll need a server to try out OpenNebula. The provided host should have a fresh default installation of required operating system with latest updates and without any customizations.

- 4 GiB RAM
- 20 GiB free space on disk
- public IP address (FE-PublicIP)
- privileged user access (`root`)
- openssh-server package installed
- operating system: CentOS 7 or 8, Debian 9 or 10, Ubuntu 18.04 or 20.04ç
- open ports: 22 (SSH), 80 (Sunstone), 2616 (FireEdge), 5030 (OneGate)

If you don't have a server available with the above characteristics, we recommend using a the Amazon EC2 service to obtain a VM to act as OpenNebula front-end. A tested combination is the following (by no means the only one possible):

- Frankfurt region
- Red Hat Enterprise Linux 8 (HVM), SSD Volume Type - ami-009b16df9fcaac611
- t2.micro
- before launching the instance, please open the ports defined above by editing the Security Groups as per the picture.

|aws_security_groups|

.. |aws_security_groups| image:: /images/aws_security_groups.png

Download
========

.. important::

    Unless specified, all commands below should be executed under privileged user **root**.

Download the latest release of the miniONE tool by running one of the following commands:

.. prompt:: bash # auto

    # wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'

or

.. prompt:: bash # auto

    # curl -O -L 'https://github.com/OpenNebula/minione/releases/latest/download/minione'

Deploy
======

Various command line parameters passed to the miniONE tool can customize the deployment process, e.g. required OpenNebula version or initial passwords. You can get a list of available switches by running:

.. prompt:: bash # auto

    # bash minione --help

In most cases, it's not necessary to specify anything and simply proceed with installation.

Run the following command under the privileged user **root** to get ready the all-in-one OpenNebula front-end installation:

.. prompt:: bash # auto

    # bash minione --frontend

Be patient, it should take only a few minutes to get the host prepared. Main deployment steps are logged on the terminal and at the end of a successful deployment, the miniONE tool provides a report with connection parameters and initial credentials. For example:

.. code::

    ### Report
    OpenNebula 6.0 was installed
    Sunstone (the webui) is running on:
      http://192.0.2.1/
    Use following to login:
      user: oneadmin
      password: t5mk2tvPCG

Now, the OpenNebula front-end for evaluation is ready.

.. note:: miniONE offers more functionality. You can install OpenNebula with a KVM host if you have a processor virtualization capabilities. Just drop the --frontend flag to enable this if interested.

Validation
==========

Point your browser to the Sunstone web URL provided in the deployment report above, and login the user **oneadmin** with provided credentials.

|images-sunstone-dashboard|

If the host configured by **miniONE** is behind the firewall, the (default) Sunstone port 80 has to be enabled for the machine you are connecting from.

.. |images-sunstone-dashboard| image:: /images/sunstone-dashboard.png

Next Steps
==========

We recommend following the :ref:`Operations Guide <operation_basics>` from Quick Start after finishing this guide to add computing power to your shiny new OpenNebula cloud.
