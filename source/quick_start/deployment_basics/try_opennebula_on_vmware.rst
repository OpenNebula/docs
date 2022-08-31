.. _try_opennebula_on_vmware:

==================================
Try OpenNebula Front-end on VMware
==================================

In this guide, we'll go through a Front-end OpenNebula environment deployment, where all the OpenNebula services needed to use, manage and run the cloud will be deployed through an OVA and collocated on the single VM running on a vCenter instance. Afterwards, you can follow the Operations and Usage basics guides of this same Quick Start to launch edge clusters based on open source hypervisors.

.. image:: /images/vonecloud_logo.png
    :align: center

vOneCloud is a virtual appliance for vSphere that builds on top of your vCenter an OpenNebula cloud for development, testing or product evaluation in five minutes. In a nutshell, it is an OVA file with a configured AlmaLinux and OpenNebula installation. vOneCloud is free to download and use and can be also used for small-size production deployments.

vOneCloud ships with the following components under the hood:

+-----------------------+--------------------------------------------------------------------------------------------------+
|       **AlmaLinux**   |                                                8                                                 |
+-----------------------+--------------------------------------------------------------------------------------------------+
| **OpenNebula**        | |release| (:ref:`release notes <rnguide>`)                                                       |
+-----------------------+--------------------------------------------------------------------------------------------------+
| **MariaDB**           | Default version shipped in AlmaLinux 8                                                           |
+-----------------------+--------------------------------------------------------------------------------------------------+
| **Phusion Passenger** | Default version shipped in AlmaLinux 8 (used to run Sunstone)                                    |
+-----------------------+--------------------------------------------------------------------------------------------------+

.. _control_console:

vOneCloud comes with a Control Console, a text-based wizard accessible through the vCenter console to the vOneCloud appliance. It is available by opening the vOneCloud appliance console in vCenter. It requires no authentication since only the vCenter administrator will be able to open the vOneCloud console. It can be used to configure the network, root password and change the password of the OpenNebula oneadmin user.

.. _vonecloud_requirements:

Requirements
============

.. note ::

     In order to follow the :ref:`Running Kubernetes Clusters <running_kubernetes_clusters>` with your vOneCloud instance, you will need a publicly accessible IP address so the deployed services can report to the OneGate server. See :ref:`OneGate Configuration <onegate_conf>` for more details.

The following components are needed to use the vOneCloud appliance:

+----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|       **Component**        |                                                                                                                                                      **Observations**                                                                                                                                                     |
+----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| vCenter 7.0                | - ESX hosts need to be grouped into clusters.                                                                                                                                                                                                                                                                             |
|                            | - The IP or DNS needs to be known, as well as the credentials (username and password) of an admin user.                                                                                                                                                                                                                   |
+----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ESX 7.0                    | - With at least 16 GB of free RAM and 100GB of free size on a datastore.                                                                                                                                                                                                                                                  |
+----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Firefox (> 3.5) and Chrome | Other browsers, including Safari, are **not** supported and may not work well.                                                                                                                                                                                                                                            |
+----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

vOneCloud ships with a default of 2 vCPUs, 16 GiB of RAM and 100GB of disk size, and as such it has been certified for infrastructures of the following dimensions:

- Up to 1.000 VMs in total
- Up to 100 users, the limit being 10 users accessing the system simultaneously

Take into account that vOneCloud is shipped for evaluation purposes. 

.. _accounts:

Accounts
================================================================================

vOneCloud ships with several pre-created user accounts which will be described in this section:

+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+
| Account  |      Interface      |           Role          |                                   Description                                    |
+==========+=====================+=========================+==================================================================================+
| root     | linux               | Appliance administrator | This user can log into the appliance (local login, no SSH).                      |
+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+
| oneadmin | linux               | Service user            | Used to run all OpenNebula services.                                             |
+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+
| oneadmin | OpenNebula Sunstone | Cloud administrator     | Cloud administrator. Run any task in OpenNebula, including creating other users. |
+----------+---------------------+-------------------------+----------------------------------------------------------------------------------+

.. _download_and_deploy:

