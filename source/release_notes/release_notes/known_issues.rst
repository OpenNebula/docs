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

Version Upgrade
================================================================================

* `#3006 <http://dev.opennebula.org/issues/3006>`_ There is a known issue in the database upgrade scripts shipped with OpenNebula 4.6.2. To fix it, download the lastest code from the repo:

    .. code-block:: none

        sudo wget https://raw.githubusercontent.com/OpenNebula/one/one-4.6/src/onedb/shared/3.8.5_to_3.9.80.rb -O /usr/lib/one/ruby/onedb/shared/3.8.5_to_3.9.80.rb
        sudo wget https://raw.githubusercontent.com/OpenNebula/one/one-4.6/src/onedb/shared/4.0.1_to_4.1.80.rb -O /usr/lib/one/ruby/onedb/shared/4.0.1_to_4.1.80.rb
        sudo wget https://raw.githubusercontent.com/OpenNebula/one/one-4.6/src/onedb/shared/4.2.0_to_4.3.80.rb -O /usr/lib/one/ruby/onedb/shared/4.2.0_to_4.3.80.rb
        sudo wget https://raw.githubusercontent.com/OpenNebula/one/one-4.6/src/onedb/shared/4.4.1_to_4.5.80.rb -O /usr/lib/one/ruby/onedb/shared/4.4.1_to_4.5.80.rb

Sunstone
================================================================================

* `#2814 <http://dev.opennebula.org/issues/2814>`_ If a role name contains < or >, the extended role view fails to open
* `#2813 <http://dev.opennebula.org/issues/2813>`_ Sporadic Uncaught TypeError in vm list callback
* `#2804 <http://dev.opennebula.org/issues/2804>`_ Wizard multple selection dataTables do not highlight element outside the current page
* `#2799 <http://dev.opennebula.org/issues/2799>`_ Template update wizard: intro calls create, not update
* `#2936 <http://dev.opennebula.org/issues/2936>`_ Template wizard cannot save if some values have quotation marks. To fix simply apply `this patch <http://dev.opennebula.org/projects/opennebula/repository/revisions/8110abdc8578650d344cf8d20254e704a3ef8e06/diff/src/sunstone/public/js/plugins/templates-tab.js>`_ to ``/usr/lib/one/sunstone/public/js/plugins/templates-tab.js``.
* `#2984 <http://dev.opennebula.org/issues/2984>`_ Image and file upload from sunstone is broken. To fix it, download these versions of the scripts from the repo as root, restart sunstone and clear the cache of the browser:

    .. code-block:: none

        # wget https://raw.githubusercontent.com/OpenNebula/one/09524280270cd160410bc035dac6eab6c932e884/src/sunstone/public/js/plugins/images-tab.js -O /usr/lib/one/sunstone/public/js/plugins/images-tab.js
        # wget https://raw.githubusercontent.com/OpenNebula/one/ee338c3ceaa46aa09609b2d9f59b3ab948532437/src/sunstone/public/js/plugins/files-tab.js -O /usr/lib/one/sunstone/public/js/plugins/files-tab.js

OneFlow
================================================================================

* `#3024 <http://dev.opennebula.org/issues/3024>`_ OneFlow template creation not working with the new csrftoken fioneflow template creation not working with the new csrftoken fix. To fix it, download this version of the script from the repo as root and restart oneflow:

    .. code-block:: none

        # wget https://raw.githubusercontent.com/OpenNebula/one/417a7787f5faaab55c99424073e11aaba8b650a9/src/flow/lib/models/service_template.rb -O /usr/lib/one/oneflow/lib/models/service_template.rb

Federation
================================================================================

* `#2982 <http://dev.opennebula.org/issues/2982>`_ The command ``onedb import-slave`` will fail if there are "orphan" resources. To fix it, download the lastest script from the repo as root:

    .. code-block:: none

        # wget https://raw.githubusercontent.com/OpenNebula/one/one-4.6/src/onedb/import_slave.rb -O /usr/lib/one/ruby/onedb/import_slave.rb
