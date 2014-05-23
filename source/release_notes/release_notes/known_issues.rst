.. _known_issues:

============
Known Issues
============

Core & System
================================================================================

* `#2831 <http://dev.opennebula.org/issues/2831>`_ Monitoring data is added to the VM even when is not active

Packaging
================================================================================

* `#2837 <http://dev.opennebula.org/issues/2837>`_ Sunstone start scripts may leave a running process without writting down the pid

Sunstone
================================================================================

* `#2814 <http://dev.opennebula.org/issues/2814>`_ If a role name contains < or >, the extended role view fails to open
* `#2813 <http://dev.opennebula.org/issues/2813>`_ Sporadic Uncaught TypeError in vm list callback
* `#2804 <http://dev.opennebula.org/issues/2804>`_ Wizard multple selection dataTables do not highlight element outside the current page
* `#2799 <http://dev.opennebula.org/issues/2799>`_ Template update wizard: intro calls create, not update
* `#2936 <http://dev.opennebula.org/issues/2936>`_ Template wizard cannot save if some values have quotation marks. To fix simply apply `this patch <http://dev.opennebula.org/projects/opennebula/repository/revisions/8110abdc8578650d344cf8d20254e704a3ef8e06/diff/src/sunstone/public/js/plugins/templates-tab.js>`_ to ``/usr/lib/one/sunstone/public/js/plugins/templates-tab.js``.


