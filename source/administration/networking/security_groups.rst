.. _security_groups:
.. _firewall:

================================================================================
Security Groups
================================================================================

Using Security Groups, administrators can define the firewall rules and apply
them to the Virtual Machines.

.. note::

    By default, the `default` security group is applied to new VMs, which allows
    all OUTBOUND traffic and all INBOUND traffic. You **must** Modify the
    `default` security group to make it more restrictive, if you leave as is
    everything will be always allowed.

.. warning::

    These drivers deprecate the old `firewall` drivers. However, it will respect
    backwards compatibility and if old rules such `WHITE_PORTS_TCP`, etc are
    defined, the old drivers will be used and it will completely ignore the new
    security drivers mechanism.

.. _security_groups_requirements:

Requirements
============

These kernel features must be enabled for the security groups to work properly:

.. code::

    net.bridge.bridge-nf-call-arptables = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1

You will probably need to load the ``bridge`` module for CentOS/RHEL 7 or ``br_netfiler`` for other OSs in order to enable those kernel features.

.. note::

    In CentOS 7.2, these directives are being explicitely disabled by ``/usr/lib/sysctl.d/00-system.conf``. You must add a file in ``/etc/sysctl.d/`` enabling them.

Definition
================================================================================

A Security Group is composed of several Rules. Each Rule is defined with the following attributes:

+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|   Attribute   |    Type   |                                                                                              Meaning                                                                                              |                                                                               Values                                                                              |
+===============+===========+===================================================================================================================================================================================================+===================================================================================================================================================================+
| **PROTOCOL**  | Mandatory | Defines the protocol of the rule                                                                                                                                                                  | ALL, TCP, UDP, ICMP, IPSEC                                                                                                                                        |
+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **RULE_TYPE** | Mandatory | Defines the direction of the rule                                                                                                                                                                 | INBOUND, OUTBOUND                                                                                                                                                 |
+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **IP**        | Optional  | If the rule only applies to a specific net. This is the first **IP** of the consecutive set of **IPs**. Must be used with **SIZE**.                                                               | A valid IP                                                                                                                                                        |
+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **SIZE**      | Optional  | If the rule only applies to a net. The number of total consecutive IPs of the network. Use always with **IP**.                                                                                    | An integer >= 1                                                                                                                                                   |
+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **RANGE**     | Optional  | A Port Range to filter specific ports. Only works with **TCP** and **UDP**.                                                                                                                       | (iptables syntax) multiple ports or port ranges are separated using a comma, and a port range is specified using a colon. Example: ``22,53,80:90,110,1024:65535`` |
+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **ICMP_TYPE** | Optional  | Specific ICMP type of the rule. If a type has multiple codes, it includes all the codes within. This can only be used with **ICMP**. If omitted the rule will affect the whole **ICMP** protocol. | 0,3,4,5,8,9,10,11,12,13,14,17,18                                                                                                                                  |
+---------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------+

To create a Security Group, use the Sunstone web interface, or create a template file following this example:

.. code::

    $ cat ./sg.txt

    NAME = test

    RULE = [
        PROTOCOL = TCP,
        RULE_TYPE = inbound,
        RANGE = 1000:2000
    ]

    RULE = [
        PROTOCOL= TCP,
        RULE_TYPE = outbound,
        RANGE = 1000:2000
    ]

    RULE = [
        PROTOCOL = ICMP,
        RULE_TYPE = inbound,
        NETWORK_ID = 0
    ]

    $ onesecgroup create ./sg.txt
    ID: 102

|sg_wizard_create|

Usage
================================================================================

To apply a Security Group to your Virtual Machines, you can assign them to the Virtual Networks. Either use the Sunstone wizard, or set the SECURITY_GROUPS attribute:

.. code::

    $ onevnet update 0

    SECURITY_GROUPS = "100, 102, 110"

|sg_vnet_assign|

When a Virtual Machine is instantiated, the rules are copied to the VM resource and can be seen in the CLI and Sunstone.

|sg_vm_view|

Advanced Usage
--------------------------------------------------------------------------------

To accommodate more complex scenarios, you can also set Security Groups to each Address Range of a Virtual Network.

.. code::

    $ onevnet updatear 0 1

    SECURITY_GROUPS = "100, 102, 110"

|sg_ar_assign|

Moreover, each Virtual Machine Template NIC can define a list of Security Groups:

.. code::

    NIC = [
      NETWORK = "private-net",
      NETWORK_UNAME = "oneadmin",
      SECURITY_GROUPS = "103, 125"
    ]

If the Address Range or the Template NIC define SECURITY_GROUPS, the IDs do not overwrite the ones defined in the Virtual Network. All the Security Group IDs are combined, and applied to the Virtual Machine instance.

Default Security Group
================================================================================

.. warning::

    If you don't modify the default Security Group you will not be able to filter any connections.

There is a default Security Group with ID 0. This Security Group, unless
modified, will allow all traffic, both outbound and inbound. You **must** modify
this `default` Security Group if you want to restrict connections. Consider this
Security Group to be the bare minimum for all VMs. For example, it may make
sense to define it as TCP port 22 inbound for SSH, and port 80 and 443 outbout
to be able to install packages.

This special Security Group is added to all the Virtual Networks when they are
created, but you can remove it later updating the network's properties.

Security Group Update
================================================================================

Security Groups can be updated to edit or add new rules. These changes are
propagated to all VMs in the security group, so it may take some time till the
changes are applied. The particular status of a VM can be checked in the security
group properties, where outdated and up-to-date VMs are listed.

If the update process needs to be reset, i.e. apply again the SG rules, you can use the ``onesecgroup commit`` command.

Configuration
================================================================================

Security groups is only supported and automatically enabled when using the
following drivers:

* ``802.1Q``
* ``ebtables``
* ``fw``
* ``vxlan``

.. note:: Openvswitch do not support Security Groups.

.. |sg_wizard_create| image:: /images/sg_wizard_create.png
.. |sg_vnet_assign| image:: /images/sg_vnet_assign.png
.. |sg_ar_assign| image:: /images/sg_ar_assign.png
.. |sg_vm_view| image:: /images/sg_vm_view.png


