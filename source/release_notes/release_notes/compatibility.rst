.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 4.4 users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`guide <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 4.6.

.. todo::

OpenNebula Administrators and Users
===================================

oZones and Federation
--------------------------------------------------------------------------------

* oZones component has been deprecated
* New functionality, federation

Virtual Data Centers (vDC)
--------------------------------------------------------------------------------

* Old oZones vDC have been deprecated.

  * no onevdc command

* Extended control over Group - vDC creation: resources, administrator, views

Sunstone Cloud View
--------------------------------------------------------------------------------

* Template compatibility between old easy provisioning and new Cloud View
* VM save + original template. --clonetemplate option

Resource Providers
--------------------------------------------------------------------------------

* Add / del resource provider.

  * Internally, same functionality as before with ACL rules, but higher level.
  * Current 4.4 ACL rules are not parsed as resource providers. Existing groups preserve current ACLs, but the set of RP is empty

Sunstone
--------------------------------------------------------------------------------

* New system to assign views to users/groups
* Major redesign:

  * wizards
  * extended info (host -> vms)
  * 

Storage
-------

* Datastore BASE_PATH
* RBD_FORMAT
* QEMU_IMG_CONVERT_ARGS
* Feature #2731 Remove limitations on managing Datastores 0,1,2
* Feature #2568 Support for RBD Format 2 images
* Feature #2202 Bring glusterfs support via libvirt integration

Monitoring
----------

* collectd shepherd.

oned.conf
--------------------------------------------------------------------------------

* FEDERATION
* RPC_LOG
* MESSAGE_SIZE
* DEFAULT_CDROM_DEVICE_PREFIX

sched.conf
--------------------------------------------------------------------------------

* HYPERVISOR_MEM
* MESSAGE_SIZE

Sunstone configuration
--------------------------------------------------------------------------------

* Instance types
* autorefresh in yaml files

CLI configuration
--------------------------------------------------------------------------------

* group.default removed. ACL rules are defined with options

oneflow-server.conf
--------------------------------------------------------------------------------

* vm_name_template


Hosts
--------------------------------------------------------------------------------

* Feature #1798 optionally limit the resources exposed by a host


Econe
--------------------------------------------------------------------------------

* econe-register public_ip

oneauth
--------------------------------------------------------------------------------

* oneauth command


oneacct
--------------------------------------------------------------------------------

* oneacct --csv option
* oneacct --list option


Marketplace
--------------------------------------------------------------------------------


Contextualization
--------------------------------------------------------------------------------

* cloud init?
* Feature #2453 Add hostname configuration to contexualization


Group
--------------------------------------------------------------------------------

* Group template


Virtual Networks
--------------------------------------------------------------------------------

* Feature #2465 Permit to modify network informations
* Feature #2208 Allow to delete leases on hold
* Feature #2270 VNets can be only deleted if there are not used leases

KVM
--------------------------------------------------------------------------------

* Feature #2567 KVM Hyper-V Enlightenments
* Feature #2547 Support libvirt "localtime" parameter for Windows KVM guest template
* Feature #2485 Configuring SPICE should enable qxl paravirtual graphic card
* Feature #2247 Graphics section in vmm_exec_kvm.conf
* Feature #2143 Add machine type to KVM deployment file

Xen
--------------------------------------------------------------------------------

* Feature #1762 Implement Xen FEATURES

Developers and Integrators
==========================

Monitoring
----------

* Return vm poll in host im drivers


Ruby OCA
--------------------------------------------------------------------------------

* Feature #2732 Support for http proxy in ruby oca client


XML-RPC API
--------------------------------------------------------------------------------

* Feature #2371 Paginate the .info API responses
* New api calls:

  * ...

* Changed api calls:

  * ...
