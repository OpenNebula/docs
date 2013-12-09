======================
Command Line Interface
======================

OpenNebula provides a set commands to interact with the system:

CLI
===

-  ``oneacct``: gets accounting data from OpenNebula
-  ``oneacl``: manages OpenNebula ACLs
-  ``onecluster``: manages OpenNebula clusters
-  ``onedatastore``: manages OpenNebula datastores
-  ``onedb``: OpenNebula database migration tool
-  ``onegroup``: manages OpenNebula groups
-  ``onehost``: manages OpenNebula hosts
-  ``oneimage``: manages OpenNebula images
-  ``onetemplate``: manages OpenNebula templates
-  ``oneuser``: manages OpenNebula users
-  ``onevdc``: manages OpenNebula Virtual DataCenters
-  ``onevm``: manages OpenNebula virtual machines
-  ``onevnet``: manages OpenNebula networks
-  ``onezone``: manages OpenNebula zones

The output of these commands can be customized by modifying the
configuration files that can be found in ``/etc/one/cli/``. They also
can be customized on a per-user basis, in this case the configuration
files should be placed in ``$HOME/.one/cli``.

OCCI Commands
=============

-  ``occi-compute``: manages compute objects
-  ``occi-network``: manages network objects
-  ``occi-storage``: manages storage objects
-  ``occi-instance-type``: Retrieve instance types

ECONE Commands
==============

-  ``econe-upload``: Uploads an image to OpenNebula
-  ``econe-describe-images``: Lists all registered images belonging to
one particular user.
-  ``econe-run-instances``: Runs an instance of a particular image (that
needs to be referenced).
-  ``econe-describe-instances``: Outputs a list of launched images
belonging to one particular user.
-  ``econe-terminate-instances``: Shutdowns a set ofvirtual machines (or
cancel, depending on its state).
-  ``econe-reboot-instances``: Reboots a set ofvirtual machines.
-  ``econe-start-instances``: Starts a set ofvirtual machines.
-  ``econe-stop-instances``: Stops a set ofvirtual machines.
-  ``econe-create-volume``: Creates a new DATABLOCK in OpenNebula
-  ``econe-delete-volume``: Deletes an existing DATABLOCK.
-  ``econe-describe-volumes``: Describe all available DATABLOCKs for
this user
-  ``econe-attach-volume``: Attaches a DATABLOCK to an instance
-  ``econe-detach-volume``: Detaches a DATABLOCK from an instance
-  ``econe-allocate-address``: Allocates a new elastic IP address for
the user
-  ``econe-release-address``: Releases a publicIP of the user
-  ``econe-describe-addresses``: Lists elastic IP addresses
-  ``econe-associate-address``: Associates a publicIP of the user with a
given instance
-  ``econe-disassociate-address``: Disasociate a publicIP of the user
currently associated with an instance
-  ``econe-create-keypair``: Creates the named keypair
-  ``econe-delete-keypair``: Deletes the named keypair, removes the
associated keys
-  ``econe-describe-keypairs``: List and describe the key pairs
available to the user
-  ``econe-register``: Registers an image

oneFlow Commands
================

-  ``oneflow``: oneFlow Service management
-  ``oneflow-template``: oneFlow Service Template management

