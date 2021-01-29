.. _verify_installation:

================================================================================
Verify your Installation
================================================================================

This chapter ends with this optional section, where you will be able to test your cloud by launching a virtual machine and test that everything is working correctly.

You should only follow the specific subsection for your hypervisor.

KVM/LXD based Cloud Verification
================================================================================

The goal of this subsection is to launch a small Virtual Machine, in this case a TTYLinux (which is a very small Virtual Machine just for testing purposes).

Requirements
--------------------------------------------------------------------------------

To complete this section, you must have network connectivity to the Internet from the Front-end, in order to import an appliance from http://marketplace.opennebula.systems .

Step 1. Check that the Hosts are on
--------------------------------------------------------------------------------

The Hosts that you have registered should be in ON status.

|sunstone_list_hosts|

Step 2. Import an appliance from the MarketPlace.
--------------------------------------------------------------------------------

We need to add an Image to our Cloud. We can do so by navigating to Storage -> Apps in the left side menu (1). You will see a list of Appliances, and you can filter by ``tty kvm`` (2) in order to find the one we are going to use in this guide. After that select it (3) and click to cloud button (4) in order to import it.

|sunstone_import_marketapp|

A dialog with the information of the appliance you have selected will pop up. You will need to select the datastore under the "Select the Datastore to store the resource" (1) and then click on the "Download" button (2)

|sunstone_download_app|

Navigate now to the Storage -> Images tab and refresh until the Status of the Image switches to ``READY``.

|sunstone_list_images|

Step 3. Instantiate a VM
--------------------------------------------------------------------------------

Navigate to Templates -> VMs, then select the ``ttylinux - kvm`` template that has been created and click on "Instantiate".

|sunstone_instantiate_template|

In this dialog simply click on the "Instantiate" button.

|sunstone_instantiate_template_dialog|

Step 4. Test VNC access
--------------------------------------------------------------------------------

Navigate to Instances -> VMs. You will see that after a while the VM switches to Status ``RUNNING`` (you might need to click on the refresh button). Once it does, you can click on the VNC icon (at the right side of the image below).

|sunstone_vm_running|

If the VM fails, click on the VM and then the ``Log`` tab to see why. Alternatively, you can look at the log file ``/var/log/one/<vmid>.log``.

Step 5. Adding Network connectivity to your VM
--------------------------------------------------------------------------------

As you might have noticed, this VM does not have networking yet, this is because it depends a lot in your network technology. You would need to follow these steps in order to add Networking to the template.

1. Read the :ref:`Networking <nm>` chapter to choose a network technology, unless you have chosen to use the dummy driver explained in the :ref:`node installation <kvm_node_networking>` section and you have configured the bridges properly.
2. Create a new Network in the Network -> Virtual Networks dialog, and fill in the details of your network: like the Bridge, or the Physical Device, the IP ranges, etc.
3. Select the ``ttylinux - kvm`` template and update it. In the Network section of the template, select the network that you created in the previous step.
4. Instantiate and connect to the VM.

.. _vcenter_based_cloud_verification:

vCenter based Cloud Verification
================================================================================

In order to verify the correct installation of your OpenNebula cloud, follow the next steps. The following assumes that Sunstone is up and running, as explained in the :ref:`front-end installation Section <verify_frontend_section>`. To access Sunstone, point your browser to ``http://<fontend_address>:9869``.


Step 1. Import a Datastore
--------------------------------------------------------------------------------

Your vCenter VM templates use virtual disks, and those virtual disks are stored in datastores. You must import into OpenNebula those vcenter datastores that contain the virtual disks.

Follow the steps to import datastores as described in the :ref:`vCenter Import Datastores Section <vcenter_import_datastores>`

Step 2. Import a VM Template
--------------------------------------------------------------------------------

You will need a VM Template defined in vCenter, and then import it using the steps described in the :ref:`vCenter Import Templates Section <vcenter_import_templates>`.

Step 3. Instantiate the VM Template
--------------------------------------------------------------------------------

You can easily instantiate the template to create a new VM from it using Sunstone. Proceed to the Templates tab of the left side menu, VMs Section, select the imported template and click on the Instantiate button.

.. image:: /images/instantiate_vcenter_template.png
    :width: 90%
    :align: center

Step 4. Check the VM is Running
--------------------------------------------------------------------------------

The scheduler should place the VM in the vCenter cluster imported as part of the :ref:`vCenter Node Installation <vcenter_node>` Section.

After a few minutes (depending on the size of the disks defined by the VM Template), the state of the VM should be ``RUNNING``. You can check the process in Sunstone in the Instances tab of the left side menu, VMs Section.

Once the VM is running, click on the VNC blue icon, and if you can see a console to the VM, congratulations! You have a fully functional OpenNebula cloud.

.. image:: /images/verify_vcenter_vm_running.png
    :width: 90%
    :align: center

The next step would be to further configure the OpenNebula cloud to suit your needs. You can learn more in the :ref:`VMware Infrastructure Setup <vmware_infrastructure_setup_overview>` guide.

Next steps
================================================================================

After this chapter, you are ready to :ref:`start using your cloud <operation_guide>` or you could configure more components:

* :ref:`Authenticating <authentication>`. (Optional) For integrating OpenNebula with LDAP/AD, or securing it further with other authentication technologies.
* :ref:`Sunstone <sunstone>`. The OpenNebula GUI should be working and accessible at this stage, but by reading this guide you will learn about specific enhanced configurations for Sunstone.

If your cloud is KVM/LXD based you should also follow:

* :ref:`Open Cloud Host Setup <vmmg>`.
* :ref:`Open Cloud Storage Setup <storage>`.
* :ref:`Open Cloud Networking Setup <nm>`.

Otherwise, if it's VMware based:

* Head over to the :ref:`VMware Infrastructure Setup <vmware_infrastructure_setup_overview>` chapter.

.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_download_app| image:: /images/sunstone_download_app.png
.. |sunstone_import_marketapp| image:: /images/sunstone_import_marketapp.png
.. |sunstone_instantiate_template_dialog| image:: /images/sunstone_instantiate_template_dialog.png
.. |sunstone_instantiate_template| image:: /images/sunstone_instantiate_template.png
.. |sunstone_list_images| image:: /images/sunstone_list_images.png
.. |sunstone_vm_running| image:: /images/sunstone_vm_running.png
