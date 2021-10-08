.. _whats_new:

================================================================================
What's New in 6.2
================================================================================

OpenNebula 6.2 'Red Square' is the second stable release of the OpenNebula 6 series. This release aims to extend the functionality introduced in OpenNebula 6.0 as well as presenting a Beta version of the new Sunstone interface, built using React/Redux and delivered by the FireEdge server. The current Sunstone interface is still the recommended and default web interface, and has received its share of attention, with support for the new scheduled actions API and several bug fixes. Another important aspect to highlight in 6.2 is the improvement of its edge capabilities to efficiently deploy workloads closer to where data is produced and consumed. Workload portability is here the key word, and where OpenNebula excels in this space.

The new Sunstone interface is being built using two main design principles. First, one focus on usability and user experience, we want to deliver an interface that is intuitive for both administrators and users of the cloud, without giving up on the richness that OpenNebula can offer feature-wise. So that's one tradeoff we are carefully balancing. The second design principle focuses on performance, taking into account large scale infrastructures, but avoiding trimming functionality like powerful search capabilities. This is the second dimension we are handling with care. With 6.2 'Red Square' the new Sunstone debuts, we are aiming for the next LTS release (6.4) to provide a fully functional interface. 6.4 will be the last OpenNebula release featuring Sunstone as we all know it today. That will be some heartfelt farewell. We'd love to get your feedback on this. Please check the :ref:`FireEdge configuration guide <fireedge_setup>` for minimal instructions on how to access the web interface, and `let us know <mailto:"contact@opennebula.io?subject=My Feedback on Sunstone Beta">`__ your thoughts!

Starting from this release we've added an important capability to the OneProvision set of tools. The OneProvision component -and its web interface delivererd by FireEdge, the OneProvision GUI- is now capable to add new provider drivers on demand. That is, there is no need to synchronize OpenNebula releases with the availability of a new set of drivers to allow the extension of the OpenNebula managed cloud using resources for new public cloud providers. This is very significant because we think it is fundamental to foster a dynamic provider ecosystem that will enable end users to better decide and chose where to deploy their workloads and optimize metrics such as cost and performance. We are excited about the future that lies ahead of the infrastructure as a service field!


.. image:: /images/new_sunstone_teaser.png
    :align: center

This new version comes with new goodies across the whole stack:

  * New scheduled actions API that reduces race conditions. This includes support and display in current Sunstone.
  * Support for cleanup parameter in OneProvision GUI. No more chasing forgotten VMs around!
  * Several improvements in the LXC drivers.

..
  Conform to the following format for new features.
  Big/important features follow this structure
  - **<feature title>**: <one-to-two line description>, :ref:`<link to docs>`
  Minor features are added in a separate block in each section as:
  - `<one-to-two line description <http://github.com/OpenNebula/one/issues/#>`__.

..

As usual, the OpenNebula 6.2 codename refers to a nebula, in this case to the Red Square Nebula, which is a celestial object located in the area of the sky occupied by star MWC 922 in the constellation Serpens. It is notable for its square shape, which according to Sydney University astrophysicist Peter Tuthill, makes it one of the most nearly discrete-symmetrical celestial objects ever imaged. The splendor of the symmetry is what we are looking forward to in the new Sunstone, reborn from the candle lit by FireEdge.

The OpenNebula team is now transitioning to “bug-fixing mode”. Note that this is a first beta release aimed at testers and developers to try the new features, and we welcome you to send feedback for the final release. Please check the :ref:`known issues <known_issues>` before submitting `an issue through GitHub <https://github.com/OpenNebula/one/issues/new?template=bug_report.md>`__. Also note that being a beta, there is no migration path from the previous stable version (6.0.x) nor migration path to the final stable version (6.2.0). A list of `open issues can be found in the GitHub development portal <https://github.com/OpenNebula/one/milestone/45>`__.

We'd like to thank the people that supports the project, OpenNebula is what it is thanks to its community. Besides the usual :ref:`acknowledgements <acknowledgements>`, we'd like to highlight the support through the ONEedge EU funding project to improve OpenNebula edge capabilities.

In the following list you can check the highlights of OpenNebula 6.2 (a detailed list of changes can be found `here <https://github.com/OpenNebula/one/milestone/45?closed=1>`__):

OpenNebula Core
================================================================================
- Option to :ref:`disable Zone <frontend_ha_zone>`, this new feature is useful for maintenance operations.
- New :ref:`XMLRPC API for scheduled actions <onevm_api>`: ``one.vm.schedadd``, ``one.vm.schedupdate``, ``one.vm.scheddelete``. The new API reduces race condition issues while handling scheduled actions.