Download and Deploy
================================================================================

vOneCloud can be downloaded by completing the form `here <https://opennebula.io/get-vonecloud>`__.

The OVA file can be imported into an existing vCenter infrastructure. It is based on `AlmaLinux 8 <https://almalinux.org/>`__ with VMware tools enabled.

Follow the next steps to deploy a fully functional OpenNebula cloud.

Step 1. Deploying the OVA
--------------------------------------------------------------------------------

Log in to your vCenter installation and select the appropriate datacenter and cluster where you want to deploy the appliance. Select ``Deploy OVF Template``.

.. image:: /images/vOneCloud-download-deploy-001.png
    :align: center

Browse to the download path of the OVA that can be downloaded from the link above.

Select the name, folder, and a compute resource where you want vOneCloud to be deployed. Also, you'll need to select the datastore in which to copy the OVA.

Select the network. You will need to choose a network that has access to the ESX hosts.

Review the settings selection and click finish. Wait for the Virtual Machine Template to appear in the cluster.

.. image:: /images/vOneCloud-download-deploy-007.png
    :align: center

After importing the vOneCloud OVA it needs to be cloned into a Virtual Machine. Before powering it on, the vOneCloud Virtual Machine can be edited to, for instance, add a new network interface, increase the amount of RAM, the available CPUs for performance, etc. Now you can power on the Virtual Machine.

.. _download_and_deploy_control_console:

Step 2. vOneCloud Control Console - Initial Configuration
--------------------------------------------------------------------------------

When the VM boots up you will see in the VM console in vCenter the :ref:`vOneCloud Control Console <control_console>`, showing this wizard:

.. image:: /images/control-console.png
    :align: center

If you are presented instead with the following:

.. image:: /images/control-console-wrong.png
    :align: center

You are being presented with the wrong tty. You will need to press Ctrl+Alt+F1 to access the Control Console.

In this wizard you first need to **configure the network**. If you are using DHCP you can simply skip to the next item.

If you are using a static network configuration, answer yes and you will need to use a ncurses interface to:

- "Edit a connection"
- Select "System eth0"
- Change IPv4 CONFIGURATION from <Automatic> to <Manual> and select "Show"
- Input the desired IP address/24 in Addresses
- Input Gateway and DNS Servers
- Select OK and then quit the dialog

Here's an example of static network configuration on the available network interface on the 10.0.1.x class C network, with a gateway in 10.0.1.1 and using 8.8.8.8 as the DNS server:

.. image:: /images/network-conf-example.png
    :align: center

The second action needed is to set the **oneadmin account password**. You will need this to log in to OpenNebula. Check the :ref:`Accounts section <accounts>` to learn more about vOneCloud roles and users.

.. image:: /images/set_oneadmin_password.png
    :align: center

.. _advanced_login:

In the third step, you need to define a **root password.** You won't be using this very often, so write it down somewhere safe. It's your master password to the appliance.

This password can be used to access the OpenNebula command line interface; for that, you need to SSH to vOneCloud using the `root` account and password. In OS X and Linux environments, simply use `ssh` to log in to the root account of vOneCloud's IP. For Windows environments you can use software like `PuTTY <http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html>`__ or even SFTP clients like `WinSCP <https://winscp.net/>`__. Alternatively, open the console of the vOneCloud VM in vCenter and change the tty (Ctrl + Alt + F2).

As the last step, you need to configure a public-facing address that will be used to access your vOneCloud instance by end-users. Enter the fully qualified domain name, hostname valid within your network, or the IP address.

.. image:: /images/control-console-fe-endpoint.png
    :align: center

Step 3. Enjoy the Out-of-the-Box Features
--------------------------------------------------------------------------------

After opening the Sunstone interface (``http://<appliance_ip>`` with oneadmin credentials), you are now ready to enjoy the out-of-the-box features of OpenNebula!

.. image:: /images/sunstone-main.png
    :align: center

If Sunstone greets you with an error while connecting to the public FireEdge endpoint, return to Control Center in the previous step and configure a valid endpoint:

.. image:: /images/sunstone-fe-error.png
    :align: center


