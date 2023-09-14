.. _try_opennebula_on_kvm:

==================================
Deploy OpenNebula Front-end on AWS
==================================

In this guide, we'll go through a Front-end OpenNebula environment deployment, where all the OpenNebula services needed to use, manage and run the cloud will be collocated on a single dedicated bare-metal server or Virtual Machine (VM). You will be also able to deploy a local KVM node within the same single server or VM to try out OpenNebula, or for daily development work. Afterwards, if you need more physical resources or want to try out the automatic provisioning features for building multi-provider hybrid clouds, you can continue to the :ref:`Operations Guide <operation_basics>` to add a remote Edge Cluster based on KVM using AWS bare-metal instances to your shiny new OpenNebula cloud!

While all the :ref:`installation and configuration <opennebula_installation>` steps can be done manually and would give you a better insight and control over what and how it is configured, we'll focus on the most straightforward approach by leveraging the miniONE tool.

The miniONE tool is a simple deployment script that deploys an OpenNebula Front-end and, optionaly, a single KVM node within a single physical or virtual machine. This tool is mainly intended for evaluation, development, and testing, but it can also be used as a base for larger short-lived deployments. Usually, it takes just a few minutes to get the environment ready.

Requirements
============

You'll need a server to try out OpenNebula. The provided Host should have a fresh default installation of the required operating system with the latest updates and without any customizations.

- 4 GiB RAM
- 40 GiB free space on disk
- public IP address (FE-PublicIP)
- privileged user access (`root`)
- openssh-server package installed
- operating system: RHEL/AlmaLinux 8 or 9, Debian 10 or 11, Ubuntu 20.04 or 22.0.4
- open ports: 22 (SSH), 80 (Sunstone), 2616 (FireEdge), 5030 (OneGate).

If you don't have a server available with the above characteristics, we recommend using a the Amazon EC2 service to obtain a VM to act as the OpenNebula Front-end. A tested combination is the following (but is by no means the only one possible):

- Frankfurt region
- Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - ami-0d85ad3aa712d96af
- t2.medium
- 40 GB hard disk (you need to edit the Storage tab before launching the instance; by default it comes with just 8GB
- open ports 22 (SSH), 80 (Sunstone), 2616 (FireEdge), 5030 (OneGate) by editing the Security Groups as per the picture. This can also happen after launching the instance following `this guide <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html>`__.

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

miniONE can be downloaded by completing the form `here <https://opennebula.io/get-minione>`__.

.. important::

    Unless specified, all commands below should be executed under privileged user **root**.

Various command line parameters passed to the miniONE tool can customize the deployment process, e.g. the required OpenNebula version or initial passwords. You can get a list of available flags by running:

.. prompt:: bash # auto

    # bash minione --help

In most cases, it's not necessary to specify anything, simply proceed with installation.

Deployment of Front-End and KVM Node
====================================

Run the following command under the privileged user **root** to deploy an evaluation cloud with an all-in-one front-end and a single KVM node:

.. prompt:: bash # auto

    # sudo bash minione

This option is suitable for bare-metal hosts to utilize HW virtualization. The deployment will fallback to emulation (QEMU) if running on virtual machine or CPU without virtualization capabilities.

Be patient, it should take only a few minutes to get the Host prepared. The main deployment steps are logged on the terminal, and at the end of a successful deployment the miniONE tool provides a report with connection parameters and initial credentials. For example:

.. code::

    ### Report
    OpenNebula 6.6 was installed
    Sunstone is running on:
      http://3.121.76.103/
    FireEdge is running on:
      http://3.121.76.103:2616/
    Use following to login:
      user: oneadmin
      password: lCmPUb5Gwk

.. note:: When running miniONE within an AWS instance, the reported IP may be a private address that's not reachable over the Internet. Use its public IP address to connect to the FireEdge and Sunstone services.

The OpenNebula Front-end and local KVM node are now ready for evaluation.

.. note:: miniONE offers more functionality. For example, you can install an OpenNebula front-end without a KVM Host (next section). Just add the --Front-end flag to enable this if interested.

Deployment of Front-End
=======================

If you do not want to create a local KVM node, run the following command to get ready the OpenNebula Front-end installation:

.. prompt:: bash # auto

    # sudo bash minione --frontend

Validation
==========

Point your browser to the Sunstone web URL provided in the deployment report above and log in as the user **oneadmin** with provided credentials.

|images-sunstone-dashboard|

If the Host configured by **miniONE** is behind the firewall, the (default) Sunstone port 80 has to be enabled for the machine you are connecting from.

.. |images-sunstone-dashboard| image:: /images/sunstone-dashboard.png

With the default Admin View you can do anything in OpenNebula. Switch to the Cloud View (oneadmin-->Views-->cloud) to see how a final user will see OpenNebula.

The Cloud View interface is much simpler and targeted at end users.

If you created a local KVM node with the front-end you can continue the validation with the following steps:

- Create a new Virtual Machine by clicking the ‘+’ button. Select the only available template and click ‘Create’.
- After clicking ‘Create’ you will be taken to the dashboard where you can see your running VMs.
- You can click on your VM and manage it: Save its state, Reboot it, etc:

.. note:: We know, these are very basic steps. If you want to try out real-life virtualization or kubernetes workloads with public IPs please continue to next section.

Next Steps
==========

if you want to continue the evaluation with physical resources for VMs and Kubernetes clusters or try out the automatic provisioning features for building multi-provider hybrid clouds, you can follow the :ref:`Operations Guide <operation_basics>` to add a remote Edge Cluster based on KVM using AWS bare-metal instances to your shiny new OpenNebula cloud!
