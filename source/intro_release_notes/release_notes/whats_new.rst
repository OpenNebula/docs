.. _whats_new:

================================================================================
What's New in 7.0
================================================================================

**OpenNebula 6.4 ‘Archeon’** is the third stable release of the OpenNebula 6 series. The most exciting addition to ‘Archeon’ is the ability to automatically deploy and manage HCI Clusters based on **Ceph**—the powerful open source software-defined storage solution. This new native **hyperconverged infrastructure** architecture can be **deployed on-premises** (just minimal OS and SSH access is required) and also on **AWS bare-metal resources**, which gives your hybrid OpenNebula Cloud great flexibility. And, of course, you can dynamically add more hosts to your cloud whenever you need to, as well as seamlessly repatriate your workloads from AWS at any time.

This release already comes with a fully-functional **new Sunstone interface** (:ref:`FireEdge Sunstone <fireedge_sunstone>`) for managing VM templates and instances, with a similar coverage in terms of features as the traditional Cloud View present in the earlier version of Sunstone, save for the OneFlow integration. If you are a cloud admin, please keep using the ruby-based Sunstone interface (port 9869) but encourage your end-users to migrate to the new Sunstone portal served in port 2616. Our development team has worked hard to streamline the functionality offered in the VM and VM Template tabs, and **more UX improvements** are on the way, so stay tuned! The old, ruby-based interface also received its share of love, adding all the functionality that OpenNebula incorporates in this new version 6.4.

.. image:: /images/fireedge_sunstone_teaser.png
    :align: center


This new release also includes the notion of **network states**. Your virtual networks will have states that will allow you to perform custom actions upon creation and destruction of instances, offering a **better integration with your datacenter** networking infrastructure. Events changing the state of your virtual networks can be tied to the execution of hooks to further tune the behavior of your cloud. There are two components that benefit from this change: **OneFlow** can now synchronize the creation of virtual networks and service VMs, while **vCenter** networking does not require any longer the activation of a hook.

There are also a number of additions to the supported hypervisor family, like the new SR-IOV support for the **NVIDIA GPU** cards and the addition of fine-grain resource control to the **LXC** driver. The integration with **vCenter** has also been improved, including the support for filtering and ordering those resources to be imported, the automatic VM Template creation for marketplace appliances, and the ability to set a default prefix for VM names, among others. Performance-wise, the vCenter driver is now more robust in large scale deployments, optimizing memory usage.

OpenNebula 6.4 is named after the `Archeon Nebula <https://www.starwars.com/databank/archeon-nebula>`__, located in the Lothal sector of the Outer Rim Territories—a beautiful body of interstellar clouds where stars are born and which provides a popular hyperscape route for smugglers traversing the continuum towards the edge of the Star Wars universe :)

OpenNebula 6.4 ‘Archeon’ is considered to be a stable release and as such it is available to update production environments.

We’d like to thank all the people that support the project, OpenNebula is what it is thanks to its community. Apart from the usual :ref:`acknowledgements <acknowledgements>`, we’d like to highlight the support we’ve received through the EU-funded H2020 project **ONEedge**.

..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

OpenNebula Core
================================================================================

Networking
================================================================================

vCenter Driver
================================================================================

Ruby Sunstone
================================================================================

FireEdge Sunstone
================================================================================

OneFlow - Service Management
================================================================================

- Global parameters for all the VMs in a service, chech :ref:`this <service_global>` fore more information.
- OneFlow resilient to oned timeouts, a retry method has been implemented in case authentication error, check more `here <https://github.com/OpenNebula/one/issues/5814>`__.

CLI
================================================================================

Distributed Edge Provisioning
================================================================================

KVM
================================================================================

LXC
================================================================================

Other Issues Solved
================================================================================

- `Fix oned.conf debug levels only covers 0-3, but oned has 0-5 levels <https://github.com/OpenNebula/one/issues/5820>`__.

Features Backported to 6.4.x
================================================================================

Contextualization
================================================================================
