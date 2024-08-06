.. _running_virtual_machines:

========================
Running Virtual Machines
========================

In previous tutorials of this Quick Start Guide, we:

   * Installed an :ref:`OpenNebula Front-end using miniONE <try_opennebula_on_kvm>`, and
   * Deployed a :ref:`Metal Edge Cluster <first_edge_cluster>` on AWS.
   
In this tutorial, we’ll use that infrastructure to deploy a fully-configured virtual machine with a ready-to-use WordPress installation, in under five minutes.

We’ll follow these high-level steps:

   #. Download the WordPress Appliance from the OpenNebula Marketplace.
   #. Instantiate the Virtual Machine for the Appliance.
   #. Verify the Installation by Connecting to WordPress.

.. important:: As mentioned above, in this tutorial we’ll deploy to the Edge Cluster created previously in this Quick Start Guide. To complete this tutorial, you need the Edge Cluster up and running.

Step 1. Download the WordPress Appliance from the OpenNebula Marketplace
========================================================================

The `OpenNebula Public Marketplace <https://marketplace.opennebula.io>`__ is a repository of Virtual Machines and appliances which are curated, tested and certified by OpenNebula.

To access the Marketplace, first log in to Sunstone on your OpenNebula Front-end, as user ``oneadmin``.

Open the left-hand pane (by hovering the mouse over the icons on the left), then select **Storage**, then **Apps**.

.. image:: /images/sunstone-select_apps.png
   :align: center
   :scale: 70%

|

Sunstone will display the **Apps** screen, showing the first page of apps that are available for download.

.. image:: /images/sunstone-apps_list.png
   :align: center
   :scale: 60%

|

Search for the app called **Service WordPress - KVM**. If it’s not on the list, type ``wordpress`` in the search field at the top, to filter by name.

.. image:: /images/sunstone-apps-word_filter.png
   :align: center
   :scale: 70%

|

Click **Service WordPress - KVM** to select it, then click the **Import into Datastore** |icon1| icon:

.. image:: /images/sunstone-import_wordp_to_ds.png
   :align: center

|

Sunstone will display the **Download App to OpenNebula** dialog:

.. image:: /images/sunstone-download_app.png
   :align: center
   :scale: 60%

|

Click **Next**. In the next screen, we'll need to select a datastore. For efficiency, and to try out the cluster created in :ref:`Provisioning an Edge Cluster <first_edge_cluster>`, select the ``aws-cluster-image`` datastore:

.. image:: /images/aws_cluster_images_datastore.png
   :align: center

|

Click **Finish**. Sunstone will download the appliance template and display basic information for the appliance, shown below in the **Info** tab:

.. image:: /images/sunstone-wordpress_info.png
   :align: center
   :scale: 80%

|

Wait for the appliance **State** to indicate **READY**. When it does, the VM will be ready to be instantiated.

Step 2. Instantiate the VM
==========================

In the left-hand pane, click **Templates**, then **VM Templates**:

.. image:: /images/sunstone-vm_templates.png
   :align: center
   :scale: 70%

|

Select **Service WordPress - KVM**, then click the **Instantiate** |icon2| icon at the top:

.. image:: /images/sunstone-vm_instantiate.png
   :align: center
   :scale: 70%

|

Sunstone will display the first screen of the **Instantiate VM Template** wizard:

.. image:: /images/sunstone-vm_instantiate_wiz1.png
   :align: center
   :scale: 70%

|

Feel free to modify the VM’s capacity according to your requirements, or leave the default values.

Click **Next**. Sunstone displays the **User Inputs** screen, where you can modify parameters such as the security credentials for the site administrator, or SSL certificates.

.. image:: /images/sunstone-vm_instantiate_wiz2.png
   :align: center
   :scale: 60%

|

Click **Next**. Sunstone displays the last screen of the wizard, **Advanced Options**:

.. image:: /images/sunstone-vm_instantiate_wiz3.png
   :align: center
   :scale: 70%

|

In this screen we need to specify what network the VM will connect to. Select the **Network** tab, then click the **Attach NIC** button:

.. image:: /images/sunstone-vm_instantiate_wiz4-attach_nic.png
   :align: center

|

Sunstone will display a wizard with network parameters:

.. image:: /images/sunstone-vm_instantiate-attach_nic1.png
   :align: center
   :scale: 70%

|

Click **Next**. Sunstone displays the **Select a network** screen:

.. image:: /images/select_aws_cluster_public_network.png
   :align: center

|

Select ``aws-cluster-public``, then click **Next**. Sunstone displays the final screen, **Select QoS**:

.. image:: /images/sunstone-vm_instantiate-attach_nic3.png
   :align: center
   :scale: 70%

|

To instantiate the VM, click **Finish**. Sunstone will take you to the last screen of the **Instantiate VM Template** wizard. To deploy the VM, click **Finish**.

Sunstone will deploy the VM to the AWS edge cluster, and display the **VMs** screen with the status of the VM. When the VM is running --- as indicated by the green dot --- it will be ready for your first login.

.. image:: /images/sunstone-wordpress.png
   :align: center

|

.. note:: The VNC icon |icon3| displayed by Sunstone does not work for accessing VMs deployed on Edge Clusters, since this access method is considered insecure and is disabled by OpenNebula.

Step 3. Connect to WordPress
============================

Select the public IP of the VM, which is highlighted in bold (blurred in the screen shown above). Simply enter the IP in your browser, and you’ll be greeted by the famous five-minute WordPress installation process.

|wordpress_install_page|

That’s it --- you have a working OpenNebula cloud with a WordPress up and running. Congratulations!

.. |wordpress_install_page| image:: /images/wordpress_install_page.png

.. |icon1| image:: /images/icons/sunstone/import_into_datastore.png
.. |icon2| image:: /images/icons/sunstone/instantiate.png
.. |icon3| image:: /images/icons/sunstone/VNC.png
