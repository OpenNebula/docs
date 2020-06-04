.. _vcenter_52_to_54:

================================================================================
vCenter upgrade 5.2 to 5.4
================================================================================

.. _vcenter_52_to_54_pre:

Pre-migration phase
--------------------------------------------------------------------------------

OpenNebula provides a script that must be run **before** it is upgraded using the **oneadmin** user account. This script can be downloaded from `https://downloads.opennebula.org/packages/opennebula-5.4.1/vcenter_one54_pre.rb <https://downloads.opennebula.org/packages/opennebula-5.4.1/vcenter_one54_pre.rb>`__.

.. warning:: As in 5.2 OpenNebula disks cannot have spaces in the VMDK paths. However, OpenNebula 5.4 now exposes all disks of existing templates and VMs. These disks were transparent for 5.2 and cannot have spaces so you need to remove them prior to upgrade. This limitation will be addressed in the short-term in the next maintenance release.

.. warning:: If you are using the vCenter drivers, there is a manual intervention required in order to upgrade to OpenNebula 5.4. Note that **upgrading from OpenNebula < 5.2 to OpenNebula 5.4 is NOT supported**. You need to upgrade first to OpenNebula 5.2, and then upgrade to OpenNebula 5.4.

.. warning:: The pre-migration phase may fail if there are resources in error, please clean resources in failed state prior to continue with this process.

The script will perform the following tasks:

* Establish a connection to every vCenter instance known by OpenNebula
* Retrieve information about clusters, virtual machines, templates, datastores and port groups.
* New information will be added to the OpenNebula resources.
* Some manual intervention may be required.
* For each IMAGE datastore found, a SYSTEM datastore will be created.
* Templates and wild VMs will be inspected in order to discover virtual hard disks and network interface cards that are invisible.
* All Datastores that hosts those virtual hard disks will be imported into OpenNebula.
* OpenNebula images and virtual networks will be created so the invisible disks and nics bebcome visible after upgrade.
* The virtual networks that represent port groups found inside existing templates will have an Ethernet address range with 255 MACs in the pool. You may want to change or increase this address range after the pre-migrator tool finishes.
* OpenNebula hosts, networks and datastores will grouped into OpenNebula clusters. Each vCenter cluster will be assigned to an OpenNebula cluster.
* XML files will be generated under ``/var/tmp`` directory. They will be used in the migration phase.

.. important:: Read carefully the instructions of the Phase 0. It involves modifying ``/etc/one/oned.conf`` and ``/var/lib/one/remotes/datastore/vcenter/rm`` and restarting OpenNebula. **DON'T FORGET TO DO SO**.

