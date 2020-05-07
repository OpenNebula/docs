.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

vCenter Driver
==========================

The vCenter driver is not fully adapted to the new monitoring system. As such, there are several functionalities that are currently known not to work:

  - Hotplug operations for network interface cards.
  - VNC due to issues with the VCENTER_ESX_HOST attribute.
  - DB lock errors introduced by the IM probe state.rb, mostly harmless.
  - Snapshots
  - OpenNebula hosts representing vCenter clusters with NSX not in OK status (NSX_STATUS = OK) cannot spawn new VMs. NSX needs to be configured correctly or the attribute added manually.
  - To use hosts with no NSX, you need modify the next files, writing an "exit 0" at the start
      /var/lib/one/remotes/vnm/pre
      /var/lib/one/remotes/vnm/post
      /var/lib/one/remotes/vnm/clean
