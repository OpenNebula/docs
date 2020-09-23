.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Accounting and Showback
=======================

A bug that might lead to inaccurate hours in accounting and showback has been fixed. You can check all the information `here <https://github.com/OpenNebula/one/issues/1662>`_. But, old VMs won't be updated, so the bug might still be on those VMs.

Sunstone
========

Inputs expressing sizes (disk, memory) that have units in MB, GB or TB have a bug. Once expressed in MB, if you want to update its value you'll need to change the units to GB or TB.

Setting a password for remote connection to VNC / SPICE from a VM imported from a vCenter host is not working properly.

Failing monitoring for EC2 driver
=================================

When there are more than 1 AWS instances monitored, the monitoring probe fails due to a bug.

As workaround, apply the following patch to the ec2_driver.rb

Save the patch to a file called ec2_driver.patch

.. code-block:: bash

    --- /usr/lib/one/ruby/ec2_driver.rb
    +++ /usr/lib/one/ruby/ec2_driver.rb.new
    @@ -728,10 +728,10 @@
                 @ec2.instances.each {|i| work_q.push i }
             else
                 # The same but just for a single VM
    -            vm = OpenNebula::VirtualMachine.new_with_id(deploy_id,
    +            one_vm = OpenNebula::VirtualMachine.new_with_id(deploy_id,
                                                             OpenNebula::Client.new)
    -            vm.info
    -            onevm_info[deploy_id] = vm
    +            one_vm.info
    +            onevm_info[deploy_id] = one_vm

                 work_q.push get_instance(deploy_id)
             end

And then run

.. code-block:: bash

    patch /usr/lib/one/ruby/ec2_driver.rb < ec2_driver.patch

Sunstone Translate
==================

If you are experiencing translation errors switching Suntone language, this fix might alleviate the issue. Download the following po2json.rb from the OpenNebula repository and run it for each of the languages that you are planing to use.

.. code-block:: bash

     # wget https://raw.githubusercontent.com/OpenNebula/one/master/share/scons/po2json.rb

.. note:: to see the existing languages proceed to ``/usr/lib/one/sunstone/public/locale/languages``. Each language is contained in separate file with the **.po** extension).

To apply the fix for a given language, adapt the following instructions for spanish.

.. code-block:: bash

     # wget https://raw.githubusercontent.com/OpenNebula/one/master/src/sunstone/public/locale/languages/es_ES.po
     # ruby po2json.rb es_ES.po > /usr/lib/one/sunstone/public/locale/languages/es_ES.js

Afterwards please make sure you clear your browser cache.

Sunstone Browser
================

Current implementation of Sunstone is not working on Internet Explorer due to new Javascript version.

As a workaround you can use the other browsers:

- Chrome (61.0 - 67.0)
- Firefox (59.0 - 61.0)

Hooks
=====

Potential issue with `host_error.rb` hook when receiving the host template argument from command line. You can check all the information `here <https://github.com/OpenNebula/one/issues/5101>`__
