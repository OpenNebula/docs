.. _migrate_images:

=====================================
Migrate Images to/from KVM/vCenter DS
=====================================

OpenNebula allows the management of heterogeneous environments, offering end-users a self-service portal to consume resources from both VMware-based infrastructures and KVM-based ones in a transparent way.

OpenNebula also offers functionality to automatically convert images so they can be run in other hypervisors.

VMDK Image to QCOW2 Datastore
--------------------------------------------------------------------------------

We have a VMDK image within Marketplace and we want to use it in KVM:

1. Go to Marketplace and select the image, then click on the **Import into Datastore** button (with the cloud and arrow icon).

.. image:: /images/market_migrate_vmdk_qcow2_1.png
    :align: center

If the destination image datastore is qcow2 or raw, you **must** define the attribute ``DRIVER=qcow2`` or ``DRIVER=raw``, respectively, in order to convert the image, otherwise it will be downloaded without any change. To do so, visit the **Templates** tab for the image and use the edit icon button to alter the **App template** before download.

2. Select the destination datastore.

.. image:: /images/market_migrate_vmdk_qcow2_2.png
    :align: center

3. Create a template in order to use the new image.

.. image:: /images/market_migrate_vmdk_qcow2_3.png
    :align: center

QCOW2 Image to VMDK Datastore
--------------------------------------------------------------------------------

1. Go to Marketplace and select the image in qcow2 format to be used in a vCenter cluster, then click on the **Import into Datastore** button.

.. image:: /images/market_migrate_qcow2_vmdk_1.png
    :align: center

.. note::

    In this case, when you import to a vcenter datastore ``DRIVER=vcenter`` is set automatically, so you don't need to define the **DRIVER** attribute.

2. Select the destination image datastore.

.. image:: /images/market_migrate_qcow2_vmdk_2.png
    :align: center

3. When we download a VDMK image from the Marketplace, a template is automatically created along with the image. However, we need a template with a valid vCenter reference for your cloud. We need to define an empty template in vCenter and import it into OpenNebula.

.. image:: /images/market_migrate_qcow2_vmdk_3.png
    :align: center

4. Now, clone the empty template to make use of the downloaded image.

.. image:: /images/market_migrate_qcow2_vmdk_4.png
    :align: center

5. Attach the image to the cloned template, so we can keep the original for other VMs.

.. image:: /images/market_migrate_qcow2_vmdk_5.png
    :align: center

Behind the Scenes
--------------------------------------------------------------------------------

When the image that we selected from the Marketplace is downloaded to the Front-end and the download process is finished, it is converted with the ``qemu-img convert`` tool as follows:

.. prompt:: bash $ auto

    qemu-img convert -f <original_type> -O <destination_type> <original_file> <destination_file>

The file is then sent to the destination datastore.

Limitations and Restrictions
--------------------------------------------------------------------------------

We have to take into account that when we convert an image from qcow2/raw to VMDK, you will most likely need to install **VMWare tools** manually so the OpenNebula contextualization process can work properly.
