.. _known_issues:

============
Known Issues
============

CLI
================================================================================

* `#3037 <http://dev.opennebula.org/issues/3037>`_ Different ruby versions need different time formats

Core & System
================================================================================

* `#3020 <http://dev.opennebula.org/issues/3020>`_ OpenNebula should check the available space in the frontend before doing an undeploy
* `#2880 <http://dev.opennebula.org/issues/2880>`_ Unicode chars in VM name are truncated
* `#2502 <http://dev.opennebula.org/issues/2502>`_ deleting image in locked state leaves current operation in progress and files not cleaned
* `#2488 <http://dev.opennebula.org/issues/2488>`_ A failed resume action will destroy and recreate the VM on the next resume

Drivers - Network
================================================================================

* `#3093 <http://dev.opennebula.org/issues/3093>`_ Review the Open vSwitch flows
* `#2961 <http://dev.opennebula.org/issues/2961>`_ review nic attach with 802.1Q

Drivers - Storage
================================================================================

* `#3097 <http://dev.opennebula.org/issues/3097>`_ volume hot attach stops working after first attach and detach
* `#1573 <http://dev.opennebula.org/issues/1573>`_ If an image download fails, the file is never deleted from the datastore

Drivers - VM
================================================================================

* `#2511 <http://dev.opennebula.org/issues/2511>`_ EC2 Tags are not correctly formatted before sending them to EC2

OneFlow
================================================================================

* `#2101 <http://dev.opennebula.org/issues/2101>`_ Validator schema is not correctly shown in the CLI after a parsing error

Packaging
================================================================================

* `#2866 <http://dev.opennebula.org/issues/2866>`_ opennebula starting before mysql in debian based distros

Scheduler
================================================================================

* `#1811 <http://dev.opennebula.org/issues/1811>`_ If more than one scheduled actions fit in a scheduler cycle, the behaviour is unexpected

Sunstone
================================================================================

* `#2292 <http://dev.opennebula.org/issues/2292>`_ sunstone novnc send ctrl-alt-del not working in Firefox
* `#2219 <http://dev.opennebula.org/issues/2219>`_ Calendar picker buttons for next month/year close the dialog
* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
