.. _try_opennebula_on_vmware:

=====================================
Deploy OpenNebula Front-end on VMware
=====================================

.. OVA = Open Virtual Appliance file

In this tutorial, we’ll use **vOneCloud** to install an OpenNebula Front-end on top of an existing VMware installation. Completing this tutorial takes approximately five minutes.

**vOneCLoud** is an Open Virtual Appliance (OVA) for VMware vSphere. It contains a complete OpenNebula Front-end, installed and configured on an AlmaLinux OS. It is free to download and use, and may be used for small-size production deployments. With **vOneCloud**, you can deploy on top of your VMware infrastructure all of the OpenNebula services needed to use, manage and run OpenNebula.

.. image:: /images/vonecloud_logo.png
    :align: center

In this tutorial, we’ll complete the following high-level steps:

    #. Verify the system requirements.
    #. Download **vOneCloud**.
    #. Deploy the **vOneCloud** OVA.
    #. Configure the **vOneCloud** virtual appliance.
    #. Access the OpenNebula Front-end through the FireEdge GUI.

After finishing this tutorial, you will have deployed a complete, ready-to-use OpenNebula Front-end on top of your VMware infrastructure. You will then be able to log in via the FireEdge GUI, define hosts and deploy virtual machines.

Step 1. Verify the System Requirements
======================================

To deploy and use the vOneCloud appliance, you will need the following:

    * **vCenter 7.0** with ESX hosts grouped into clusters.
    * **ESX 7.0** with at least 16 GB of free RAM and a datastore with 100 GB of free space.
    * **Information** for connecting to vCenter7.0:
        - IP or DNS address
        - Login credentials (username and password) of an admin user
    * **Web browser**: Firefox (3.5 and above) or Chrome.

    .. warning ::
    
        Other browsers, including Safari, are not supported and may not work well.

Step 2. Download vOneCloud
==========================

To download vOneCloud, you will need to complete the `download form <https://opennebula.io/get-vonecloud>`__.

Download the OVA and save it to a convenient location.

Step 3. Deploy the vOneCloud OVA
====================================

Log in to your vCenter installation. Determine which cluster to deploy vOneCloud on.

In the left-hand pane, right-click the desired cluster, then click **Deploy OVF Template**.

.. image:: /images/6.10-vOneCloud-download-deploy-001.png
    :align: center
    :scale: 70%

|

In the **Deploy OVF Template** dialog box, select **Local file**, then click **Browse** to search for and select the vOneCloud appliance OVA that you downloaded.

Click **Next**. In the next few screens, follow the vCenter wizard to deploy vOneCloud as you would any other OVA. You will need to select the compute resource to deploy on, the datastore where the OVA will be copied, and the network that the virtual appliance will use.

.. note::

    The datastore used for the vOneCloud appliance needs to have at least 100 GB of available space.
    
The final screen displays a summary of deployment information. Click **Finish**.

Wait for the deployment to complete. This should not take more than a few moments.

After the VM has finished booting, the Web Console should display the OpenNebula Control Console:

.. image:: /images/control-console.png
    :align: center
    :scale: 60%

|

At this point, the vOneCloud virtual appliance is up and running.

.. note::

    If instead of the Control Console you see a normal Linux tty login screen:
    
     .. image:: /images/control-console-wrong.png
        :align: center
        :scale: 60%

    |
    
    then the virtual appliance is displaying the wrong tty terminal. The vOneCloud Control Console is on tty1. To access tty1, press ``Ctrl+Alt+F1``.
    
In the next steps we’ll configure the vOneCloud appliance.

Step 4. Configure vOneCloud
===========================

We’ll configure the following:

    * Network connection for the vOneCloud appliance
    * OpenNebula user ``oneadmin`` password
    * Linux ``root`` password
    * IP address or FQDN for the public endpoint of FireEdge

