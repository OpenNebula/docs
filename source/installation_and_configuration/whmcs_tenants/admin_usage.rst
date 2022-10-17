.. _whmcs_tenants_admin:

========================================
WHMCS Tenants Module Administrator Usage
========================================

Creating a Product Group
------------------------

Before creating products you should create groups to better organize your offerings.  To create a new product group, navigate to **System Settings** -> **Products/Services**, then click on the **Create a New Group** button there. Fill in the Product Group Name, and any other pieces of this form such as Template and Payment Gateways, then click **Save Changes** once you're done.

Creating a Product
------------------

Navigate to **System Settings** -> **Products/Services**.

From the Products/Services page, click on **Create a New Product**.  Select the **Product Type**, **Product Group**, and a **Product Name**.  The **Module** should be **OpenNebula Tenants**.  Once this is call done, click the **Continue** button.

.. image:: /images/whmcs_tenants_new_product.png
    :align: center

On this page, click on the **Module Settings** tab then select **OpenNebula Tenants** for the **Module Name**, then select your recently created **Server Group**.  Here, you can fill in the maximum resources usable by this product. You can also set the ACL parameters which will be created in OpenNebula for this product.

These resource limites correlate to the :ref:`Quota <quota_auth>` for the Group in OpenNebula, so this will limit the amount of resources used in OpenNebula for each product.  You can also enable Metric Billing and set pricing for each of these metrics:

 * IP Addresses
 * RAM
 * CPU cores
 * Supporting Multiple VDCs
 * Datastore Images
 * Datastore Size
 * NETRX
 * NETTX

Below the resources you can determine if the User should be automatically setup or if the system should wait for the Administrator to Accept the order.

.. image:: /images/whmcs_tenants_module_settings.png
    :align: center

.. note:: For more information about managing VDCs refer to the :ref:`Managing VDCs <manage_vdcs>` page.

The **Upgrades** tab can also be a useful feature to make use of.  If you create multiple products with different resource quotas, you can select the products here which your users can upgrade to.  You can select multiple products by holding the Shift or Ctrl key.

Managing Orders
---------------

To view the orders waiting to be accepted navigate to **Orders** -> **Pending Orders** on the top bar. On this page you can view the information about the client and the service they are ordering. Here you can accept, cancel, set as fraud, or delete the orders.

.. image:: /images/whmcs_tenants_accept_order.png
    :align: center

If your product is configured to be setup after manually accepting the order, you will need to accept the order created before any changes are made in OpenNebula. This is also true for package upgrades your users might request.

Once orders are setup there is a User, Group, and ACL created corresponding to the Service in WHMCS. Then, the Quota will be created for the Group linked to this Order. On the service page for the customer, they will have a Login link.

.. note:: If there are issues when upgrading products, the user and group may need to be recreated. Any existing VMs can be assigned to the admin user temporarily while this is done. This will be fixed in a future release.

Checking Metrics
----------------

To view metrics for your customers, navigate to **View/Search Clients** and click on the ID of any user. Click on the **Products/Services** tab, there should be a Metric Statistics section with a table. You can click **Refresh Now** to update the information manually.
