.. _whats_new:

================================================================================
What's New in 5.2 Beta
================================================================================

OpenNebula 5.2 (Excession) is the second release of the OpenNebula 5 series. A significant effort has been applied in this release to stabilize features introduced in 5.0 Wizard, while keeping an eye in implementing those features more demanded by the community.

As usual almost every component of OpenNebula has been reviewed to target usability and functional improvements, trying to keep API changes to a minimum to avoid disrupting ecosystem components. Also, new components have been added to enhance the OpenNebula experience. 

.. image:: /images/hyperlinks_sunstone.png
    :width: 90%
    :align: center

One important new module is the IPAM subsystem. In order to foster SDN integration, a important step is being able to integrate OpenNebula with existing IPAM modules, in those cases where outsourcing of IP management is required in the datacenter. Fitting in the OpenNebula architecture design principles, the IPAM subsystem interacts with IPAM servers using drivers, and as such a IPAM driver lets you delegate IP lease management to an external component. This way you can coordinate IP use with other virtual or bare metal servers in your datacenter. No default integration is provided, but rather to effectively use an external IPAM you need to develop four action scripts that hook on different points of the IP network/lease life-cycle.

Another great addition in Excession is the ability to use group bound tokens. The goal is to be able to use OpenNebula for different projects, which are identified with different groups. For instance, the same user can use OpenNebula for "WebDevelopment" project and a "BioResearch" one, for instance. This user can request a couple of tokens tied to each of these groups. Upon login with the "WebDevelopment" token, she will only be seeing resources from that particular project, and all new resources (VMs, images, networks) will be created within that group, isolating them from the "BioResearch" group. This feature is available both in the CLI and Sunstone, with helpers and dialogs to create, maintain and use the tokens.

.. image:: /images/tokens_sunstone.png
    :width: 90%
    :align: center

All the OpenNebula drivers have been improved for robustness. For instance, a new default timeout (which is configurable) has been defined to identify hanging operations and kill crashed processes. In this regard, the EC2 drivers has also been thoroughly revisited, being updated to the v2 of the aws ruby gem, ensuring compatibility with all Amazon EC2 regions. Error handling has been improved as well in the EC2 driver, adding operation retries to circumvent those situations where the EC2 API is not consistent, and adding improved logging.

Sunstone is the face of OpenNebula for both administrators and users, and hence a constant target of enhancements to improve usability. Excession brings to the cloud table stabilized features that were introduced in the Wizard maintenance releases, like for instances advanced searches (that now are maintained regardless of tab switching), labels colors and ergonomics, improved vCenter dialogs and import tables (now with feature à la Gmail), hyperlinks to access resources displayed in the info tabs, and many other minor improvements.

.. image:: /images/labels_searches_sunstone.png
    :width: 90%
    :align: center


There are many other improvements in 5.2 like revamped group mapping in LDAP authentication -now being dynamic mapping-, rollback mechanism in failed migrate operations, significantly improved fault tolerant hook -to provide high availability at the VM level-, improved driver timeout, vCenter storage functionality wrinkles ironed out, more robust Ceph drivers -for instance, in volatile disks-, improved SPICE support, improvements in ebtables and Open vSwitch drivers, multiple CLI improvements -imrpved onedb patch, password handling in onevcenter command, default columns reviewed in all commands- and much more. As with previous releases, it is paramount to the prject to help build and maintain robust private, hybrid and public clouds with OpenNebula, fixing reported bugs and improving general usability.

This OpenNebula release is named after the `Ian M. Banks novel <https://en.wikipedia.org/wiki/Excession>`__, a recommended read, as well as having a fitting slang meaning, "something so technologically superior that it appears as magic to the viewer.". We are confident that OpenNebula, if not really appearing as magic, at least solves elegantly your IaaS needs.

The OpenNebula team is now set to bug-fixing mode. Note that this is a beta release aimed at testers and developers to try the new features, hence not suitable for production environments. Feedback is more than welcome for the final release.

