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
- 80 GiB free space on disk
- public IP address (FE-PublicIP)
- privileged user access (`root`)
- openssh-server package installed
- operating system: RHEL/AlmaLinux 8 or 9, Debian 10 or 11, Ubuntu 20.04 or 22.0.4
- open ports: 22 (SSH), 80 (Ruby Sunstone), 2616 (FireEdge), 5030 (OneGate).

If you don't have a server available with the above characteristics, we recommend using a the Amazon EC2 service to obtain a VM to act as the OpenNebula Front-end. A tested combination is the following (but is by no means the only one possible):

- Frankfurt region
- Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
- t2.medium
- 80 GB hard disk (you need to edit the Storage tab before launching the instance; by default it comes with just 8GB)
- open ports 22 (SSH), 80 (Ruby Sunstone), 2616 (FireEdge), 5030 (OneGate) by editing the Security Groups as per the picture. This can also happen after launching the instance following `this guide <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html>`__.

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

Deploy Front-End only
=====================

This option installs OpenNebula frontend and prepares it to provision hypervisor node on one of the providers with OneProvision later.

Run the following command under the privileged user **root**

.. important::

    In this case, FireEdge and OneGate endpoints expose HTTP on public interface, keep in mind MiniONE is just an evaluation tool.

.. prompt:: bash # auto

    # sudo bash minione --frontend


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

.. note:: When running miniONE within an AWS instance, the reported IP may be a private address that's not reachable over the Internet. Use its public IP address to connect to the FireEdge and Ruby Sunstone services.

The OpenNebula Front-end and local KVM node are now ready for evaluation.

.. note:: miniONE offers more functionality. For example, you can install an OpenNebula front-end without a KVM Host (next section). Just add the --Front-end flag to enable this if interested.

Validation
==========

Point your browser to the FireEdge web URL provided in the deployment report above and log in as the user **oneadmin** with provided credentials.

|images-sunstone-dashboard|

If the Host configured by **miniONE** is behind the firewall, the (default) FireEdge port 2616 has to be enabled for the machine you are connecting from.

With the default Admin View you can do anything in OpenNebula. Switch to the Cloud View (top right-->Views-->cloud) to see how a final user will see OpenNebula.

|images-sunstone-change-view|

The :ref:`Cloud View <fireedge_cloud_view>` interface is much simpler and targeted at end users.

If you created a local KVM node with the front-end you can continue the validation with the following steps:

- Create a new Virtual Machine by clicking ‘VMs’ button. This will take you to the instances/VMs tab.
- Press ‘+’ button and select the only available template. Continue through the instantiation dialog.
- After clicking ‘Finish’ your VM will be instantiated, and you should be able to see your running machine.
- You can click on your VM to manage it: Save it's state, Reboot it, etc:

.. note:: We know, these are very basic steps. If you want to try out real-life virtualization or kubernetes workloads with public IPs please continue to next section.

Deploy Front-End and KVM Node
=============================

If you want to quickly deploy an OpenNebula front-end + a virtualization node, run the following command under the privileged user **root** to deploy an evaluation cloud with an all-in-one front-end and a single KVM node:

.. important::

    This option uses private IP for OneGate which is fine for local KVM but won't work for :ref:`OneProvision <first_edge_cluster>` or :ref:`Kubernetes cluster <running_kubernetes_clusters>`

.. prompt:: bash # auto

    # sudo bash minione

This option is suitable for bare-metal hosts to utilize HW virtualization. The deployment will fallback to emulation (QEMU) if running on virtual machine or CPU without virtualization capabilities.

Next Steps
==========

if you want to continue the evaluation with physical resources for VMs and Kubernetes clusters or try out the automatic provisioning features for building multi-provider hybrid clouds, you can follow the :ref:`Operations Guide <operation_basics>` to add a remote Edge Cluster based on KVM using AWS bare-metal instances to your shiny new OpenNebula cloud!


.. |images-sunstone-dashboard| image:: /images/sunstone-dashboard.png
.. |images-sunstone-change-view| image:: /images/sunstone-change-view.png
