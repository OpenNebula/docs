.. _try_opennebula_on_kvm:

=============================
Try OpenNebula on KVM/LXC/FC
=============================

In this guide, we'll go through a Front-end OpenNebula environment deployment, where all the OpenNebula services needed to use, manage and run the cloud will be collocated on the single dedicated bare-metal Host. Afterwards, you can continue to the Operations Basics section to add a remote Edge Cluster based on KVM, LXC or Firecracker to your shiny new OpenNebula cloud!

While all the :ref:`installation and configuration <opennebula_installation>` steps can be done manually and would give you a better insight and control over what and how it is configured, we'll focus on the most straightforward approach by leveraging the miniONE tool.

The `miniONE <https://github.com/OpenNebula/minione>`_ tool is a simple deployment script that deploys an OpenNebula Front-end. This tool is mainly intended for evaluation, development, and testing, but can also be used as a base for larger short-lived deployments. Usually, it takes just a few minutes to get the environment ready.


If you're feeling adventurous, go ahead and try out the following.

.. prompt:: bash # auto

    # wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
    # sudo bash minione --frontend

Otherwise, read on!

Requirements
============

You'll need a server to try out OpenNebula. The provided Host should have a fresh default installation of the required operating system with the latest updates and without any customizations.

- 4 GiB RAM
- 20 GiB free space on disk
- public IP address (FE-PublicIP)
- privileged user access (`root`)
- openssh-server package installed
- operating system: CentOS 7 or 8, Debian 9 or 10, Ubuntu 18.04 or 20.04
- open ports: 22 (SSH), 80 (Sunstone), 2616 (FireEdge), 5030 (OneGate).

If you don't have a server available with the above characteristics, we recommend using a the Amazon EC2 service to obtain a VM to act as the OpenNebula Front-end. A tested combination is the following (but is by no means the only one possible):

- Frankfurt region
- Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - ami-0767046d1677be5a0
- t2.small
- 40 GB hard disk (you need to edit the Storage tab before launching the instance; by default it comes with just 8GB)
- before launching the instance, please open the ports defined above by editing the Security Groups as per the picture. This can also happen after launching the instance following `this guide <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html>`__.

|aws_security_groups|

In order to SSH into the EC2 VM, you need to pass the correct user and PEM file (you can create one and download it prior to launching the instance). You'll then be conecting to your Front-end using a comand similar to:

.. prompt:: bash # auto

    # ssh <FE-PublicIP> -l ubuntu -i <PATH-TO-PEM-FILE>

We recommend updating the system:

.. prompt:: bash # auto

    # sudo apt update && sudo apt upgrade

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

Various command line parameters passed to the miniONE tool can customize the deployment process, e.g. the required OpenNebula version or initial passwords. You can get a list of available switches by running:

.. prompt:: bash # auto

    # bash minione --help

In most cases, it's not necessary to specify anything, simply proceed with installation.

Run the following command under the privileged user **root** to get ready the all-in-one OpenNebula Front-end installation:

.. prompt:: bash # auto

    # sudo bash minione --frontend

Be patient, it should take only a few minutes to get the Host prepared. The main deployment steps are logged on the terminal, and at the end of a successful deployment the miniONE tool provides a report with connection parameters and initial credentials. For example:

.. code::

    ### Report
    OpenNebula 6.1 was installed
    Sunstone is running on:
      http://3.121.76.103/
    FireEdge is running on:
      http://3.121.76.103:2616/
    Use following to login:
      user: oneadmin
      password: lCmPUb5Gwk

The OpenNebula Front-end is now ready for evaluation.

.. note:: miniONE offers more functionality. You can install OpenNebula with a KVM Host if you have a processor virtualization capabilities. Just drop the --Front-end flag to enable this if interested.

Validation
==========

Point your browser to the Sunstone web URL provided in the deployment report above and log in as the user **oneadmin** with provided credentials.

|images-sunstone-dashboard|

If the Host configured by **miniONE** is behind the firewall, the (default) Sunstone port 80 has to be enabled for the machine you are connecting from.

.. |images-sunstone-dashboard| image:: /images/sunstone-dashboard.png

Next Steps
==========

We recommend following the :ref:`Operations Guide <operation_basics>` from Quick Start after finishing this guide to add computing power to your shiny new OpenNebula cloud.