.. code::

    ================================================================================
     / _ \ _ __   ___ _ __ | \ | | ___| |__  _   _| | __ _
    | | | | '_ \ / _ \ '_ \|  \| |/ _ \ '_ \| | | | |/ _` |
    | |_| | |_) |  __/ | | | |\  |  __/ |_) | |_| | | (_| |
     \___/| .__/ \___|_| |_|_| \_|\___|_.__/ \__,_|_|\__,_|
          |_|
    --------------------------------------------------------------------------------
      vCenter pre-migrator tool for OpenNebula 5.4 - Version: 1.0
    ================================================================================

    ================================================================================
     PHASE 0 - Before running the script please read the following notes
    ================================================================================

    - Please check that you have set PERSISTENT_ONLY="NO" and REQUIRED_ATTRS=""
      in you DS_MAD_CONF vcenter inside the /etc/one/oned.conf and that you have
      restarted your OpenNebula services to apply the new configuration before
      launching the script.

    - Edit the file /var/lib/one/remotes/datastore/vcenter/rm and replace the
      following lines:

      vi_client.delete_virtual_disk(img_src,
                                    ds_name)

      with the following lines:

      if drv_action["/DS_DRIVER_ACTION_DATA/IMAGE/TEMPLATE/VCENTER_IMPORTED"] != "YES"
           vi_client.delete_virtual_disk(img_src,ds_name)
      end

      in order to avoid that you accidentally remove a virtual hard disk from a template
      or wild VM when you delete an image.

    - Note that this script may take some time to perform complex tasks so please be patient.

    - Although this scripts will do its best to be fully automated there may be situations
      where a manual intervention is needed, in that case a WARNING will be shown.

    - The virtual networks that represent port groups found inside existing templates
      will have an Ethernet address range with 255 MACs in the pool. You may want to
      change or increase this address range after the pre-migrator tool finishes.

    - It's advisable to disable the Sunstone user interface before launching this script
      in order to avoid that OpenNebula objects created by users while
      the script is running are not pre-migrated by the tool.

    - This script can be executed as many times as you wish. It will update previous
      results and XML template will be always overwritten.

    Don't forget to restart OpenNebula if you have made changes!

    Do you want to continue? ([y]/n):

In short, you need to replace the following in ``/etc/one/oned.conf``:

.. code-block:: diff

    DS_MAD_CONF = [
    -    NAME = "vcenter", REQUIRED_ATTRS = "VCENTER_CLUSTER", PERSISTENT_ONLY = "YES",
    +    NAME = "vcenter", REQUIRED_ATTRS = "", PERSISTENT_ONLY = "NO",
        MARKETPLACE_ACTIONS = "export"
    ]


And the following change in ``/var/lib/one/remotes/datastore/vcenter/rm``:

.. code-block:: diff

    -vi_client.delete_virtual_disk(img_src,
    -                              ds_name)
    +if drv_action["/DS_DRIVER_ACTION_DATA/IMAGE/TEMPLATE/VCENTER_IMPORTED"] != "YES"
    +    vi_client.delete_virtual_disk(img_src,ds_name)
    +end

.. note:: It's advisable to disable the Sunstone user interface while the pre-migrator script is run in order to avoid that OpenNebula objects created by users while the script is run are not pre-migrated.


In order to execute the script you need to download from `https://downloads.opennebula.org/packages/opennebula-5.4.1/vcenter_one54_pre.rb <https://downloads.opennebula.org/packages/opennebula-5.4.1/vcenter_one54_pre.rb>`__ and run it manually **as oneadmin**.

.. code::

    $ curl -skLO https://downloads.opennebula.org/packages/opennebula-5.4.1/vcenter_one54_pre.rb
    $ ruby vcenter_one54_pre.rb

.. note::
    If you want to execute this script more than once, please delete ``/var/tmp/vcenter_one54`` directory.


OpenNebula Upgrade
--------------------------------------------------------------------------------

.. important:: Now you need to continue upgrading the software following the steps described in the upgrade guide.

Follow the :ref:`Upgrade OpenNebula software <upgrade_52_stop_opennebula>`.

.. _vcenter_52_to_54_migr:

Migration phase
--------------------------------------------------------------------------------

Once OpenNebula packages have been upgraded, you need to execute the pre migration tool for vCenter.

.. warning:: The migration tool must be run **before** a onedb upgrade command is executed.

The migration tool is launched using the ``onedb vcenter-one54`` command, and it must be run from the same machine where the pre-migrator tool was executed as it requires some XML templates files stored in the ``/var/tmp`` directory.

.. code::

    $ onedb vcenter-one54 -v -u <dbuser> -p <dbpass> -d <dbname> -S <dbhost>

The migration tool will update some OpenNebula's database tables using the XML files that were created in the pre-migration phase. This is the list of affected tables:

* ``template_pool``
* ``vm_pool``
* ``host_pool``
* ``datastore_pool``
* ``network_pool``
* ``image_pool``

In the following sections you will need to execute ``onedb fsck``. Note that you might get the following error:  ``[UNREPAIRED] VM XX has a lease from VNet XX, but it could not be matched to any AR``. This is expected for previously invisible NIC interfaces in VMs added in the pre-migration phase.

Continue the upgrade by moving on to the :ref:`next section <upgrade_52_onedb_upgrade>`.