Step 4.1. Configure the Network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The vOneCloud appliance is configured to connect automatically via DHCP. If you are using DHCP, you can skip to the :ref:`next step <Step 4.2>`. If using a manual network configuration, read on.

In the Control Console, press ``1`` to configure the network following the steps below:

    #. Select **Edit a connection**.
    #. Select **System eth0**.
    #. Select **IPv4 Configuration**, then **Show**.
    #. Change the configuration from ``Automatic`` to ``Manual``.
    #. Fill in the required information for manual configuration:
        - **Addresses**: IPv4 address in /24 notation, e.g. ``10.0.1.249/24``. To add more addresses, use the **Add** item under the **Addresses** field.
        - **Gateway**: IP address of the Gateway for the appliance.
        - **DNS servers**: IP address(es) of one or more DNS servers.
        - **Search domain** (optional): Search domains for DNS.

After filling in the information, select **OK** to exit the dialog.

In the next screen, select **Activate a connection** and ensure that **System eth0** is activated. Then, select **Set system hostname** and type a hostname.


.. _Step 4.2:

Step 4.2. Configure the OpenNebula User Password
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the Control Console, press ``2`` to configure the password for the OpenNebula user, ``oneadmin``.

Enter the desired password. You will use this password to log into the FireEdge GUI in the last step of this tutorial.

.. important::

    This is the OpenNebula system user account, not to be confused with the Linux user ``oneadmin``.

Step 4.3. Configure the Linux ``root`` User Password
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the Control Console, press ``3`` to set the password for the Linux OS ``root`` user. This is your master password for the virtual appliance.

.. warning::

    This password is not often used, so it’s easy to forget. As in all Unix-like systems, there is no way to recover a lost ``root`` password, so ensure it is stored in a safe place.

Step 4.4. Configure a Public IP for vOneCloud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the Control Console, press ``4`` to select the FQDN or public IP address that will serve as the endpoint for accessing the FireEdge GUI.

At this point, the vOneCloud appliance is configured and ready to be accessed through the FireEdge GUI.

.. important::

    Bear in mind that in this evaluation version, FireEdge is listening on unencrypted HTTP over a public IP address.

Step 5. Access the OpenNebula Front-end through the FireEdge GUI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Open a web browser (Firefox or Chrome) and enter the public IP or FQDN you defined as the FireEdge endpoint in Step 4.4.

For example, ``http://10.0.1.176``.

You should be greeted by the FireEdge login screen:

.. image:: /images/6.10-fireedge_login.png
    :align: center
    :scale: 50%

|

In the **Username** field, type ``oneadmin``. In the **Password** field, enter the password you defined for the OpenNebula user in Step 4.2.

FireEdge should display the Dashboard:

.. image:: /images/6.10-sunstone_dashboard.png
    :align: center
    :scale: 50%

|

Congratulations -- you have deployed and fully configured an OpenNebula Front-end on your VMware infrastructure. At this point, you are ready to add computing clusters to OpenNebula and launch virtual machines.

.. note::

    If you get an error message from FireEdge when attempting to log in, it means the public endpoint for FireEdge is not properly configured.
    
    .. image:: /images/sunstone-fe-error.png
        :align: center
        :scale: 70%
    
    |
    
    Return to the Control Console and configure a public IP or FQDN (see Step 4.4 above).

.. _advanced_login:

Accessing the Linux CLI in the Virtual Appliance
================================================

If wish to access the Linux OS running on the virtual appliance, you can do so in one of two ways:

    * Using SSH:
        - Connect to vOneCloud’s public IP address or FQDN. For example: ``ssh root@10.0.1.176``.
            (If connecting from Windows, you can use a program such as `PuTTY <http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html>`__ or `WinSCP <https://winscp.net/>`__.)
    * Using vCenter:
        - When connected to the Control Console, change to tty2 by pressing ``Ctrl+Alt+F2``. Then, log in to the system as ``root`` with the password you defined in Step 4.3.
