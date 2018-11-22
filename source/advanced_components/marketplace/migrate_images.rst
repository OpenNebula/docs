.. _migrate_images:

=======================================
Migrate images to/from KVM / vCenter DS
=======================================

Overview
--------------------------------------------------------------------------------

OpenNebula allows the management of hybrid environments, offering end-users a self-service portal to consume resources from both VMware-based infrastructures and KVM based ones in a transparent way to the user.

We are going to show you both transition below step-by-step trough Sunstone:

VMDK Image to QCOW2 Datastore
--------------------------------------------------------------------------------

Here is how it works. We have a qcow2 image within MarketPlace and we want to use it in KVM

1. We go to MarketPlace and select the image that we want, then click on **Download Button**.

.. image:: /images/market_migrate_vmdk_qcow2_1.png
    :width: 90%
    :align: center

.. warning::

    When the image destination datastore is qcow2/raw we should define the attribute ``DRIVER=qcow2`` or ``DRIVER=raw`` in order to convert the image. If not, the image will be download without any change.

2. Now, we have to select the destination datastore.

.. image:: /images/market_migrate_vmdk_qcow2_2.png
    :width: 90%
    :align: center

3. Then, We have to create a template in order to use the new image.

.. image:: /images/market_migrate_vmdk_qcow2_3.png
    :width: 90%
    :align: center

4. Now, instantiate the template and we will see that it works.

.. image:: /images/market_migrate_vmdk_qcow2_4.png
    :width: 90%
    :align: center

QCOW2 Image to VMDK Datastore
--------------------------------------------------------------------------------

The process is very similar to the described aboved.

1. We go to MarketPlace and select the image that we want, then click on **Download Button**.

.. image:: /images/market_migrate_qcow2_vmdk_1.png
    :width: 90%
    :align: center

.. note::

    In this case, when you import a vcenter datastore is automatically set ``DRIVER=vcenter`` so we dont need to define **DRIVER** attribute.

2. Now, we have to select the destination datastore.

.. image:: /images/market_migrate_qcow2_vmdk_2.png
    :width: 90%
    :align: center

3. When we download a vmdk image from the marketplace, automatically is created a template with the image attached. However, we need a template with a vcenter ref in order to deploy the VM so, we should create a void-template in vcenter and import to OpenNebula.

.. image:: /images/market_migrate_qcow2_vmdk_3.png
    :width: 90%
    :align: center

4. Now, we will clone the template in order to have a template backup.

.. image:: /images/market_migrate_qcow2_vmdk_4.png
    :width: 90%
    :align: center

5. We have to set the cloned void template to attach the new image.

.. image:: /images/market_migrate_qcow2_vmdk_5.png
    :width: 90%
    :align: center

6. Finally, we can instantiate the template.

.. image:: /images/market_migrate_qcow2_vmdk_6.png
    :width: 90%
    :align: center

.. image:: /images/market_migrate_qcow2_vmdk_7.png
    :width: 90%
    :align: center

In vcenter:

.. image:: /images/market_migrate_qcow2_vmdk_8.png
    :width: 90%
    :align: center

How was implemented
--------------------------------------------------------------------------------

Everytime the image that we selected from MarketPlace is downloaded to the frontend. Then, when the download process finish, is convert with ``qemu-img convert`` tool as follow:

.. prompt:: bash $ auto

    qemu-img convert -f <original_type> -O <destination_type> <original_file> <destination_file>

Then, the destination file is send to the destination datastore.

Limitations and restrictions
--------------------------------------------------------------------------------

We have to take into account that when we convert an image from qcow2/raw to vmdk, the contextualization is lost so, we will have to install **VMWare tools** manually.