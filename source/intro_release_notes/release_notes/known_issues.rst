.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Upgrade Process
================================================================================

There is an issue where the database upgrade process can drop some XML attributes in the listing column. This issue only impacts on the list operations, including the Sunstone VM list, and the XML data returned by the ``onevm list`` command and ``one.vmpool.info`` API call. This data is updated and fixed by oned as it refreshes the VM information.

If you want to obtain the right listing information after the upgrade, please replace the file ``/usr/lib/one/ruby/onedb/local/5.6.0_to_5.7.80.rb`` `with the one you can download here. <https://raw.githubusercontent.com/OpenNebula/one/one-5.8/src/onedb/local/5.6.0_to_5.7.80.rb>`__

LXD VNC - Login process
===============================================================================

For some operating system versions the login process does not work through the ``lxc exec`` command. This may fail the login into the container through VNC. You can change the VNC command to be executed to start your VNC session (e.g. to /bin/bash) `as explained here <http://docs.opennebula.org/5.8/deployment/open_cloud_host_setup/lxd_driver.html#configuration>`_.

Qcow2 Image Datastores and SSH transfer mode
================================================================================

Qcow2 image datastores are compatible with SSH system datastore (SSH transfer mode). However the configuration attributes are missing. To enable this mode for qcow2 you need to:

1. Stop OpenNebula
2. Update ``/etc/one/oned.conf`` file so the ``qcow2`` configuration reads as follows:

.. code-block:: bash

   TM_MAD_CONF = [
       NAME = "qcow2", LN_TARGET = "NONE", CLONE_TARGET = "SYSTEM", SHARED = "YES",
       DS_MIGRATE = "YES", TM_MAD_SYSTEM = "ssh", LN_TARGET_SSH = "SYSTEM",
       CLONE_TARGET_SSH = "SYSTEM", DISK_TYPE_SSH = "FILE", DRIVER = "qcow2"
   ]

3. Restart OpenNebula
4. Force the update of the qcow2 image datastores by executing ``onedatastore update <datastore_id>``. Simply save the file as is, OpenNebula will add the extra attributes for you.

