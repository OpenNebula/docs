.. _verify_installation:

================================================================================
Verify your Installation
================================================================================

.. todo:: Add contents



vCenter based Cloud Verification
================================================================================

In order to verify the correct installation of your OpenNebua cloud, follow the next steps. The following assumes that Sunstone is up and running, as explained in the :ref:`front-end installation Section <verify_frontend_section>`. To access Sunstone, point your browser to ``http://<fontend_address>:9869``.

Step 1. Import a VM Template
--------------------------------------------------------------------------------

You will need a VM Template defined in vCenter, and then import it using the steps described in the :ref:`vCenter Node Section <import_vcenter_resources>`.

Step 2. Instantiate the VM Template
--------------------------------------------------------------------------------

You can easily instantiate the template to create a new VM from it using Sunstone. Proceed to the Templates tab of the left side menu, VMs Section, select the imported template and click on the Instantiate button.

.. image:: /images/instantiate_vcenter_template.png
    :width: 90%
    :align: center

Step 3. Check the VM is Running
--------------------------------------------------------------------------------

The scheduler should place the VM in the vCenter cluster imported as part of the :ref:`vCenter Node Installation <vcenter_node>` Section.

After a few minutes (depending on the size of the disks defined by the VM Template), the sate of the VM should be "RUNNING". You can check the process in Sunstone in the Instances tab of the left side menu, VMs Section. 

Once the VM is running, click on the VNC blue icon, and if you can see a console to the VM, congratulations! You have a fully functional OpenNebula cloud.

.. image:: /images/verify_vcenter_vm_running.png
    :width: 90%
    :align: center

The next step would be to further configure the OpenNebula cloud to suits your needs. You can learn more in the :ref:`VMware Infrastructure Setup <vmware_infrastructure_setup_overview>` guide.
