.. _cli:

=======================
Command Line Interface
=======================

OpenNebula provides a set commands to interact with the system:

CLI
===

-  `oneacct </doc/4.6/cli/oneacct.1.html>`__: gets accounting data from OpenNebula
-  `oneacl </doc/4.6/cli/oneacl.1.html>`__: manages OpenNebula ACLs
-  `onecluster </doc/4.6/cli/onecluster.1.html>`__: manages OpenNebula clusters
-  `onedatastore </doc/4.6/cli/onedatastore.1.html>`__: manages OpenNebula datastores
-  `onedb </doc/4.6/cli/onedb.1.html>`__: OpenNebula database migration tool
-  `onegroup </doc/4.6/cli/onegroup.1.html>`__: manages OpenNebula groups
-  `onehost </doc/4.6/cli/onehost.1.html>`__: manages OpenNebula hosts
-  `oneimage </doc/4.6/cli/oneimage.1.html>`__: manages OpenNebula images
-  `onetemplate </doc/4.6/cli/onetemplate.1.html>`__: manages OpenNebula templates
-  `oneuser </doc/4.6/cli/oneuser.1.html>`__: manages OpenNebula users
-  `onevdc </doc/4.6/cli/onevdc.1.html>`__: manages OpenNebula Virtual DataCenters
-  `onevm </doc/4.6/cli/onevm.1.html>`__: manages OpenNebula virtual machines
-  `onevnet </doc/4.6/cli/onevnet.1.html>`__: manages OpenNebula networks
-  `onezone </doc/4.6/cli/onezone.1.html>`__: manages OpenNebula zones

The output of these commands can be customized by modifying the configuration files that can be found in ``/etc/one/cli/``. They also can be customized on a per-user basis, in this case the configuration files should be placed in ``$HOME/.one/cli``.

OCCI Commands
=============

-  `occi-compute </doc/4.6/cli/occi-compute.1.html>`__: manages compute objects
-  `occi-network </doc/4.6/cli/occi-network.1.html>`__: manages network objects
-  `occi-storage </doc/4.6/cli/occi-storage.1.html>`__: manages storage objects
-  `occi-instance-type </doc/4.6/cli/occi-instance-type.1.html>`__: Retrieve instance types

ECONE Commands
==============

-  `econe-upload </doc/4.6/cli/econe-upload.1.html>`__: Uploads an image to OpenNebula
-  `econe-describe-images </doc/4.6/cli/econe-describe-images.1.html>`__: Lists all registered images belonging to one particular user.
-  `econe-run-instances </doc/4.6/cli/econe-run-instances.1.html>`__: Runs an instance of a particular image (that needs to be referenced).
-  `econe-describe-instances </doc/4.6/cli/econe-describe-instances.1.html>`__: Outputs a list of launched images belonging to one particular user.
-  `econe-terminate-instances </doc/4.6/cli/econe-terminate-instances.1.html>`__: Shutdowns a set ofvirtual machines (or cancel, depending on its state).
-  `econe-reboot-instances </doc/4.6/cli/econe-reboot-instances.1.html>`__: Reboots a set ofvirtual machines.
-  `econe-start-instances </doc/4.6/cli/econe-start-instances.1.html>`__: Starts a set ofvirtual machines.
-  `econe-stop-instances </doc/4.6/cli/econe-stop-instances.1.html>`__: Stops a set ofvirtual machines.
-  `econe-create-volume </doc/4.6/cli/econe-create-volume.1.html>`__: Creates a new DATABLOCK in OpenNebula
-  `econe-delete-volume </doc/4.6/cli/econe-delete-volume.1.html>`__: Deletes an existing DATABLOCK.
-  `econe-describe-volumes </doc/4.6/cli/econe-describe-volumes.1.html>`__: Describe all available DATABLOCKs for this user
-  `econe-attach-volume </doc/4.6/cli/econe-attach-volume.1.html>`__: Attaches a DATABLOCK to an instance
-  `econe-detach-volume </doc/4.6/cli/econe-detach-volume.1.html>`__: Detaches a DATABLOCK from an instance
-  `econe-allocate-address </doc/4.6/cli/econe-allocate-address.1.html>`__: Allocates a new elastic IP address for the user
-  `econe-release-address </doc/4.6/cli/econe-release-address.1.html>`__: Releases a publicIP of the user
-  `econe-describe-addresses </doc/4.6/cli/econe-describe-addresses.1.html>`__: Lists elastic IP addresses
-  `econe-associate-address </doc/4.6/cli/econe-associate-address.1.html>`__: Associates a publicIP of the user with a given instance
-  `econe-disassociate-address </doc/4.6/cli/econe-disassociate-address.1.html>`__: Disasociate a publicIP of the user currently associated with an instance
-  `econe-create-keypair </doc/4.6/cli/econe-create-keypair.1.html>`__: Creates the named keypair
-  `econe-delete-keypair </doc/4.6/cli/econe-delete-keypair.1.html>`__: Deletes the named keypair, removes the associated keys
-  `econe-describe-keypairs </doc/4.6/cli/econe-describe-keypairs.1.html>`__: List and describe the key pairs available to the user
-  `econe-register </doc/4.6/cli/econe-register.1.html>`__: Registers an image

oneFlow Commands
================

-  `oneflow </doc/4.6/cli/oneflow.1.html>`__: oneFlow Service management
-  `oneflow-template </doc/4.6/cli/oneflow-template.1.html>`__: oneFlow Service Template management

