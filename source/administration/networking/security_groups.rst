.. _security_groups:

================================================================================
Security Groups
================================================================================

Using Security Groups, administrators can define the firewall rules and apply them to the Virtual Machines.

Definition
================================================================================

A Security Group is composed of several Rules. Each Rule is defined with the following attributes:

+----------------+-------------------------------------------------------------------+
|   Attribute    |                              Meaning                              |
+================+===================================================================+
| **PROTOCOL**   | TCP, UDP, ICMP, IPSEC                                             |
+----------------+-------------------------------------------------------------------+
| **RULE_TYPE**  | INBOUND, OUTBOUND                                                 |
+----------------+-------------------------------------------------------------------+
| **IP**         | First IP of the address range. Must be used with SIZE             |
+----------------+-------------------------------------------------------------------+
| **SIZE**       | Size of the address range. Must be used with IP                   |
+----------------+-------------------------------------------------------------------+
| **NETWORK_ID** | ID of an OpenNebula Virtual Network. Cannot be used with IP, SIZE |
+----------------+-------------------------------------------------------------------+
| **RANGE**      | Port range (TCP & UDP only)                                       |
+----------------+-------------------------------------------------------------------+

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


Considerations and Limitations
================================================================================

.. todo:: If you update a SG, new rules will only apply to new VMs.

.. todo:: By default, all connections to/from the VM are disabled.


Configuration
================================================================================

.. todo:: To enable Security Groups...

.. |sg_wizard_create| image:: /images/sg_wizard_create.png
.. |sg_vnet_assign| image:: /images/sg_vnet_assign.png
.. |sg_ar_assign| image:: /images/sg_ar_assign.png
.. |sg_vm_view| image:: /images/sg_vm_view.png