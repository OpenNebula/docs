.. _try_opennebula_on_kvm:

========================
Quickstart Using miniONE
========================

Using ``miniONE``, you can build an OpenNebula cloud with a single command in under ten minutes. Optionally, you can also deploy a KVM node on the server, to evaluate OpenNebula or for daily development.

``miniONE`` is a simple Bash script. It automatically downloads, installs and configures an OpenNebula Front-end and all necessary components to manage and run virtual machines.

In this tutorial, we’ll use ``miniONE`` to build an OpenNebula cloud. To do so, we need to complete the following high-level steps:

#. Verify the system requirements.
#. Select the installation type.
#. Download ``miniONE``.
#. Run the ``miniONE`` script.
#. Verify the installation.

.. tip::

   The cloud environment installed by ``miniONE`` is mainly intended for evaluation, development and testing. However, it can also serve as a base for larger short-lived deployments.

Step 1. Verify the System Requirements
======================================

To run the ``miniONE`` script and the OpenNebula cloud, you’ll need a physical server or a virtual machine. This server should run a supported operating system with the latest software updates and without any customizations. (If you don’t have access to a physical server or a VM, see :ref:`Installing on Amazon AWS <AWS>` below.)

**Supported operating systems:**
   - RHEL/AlmaLinux 8 or 9
   - Debian 10 or 11
   - Ubuntu 20.04 or 22.0.4

**Minimum hardware:**
   - 4 GiB RAM
   - 80 GiB free disk space

**Configuration:**
   - Access to the privileged user (root) account
   - A public IP address
   - An SSH server running on port 22
   - Open ports:
      - 22 (SSH)
      - 80 (for the Sunstone GUI)
      - 2616 (for the FireEdge GUI)
      - 5030 (for the OneGate service)

.. _AWS:

Optional: Installing on Amazon AWS
----------------------------------

(If you are not installing on Amazon AWS, you can skip to the next section, `Step 2: Select the Installation Type`_.)

If you don’t have a server available, we recommend using the Amazon EC2 service to obtain a VM to act as the OpenNebula Front-end.

An example of a successfully-tested configuration:

- Region: Frankfurt
- Operating System: Ubuntu Server 20.04 LTS (HVM)
- Tier: ``t2.medium``
- Open ports - Same as in a bare-metal installation:
      - 22 (SSH)
      - 80 (for the Sunstone GUI)
      - 2616 (for the FireEdge GUI)
      - 5030 (for the OneGate service)
- Storage: 80 GB SSD. Ensure to edit the **Storage** tab before launching the VM, since by default it is assigned only 8GB

Log in to the EC2 VM
^^^^^^^^^^^^^^^^^^^^

To log in to your EC2 VM using SSH, you will need to generate a key pair (public and private key) for your Amazon EC2 instance. You will then use your private key to log in to your EC2 VM.

You can generate a key pair from within Amazon EC2 itself. You can download the private key as a PEM file, and use this file to connect to your EC2 VM using SSH.

For complete instructions on creating key pairs and connecting to your Linux instance, see the AWS documentation: `Create a key pair for your Amazon EC2 instance <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html>`_ and `Connect to your Linux instance from Linux or macOS using SSH <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-ssh.html>`_.

To log in to your EC2 VM, use ssh as user ``ubuntu``, specifying the PEM file you downloaded, by running the following command:

.. prompt::

   ssh <public IP of the VM> -l ubuntu -i <path to PEM file>

.. note::

   Ensure you have set the appropriate permissions for the PEM file, or SSH will refuse to connect.
   
Update the VM Operating System
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When logged in as user ``ubuntu``, use the ``sudo`` command to become the root user (no password is required). Then, update the system to its latest software packages by running the following command:

.. prompt::

   apt update && apt upgrade

After updating, proceed to the next section, `Step 2: Select the Installation Type`_.

.. tip::

   After downloading the ``miniONE`` script (described in the next sections), you will need to copy it to your EC2 VM. To copy it, you can first download the script to your local machine, then copy it with the ``scp`` command specifying the same user and PEM file as when logging in via ssh. For example, the command below copies the ``miniONE`` script to the ``ubuntu`` user’s home directory:
   
   .. prompt::
   
      scp -i <path to PEM file> <path to minione script> ubuntu@<public IP of the VM>:~

Step 2: Select the Installation Type
====================================