Sunstone
================================================================================
- Support for new scheduled actions api on :ref:`Sunstone <sunstone>`.
- Error message for failed :ref:`scheduled actions <vm_guide2_scheduling_actions>` in VM info view.

FireEdge
================================================================================
- Support to delete command with cleanup parameter in OneProvision GUI. Check :ref:`this <cluster_operations>` for more information.

CLI
================================================================================
- :ref:`Append option <api_onevmmupdateconf>` for ``onevm updateconf``. If no option is provided the 6.0 behavior is preserved.

Distributed Edge Provisioning
================================================================================
- Packet provider has been renamed to :ref:`Equinix<equinix_cluster>`.
- Ability to dynamically load providers into OneProvision. Check :ref:`this <devel-provider>` to see how to add a new provider.

KVM
===
- Option to specify :ref:`default attribute values <kvmg_default_attributes>` for VM ``GRAPHICS`` section.

LXC
===
- Add support for Images with custom *user:group* offset on the filesystem. OpenNebula will `preserve the shift present in the image filesystem when creating the container <https://github.com/OpenNebula/one/issues/5501>`_.
- `Allow admins to set custom bindfs mount options to further tune the how the container filesystems are exposed, :ref:`see the LXC driver documentation for more details <lxcmg>`.
- Add support for privileged containers by simple label them with the attribute **LXC_UNPRIVILEGED=FALSE** in the VM Template. :ref:`See the LXC documentation for more information on how to tune this setting <lxcmg>`.

Other Issues Solved
================================================================================
- `Hide VNC button in cloud view <https://github.com/OpenNebula/one/issues/5547>`__.
- `Fix for resources with several labels <https://github.com/OpenNebula/one/issues/5557>`__.
- `Fix slow transition from host DISABLED->MONITORED <https://github.com/OpenNebula/one/issues/5558>`__.
- `Fix error management in onedb live operations <https://github.com/OpenNebula/one/issues/5569>`__.

Features Backported to 6.0.x
============================

Additionally, a lot of new functionality is present that was not in OpenNebula 6.0.0, although they debuted in subsequent maintenance releases of the 6.0.x series:

- `Add remotes connections to VMs with external IP <https://github.com/OpenNebula/one/issues/5335>`__.
- `Add button to take screenshots from Guacamole Sunstone <https://github.com/OpenNebula/one/issues/5342>`__.
- `Improvement in Guacamole console access in Sunstone <https://github.com/OpenNebula/one/issues/5371>`__.
- `Add states to role vm actions buttons in Sunstone <https://github.com/OpenNebula/one/issues/5341>`__.
- :ref:`Add support to provision On-Premises Edge Clusters <onprem_cluster>`.
- :ref:`Add support for DigitalOcean Edge Clusters <do_cluster>`.
- :ref:`Add support for Google Compute Engine Edge Clusters <google_cluster>`.
- `Add support for LXC profiles <https://github.com/OpenNebula/one/issues/5333>`__.
- `Add support for list options in (un)lock CLI commands <https://github.com/OpenNebula/one/issues/5364>`__.
- `Add support for OpenvSwitch in Firecracker <https://github.com/OpenNebula/one/issues/5362>`__.
- :ref:`Add support for Vultr Virtual Edge Clusters <vultr_virtual_cluster>`.
- `Add support for adding/removing roles from running service <https://github.com/OpenNebula/one/issues/4654>`__.
- `Add option "delete this file" to VirtViewer file <https://github.com/OpenNebula/one/issues/5393>`__.
- :ref:`SAN Datastore (LVM) supports SSH transfer mode for disk image files <lvm_drivers>`.
- :ref:`LXC containers can run from LVM disk images <lxcmg>`.
- :ref:`Add support for docker entrypoints <market_dh>`.
- :ref:`Add support for MarketPlaces based on private Docker Registries <market_docker_registry>`.
- :ref:`Add switcher screen resolution for RDP in Sunstone <requirements_guacamole_rdp_sunstone>`.
- :ref:`Add support to enable/disable MarketPlaces <marketplace_disable>`.
- `Add a supported version validation to the LXD server running in the host <https://github.com/OpenNebula/one/issues/4661>`__.
- :ref:`IPv6 no-SLAAC <vn_template_ar6_nslaac>` computes ``SIZE`` from ``PREFIX_LENGTH``. Max size increased from 2^32 to 2^64.
- `Allow disabling fallocate for fs DS_MAD <https://github.com/OpenNebula/one/issues/5441>`__.
