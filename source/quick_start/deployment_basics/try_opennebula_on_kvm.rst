.. _try_opennebula_on_kvm:

=====================
Try OpenNebula on KVM
=====================

**miniONE** is an easy to use deployment tool to build an evaluation OpenNebula (local and edge) cloud based on either virtual machines (KVM), system containers (LXD) or micro-VMs (Firecracker). All necessary components to manage and run the virtual machines or containers are installed and configured on your dedicated system with just a single command run.

Quick Start
-----------

.. prompt:: bash # auto

    # wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
    # sudo bash minione

What is?
========

OpenNebula is a lightweight datacenter management solution to operate the private, public, and hybrid clouds running on the KVM, LXD, and VMware technologies. It can serve small compact clouds with just a few nodes, and scale to thousands of computing cores over multiple federated zones. It's easy to install, maintain and upgrade, and comes with its own `Marketplace <https://marketplace.opennebula.io>`_, offering a selection of base appliances with popular Linux distributions with which you can quickly start. Extensive `documentation <http://docs.opennebula.io>`_ covers wide range of uses, from the individual end-user to the cloud administrator preparing the deployment.

In this guide, we'll go through the special type of deployment, the all-in-one OpenNebula environment. All the necessary services to use, manage and run the cloud will be colocated on the single dedicated bare-metal host.

While all the installation and configuration steps could be done manually by following the official documentation and would give you a better insight and control over what and how it is configured, we'll focus on the most straightforward approach leveraging the miniONE tool.

The `miniONE <https://github.com/OpenNebula/minione>`_ tool is simple deployment script which prepares the all-in-one OpenNebula environments. Such deployments are mainly intended for evaluation, development and testing, but can also be used as a base for larger short-lived deployments. Usually, it takes just a few minutes to get the environment ready. The tool can prepare evaluation environments for true virtual machines running on KVM hypervisors, or the system containers running on LXD hypervisors. Another option which we call *Edge deployment* includes OpenNebula frontend and configured KVM hypervisors on public Cloud providers. And lastly, you can have environment prepared for running micro VMs on Firecracker hypervisor.

Requirements
============

Requirements may differ for various types of evaluation environments which you may deploy. In all cases, the provided host should have a fresh default installation of required operating system with latest updates and without any customizations.

Common minimal requirements
===========================
- 4 GiB RAM
- 20 GiB free space on disk
- default installation of the operating system with the latest updates
- privileged user access (`root`)
- openssh-server package installed

Virtual Machines (KVM)
======================
|images-minione-kvm.png|

For KVM evaluation on a dedicated physical server for the front-end and one KVM hypervisor node the minimal requirements are:

* x86-64 Intel or AMD processor with **virt. capabilities**
* physical host or virtual machine supporting the nested virtualization
* operating system: CentOS 7 or 8, Debian 9 or 10, Ubuntu 16.04, 18.04 or 20.04


System Containers (LXD)
=======================
|images-minione-lxd|

For LXD evaluation on a dedicated physical server or virtual machine for the front-end and one LXD hypervisor node the minimal requirements are:

* x86-64 Intel or AMD processor
* physical host or virtual machine
* operating system: Ubuntu 18.04 or 20.04

Micro VMs (Firecracker)
=======================
|images-minione-firecracker|

For Firecracker evaluation on a dedicated physical server or virtual machine for the front-end and one Firecracker hypervisor node the minimal requirements are:

* x86-64 Intel or AMD processor
* physical host or virtual machine
* operating system: CentOS 7 or 8, Debian 9 or 10, Ubuntu 16.04, 18.04 or 20.04

Edge deployment + KVM or Firecracker on Packet
==============================================
|images-minione-packet|

For Edge evaluation on a dedicated physical server or virtual machine for the front-end and one remote Packet edge physical server for one KVM or Firecracker hypervisor node the minimal requirements are

for the frontend

* x86-64 Intel or AMD processor
* physical host or virtual machine
* operating system: CentOS 7, Debian 9, Ubuntu 16.04 or 18.04

for the hypervisor(s) on Packet

* Packet API token
* Packet API project

The deployment process with the `miniONE <https://github.com/OpenNebula/minione>`_ tool is so quick and easy, that you can switch to the new machine at any time your existing one doesn't fit anymore.

.. |images-minione-kvm.png| image:: /images/minione-kvm.png
.. |images-minione-lxd| image:: /images/minione-lxd.png
.. |images-minione-firecracker| image:: /images/minione-firecracker.png
.. |images-minione-packet| image:: /images/minione-packet.png

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

.. todo:: If needed, the deployment customizations are covered in the section Advanced Usage <advanced>.

You have to choose among the KVM (default), LXD, Firecracker, Edge with KVM or Edge with Firecracker evaluation environments.

Run the following command under the privileged user **root** to get ready the all-in-one OpenNebula installation with default KVM hypervisor:

.. prompt:: bash # auto

    # bash minione

Or, for **LXD** environment:

.. prompt:: bash # auto

    # bash minione --lxd

Or, for **Firecracker** environment:

.. prompt:: bash # auto

    # bash minione --firecracker

Or, for **Edge with KVM** environment on Packet:

.. prompt:: bash # auto

    # bash minione --edge packet --edge-packet-token [token] --edge-packet-project [project]

Or, for **Edge with Firecracker** environment on Packet:

.. prompt:: bash # auto

    # bash minione --firecracker --edge packet --edge-packet-token [token] --edge-packet-project [project]

Be patient, it should take only a few minutes to get the host prepared. Main deployment steps are logged on the terminal and at the end of a successful deployment, the miniONE tool provides a report with connection parameters and initial credentials. For example:

.. code::

    ### Report
    OpenNebula 5.12 was installed
    Sunstone (the webui) is running on:
      http://192.0.2.1/
    Use following to login:
      user: oneadmin
      password: t5mk2tvPCG

When running the Edge deployment you will see also similar report:

.. code::

    ### Packet provisioned
      ID NAME            CLUSTER   TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 147.75.84.183   PacketClu   0                  -                  - init

To extend the setup by additional hypervisor on Packet run following command:

.. prompt:: bash # auto

    # bash minione --edge packet --node --edge-packet-token [<token>] --edge-packet-project [<project>]

To cleanup (delete resources in OpenNebula and Packet) run:

.. prompt:: bash # auto

    # oneprovision delete aeb1e3e0-09fd-426c-9ee5-13ee60daeee7 --cleanup

Now, the all-in-one OpenNebula evaluation environment is ready.

The rest of the guide introduces "how to run the very first virtual machine in a single click", "how to control the virtual machine state" and "how to explore the infrastructure defined in the OpenNebula" - first, utilizing the Sunstone web UI, and later using CLI as part of the Advanced sections. If you are familiar with the OpenNebula, you can skip the rest.
