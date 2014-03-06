.. _known_issues:

============
Known Issues
============

The following bugs or issues have been identified in the current 4.4 version, and will be solved in future releases.

Installation
------------

-  `#2705 <http://dev.opennebula.org/issues/2705>`__: ``install_gems`` script crashes installing nokogiri in ruby 1.8.7. These commands should be executed to fix it:

.. code-block:: none

    # /usr/share/one/install_gems oca
    # /usr/share/one/install_gems

VMware
------

-  No multi boot support

OneFlow
-------

-  `#2535 <http://dev.opennebula.org/issues/2535>`__: VM creation fails if role name has a space. Patch in ticket.

Drivers - Auth
--------------

-  `#823 <http://dev.opennebula.org/issues/823>`__: X509 auth driver should check errors when encripting

An exception is returned if the data to be encripted is too large for that key size.

.. code::

    OpenSSL::PKey::RSAError - data too large for key size:
    /srv/cloud/one/lib/ruby/x509_auth.rb:178:in `private_encrypt'

Drivers - Network
-----------------

-  `#2267 <http://dev.opennebula.org/issues/2267>`__: Reapply network driver actions after resume. OpenVSwitch tags are not reapplied upon VM resume.

Drivers - VM
------------

-  `#2511 <http://dev.opennebula.org/issues/2511>`__: EC2 Tags are not correctly formatted before sending them to EC2
-  `#2483 <http://dev.opennebula.org/issues/2483>`__: Properly support cdrom in Xen HVM. Right now cdrom images in xen HVM are added like normal disks but should be set to emulate cdrom.


OneGate
-------

-  `#2527 <http://dev.opennebula.org/issues/2527>`__: after VM delete-recreate onegate token is not valid

Packaging
---------

-  `#2482 <http://dev.opennebula.org/issues/2482>`__: After 4.4 Upgrade, Sunstone may not display information in various views

Sunstone
--------

-  `#2522 <http://dev.opennebula.org/issues/2522>`__: Uploading files from passenger needs a fix (workaround in ticket description)
-  `#2292 <http://dev.opennebula.org/issues/2292>`__: sunstone novnc send ctrl-alt-del not working in Firefox
-  `#2246 <http://dev.opennebula.org/issues/2246>`__: OneFlow Update wizard: reset button discards the resource, and shows a create dialog
-  `#1877 <http://dev.opennebula.org/issues/1877>`__: If syslog is enabled, the logs tab in the VM detailed view are not populated
- `#2764 <http://dev.opennebula.org/issues/2764>`__: In the Template wizard, Scheduling Policy Load-aware will set the expression "FREECPU", when it should be "FREE_CPU". It must be changed manually.

Scheduling
----------

- `#2764 <http://dev.opennebula.org/issues/2764>`__: For the :ref:`SCHED\_REQUIREMENTS and SCHED\_RANK expressions <template_placement_section>`, some attributes were deprecated but not properly documented or updated by the onedb upgrade tool:

===============  ===============
4.2              4.4
===============  ===============
TOTALCPU         MAX_CPU
TOTALMEMORY      MAX_MEM
FREECPU          FREE_CPU
FREEMEMORY       FREE_MEM
USEDCPU          USED_CPU
USEDMEMORY       USED_MEM
===============  ===============

You can see all tickets in our development portal: `dev.opennebula.org <http://dev.opennebula.org/>`__.
