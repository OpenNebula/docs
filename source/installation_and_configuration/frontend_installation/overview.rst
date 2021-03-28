.. _opennebula_installation_overview:

================================================================================
Overview
================================================================================

The Front-end is the central part of an OpenNebula installation and is the very first thing that needs to be deployed (or upgraded). Typically it's a host where the OpenNebula server-side components are installed and which is responsible for the management of an entire virtualization stack. It can be a physical host or a virtual machine (this decision is left up to the cloud administrator) as long as it matches the :ref:`requirements <uspng>`.

How Should I Read This Chapter
================================================================================

Before reading this chapter make sure you are familiar with the :ref:`Architecture Blueprint <architecture_blueprints>`, and the blueprint most appropriate to your needs.

The aim of this chapter is to give you a quick-start guide to deploying OpenNebula. This is the simplest possible installation, but it is also the foundation for a more complex setup. First, you should go through the :ref:`Database Setup <database_setup>` section, especially if you expect to use OpenNebula for production. Then move on to the configuration of :ref:`OpenNebula Repositories <repositories>`, from which you'll install the required components. And finally, proceed with the :ref:`Front-end Installation <frontend_installation>` section. You'll end up running a fully featured OpenNebula Front-end.

After reading this chapter, you can go on to add the :ref:`KVM <kvm_node>`, :ref:`LXC <lxc_node>`,  :ref:`Firecracker <fc_node>` hypervisor nodes, or :ref:`vCenter <vcenter_node>`.

To scale from a single-host Front-end deployment to several hosts for better performance or reliability (HA), continue to the following chapters on :ref:`Large-scale Deployment <large_scale_deployment>`, :ref:`High Availability <ha>` and :ref:`Data Center Federation <federation_section>`.

Hypervisor Compatibility
================================================================================

This chapter applies to all supported hypervisors.
