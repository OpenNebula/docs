.. _try_opennebula_on_kvm:

=====================
Try OpenNebula on KVM
=====================

In this guide, we'll go through an all-in-one OpenNebula environment deployment, where all the necessary OpenNebula services to use, manage and run the cloud will be colocated on the single dedicated bare-metal host.

While all the :ref:`installation and configuration <opennebula_installation>` steps could be done manually and would give you a better insight and control over what and how it is configured, we'll focus on the most straightforward approach leveraging the miniONE tool.

The `miniONE <https://github.com/OpenNebula/minione>`_ tool is simple deployment script which prepares the all-in-one OpenNebula environments. Such deployments are mainly intended for evaluation, development and testing, but can also be used as a base for larger short-lived deployments. Usually, it takes just a few minutes to get the environment ready. The tool can prepare evaluation environments for true virtual machines running on KVM hypervisors.

miniONE will preapre your OpenNebula environment to act also as a qemu node, so you can test quickly to launch emulated Virtual Machines. However, we recommend following the :ref:`Operations Guide <operation_basics>` from Quick Start after finishing this guide to add computing power to your shiny new OpenNebula cloud.

If you're feeling adventurous, go ahead and try out the following.

.. prompt:: bash # auto

    # wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
    # sudo bash minione

Otherwise, read on!

Requirements
============

You'll need a server to try out OpenNebula. The provided host should have a fresh default installation of required operating system with latest updates and without any customizations.

.. todo:: Drop dependency for KVM qemu node?

- 4 GiB RAM
- 20 GiB free space on disk
- default installation of the operating system with the latest updates
- privileged user access (`root`)
- openssh-server package installed
- x86-64 Intel or AMD processor with **virt. capabilities**
- physical host or virtual machine supporting the nested virtualization
- operating system: CentOS 7 or 8, Debian 9 or 10, Ubuntu 16.04, 18.04 or 20.04

.. image:: /images/minione-kvm.png

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

This guide covers the default miniONE environment (KVM). This guide does not cover LXC, Firecracker, Edge with KVM or Edge with Firecracker evaluation environments.

Run the following command under the privileged user **root** to get ready the all-in-one OpenNebula installation with default KVM hypervisor:

.. prompt:: bash # auto

    # bash minione

Be patient, it should take only a few minutes to get the host prepared. Main deployment steps are logged on the terminal and at the end of a successful deployment, the miniONE tool provides a report with connection parameters and initial credentials. For example:

.. code::

    ### Report
    OpenNebula 6.0 was installed
    Sunstone (the webui) is running on:
      http://192.0.2.1/
    Use following to login:
      user: oneadmin
      password: t5mk2tvPCG

Now, the all-in-one OpenNebula evaluation environment is ready.

The rest of the guide introduces "how to run the very first virtual machine in a single click", "how to control the virtual machine state" and "how to explore the infrastructure defined in the OpenNebula" - first, utilizing the Sunstone web UI, and later using CLI as part of the Advanced sections. If you are familiar with the OpenNebula, you can skip the rest.

Validation
==========

Point your browser to the Sunstone web URL provided in the deployment report above, and login the user **oneadmin** with provided credentials.

|images-sunstone-dashboard|

If the host configured by **miniONE** is behind the firewall, the (default) Sunstone port 80 has to be enabled for the machine you are connecting from.

.. |images-sunstone-dashboard| image:: /images/sunstone-dashboard.png
