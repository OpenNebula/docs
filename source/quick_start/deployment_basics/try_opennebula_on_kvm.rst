.. _try_opennebula_on_kvm:

=====================================
Deploy an OpenNebula Front-end on AWS
=====================================

In this tutorial, we’ll install an OpenNebula Front-end in under ten minutes, using **miniONE**, the installation script provided by OpenNebula.

We’ll install our OpenNebula Front-end on a Virtual Machine in AWS. In later sections of this Quick Start Guide, you can use this Front-end to provision additional resources — such as Edge clusters or Kubernetes clusters — on your OpenNebula cloud.

To complete this tutorial, you will need an AWS account with the capacity to create a virtual machine and obtain public IP addresses.

**miniONE** is a simple Bash script. It automatically downloads, installs and configures an OpenNebula Front-end and all necessary components to manage and run virtual machines.

To install an OpenNebula Front-end using miniONE, we’ll need to complete the following high-level steps:

   #. Prepare the AWS VM where we’ll install miniONE.
   #. Update the OS in the VM.
   #. Download and run the miniONE script.
   #. Verify the installation.

The cloud environment installed by miniONE is mainly intended for evaluation, development and testing. However, it can also serve as a base for larger short-lived deployments.

.. note::

    To complete this tutorial, you will need to log in to a remote Linux machine via SSH. If you follow this tutorial on a Windows machine, you will need to use an SSH client application such as `PuTTY <https://www.putty.org/>`__.
   
.. tip::

    For a list of options supported by the script, run ``bash minione -h``. The script supports several types of installations (such as installing a Front-end and a KVM hypervisor node) which are not covered in this tutorial.

Step 1. Prepare the VM in AWS
=============================

In order to SSH into the EC2 VM, you need to pass the correct user and PEM file (you can create one and download it prior to launching the instance). You'll then be connecting to your Front-end using a command similar to:

As a first step, if you don’t already have one, create an account in AWS. AWS publishes a complete guide: `How do I create and activate a new AWS account? <https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/>`__

After you have created your account, you’ll need to obtain the ``access_key`` and ``secret_key`` of a user with the necessary permissions to manage instances. The relevant AWS guide is `Configure tool authentication with AWS <https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html>`__.

Next, you need to choose the region where you want to deploy the new resources. You can check the available regions in AWS’s documentation: `Regions, Availability Zones, and Local Zones <https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html>`__.

To run the miniONE script on AWS, you will need to instantiate a virtual machine with a supported operating system and the latest software updates, and without any customizations.

**Supported operating systems:**
   - RHEL/AlmaLinux 8 or 9
   - Debian 11 or 12
   - Ubuntu 22.04 or 24.04

**Minimum hardware:**
   - 4 GiB RAM
   - 80 GiB free disk space

**Configuration:**
   - Access to the privileged user (root) account
   - A public IP address
   - An SSH server running on port 22
   - Open ports:
      - 22 (SSH)
      - 80 (for the Ruby Sunstone GUI)
      - 2616 (for the FireEdge GUI)
      - 5030 (for the OneGate service)

.. tip:: To quickly deploy a suitable VM, browse the AWS AMI Catalog and select ``Ubuntu Server 22.04 LTS (HVM), SSD Volume Type``:

   .. image:: /images/minione-aws-ubuntu22.04.png
      :align: center

Below is an example of a successfully-tested configuration (though by no means the only possible one):

- Region: Frankfurt
- Operating System: Ubuntu Server 22.04 LTS (HVM)
- Tier: ``t2.medium``
- Open ports: 22, 80, 2616, 5030
- Storage: 80 GB SSD

When configuring the VM, ensure to assign enough storage (by editing the **Storage** tab), since by default the VM is only assigned 8GB.

Likewise, ensure that the ports mentioned above are open for incoming connections, by editing the **Security Group** for the VM:

    .. image:: /images/aws_security_groups.png
        :align: center

When configuration is finished, launch an instance of the VM. (See `Amazon’s tutorial <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/option2-task1-launch-ec2-instance.html>`_ if you have any doubts.) Once the VM is up and running we’ll need to log in to it, by following the steps below.

.. _minione_log_in_to_ec2:

Step 1.1. Log in to the EC2 VM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To log in to your EC2 VM using SSH, you will need to generate a key pair (public and private key) for your Amazon EC2 instance. You will use your private key to log in to your EC2 VM.

You can generate a key pair from within Amazon EC2 itself. You can download the private key as a PEM file, and use this file to connect to your EC2 VM using SSH.

For complete instructions on creating key pairs and connecting to your Linux instance, see the AWS documentation: `Create a key pair for your Amazon EC2 instance <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html>`__ and `Connect to your Linux instance from Linux or macOS using SSH <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-ssh.html>`__.

