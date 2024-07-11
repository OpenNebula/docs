.. _ruby_sunstone_vm_charter:

================================================================================
Virtual Machine Charters
================================================================================

This functionality automatically adds scheduling actions in VM templates. To enable Charters, you only need add the following to ``sunstone-server.conf`` file:

|vm_charter|

.. prompt:: text $ auto

  :leases:
    suspend:
      time: "+1209600"
      color: "#000000"
    terminate:
      time: "+1209600"
      color: "#e1ef08"

In the previous example you can see that Scheduled Actions are added to the VMs. You can tune the following values:

+---------+-------------------------------------------------------------------------------------------------------+
| time    | Time for the action in secs example: +1209600 is two weeks.                                           |
|         | The order is very important since time adds to the previous scheduled action.                         |
+---------+-------------------------------------------------------------------------------------------------------+
| color   | Is the color in hexadecimal since the icon will appear in the Vms table                               |
+---------+-------------------------------------------------------------------------------------------------------+

.. |vm_charter| image:: /images/vm_charter.png