In the following list you can check the highlights of OpenNebula 5.2 (`a detailed list of changes can be found here <http://dev.opennebula.org/projects/opennebula/issues?c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&f%5B%5D=fixed_version_id&f%5B%5D=tracker_id&f%5B%5D=&group_by=category&op%5Bfixed_version_id%5D=%3D&op%5Btracker_id%5D=%21&per_page=200&set_filter=1&utf8=%E2%9C%93&v%5Bfixed_version_id%5D%5B%5D=83&v%5Btracker_id%5D%5B%5D=7>`__):

OpenNebula Core
--------------------------------------------------------------------------------

- **Improved FT hook**, to enhancing logging and fencing mechanisms integration in the :ref:`host on error hook <ftguide>`.
- **Project and group management**, adding authorization :ref:`tokens <user_tokens>` to include session information, to allow different group/project sessions with the same user, paired with a new parameter in the one.user.allocate API call
- **better template management in marketplaces**, with :ref:`rethinked restricted attributes <oned_conf_restricted_attributes_configuration>`.
- **Rollback capabilities**, in the :ref:`migrate operation <vm_states>`.
- **Update group information**, if driver (such as :ref:`LDAP <ldap>`) provides it.
- **Improved range definitions** for the :ref: vlan`<vlan>` driver
- **Allow migration** between :ref:`clusters <cluster_guide>` provided they share datastores between them.
- **Outsource IP management** with the new :ref:IPAM subsystem `<ipam>`.
- **Allow to override** of :ref:`EMULATOR attribute <emulator_override>` placing it in the VM template.


OpenNebula Drivers :: Storage
--------------------------------------------------------------------------------

- **Files are copied directly from source to target hypervisor** when migrating over :ref:`SSH <fs_ds>`.

OpenNebula Drivers :: Virtualization
--------------------------------------------------------------------------------

- **Add timeouts (TODO doc ref)** for driver actions
- **Stop execution** of :ref:`drivers <intro_integration>` if a pipe fails
- **Improved driver** for :ref:`EC2 integration <ec2g>`, now using aws-sdk v2 ruby gem and with double checks and retries in EC2 API methods and responses, as well as better error logging

OpenNebula Drivers :: Marketplace
--------------------------------------------------------------------------------

- **Enable access behind HTTP proxy** for :ref:`marketplaces <marketplace>`.

Scheduler
--------------------------------------------------------------------------------

- **Improved datastore capacity tests**, for datastore space in :ref:`scheduler <schg>`.

Sunstone
--------------------------------------------------------------------------------

- **Better display**, for :ref:`labels <vm_templates_labels>` as well as automatic color assignment.
- **Name display** when instantiating a :ref:`Virtual Router <vrouter>` template.
- **required inputs and better datatables** in :ref:`vCenter import dialogs <vcenter_view>`.
- **Compatibility with browser history**, now is possible to use the back button
- **Better user workflow**, wizards now return to the individual view
- **Improved VM capacity graphs**, now displaying the allocated value for better understanding of resource consumption.
- **Hyperlinks for related resource**, like for instance clicking on an image ID inside a VM disk attribute goes directly to the image in the image tab. Nice!

Command Line Interface
--------------------------------------------------------------------------------

- **Improved onedb command**, :ref:`onedb patch <onedb>` now accepts arguments
- **Better password prompt** when doing `oneuser login </doc/5.2/cli/oneuser.1.html>`__
- **vCenter import command improved**, :ref:`onevcenter <cli>` now asks for password in prompt if not provided in arguments
- **Improved default columns** in :ref:`commands <cli>` output.

Components Moved to the Add-ons Catalog
--------------------------------------------------------------------------------

Some of the infrastructure drivers that were available in OpenNebula 4.x were moved in 5.0 Wizard to the add-ons catalog. This decision has been made based on user demands and with the aim of delivering an OpenNebula distribution supporting the most widely used cloud environments.

- `Xen hypervisor <https://github.com/OpenNebula/addon-xen>`__
- `LVM storage backend <https://github.com/OpenNebula/addon-lvm>`__
- `SoftLayer public cloud <https://github.com/OpenNebula/addon-softlayer>`__

OpenNebula users interested in using these components can install them from the add-ons catalog after installing OpenNebula 5.x.
