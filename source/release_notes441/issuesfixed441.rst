.. _issuesfixed441:

================================
Issues Fixed In OpenNebula 4.4.1
================================

OpenNebula 4.4.1 is a maintenance release that fixes bugs reported by the community after 4.4 was released. To see what's new in OpenNebula 4.4 Retina, refer to its :ref:`release notes <rn44>`.

This release only includes bug fixes and it is a recommended update for everyone running any 3.x or 4.x version of OpenNebula. Several bugs related to different OpenNebula components were fixed, ranging from datastore drivers to logging messages, see below for a complete list.

-  `#2699 <http://dev.opennebula.org/issues/2699>`__: FILES in CONTEXT now accepts multiple lines
-  `#2689 <http://dev.opennebula.org/issues/2689>`__: Fix for wrong monitoring value being picked on hook on host error
-  `#2657 <http://dev.opennebula.org/issues/2657>`__: Fix VMM driver to send one action per host
-  `#2483 <http://dev.opennebula.org/issues/2483>`__: User proper vnc parameters for HVM XEN
-  `#2535 <http://dev.opennebula.org/issues/2535>`__: Set cdrom disk type in xen driver
-  `#2602 <http://dev.opennebula.org/issues/2602>`__: Fix DS name space on ESX
-  `#2601 <http://dev.opennebula.org/issues/2601>`__: Use ssh_public_key when updating a template
-  `#2544 <http://dev.opennebula.org/issues/2544>`__: Do not output error messages when inserting multiple monitoring values for the same time
-  `#2542 <http://dev.opennebula.org/issues/2542>`__: CDROM on ceph datastore now uses CEPH_HOST, CEPH_SECRET, CEPH_USER
-  `#2572 <http://dev.opennebula.org/issues/2572>`__: Configuration option for XML-RPC message size limit
-  `#2548 <http://dev.opennebula.org/issues/2548>`__: Set correct flag for pool retrieval
-  `#2541 <http://dev.opennebula.org/issues/2541>`__: Defaults 0 to monitor probes when error occur to prevent syntax errors
-  `#2535 <http://dev.opennebula.org/issues/2535>`__: Put quotes around role name in the instantiate extra template

