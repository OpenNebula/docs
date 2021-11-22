.. _whmcs_tenants_instcfg:

===================================
WHMCS Tenants Module Install/Update
===================================

The install and update process are essentially identical. The Module files can be found in */usr/share/one/whmcs*. You will just need to copy the files in this directory to the main WHMCS directory on the server hosting WHMCS. When updating the module just copy the files on top of the existing files and overwrite them.

.. note:: Make sure you download the updated files from the one-ee-tools repository before doing either an install or an update.

==================================
WHMCS Tenants Module Configuration
==================================

In this chapter we will go over adding a server, creating the group for it, and configuring a product.

Adding a Server
---------------

.. image:: /images/whmcs_tenants_system_settings.png
    :align: center

To configure your WHMCS Tenants Module, first log in to your WHMCS admin area and navigate to **System Settings** -> **Servers** and click on the button **Add New Server**.

.. image:: /images/whmcs_tenants_add_server.png
    :align: center

Fill in a **Name** and the **Hostname** for your OpenNebula Server. Under the **Server Details** section select **OpenNebula Tenants** as the Module and fill in the **Username** and **Password** with a user in the *oneadmin* group in your OpenNebula installation.

Once these are filled out, click the **Test Connection** button to verify the module can authenticate with your OpenNebula server.

Do not forget to hit the **Save Changes** button once this is verified in order to complete adding the server.

Creating a Server Group
-----------------------

After the server is added it should return you to the list of Servers. Here you can click the **Create New Group** button to make a server group to contain your OpenNebula Server(s).

Fill in the **Name** of your Server Group, then highlight your OpenNebula Server and click **Add** to add it to your new group.  Once this is done, click **Save Changes**.
