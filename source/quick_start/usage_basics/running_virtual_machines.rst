.. _running_virtual_machines:

========================
Running Virtual Machines
========================

In previous tutorials of this Quick Start Guide, we:

   * Installed an :ref:`OpenNebula Front-end <deployment_basics>`, and
   * Deployed a :ref:`Metal Edge Cluster <first_edge_cluster>` on AWS.
   
In this tutorial, we’ll use that infrastructure to deploy a fully-configured virtual machine with a ready-to-use WordPress installation, in under five minutes.

We’ll follow these high-level steps:

   #. Download the Wordpress Appliance from the OpenNebula Marketplace
   #. Instantiate the Virtual Machine for the Appliance
   #. Verify the Installation by Connecting to WordPress


Step 1. Download the Wordpress Appliance from the OpenNebula Marketplace
========================================================================

The `OpenNebula Public Marketplace <https://marketplace.opennebula.io>`_ is a repository of curated Virtual Machines, tested by OpenNebula.

To access the Marketplace, first log in to Sunstone on your OpenNebula Front-end, as user ``oneadmin``.

Open the left-hand pane (by hovering the mouse over the icons on the left), then select **Storage**, then **Apps**.

.. image:: /images/6.10-sunstone-select_apps.png
   :align: center
   :scale: 70%

|

Sunstone will display the **Apps** screen, showing the first page of apps that are available for download.

.. image:: /images/6.10-sunstone-apps_list.png
   :align: center
   :scale: 60%

|

Search for the app called **Service WordPress - KVM**. If it’s not on the list, type ``wordpress`` in the search field at the top, to filter by name.

.. image:: /images/6.10-sunstone-apps-word_filter.png
   :align: center
   :scale: 70%

|

Click the app entry to select it, then click the **Import into Datastore** |icon1| icon:

.. image:: /images/6.10-sunstone-import_wordp_to_ds.png
   :align: center

|

Sunstone will display the **Download App to OpenNebula** dialog:

.. image:: /images/6.10-sunstone-download_app.png
   :align: center
   :scale: 60%

|

Click **Next**. In the next screen, we'll need to select a datastore:

.. image:: /images/6.10-sunstone-download_app-2-DS.png
   :align: center
   :scale: 60%

|

For efficiency, and to try out the cluster created in :ref:`Provisioning an Edge Cluster <first_edge_cluster>`, select the ``aws-cluster-image`` datastore, then click **Finish**. Sunstone will download the appliance template and display its basic information:

.. image:: /images/6.10-sunstone-wordpress_info.png
   :align: center
   :scale: 80%

|

Wait for ``State`` to indicate ``Ready``. When it does, the VM will be ready to be instantiated.


Step 2. Instantiate the VM
~~~~~~~~~~~~~~~~~~~~~~~~~~

In the left-hand pane, click **Templates**, then **VM Templates**:

.. image:: /images/6.10-sunstone-vm_templates.png
   :align: center
   :scale: 70%

|

Select **Service WordPress - KVM**, then click the **Instantiate** |icon2| icon at the top:

.. image:: /images/6.10-sunstone-vm_instantiate.png
   :align: center
   :scale: 70%

|

Sunstone will display the first screen of the **Instantiate VM Template** wizard:

.. image:: /images/6.10-sunstone-vm_instantiate_wiz1.png
   :align: center
   :scale: 70%

|

Feel free to modify the VM’s capacity according to your requirements, or leave the default values.

Click **Next**. Sunstone displays the **User Inputs** screen. Here you can optionally modify parameters such as the security credentials for the site administrator, or SSL certificates.

.. image:: /images/6.10-sunstone-vm_instantiate_wiz2.png
   :align: center
   :scale: 60%

|

Clicking **Next** takes you to the last screen of the wizard, **Advanced Options**:

.. image:: /images/6.10-sunstone-vm_instantiate_wiz3.png
   :align: center
   :scale: 70%

|

Before instantiating the VM, we need to set the network it will connect to.

Click the **Network** tab, then click the **Attach NIC** button:

.. image:: /images/6.10-sunstone-vm_instantiate_wiz4-attach_nic.png
   :align: center

|

Sunstone will display a wizard with network parameters:

.. image:: /images/6.10-sunstone-vm_instantiate-attach_nic1.png
   :align: center
   :scale: 70%

|

Click **Next**. Sunstone displays the **Select a network** screen:

.. image:: /images/6.10-sunstone-vm_instantiate-attach_nic2.png
   :align: center
   :scale: 70%

|

Select ``aws-cluster-public``, then click **Next**. Sunstone displays the final screen, **Select QoS**:

.. image:: /images/6.10-sunstone-vm_instantiate-attach_nic3.png
   :align: center
   :scale: 70%

|

To instantiate the VM, click **Finish**. Sunstone will take you to the last screen of the **Instantiate VM Template** wizard. To deploy the VM, click **Finish**.

Sunstone will deploy the VM to the AWS edge cluster, and display the **VMs** screen with the status of the VM. When the VM is running --- as indicated by the green dot --- it will be ready for your first login.

.. image:: /images/6.10-sunstone-wordpress.png
   :align: center
   :scale: 80%

|


.. note:: The VNC icon |icon3| displayed by Sunstone does not work for accessing the VM, since this access method is considered insecure for VMs running in Edge Clusters, and is disabled by OpenNebula.

Step 3. Connect to WordPress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select the public IP of the VM, which is highlighted in bold (blurred in the screen shown above). You should only have one bold IP in that VM. Simply enter it in your browser and you’ll be greeted by the famous five-minute WordPress installation process! That’s it, you have a working OpenNebula cloud. Congrats!

|wordpress_install_page|



.. |wordpress_install_page| image:: /images/wordpress_install_page.png

.. |icon1| image:: /images/icons/sunstone/import_into_datastore.png
.. |icon2| image:: /images/icons/sunstone/instantiate.png
.. |icon3| image:: /images/icons/sunstone/VNC.png