After downloading the PEM file, make sure to set its file permissions to read-only, for the user only. On Linux, you can set these permissions with ``chmod 400 <PEM file>``, for example ``chmod 400 ~/.ssh/aws_pemfile.pem``.

To log in to your EC2 VM, use ssh as user ``ubuntu``, specifying the PEM file you downloaded, by running this command:

.. prompt::

   ssh <public IP of the VM> -l ubuntu -i <PEM file>

For example:

.. prompt::

   ssh <IP> -l ubuntu -i ~/.ssh/aws_pemfile.pem

.. warning::

   Ensure you have set the appropriate permissions for the PEM file, or for security reasons SSH will refuse to connect.
   

Step 1.2. Update the VM Operating System
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once you have logged in to the VM as user ``ubuntu``, use the ``sudo`` command to become the root user (no password is required):

.. prompt::

    sudo su -

Then, update the system to its latest software packages by running the following command:

.. prompt::

   apt update && apt upgrade

Your AWS VM is now ready. In the next steps, we’ll download the miniONE script, upload it to the VM, and run the installation.

Step 3: Download and install miniONE
====================================

To download miniONE, please fill `the required form <https://opennebula.io/get-minione/>`__.

Step 3.1. Copy the miniONE script to the AWS VM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After downloading miniONE, you will need to copy it to your AWS VM.

- On Linux and Mac:
    
    If you’re on Linux, you can copy it with the ``scp`` command, providing the same user and PEM file as when logging in via SSH. For example, the command below copies the miniONE script to the ``ubuntu`` user’s home directory:

        .. prompt::
   
          scp -i <path to PEM file> <path to minione script> ubuntu@<public IP of the VM>:~

- On Windows:

    You can use either of two methods:
    
    * The GUI tool `WinSCP <https://winscp.net/eng/download.php>`__, which allows you to copy files by drag-and-drop
    * The command-line tool `PuTTY Secure Copy <https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html>`__, which emulates the Unix ``scp`` tool.
    
    For both methods you will need to provide the private key file for authentication.

Step 3.2. Run the miniONE script on the AWS VM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After copying the miniONE script to the VM, log in to the VM (as described :ref:`above <minione_log_in_to_ec2>`).

Use the ``sudo`` command to become the ``root`` user.

If necessary, use the ``cd`` command to navigate to the folder where you copied the miniONE script. For example, if you copied it to the home directory of user ``ubuntu`` run ``cd ~ubuntu``.

To install miniONE, run:

.. prompt::

   bash minione --frontend

The miniONE script will begin the installation, logging output to the terminal. Installation may take about a minute. When it’s finished, miniONE shows a report with connection parameters and login credentials:

.. prompt::

   ### Report
   OpenNebula 6.8 was installed
   Sunstone is running on:
   http://<omitted>/
   FireEdge is running on:
   http://<omitted>:2616/
   Use following to login:
      user: oneadmin
      password: lCmPUb5Gwk
   
At this point, you have successfully installed miniONE. OpenNebula services should be running, and the system should be ready for your first login.

.. important::

   In this configuration, the Ruby and FireEdge Sunstone endpoints, and the OneGate endpoint expose HTTP on a public network interface. miniONE is an evaluation tool, and this configuration should not be used in production environments.

Step 4: Verify the Installation
===============================

We will verify the installation by logging in to OpenNebula’s FireEdge Sunstone GUI.

.. note:: When running miniONE within an AWS instance, the reported IP may be a private address that’s not reachable over the Internet. Use the instance’s public IP address to connect to the FireEdge and Ruby Sunstone services.

Point your browser to the FireEdge IP and port provided by the miniONE output shown above, i.e. ``<public IP>:2616``. You should be greeted with the Sunstone login screen:

.. image:: /images/sunstone-login.png
   :align: center
   :scale: 50%

|

In the **Username** input field, type ``oneadmin``. For **Password**, enter the password provided by miniONE, then press ``Enter`` or click **SIGN IN**.

The screen should display the Sunstone Dashboard:

.. image:: /images/sunstone-dashboard.png
   :align: center

|

This is the default view for cloud administrators. From this view in Sunstone, you have complete control over your OpenNebula infrastructure. (The :ref:`Cloud View <fireedge_cloud_view>` interface is much simpler, intended for end users.) To explore what you can do in the GUI, open the left-hand panel by clicking on the hamburger icon on the top left:

.. image:: /images/sunstone-dashboard_hamb_menu.png
   :align: center
   :scale: 50%

|

Congratulations — you have deployed an OpenNebula Front-end node, which is ready to provision resources on cloud infrastructure. 


Next Steps
==========

You can now try out the GUI-based automatic provisioning features in the :ref:`Operations Guide <operation_basics>` to quickly and easily add a remote Edge Cluster on AWS to your shiny new OpenNebula cloud!


.. |images-sunstone-dashboard| image:: /images/sunstone-dashboard.png
.. |images-sunstone-change-view| image:: /images/sunstone-change-view.png