``miniONE`` offers two installation types:

- **OpenNebula Front-end and KVM node** (default)
   Installs the OpenNebula Front-end plus a KVM node on the local machine
- **OpenNebula Front-end only**
   Installs an OpenNebula Front-end without KVM node

   .. warning::

      When deploying only a OpenNebula front-end, the installation uses a private IP address, and the ensuing cloud environment will not work with OneProvision or with a Kubernetes cluster.

Step 3: Download MiniONE
========================

To download ``miniONE``, please complete `the required form <https://opennebula.io/get-minione/>`__.

Step 4: Run the ``miniONE`` Script
==================================

Open a terminal in the folder where you downloaded the ``miniONE`` script.

All of the commands listed in this section should be run from the folder that contains the script.

As mentioned above, ``miniONE`` is a Bash installation script. It offers several command line parameters to customize the installation. For a list of available parameters, run the following command:

.. prompt::

   bash minione --help

For most installations, no flags are required.

Option 1: Run ``miniONE`` to Deploy Front-end Only
--------------------------------------------------

This option installs an OpenNebula Front-end without a KVM hypervisor. With this configuration, you can later provision the hypervisor with OneProvision, for example by following the :doc:`Provisioning an Edge Cluster <../operation_basics/provisioning_edge_cluster>` guide.

.. important::

   In this configuration, the FireEdge and OneGate endpoints expose HTTP on a public network interface. ``miniONE`` is an evaluation tool, and this configuration should not be used in production environments.
   
To install as Front-end only, run the following command as user ``root``:

.. prompt::

   bash minione --frontend

.. _Option 2:

Option 2: Run ``miniONE`` to Deploy a Front-end and a KVM Node
--------------------------------------------------------------

Running ``miniONE`` without options installs an OpenNebula Front-end and a single OpenNebula node on KVM. This option is suitable for using hardware virtualization on bare-metal hosts. However, if running on a virtual machine or if the CPU does not support virtualization, the deployment will fall back to emulation via QEMU.

To install an OpenNebula Front-end and a virtualization module, run ``miniONE`` without options, as user ``root``:

.. prompt::

   bash minione
      
.. important::

   This configuration does not expose the OneGate service on a public IP address, and hence will not work with OneProvision or a Kubernetes cluster.

Step 5: Verify the Installation
==================================

During installation, ``miniONE`` logs output to the terminal. Installation may take about a minute, depending on your server.

After installation, ``miniONE`` prints a report with connection parameters and login credentials, as shown below.

.. prompt::

   ### Report
   OpenNebula 6.8 was installed
   Sunstone is running on:
   http://3.121.76.103/
   FireEdge is running on:
   http://3.121.76.103:2616/
   Use following to login:
      user: oneadmin
      password: lCmPUb5Gwk

At this point, you have successfully installed ``miniONE``. OpenNebula services should be running, and the system should be ready for your first login.

We will now log in to OpenNebula’s FireEdge GUI. To do so, ensure that you can connect to port 2616 of the host where you installed ``miniONE``.

Point your browser to the IP and port provided by the ``miniONE`` output shown above. You should be greeted with the FireEdge login screen:

.. image:: /images/6.10-fireedge_login.png
   :align: center
   :scale: 50%

|

In the **Username** input field, type ``oneadmin``. For **Password**, enter the password provided by ``miniONE``, then press ``Enter`` or click **SIGN IN**.

The screen should display the FireEdge Dashboard:

.. image:: /images/6.10-sunstone_dashboard.png
   :align: center
   :scale: 50%

|

This is the default view for cloud administrators. From this view in FireEdge, you have complete control over your OpenNebula infrastructure. To explore what you can do in the GUI, click the hamburguer icon on the left to open the left-hand control menu, as shown below:

.. image:: /images/6.10-fireedge_dashboard_hamb_menu.png
   :align: center
   :scale: 50%

|

If you deployed a Front-end and a KVM node (in :ref:`Option 2 <Option 2>` above), you can use the GUI to create VM templates, instantiate VMs, download appliances, and explore the capabilities of OpenNebula through its graphical user interface.

Next Steps
==========

To continue evaluating OpenNebula on physical resources, or try out the automatic provisioning features, follow the :ref:`Operations Guide <operation_basics>` to quickly and easily add a remote Edge Cluster on AWS to your shiny new OpenNebula cloud!
