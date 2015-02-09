.. _known_issues:

================================================================================
Known Issues
================================================================================

CLI
================================================================================

* `#3037 <http://dev.opennebula.org/issues/3037>`_ Different ruby versions need different time formats

Core & System
================================================================================

* `#3020 <http://dev.opennebula.org/issues/3020>`_ OpenNebula should check the available space in the frontend before doing an undeploy
* `#2880 <http://dev.opennebula.org/issues/2880>`_ Unicode chars in VM name are truncated
* `#2502 <http://dev.opennebula.org/issues/2502>`_ deleting image in locked state leaves current operation in progress and files not cleaned
* `#2488 <http://dev.opennebula.org/issues/2488>`_ A failed resume action will destroy and recreate the VM on the next resume
* `#3139 <http://dev.opennebula.org/issues/3139>`_ Drivers do not work with rbenv

Drivers - Network
================================================================================

* `#3093 <http://dev.opennebula.org/issues/3093>`_ Review the Open vSwitch flows
* `#2961 <http://dev.opennebula.org/issues/2961>`_ review nic attach with 802.1Q
* `#3250 <http://dev.opennebula.org/issues/3250>`_ WHITE_PORTS_TCP Network Filtering with Open vSwitch does not work
* `#3349 <http://dev.opennebula.org/issues/3349>`_ The Virtual Router is not working

Drivers - Storage
================================================================================

* `#1573 <http://dev.opennebula.org/issues/1573>`_ If an image download fails, the file is never deleted from the datastore

Drivers - VM
================================================================================

* `#2511 <http://dev.opennebula.org/issues/2511>`_ EC2 Tags are not correctly formatted before sending them to EC2

OneFlow
================================================================================

* `#2101 <http://dev.opennebula.org/issues/2101>`_ Validator schema is not correctly shown in the CLI after a parsing error
* `#3134 <http://dev.opennebula.org/issues/3134>`_ Service Templates with dynamic networks cannot be instantiated from the CLI, unless the a template file with the required attributes is merged

Scheduler
================================================================================

* `#1811 <http://dev.opennebula.org/issues/1811>`_ If more than one scheduled actions fit in a scheduler cycle, the behaviour is unexpected

Sunstone
================================================================================

* `#2292 <http://dev.opennebula.org/issues/2292>`_ sunstone novnc send ctrl-alt-del not working in Firefox
* `#1877 <http://dev.opennebula.org/issues/1877>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#3272 <http://dev.opennebula.org/issues/3272>`_ The vCenter host creation dialog will fail with the enter key. The "import vCenter clusters" button needs to be pressed instead

Issues Solved in 4.10.1
================================================================================

For a complete list of issues solved in the 4.10.1 release, visit the `project's tracker <http://dev.opennebula.org/versions/70>`_.
